// ==UserScript==
// @name        VID EDS Bērziņš scraper
// @namespace   *.vid.gov.lv/*
// @description Gets info from VID EDS
// @include     *.vid.gov.lv/*
// @version     11
// @require     https://code.jquery.com/jquery-2.2.4.min.js
// @grant       unsafeWindow
// @grant       GM_xmlhttpRequest
// ==/UserScript==

/*
 *
 * Author: Janis Jansons (janis.jansons@janhouse.lv)
 *
 * Do not use this without consulting your lawyer.
 *
 */


var parsingServer="https://vad.opendata.lv/import_declarations";

var appid="opendata-mvdbs";
var appver=9;
var vadPath="/VID_PDB/VAD";


/*--- waitForKeyElements():  A handy, utility function that
 does what it says.
 */
function waitForKeyElements (
    selectorTxt,    /* Required: The jQuery selector string that
     specifies the desired element(s).
     */
    actionFunction, /* Required: The code to run when elements are
     found. It is passed a jNode to the matched
     element.
     */
    bWaitOnce,      /* Optional: If false, will continue to scan for
     new elements even after the first match is
     found.
     */
    iframeSelector  /* Optional: If set, identifies the iframe to
     search.
     */
)
{
    var targetNodes, btargetsFound;

    if (typeof iframeSelector == "undefined")
        targetNodes     = $(selectorTxt);
    else
        targetNodes     = $(iframeSelector).contents ()
            .find (selectorTxt);

    if (targetNodes  &&  targetNodes.length > 0) {
        /*--- Found target node(s).  Go through each and act if they
         are new.
         */
        targetNodes.each ( function () {
            var jThis        = $(this);
            var alreadyFound = jThis.data ('alreadyFound')  ||  false;

            if (!alreadyFound) {
                //--- Call the payload function.
                actionFunction (jThis);
                jThis.data ('alreadyFound', true);
            }
        } );
        btargetsFound   = true;
    }
    else {
        btargetsFound   = false;
    }

    //--- Get the timer-control variable for this selector.
    var controlObj      = waitForKeyElements.controlObj  ||  {};
    var controlKey      = selectorTxt.replace (/[^\w]/g, "_");
    var timeControl     = controlObj [controlKey];

    //--- Now set or clear the timer as appropriate.
    if (btargetsFound  &&  bWaitOnce  &&  timeControl) {
        //--- The only condition where we need to clear the timer.
        clearInterval (timeControl);
        delete controlObj [controlKey]
    }
    else {
        //--- Set a timer, if needed.
        if ( ! timeControl) {
            timeControl = setInterval ( function () {
                    waitForKeyElements (    selectorTxt,
                        actionFunction,
                        bWaitOnce,
                        iframeSelector
                    );
                },
                500
            );
            controlObj [controlKey] = timeControl;
        }
    }
    waitForKeyElements.controlObj   = controlObj;
}



function initTask(){

    console.log("We are at the correct domain. Starting...");

    if(window.location.pathname == vadPath){
        console.log("We are at the correct page. Keep on rollin' baby.");
        if($('#frmQuery').length > 0){
            console.log("Form found. Time to try some crazy things.");

            var form=$('#frmQuery');

            if(form.children('#Name').length == 0){
                console.log("Could not find the name field, aborting.");
                return 0;
            }

            form.children('#Name').attr('value', 'Andris');

            if(form.children('#Surname').length == 0){
                console.log("Could not find the surname field, aborting.");
                return 0;
            }

            form.children('#Surname').attr('value', 'Bērziņš');

            if($('input[type=submit]').length == 0){
                console.log("Could not find the submit button, aborting.");
                return 0;
            }

            $('input[type=submit]').click();
        }
    }
}


// Posting data to opendata server.
function postData(data, id, that){

    $data = $(data);

    var trim = function(str) {
        return str.trim().replace(/(\s)+/g, " ");
    };

    var resultData = {
        type: trim($data.find("tr:contains('Deklarācijas veids:') td:nth-of-type(2)").text()),
        name: trim($data.find("tr:contains('Vārds, uzvārds:') td:nth-of-type(2)").text()),
        workplace: trim($data.find("tr:contains('Darbavieta:') td:nth-of-type(2)").text()),
        workplace_role: trim($data.find("tr:contains('Valsts amatpersonas amats:') td:nth-of-type(2)").text()),
        date_added: trim($data.find("tr:contains('Iesniegta VID:') td:nth-of-type(2)").text()),
        date_published: trim($data.find("tr:contains('Publicēta:') td:nth-of-type(2)").text()),
    };

    resultData.year = resultData.type.match(/(\d+)/)[1];

    resultData.sections = $data.find("h2").toArray().map(function(el) {
        return trim($(el).text());
    });

    var sectionData = {};
    $data.find("h2").each(function() {
        var section = trim($(this).text());
        var $table = $(this).next("table");
        while($table.length > 0) {

            if (!sectionData[section]) {
                sectionData[section] = [];
            }
            var headers = $table.find("thead th").toArray().map(function(el) {
                return trim($(el).text());
            });

            $table.find("tbody tr").each(function() {
                var rowData  = {};
                $(this).find("td").each(function(i){
                    var key = headers[i];
                    var value = trim($(this).text());
                    rowData[key] = value;
                });
                sectionData[section].push(rowData);
            });

            $table = $table.next("table");
        }
    });
    resultData.sectionData = sectionData;

    var project = trim($("#project").val());



    $.ajax({
        type: 'POST',
        url: parsingServer,
        data: {'appid': appid, 'appversion': appver, 'project': project, 'data': JSON.stringify(resultData), 'id': id},
        success: function(data) {
            console.log("Request done.");
            $('#'+that).children(".preload").remove();
            if(data.length == 0) {
                console.log("fajuuul?");
                return false;
            }
            if(data == "OK"){
                console.log("Success!!! The Matrix has you.");
                showMessage("Thank you, you are awesome! :)", "ok");
                $('#'+that).css("background-color", "green");
                return true;
            }else if(data == "IN"){
                console.log("Already have it!!! Awwww...");
                showMessage("We already have this entry.", "warning");
                $('#'+that).css("background-color", "yellow");
                return true;
            }else{
                console.log("Epic fail!!! "+ data);
                showMessage("Failure: "+data, "error");
                $('#'+that).css("background-color", "red");
            }

        },
    });
}

function newHrefVad(item, isOld, that, captcha) {

    console.log("Setting new cookie, requesting details page.");
    console.log(that);
    unsafeWindow.setCookie("VADData", item, false, "/", false, false);

    var preload=$(document.createElement('div'));
    preload.attr("id", "p"+that);
    preload.addClass("preload");
    $("#"+that).append(preload);

    // VID's magic o.O
    var url = (isOld == "2") ? '/VID_PDB/VAD/VADData'
        : '/VID_PDB/VAD/VAD2002Data';

    $.ajax({
        url: url,

        success: function(data) {

            console.log("Request done.");
            var foundin = $('*:contains("<img id=\"cap_pic")');
            preload.css("opacity", 0.4);
            if (/showRecaptcha/i.test(data)){

                console.log("Found captcha. Request user to fill it");

                $("#scid").attr('value', item); $("#scold").attr('value', isOld);

                $("#scthat").attr("value", that);

                solveCaptcha(data);

                showMessage("Captcha required!", "error");
                $('#'+that).css("background-color", "red");

                preload.remove();

                return false;

            }
            if(captcha==0){
                postData(data, item, that);
            }

            return false;
        }
    });

    return false;
}


function solveCaptcha(data){
    console.log("Making the human solve the captcha");

    //var n=data.match(/<img id="cap_pic" alt="" src="\/VID_PDB\/CaptchaImage\?.*?" onload="CaptchaImageLoad\(\);"\/>/gi);

    //console.log(n[0]);
    $("#checkCode").remove();
    var gooCaptcha='<script type="text/javascript">showRecaptcha();$("#recaptcha_response_field").hide();$("label[for=\'recaptcha_response_field\']").hide();</script><div id="checkCode"></div>';


    $("#ccode").html(gooCaptcha);
    $("#csolve").fadeIn("fast");
    $("#tadcode").focus();


}

function takeSolveCaptcha(){

    $.ajax({
        type: 'POST',
        url: "/VID_PDB/VAD/VADDataDeclaration",
        data: {'recaptcha_response_field': $("#tadcode").val(), 'recaptcha_challenge_field' : $("#recaptcha_challenge_field").val()},
        success: function(data) {

            console.log("Request done.")

            if (/check_code/i.test(data)){
                console.log("Wrong code. :( Try again...");
                newHrefVad($("#scid").attr('value'), $("#scold").attr('value'), $("#scthat").attr('value'), 0)
                return 0;
            }
            postData(data, $("#scid").attr('value'), $("#scthat").attr('value'), 1);
        },
    });

    $("#csolve").fadeOut();
    $("#tadcode").attr('value', '');

}

function hijackFunction(first){

    console.log("Got the element we need, hijacking the function...");

    unsafeWindow.HrefVad = newHrefVad;

    //////////////
    $('td a').each(function(index) {

        var pattern = /'\) ;/g;
        var tt=$(this).attr("onclick").replace(pattern, "', this.id, 0);");

        $(this).attr("onclick", tt);
        $(this).attr("id", 'itq'+index);

    });

}

function showMessage(message, type){

    var zumzum=$(document.createElement('div'));
    zumzum.css("display", "none");
    zumzum.html(message);
    console.log("Printing status");

    if(type=="error"){
        zumzum.addClass("error-o");
    }else if(type=="ok"){
        zumzum.addClass("ok-o");
    }else if(type=="warning"){
        zumzum.addClass("warning-o");
    }else {
        console.log("What is this I don't even. (Wrong showMessage 'type' parameter.)");
    }

    $("#csstatus").prepend(zumzum);
    zumzum.fadeIn();

    setTimeout(function () {  zumzum.fadeOut("fast", function(){ zumzum.remove();});  }, 5000);

}

function addStatusSpace(){

    $('html').append('<div id="csstatus" style="background: none;z-index:20;position: fixed; top: 10px; right: 10px"></div>');

}

function addProjectInput() {
    $("#frmQuery").append('<div class="surname"><label for="project">Projekts</label><input id="project" maxlength="120" name="project" size="30" type="text" value=""></div>');
}

function addCaptchaSpace(){

    $('html').append('<div id="csolve" style="text-align:center;display: none;z-index:10; position: fixed; top:0px; left:0px; width: 100%; height: 100%;">'+
        '<p id="ttlr" style="margin-top:60px">Hello there friend! '+
        'Seems like VID is trying to prove that you are not a human. Prove them that they are wrong!</p>'+
        '<div id="ccode"></div>'+
        '<br /><input type="text" id="tadcode" name="CaptchaCode" autocomplete="off" value="" /><br />'+
        '<input type="hidden" value="" name="scthat" id="scthat" />'+
        '<input type="hidden" value="" name="scid" id="scid" />'+
        '<input type="hidden" value="" name="scold" id="scold" />'+
        '<input type="button" value="Take that!" name="search" id="scin" /></div>');

    $("#scin").click(function(){
        takeSolveCaptcha();
    });

    $("#tadcode").keyup(function(event){
        if(event.keyCode == 13){
            $("#scin").click();
        }
    });

}

function addCSS(){

    $('html').append('<style type="text/css">#cap_pic{ width:200px; } #csstatus div { '+
        'box-shadow:0 0 11px -1px rgba(0, 0, 0, 0.86), 0 0 4px 1px rgba(255, 255, 255, 0.73) inset; '+
        'padding: 10px; border-radius: 10px; margin-bottom: 10px;'+
        'font-family: "Segoe UI Light","Segoe UI", "Myriad Pro Light", Geneva, Verdana, sans-serif; '+
        '}'+
        ''+
        ' td a { position: relative; }'+
        '.error-o{'+
        'background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, color-stop(0.33, rgba(162, 5, 5, 0.75)), to(rgba(128, 31, 31, 0.88)));'+
        'background-image: -moz-linear-gradient(top, rgba(162, 5, 5, 0.75) 33%, rgba(128, 31, 31, 0.88) 100%);'+
        '}'+

        '.ok-o{'+
        'background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, color-stop(0.33, rgba(30, 162, 5, 0.75)), to(rgba(18, 102, 3, 0.67)));'+
        'background-image: -moz-linear-gradient(top, rgba(30, 162, 5, 0.75) 33%,  rgba(18, 102, 3, 0.67) 100%);'+
        '}'+

        '.warning-o{'+
        'background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, color-stop(0.33, rgba(190, 178, 42, 0.831373)), to(rgba(175, 126, 0, 0.670588)));'+
        'background-image: -moz-linear-gradient(top,rgba(190, 178, 42, 0.831373) 33%, rgba(175, 126, 0, 0.670588) 100%);'+
        '}'+

        '#csolve{'+
        'background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, color-stop(0.33, rgba(201, 201, 201, 0.91)), to(rgba(255, 255, 255, 0.88)));'+
        'background-image: -moz-linear-gradient(top, rgba(201, 201, 201, 0.91) 33%, rgba(255, 255, 255, 0.88) 100%);'+
        '}'+

        '#ccode img{'+
        'box-shadow: inset 2px 2px 5px -2px black, 0px 0px 6px -2px white;'+
        'background-color: white;'+
        '}'+

        '#ttlr{'+
        'font-family: "Segoe UI Light","Segoe UI", "Myriad Pro Light", Geneva, Verdana, sans-serif; '+
        'font-size: 21px; '+
        '}'+

        ' .preload {left: -16px;position: absolute; top: 0; width: 16px;; width: 16px; height: 16px;display: block; background-image: url("http://www6.vid.gov.lv/VID_PDB/Content/Images/spinner.gif"); }'+
        '</style>');
}

$(document).ready(function(){

    console.log("Found myself at the VID page.");

    addCSS();
    addCaptchaSpace();
    addStatusSpace();
    addProjectInput();

    waitForKeyElements (".itemcount", hijackFunction);

    // Do not use the next line unless you know what you are doing.
    //setTimeout(function () {  initTask();  }, 3000);

});

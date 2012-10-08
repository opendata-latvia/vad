class VAD.DeclarationsDatatableView extends Backbone.View
  events:
    "keyup thead th input" : "columnFilterChanged"

  initialize: (options = {}) ->
    @initializeDataTable()

  translations:
    oPaginate:
      sFirst: "Pirmais"
      sLast: "Pēdējais"
      sNext: "Nākošie"
      sPrevious: "Iepriekšējie"
    sEmptyTable: "Nav pieejami dati"
    sInfo: "Attēloti _START_ - _END_ no _TOTAL_ ierakstiem"
    sInfoEmpty: "Attēloti 0 - 0 no 0 ierakstiem"
    sInfoFiltered: "<br/>(atfiltrēti no _MAX_ ierakstiem)"
    sLengthMenu: "Parādīt _MENU_ ierakstus"
    sLoadingRecords: "Ielādē..."
    sProcessing: "Apstrādā..."
    sSearch: "Meklēt visās kolonnās:"
    sZeroRecords: "Nav atrasts neviens ieraksts"

  initializeDataTable: ->
    @columnFilterValues = []
    $dataTable = @$(".table")
    # bind to click event on individual input elements
    # to prevent default th click behaviour
    $dataTable.find("thead th input").click @clickHeadInput

    $.extend $.fn.dataTableExt.oStdClasses,
      "sSortAsc": "header headerSortDown"
      "sSortDesc": "header headerSortUp"
      "sSortable": "header"

    @dataTable = $dataTable.dataTable
      # sDom: "<'row-fluid'<'span4'l><'span8'f>r>t<'row-fluid'<'span5'i><'span7'p>>"
      sDom: "<'row-fluid'<'span4'l>r>t<'row-fluid'<'span5'i><'span7'p>>"
      # sScrollX: "100%"
      bProcessing: true
      bServerSide: true
      sAjaxSource: $dataTable.data "source"
      fnServerData: @fnServerData
      sPaginationType: "bootstrap"
      oLanguage: @translations

    @fixedHeader = new FixedHeader @dataTable,
      offsetTop: $(".navbar-fixed-top").height()

    # do not focus on table headers when moving with tabs between column filters
    @$("thead th").attr "tabindex", "-1"

  # override standard DataTebles implementation to add processing of additional returned query parameter
  fnServerData: (sUrl, aoData, fnCallback, oSettings) =>
    oSettings.jqXHR = $.ajax
      url: sUrl
      data: aoData
      success: (json) =>
        # console.log "fnServerData success", json
        @updateDownloadLinks(json.queryParams)
        $(oSettings.oInstance).trigger('xhr', oSettings)
        fnCallback(json)
      dataType: "json"
      cache: false
      type: oSettings.sServerMethod
      error: (xhr, error, thrown) ->
        if error == "parsererror"
          oSettings.oApi._fnLog( oSettings, 0, "DataTables warning: JSON data from " +
            "server could not be parsed. This is caused by a JSON formatting error." )

  updateDownloadLinks: (params) ->
    delete params.q unless params.q
    allPagesParams = _.clone params
    delete allPagesParams.page
    delete allPagesParams.per_page
    delete allPagesParams.sort
    delete allPagesParams.sort_direction

    @$("a[data-download-path]").each ->
      $this = $(this)
      # urlParams = $.param(if $this.data("currentPage") then params else allPagesParams)
      urlParams = $.param allPagesParams
      url = $this.data("downloadPath")
      url += "?" + urlParams if urlParams
      $this.attr "href", url
    @$(".download-data").show()

  clickHeadInput: (e) =>
    # ignore click to prevent sorting
    false

  columnFilterChanged: (e) ->
    $target = $(e.currentTarget)
    inputIndex = $target.closest("tr").find("input").index($target)
    @columnFilterValues[inputIndex] ?= ""
    if (value = $target.val()) isnt @columnFilterValues[inputIndex]
      @columnFilterValues[inputIndex] = value
      @dataTable.fnFilter value, inputIndex

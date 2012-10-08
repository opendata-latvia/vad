FixedHeader.prototype._fnCloneThead = function ( oCache )
{
  var s = this.fnGetSettings();
  var nTable = oCache.nNode;

  /* Set the wrapper width to match that of the cloned table */
  oCache.nWrapper.style.width = jQuery(s.nTable).outerWidth()+"px";

  /* Remove any children the cloned table has */
  while ( nTable.childNodes.length > 0 )
  {
    jQuery('thead th', nTable).unbind( 'click' );
    nTable.removeChild( nTable.childNodes[0] );
  }

  /* Clone the DataTables header */
  var nThead = jQuery('thead', s.nTable).clone(true)[0];

  // PATCH: remove column filter inputs
  jQuery(".column_filter", nThead).remove();

  nTable.appendChild( nThead );


  /* Copy the widths across - apparently a clone isn't good enough for this */
  jQuery("thead>tr th", s.nTable).each( function (i) {
    jQuery("thead>tr th:eq("+i+")", nTable).width( jQuery(this).width() );
  } );

  jQuery("thead>tr td", s.nTable).each( function (i) {
    jQuery("thead>tr td:eq("+i+")", nTable).width( jQuery(this).width() );
  } );
}

FixedHeader.prototype._fnCloneTLeft = function ( oCache )
{
  var s = this.fnGetSettings();
  var nTable = oCache.nNode;
  var nBody = $('tbody', s.nTable)[0];
  var iCols = $('tbody tr:eq(0) td', s.nTable).length;
  var bRubbishOldIE = ($.browser.msie && ($.browser.version == "6.0" || $.browser.version == "7.0"));

  /* Remove any children the cloned table has */
  while ( nTable.childNodes.length > 0 )
  {
    nTable.removeChild( nTable.childNodes[0] );
  }

  /* Is this the most efficient way to do this - it looks horrible... */
  nTable.appendChild( jQuery("thead", s.nTable).clone(true)[0] );
  nTable.appendChild( jQuery("tbody", s.nTable).clone(true)[0] );
  if ( s.bFooter )
  {
    nTable.appendChild( jQuery("tfoot", s.nTable).clone(true)[0] );
  }

  /* Remove unneeded cells */
  $('thead tr', nTable).each( function (k) {
    $('th:gt(0)', this).remove();
  } );

  $('tfoot tr', nTable).each( function (k) {
    $('th:gt(0)', this).remove();
  } );

  $('tbody tr', nTable).each( function (k) {
    $('td:gt(0)', this).remove();
  } );

  // PATCH: remove column filter inputs
  jQuery(".column_filter", nTable).remove();
  jQuery("thead tr", nTable).height(jQuery("thead tr", s.nTable).height()).empty();
  jQuery("thead", nTable).css("zIndex", -1);
  // PATCH: remove if only message td is present
  if(jQuery("tbody td", nTable).length <= 1) {
    jQuery("tbody", nTable).remove();
  }

  this.fnEqualiseHeights( 'tbody', nBody.parentNode, nTable );

  var iWidth = jQuery('thead tr th:eq(0)', s.nTable).outerWidth();
  nTable.style.width = iWidth+"px";
  oCache.nWrapper.style.width = iWidth+"px";
}

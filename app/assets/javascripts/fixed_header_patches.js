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

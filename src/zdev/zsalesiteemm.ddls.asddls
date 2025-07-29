@EndUserText.label: 'item'
define custom entity zsalesiteemm
// with parameters parameter_name : parameter_type
{
   key sales : abap.char( 10 );
  key salesitem : abap.char( 10 );
 total : abap.char( 10 );
 
 _parent : association  to parent   zsales1 on $projection.sales = _parent.sales  ;
  
  
}

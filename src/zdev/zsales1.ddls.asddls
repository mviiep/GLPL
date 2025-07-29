@EndUserText.label: 'sales'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SALES1'
define root custom entity zsales1
// with parameters parameter_name : parameter_type
{
  key sales : abap.char( 10 );
  loc : abap.char( 10 );
 _item : composition[0..*] of zsalesiteemm;
}

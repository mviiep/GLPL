@EndUserText.label: 'ZCOLCUS'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_COLCUS'
define root custom entity ZCOLCUS
  // with parameters parameter_name : parameter_type
{

  key lv_json    : abap.string( 256 );
  key lv_message : abap.string( 256 );

}

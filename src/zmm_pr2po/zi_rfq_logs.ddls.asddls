@ObjectModel.query.implementedBy: 'ABAP:ZCL_RFQ_LOGS'
@EndUserText.label: 'Interface view for ZTB_RFQ_LOGS'
//@Metadata.ignorePropagatedAnnotations: true
define root custom entity ZI_RFQ_LOGS 
//as select from data_source_name
//composition of target_data_source_name as _association_name
{
  key requestforquotation : ebeln;
  key recordcounter       : abap.numc(4);
      msgtyp              : abap.char(1);
      msgtext             : abap.char(60);
}

@AbapCatalog.sqlViewName: 'ZVWRFQLOGS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for ZTB_RFQ_LOGS'
@Metadata.ignorePropagatedAnnotations: true
define view zcds_rfq_logs as select from ztb_rfq_logs
{
   requestforquotation,
   recordcounter,
   msgtyp,
   msgtext
}

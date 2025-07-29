@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for RFQ'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RFQ
  as select distinct from I_Requestforquotation_Api01
   association [1..1] to I_RfqItem_Api01 as item on item.RequestForQuotation = I_Requestforquotation_Api01.RequestForQuotation
{
  key RequestForQuotation,
//  RequestForQuotationName,
  concat( item.PurchaseRequisition,
  concat_with_space( ' -' , I_Requestforquotation_Api01.RequestForQuotationName , 1 ) ) as RequestForQuotationName
}

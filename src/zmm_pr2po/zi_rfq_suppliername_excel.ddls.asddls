@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Supplier Items Name Excel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_RFQ_Suppliername_excel
  as select from I_RfqBidder_Api01
  association [0..1] to I_Supplier as _supplier on I_RfqBidder_Api01.Supplier = _supplier.Supplier
{
  key RequestForQuotation,
      I_RfqBidder_Api01.Supplier,
      _supplier.SupplierName
}

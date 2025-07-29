@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for cost center with PR'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_Cost_center
  as select distinct from I_PurReqnAcctAssgmtAPI01 as a
  association [0..1] to I_CostCenterText as b on  a.CostCenter      = b.CostCenter
                                              and a.ControllingArea = b.ControllingArea
  //                                              and a.PURCHASEREQNACCTASSGMTNUMBER = b.
                                              and b.Language        = 'E'
{
  key  a.PurchaseRequisition,
  key  a.PurchaseRequisitionItem,
  key  a.CostCenter,
       b.CostCenterName
}

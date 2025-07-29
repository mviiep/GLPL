@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Cost Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_mm_Cost_center
  as select distinct from I_CostCenterText as a
  //  association [0..1] to I_CostCenterText as b on  a.CostCenter      = b.CostCenter
  //                                              and a.ControllingArea = b.ControllingArea
  //  //                                              and a.PURCHASEREQNACCTASSGMTNUMBER = b.
  //                                              and b.Language        = 'E'
{
  key  a.CostCenter,
       a.CostCenterName
}
where
  a.Language = 'E'

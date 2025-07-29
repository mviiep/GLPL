@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Mass Upload Cost Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_Mass_Upload_CostCenter
  as select distinct from I_CostCenterText as a
//  association to I_CostCenterText as b on a.CostCenter = b.CostCenter
//                                      and b.Language = 'E'
{
  key a.CostCenter,
      a.CostCenterName
}
where a.Language = 'E'

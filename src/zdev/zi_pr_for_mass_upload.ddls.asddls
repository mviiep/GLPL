@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for PR Mass Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PR_FOR_MASS_UPLOAD
  as select from I_PurchaseRequisitionAPI01
{
  key PurchaseRequisition,
      PurReqnDescription
}

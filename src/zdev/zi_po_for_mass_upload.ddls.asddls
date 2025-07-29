@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Defination of ZI_PO_FOR_MASS_UPLOAD'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_FOR_MASS_UPLOAD
  as select distinct from I_PurchaseOrderAPI01 as header
  association to I_PurOrdAccountAssignmentAPI01 as accassignment on header.PurchaseOrder = accassignment.PurchaseOrder
{
  key header.PurchaseOrder,
      header.PurchaseOrderType,
      accassignment.CostCenter,
      accassignment.MasterFixedAsset
}

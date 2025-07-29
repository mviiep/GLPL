@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Purchase Requisition Mass Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PR_Mass_Upload
  as select distinct from I_PurchaseRequisitionItemAPI01 as item
  association to I_Supplier                 as _supplier          on  _supplier.Supplier = item.Supplier
  association to I_PurchaseRequisitionAPI01 as header             on  header.PurchaseRequisition = item.PurchaseRequisition
  association to I_PurReqnAcctAssgmtAPI01   as _PurReqnAcctAssgmt on  _PurReqnAcctAssgmt.PurchaseRequisition     = item.PurchaseRequisition
                                                                  and _PurReqnAcctAssgmt.PurchaseRequisitionItem = item.PurchaseRequisitionItem
{
  key item.PurchaseRequisition,
  key item.PurchaseRequisitionItem,
      item.DeliveryDate,
      header.PurchaseRequisitionType,
      //      header.
      item.AccountAssignmentCategory,
      item.Material,
      item.PurchaseRequisitionItemText,
      item.TaxCode,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      item.RequestedQuantity,
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      item.PurchaseRequisitionPrice,
      item.Plant,
      item.BaseUnit,
      item.PerformancePeriodStartDate,
      item.PerformancePeriodEndDate,
      _PurReqnAcctAssgmt.MasterFixedAsset as FixedAsset,
      _PurReqnAcctAssgmt.CostCenter,
      item.PurReqnItemCurrency,
      item.IsClosed,
      _PurReqnAcctAssgmt.PurchaseReqnAcctAssgmtNumber

}
where
  item.IsDeleted <> 'X'

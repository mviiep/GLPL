@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for PO Mass Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_Mass_Upload_Sub
  as select distinct from I_PurchaseOrderItemAPI01 as item
  association to I_PurchaseOrderHistoryAPI01    as _PurchaseOrderHistory on  item.PurchaseOrder     = _PurchaseOrderHistory.PurchaseOrder
                                                                         and item.PurchaseOrderItem = _PurchaseOrderHistory.PurchaseOrderItem

  association to I_PurchaseOrderAPI01           as header                on  item.PurchaseOrder = header.PurchaseOrder
  
  association to I_PurOrdAccountAssignmentAPI01 as accassignment         on  item.PurchaseOrder     = accassignment.PurchaseOrder
                                                                         and item.PurchaseOrderItem = accassignment.PurchaseOrderItem
                                                                         
  association to I_PurOrdScheduleLineAPI01      as scheduleline          on  scheduleline.PurchaseOrder     = item.PurchaseOrder
                                                                         and scheduleline.PurchaseOrderItem = item.PurchaseOrderItem
{
  key item.PurchaseOrder,
  key item.PurchaseOrderItem,
      case
      when  ( _PurchaseOrderHistory.PurchaseOrder is not initial
      and _PurchaseOrderHistory.ReferenceDocument is initial )
      then _PurchaseOrderHistory.PurchaseOrder
      when ( _PurchaseOrderHistory.PurchaseOrder is not initial
      and _PurchaseOrderHistory.PurchasingHistoryDocument = _PurchaseOrderHistory.ReferenceDocument
      and _PurchaseOrderHistory.PurchasingHistoryDocumentType = '1' )
      then '0'
      else '0' end as po,
      header.Supplier,
      header._Supplier.SupplierName,
      header.PurchaseOrderType,
      header.PaymentTerms,
      item.AccountAssignmentCategory,
      item.Material,
      item.PurchaseOrderItemText,
      item.TaxCode,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      item.OrderQuantity,
      item.PurchaseOrderQuantityUnit,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      item.NetPriceAmount,
      item.PurchasingDocumentDeletionCode,
      item.Plant,
      scheduleline.PerformancePeriodEndDate,
      scheduleline.PerformancePeriodStartDate,
      accassignment.CostCenter,
      accassignment.MasterFixedAsset,
      item.IsCompletelyDelivered,
      DocumentCurrency,
      accassignment.AccountAssignmentNumber,  //added for URL Purpose
      scheduleline.PurchaseOrderScheduleLine, //added for URL Purpose
      _PurchaseOrderHistory.GoodsMovementType


}
where
  item.PurchasingDocumentDeletionCode <> 'L'

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Purchase Order Mass Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_PO_Mass_Upload
  as select distinct from ZI_PO_Mass_Upload_Sub as item
  association to I_PurOrdScheduleLineAPI01 as date on  item.PurchaseOrder     = date.PurchaseOrder
                                                   and item.PurchaseOrderItem = date.PurchaseOrderItem

{
  key item.PurchaseOrder,
  key item.PurchaseOrderItem,
      //      item.po,
      date.ScheduleLineDeliveryDate,
      item.Supplier,
      item.SupplierName,
      item.PurchaseOrderType,
      item.PaymentTerms,
      item.AccountAssignmentCategory,
      item.Material,
      item.PurchaseOrderItemText,
      item.TaxCode,
      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      item.OrderQuantity,
      item.PurchaseOrderQuantityUnit,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      item.NetPriceAmount,
      item.Plant,
      item.PerformancePeriodEndDate,
      item.PerformancePeriodStartDate,
      item.PurchaseOrderScheduleLine,
      item.CostCenter,
      item.IsCompletelyDelivered,
      item.MasterFixedAsset,
      DocumentCurrency,
      item.AccountAssignmentNumber //added for URL Purpose
      //      item.GoodsMovementType

}
where
  item.po = '0'

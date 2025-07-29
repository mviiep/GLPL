@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'interface for ite'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsales_ti as select from I_SalesOrderItem
{
    key SalesOrder,
    key SalesOrderItem,
    SalesOrderItemUUID,
    SalesOrderItemCategory,
    SalesOrderItemType,
    IsReturnsItem
}

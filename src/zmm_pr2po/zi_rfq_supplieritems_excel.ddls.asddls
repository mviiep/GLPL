@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Supplier Items Excel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity Zi_RFQ_Supplieritems_excel
  as select distinct from I_RfqItem_Api01 as item
  association [0..1] to I_Requestforquotation_Api01 as header              on  item.RequestForQuotation = header.RequestForQuotation
  association [0..1] to I_RfqScheduleLine_Api01     as RfqScheduleLineitem on  item.RequestForQuotation     = RfqScheduleLineitem.RequestForQuotation
                                                                           and item.RequestForQuotationItem = RfqScheduleLineitem.RequestForQuotationItem
  association [0..1] to Zi_RFQ_Suppliername_excel   as supplierbidders     on  item.RequestForQuotation = supplierbidders.RequestForQuotation
  association [0..1] to I_ProductText               as producttext         on  item.Material        = producttext.Product
                                                                           and producttext.Language = 'E'
{
      //  key RequestForQuotation,

  key item.RequestForQuotation                                                 as RequestForQuotation,
      RequestForQuotationItem                                                  as RequestForQuotationItem,
      //      supplierbidders.Supplier                              as Supplier,
      //      supplierbidders.SupplierName                          as SupplierName,
      Material                                                                 as Material,
      coalesce( producttext.ProductName, item.PurchasingDocumentItemText )                                           as MaterialName,
      cast( RfqScheduleLineitem.ScheduleLineOrderQuantity as abap.char( 20 ) ) as Quantity,
      OrderQuantityUnit                                                        as Unit,
//      case YY1_TargetRate_PDI
//      when 0
//      then cast(YY1_TargetRate_PDI as abap.char( 20 ) )
//      else null                          end                                   as QuotedRate,
       '' as QuotedRate, 
      cast(YY1_TargetRate_PDI as abap.char( 20 ) )                             as TargetRate,
      header.DocumentCurrency                                                  as Currency,
      item.YY1_Remark_PDI                                                      as ItemRemark,
      header.YY1_Headertext_PDH                                                as HeaderRemark
}

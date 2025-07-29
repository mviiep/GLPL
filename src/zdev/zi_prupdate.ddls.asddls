@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for PR Update'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRUpdate
  as select distinct from I_PurchaseRequisitionItemAPI01 as a
  association [0..*] to I_PurchaseOrderItemAPI01 as c        on  a.PurchaseRequisition     = c.PurchaseRequisition
                                                             and a.PurchaseRequisitionItem = c.PurchaseRequisitionItem

  association [1..1] to I_Product                as _product on  a.Material = _product.Product

  association [1..1] to I_RfqItem_Api01          as b        on  a.PurchaseRequisition     = b.PurchaseRequisition
                                                             and a.PurchaseRequisitionItem = b.PurchaseRequisitionItem
  association [0..1] to I_ProductText            as d        on  a.Material = d.Product
                                                             and d.Language = 'E'
  association [0..1] to Zi_Cost_center           as e        on  a.PurchaseRequisition     = e.PurchaseRequisition
                                                             and a.PurchaseRequisitionItem = e.PurchaseRequisitionItem
  association [1..1] to zpr_zohostatus           as f        on  a.PurchaseRequisition = f.purchaserequisition
  //  association [0..1] to I_Supplier               as d on  a.Supplier = d.Supplier
{
      @UI.facet         : [{
                         id      :'PurchaseRequisition',
                         label   : 'PurchaseRequisition',
                         type    : #IDENTIFICATION_REFERENCE,
                         position: 10 }]
      @UI : {  lineItem       : [ { position: 10 },{ type: #FOR_ACTION, dataAction: 'Update_PR', label: 'Update PR'} ],
               identification : [ { position: 10 },{ type: #FOR_ACTION, dataAction: 'Update_PR', label: 'Update PR'} ],
               selectionField: [ { position:1  } ]}
      @EndUserText.label: 'PurchaseRequisition'
  key a.PurchaseRequisition,
      @UI : {  lineItem       : [ { position: 20 } ],
               identification : [ { position: 20 } ]}
      @EndUserText.label: 'Purchase Requisition Item'
  key a.PurchaseRequisitionItem,
      @UI : {  lineItem       : [ { position: 60 } ],
              identification : [ { position: 60 } ]}
      @EndUserText.label: 'Purchase Order'
      //      case c.PurchasingDocumentDeletionCode
      //      when ''
      //      then c.PurchaseOrder  end    as PurchaseOrder,
  key c.PurchaseOrder,
      @UI : {  lineItem       : [ { position: 70 } ],
               identification : [ { position: 70 } ]}
      @EndUserText.label: 'Purchase Order Item'
      //      case c.PurchasingDocumentDeletionCode
      //      when ''
      //      then c.PurchaseOrderItem end as PurchaseOrderItem,
  key c.PurchaseOrderItem,
      @UI : {  lineItem       : [ { position: 25 } ],
               identification : [ { position: 25 } ]}
      @EndUserText.label: 'Purchase Requisition Item Text'
      a.PurchaseRequisitionItemText,

      @UI : {  lineItem       : [ { position: 30 } ],
         identification : [ { position: 30 } ]}
      @EndUserText.label: 'Zoho ID'
      a.YY1_PRZohoID_PRI,

      @UI : {  lineItem       : [ { position: 25 } ],
               identification : [ { position: 25 } ]}
      @EndUserText.label: 'Code'
      case
      when a.LastChangeDateTime is initial
      then 0
      when a._PurchaseRequisition.LastChangeDateTime is not initial and f.prlastchangedatetime is initial
      then 200
      when a._PurchaseRequisition.LastChangeDateTime <> f.prlastchangedatetime
      then 200
      when f.message = 'Data Updated Successfully'
      then 201
      //      else 202
       end                       as code,
      @UI : {  lineItem       : [ { position: 27 } ],
               identification : [ { position: 27 } ]}
      @EndUserText.label: 'Status'
      case
      when a.LastChangeDateTime is initial
      then ''
      when a._PurchaseRequisition.LastChangeDateTime is not initial and f.prlastchangedatetime is initial
      then 'To be sent to ZOHO'
      when a._PurchaseRequisition.LastChangeDateTime <> f.prlastchangedatetime
      then 'To be sent to ZOHO'
      //      when a.LastChangeDateTime = f.prlastchangedatetime
      //      then 'Data Updated Successfully'
      else f.message
       end                       as message,
      @UI : {  lineItem       : [ { position: 40 } ],
              identification : [ { position: 40 } ]}
      @EndUserText.label: 'Purchase Requisition Status'
      a.IsDeleted,
      a.PurReqnItemCurrency,
      @UI : {  lineItem       : [ { position: 45 } ],
               identification : [ { position: 45 } ]}
      @EndUserText.label: 'Purchase Requisition Price'
      @Semantics.amount.currencyCode: 'PurReqnItemCurrency'
      a.PurchaseRequisitionPrice as ItemNetAmount,
      @UI : {  lineItem       : [ { position: 50 } ],
              identification : [ { position: 50 } ]}
      @EndUserText.label: 'Request For Quotation'
      case
      when b.RequestForQuotation is not initial
      then 'Yes'
      else 'No' end              as RequestForQuotation,
      //      @UI : {  lineItem       : [ { position: 50 } ],
      //              identification : [ { position: 50 } ]}
      //      @EndUserText.label: 'Request For Quotation Item '
      //      case b._RequestForQuotation.RFQLifecycleStatus
      //      when '01'
      //      then b.RequestForQuotationItem
      //      when '02'
      //      then b.RequestForQuotationItem end as RequestForQuotationItem,

      @UI : {  lineItem       : [ { position: 80 } ],
               identification : [ { position: 80 } ]}
      @EndUserText.label: 'Supplier Name'
      c._PurchaseOrder._Supplier.SupplierName,
      @UI : {  lineItem       : [ { position: 90 } ],
               identification : [ { position: 90 } ],
               selectionField : [ { position: 2  } ]}
      @EndUserText.label: 'Material'
      a.Material,
      @UI : {  lineItem       : [ { position: 92 } ],
               identification : [ { position: 92 } ] }
      @EndUserText.label: 'Material Name'
      d.ProductName,
      @UI : {  lineItem       : [ { position: 95 } ],
               identification : [ { position: 95 } ]}
      @EndUserText.label: 'Material Group Code'
      a.MaterialGroup,
      @UI : {  lineItem       : [ { position: 100 } ],
               identification : [ { position: 100 } ],
               selectionField : [ { position: 3  } ]}
      @EndUserText.label: 'Plant'
      a.Plant,
      @UI : {  lineItem       : [ { position: 110 } ],
               identification : [ { position: 110 } ]}
      @EndUserText.label: 'Purchasing Group'
      a.PurchasingGroup,
      @UI : {  lineItem       : [ { position: 120 } ],
               identification : [ { position: 120 } ]}
      @EndUserText.label: 'Base Unit'
      a.BaseUnit,
      @UI : {  lineItem       : [ { position: 130 } ],
               identification : [ { position: 130 } ]}
      @EndUserText.label: 'Ordered Quantity'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.OrderedQuantity,
      @UI : {  lineItem       : [ { position: 135 } ],
               identification : [ { position: 135 } ]}
      @EndUserText.label: 'Requested Quantity'
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.RequestedQuantity,
      @UI : {  lineItem       : [ { position: 140 } ],
               identification : [ { position: 140 } ]}
      @EndUserText.label: 'Delivery Date'
      a.DeliveryDate,
      @UI : {  lineItem       : [ { position: 150 } ],
               identification : [ { position: 150 } ]}
      @EndUserText.label: 'Performance Period Start Date'
      a.PerformancePeriodStartDate,
      @UI : {  lineItem       : [ { position: 160 } ],
               identification : [ { position: 160 } ]}
      @EndUserText.label: 'Performance Period End Date'
      a.PerformancePeriodEndDate,
      @UI : {  lineItem       : [ { position: 170 } ],
               identification : [ { position: 170 } ]}
      @EndUserText.label: 'Asset Code'
      a._PurReqnAcctAssgmt.MasterFixedAsset,
      @UI.hidden: true
      a.YY1_PRZohoURL_PRI,
      @UI : {  lineItem       : [ { position: 180 } ],
               identification : [ { position: 180 } ],
               selectionField : [ { position: 4  } ] }
      @EndUserText.label: 'Cost Center'
      e.CostCenter,
      @UI : {  lineItem       : [ { position: 185 } ],
               identification : [ { position: 185 } ] }
      @EndUserText.label: 'Cost Center Name'
      e.CostCenterName,
      @UI : {  lineItem       : [ { position: 190 } ],
               identification : [ { position: 190 } ]}
      @EndUserText.label: 'Requisitioner Name'
      a.RequisitionerName,
      a._PurchaseRequisition.LastChangeDateTime,
      @UI.hidden: true
      a.YY1_ZohoUniquePRID_PRI,
      _product.ProductType
}

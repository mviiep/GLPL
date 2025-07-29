@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
serviceQuality: #X,
sizeCategory: #S,
dataClass: #MIXED 
}
define root view entity zapi_sales_order
  as select distinct from I_SalesOrder as a
  association to I_SalesDocument       as b on  a.SalesOrder = b.SalesDocument
  // association to zsales_order        as c on a.SalesOrder = c.salesorder
  association to I_BillingDocumentItem as d on  a.SalesOrder                = d.SalesDocument
                                            and d.SalesSDDocumentCategory = 'C'
                                            
 association to zsales_order as f on a.SalesOrder = f.salesorder


{

      @UI.facet         : [{
      id      :'SalesOrder',
      label   : 'Sales order',
      type    : #IDENTIFICATION_REFERENCE,
      position: 10 }]
      @UI : {  lineItem       : [ { position: 10 },{ type: #FOR_ACTION, dataAction: 'Updatebilling', label: 'Update billing'} ],
      identification : [ { position: 10 },{ type: #FOR_ACTION, dataAction: 'Updatebilling', label: 'Update billing'} ]}
      @EndUserText.label: 'Sales Order'
  key a.SalesOrder,



      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      @EndUserText.label: 'Billing Document'
      d.BillingDocument         as zbillingdoc,

      @UI.lineItem: [{ position: 30 }]
      @UI.identification: [{ position: 30 }]
      @EndUserText.label: 'Billing Date'
      d.BillingDocumentDate,

      a.TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'

      @UI.lineItem: [{ position: 40 }]
      @UI.identification: [{ position: 40 }]
      @EndUserText.label: 'Net Amount'
      a.TotalNetAmount,
      
      
       @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @EndUserText.label: 'Created Date'
      d.CreationDate as Lastchanged ,
      
      
      
       @UI.lineItem: [{ position: 50 }]
      @UI.identification: [{ position: 50 }]
      @EndUserText.label: 'Created Time'
      d.CreationTime as Createdtime ,
      
      
       @UI : {  lineItem       : [ { position: 60 } ],
               identification : [ { position: 60 } ]}
      @EndUserText.label: 'Status'
      case
      when  d.CreationTime  is not initial and f.lastchangedate is null
      then 'To be sent to ZOHO'
      when  f.lastchangedate is not initial
      then 'Data created Successfully'
//      when a.LastChangeDateTime = f.prlastchangedatetime
//      then 'Data Updated Successfully'
      else f.msg
       end          as message ,
      
      
      

      @UI.lineItem: [{ position: 80 }]
      @UI.identification: [{ position: 80 }]
      @EndUserText.label: 'Zoho CRM ID'
      a.PurchaseOrderByCustomer as zohoid
      
      
      

      //      @UI.lineItem: [{ position: 60 }]
      //      @UI.identification: [{ position: 60 }]
      //        @EndUserText.label: 'Status'
      //      c.status,
      //
      //      @UI.lineItem: [{ position: 70 }]
      //      @UI.identification: [{ position: 70 }]
      //        @EndUserText.label: 'Message'
      //      c.msg as Message,


      //      @UI.lineItem: [{ position: 80 }]
      //      @UI.identification: [{ position: 80 }]
      //      @EndUserText.label: 'Zoho code'
      //      c.zohosocode


}

where  a.PurchaseOrderByCustomer is not null and d.BillingDocument is not null

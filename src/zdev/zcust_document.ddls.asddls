@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zcust'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zcust_document as select from I_OperationalAcctgDocItem
{
   @UI.lineItem: [{ position: 10,label: 'Companycode' }]
  

    key CompanyCode,
     @UI.lineItem: [{ position: 20,label: 'AccountingDocument' }, { type: #FOR_ACTION, dataAction: 'postdata', label: 'dalde' }]
     AccountingDocument,
     @UI.lineItem: [{ position: 30,label: 'FiscalYear' }]
     FiscalYear,
     @UI.lineItem: [{ position: 40,label: 'AccountingDocumentItem' }]
     AccountingDocumentItem
    
}

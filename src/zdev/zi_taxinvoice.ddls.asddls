@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'tax invoice interface'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TAXINVOICE 
 as select distinct from I_AccountingDocumentJournal( P_Language: 'E' )

{
  
  @UI.lineItem: [{
      label: 'AccountingDocument',
      position: 10
 
  }]
  
  @UI.selectionField: [{
   
      position:10 

  }]
  @EndUserText.label: 'AccountingDocument'
  key AccountingDocument,
   @UI.selectionField: [{
   
      position:20 

  }]
  @EndUserText.label: 'FiscalYear'
  @Consumption.filter.mandatory: true
  key FiscalYear
}

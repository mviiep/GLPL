@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'exp'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ztest_exp
as select from I_JournalEntry
  
{

       @UI                 : {lineItem: [{ position: 5,label: 'AccountingDocument' }]}
       @UI.selectionField  : [ { position: 10}]
       @EndUserText.label  : 'AccountingDocument'
  key  AccountingDocument,
  
   @UI                 : {lineItem: [{ position: 3,label: 'FiscalYear' }]}
     @UI.selectionField  : [ { position: 20}]
       FiscalYear,
       
     @UI                 : {lineItem: [{ position: 13,label: 'CompanyCode' , type: #WITH_URL  } ]}
     @UI.selectionField  : [ { position: 30}]
     
//       @UI.lineItem: [ { 
//    position: 20,
//    type: #WITH_URL,
//    url: 'WebsiteUrl'   -- Reference to element
//  } ]
       CompanyCode,
       
      
           @UI                 : {lineItem: [{ position: 114,label: 'CompanyCode' , type: #WITH_URL, url: 'abc'  } ]}
     @UI.selectionField  : [ { position: 14}]
     @EndUserText.label: 'ABC'
       'abc' as abc
       
       
    

} 

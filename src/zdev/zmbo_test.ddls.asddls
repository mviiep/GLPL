@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'mANAGED'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZMbo_TEST as select from I_JournalEntry
{
    
      @UI                 : {lineItem: [{ position: 5,label: 'CustomerID' }, { type: #FOR_ACTION , dataAction: 'jvpost', label: 'JVPost' } ] }
  
      @EndUserText.label  : 'Accountingno'
    key AccountingDocument
}

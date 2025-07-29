@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'test3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE
//@Analytics.query: true
//@VDM.viewType: #CONSUMPTION



define view entity ZI_Test3 as select from I_JournalEntry as _header
association[0..1] to I_JournalEntryItem as _item 
on _header.AccountingDocument = _item.AccountingDocument
{
    _header.AccountingDocument,
    _header.LastChangeDate,
    _header._CompanyCode._Country.BankCheckRule,
    _header.CompanyCode,
    _item.AccountingDocumentItem,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    // Measures
    @DefaultAggregation: #SUM
   _item.AmountInCompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   _item.AmountInTransactionCurrency,
   _item.TransactionCurrency,
    _item
    
}

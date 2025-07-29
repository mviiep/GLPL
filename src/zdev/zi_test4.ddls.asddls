@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for test4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity zi_test4 as select from ZI_Test3
{
 key   AccountingDocument,
 key AccountingDocumentItem,
    LastChangeDate,
    BankCheckRule,
    CompanyCode,
   
     @Semantics.amount.currencyCode: 'TransactionCurrency'
      @DefaultAggregation: #SUM
    AmountInCompanyCodeCurrency,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    AmountInTransactionCurrency,
    TransactionCurrency,
    /* Associations */
    _item
}

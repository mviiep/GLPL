@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sALES REGISTER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zsales_register    
 as select from  I_AccountingDocumentJournal( P_Language : 'E' ) as A  
{
 key A.AccountingDocument as TY,
     A.DocumentReferenceID,
     A.CreationDate as invoice_date,
     A.PostingDate,
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      
//     a.CreditAmountInCoCodeCrcy as tax_amt,    
     A.CreditAmountInCoCodeCrcy as cntrl_amt,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
     A.CreditAmountInCoCodeCrcy as stut_amt,
     A.CompanyCode,
     A.FiscalYear,
     A.AccountingDocumentType,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
     A.CreditAmountInCoCodeCrcy as line_item,
     A.Customer,
     A.GLAccount,
     A.CreationDate,
     A.CompanyCodeCurrency
 
}
where A.AccountingDocument = 'RV' or A.AccountingDocument = 'DR' or A.AccountingDocument = 'ZA'

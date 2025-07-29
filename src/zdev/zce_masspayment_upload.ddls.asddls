@EndUserText.label: 'Custom entity for mass payment upload'
define root custom entity ZCE_MASSPAYMENT_UPLOAD
  // with parameters parameter_name : parameter_type
{
      //Item and creditor keys " 
  key serialno                       : abap.numc( 6 );
      CompanyCode                    : abap.char(4); // fis_bukrs;
      AccountingDocumentType         : abap.char(2); //  farp_blart;
      DocumentReferenceID            : abap.char(16); // fis_xblnr1;
      DocumentHeaderText             : abap.char(25); //  bktxt;so
      DocumentDate                   : abap.dats; //fis_bldat;
      PostingDate                    : abap.dats; //fis_budat;

      //Item details
      //CompanyCodeitem               : abap.char(4); // Need to check data type again                  //    fis_bukrs;
      ReferenceDocumentItem          : abap.numc( 6 ); // fis_awitem;
      GLAccount                      : abap.char(10);
      @Semantics.amount.currencyCode : 'CurrencyCode'
      AmountInTransactionCurrency    : abap.curr(23,2); //fis_wsl;
      DebitCreditCode                : abap.char(1); // fis_shkzg;
      DocumentItemText               : abap.char(50); //farp_sgtxt;
      HouseBank                      : abap.char(5); // farp_hbkid;
      HouseBankAccount               : abap.char(5); // fac_hktid  ;
      ProfitCenter                   : abap.char(10); //fis_prctr;

      // //Creditor Item Details
      CreditorReferenceDocumentItem  : abap.numc( 6 ); //fis_awitem ;
      Creditor                       : abap.char(10);
      @Semantics.amount.currencyCode : 'CurrencyCode'
      CreAmountInTransactionCurrency : abap.curr(23,2);
      CreditorDebitCreditCode        : abap.char(1);
      CurrencyCode                   : abap.cuky(5); // FIS_HWAER;
      CreditorDocumentItemText       : abap.char(50); // DocumentItemText;
      BusinessPlace                  : abap.char(4); //farp_bupla;
      SpecialGLCode                  : abap.char(1); //fac_umskz;


}

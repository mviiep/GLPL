@ObjectModel.query.implementedBy: 'ABAP:ZCL_CUSTOMER_AEGING'
@EndUserText.label: 'Vendor Ageing report'

define custom entity ZDEV_VENDOR_AGEING
{

      @UI                         : {
         lineItem                 : [{position: 10, importance: #HIGH}],
         selectionField           : [{position: 1}]}
      @EndUserText.label          : 'Company Code'
  key CompanyCode                 : abap.char(30);


      @UI                         : {
        lineItem                  : [{position: 20, importance: #HIGH}],
        selectionField            : [{position: 2}]}
      @EndUserText.label          : 'Vendor Code'
  key Supplier                    : abap.char(30);


      @UI                         : {lineItem       : [{position: 30}]}
      @EndUserText.label          : ' AccountingDocument/Invoice Reference'
  key AccountingDocument          : abap.char(30);


      @UI                         : {lineItem            : [{position: 40}]}
      @EndUserText.label          : 'Supplier Name'
      SupplierName                : abap.char(50);

      @UI                         : {lineItem       : [{position: 50}]}
      @EndUserText.label          : 'City Name'
      CityName                    : abap.char(30);

      @UI                         : {lineItem       : [{position: 60}]}
      @EndUserText.label          : 'Region'
      Region                      : abap.char(30);


      @UI                         : {lineItem       : [{position: 70}]}
      @EndUserText.label          : 'Account Group'
      SupplierAccountGroup        : abap.char(30);

      @UI                         : {lineItem       : [{position: 80}]}
      @EndUserText.label          : 'User'
      AccountingDocCreatedByUser  : abap.char(30);

      @UI                         : {lineItem       : [{position: 90}]}
      @EndUserText.label          : 'SpecialGLCode'
      SpecialGLCode               : abap.char(30);

      //      @UI                         : {
      //          lineItem                : [{position:90}],
      //          selectionField          : [{position: 3}]}
      //      @EndUserText.label          : 'Posting Date'
      //      PostingDate                 : abap.dats(8);


      @UI                         : {lineItem       : [{position: 100}]}
      @EndUserText.label          : 'Posting Date'

      PostingDate                 : abap.dats(8);

      @UI                         : {lineItem       : [{position: 110}]}
      @EndUserText.label          : 'Document Date'
      DocumentDate                : abap.dats(8);

      @UI                         : {lineItem       : [{position: 120}]}
      @EndUserText.label          : 'Document Type'

      AccountingDocumentType      : abap.char(30);

      //      @UI                         : {lineItem       : [{position: 120}]}
      //      @EndUserText.label          : 'Transaction Currency'
      //      TransactionCurrency         : abap.cuky(5);

      @UI                         : {lineItem       : [{position: 130}]}
      @EndUserText.label          : ' Document Reference ID'
      DocumentReferenceID         : abap.char(30);

      //      @UI                         : {lineItem       : [{position: 140}]}
      //      @EndUserText.label          : ' AccountingDocument/Invoice Reference'
      //      AccountingDocument          : abap.char(30);

      @UI                         : {lineItem       : [{position: 140}]}
      @EndUserText.label          : '  Fiscal Year/Document Year'
      FiscalYear                  : abap.char(30);

      @UI                         : {lineItem       : [{position: 150}]}
      @EndUserText.label          : '  LedgerGL Line Item/Invoice Ref Item'
      LedgerGLLineItem            : abap.char(30);

      //      @UI                         : {lineItem       : [{position: 170}]}
      //      @EndUserText.label          : '   Profit Center'
      //      ProfitCenter                : abap.char(30);
      //
      //      @UI                         : {lineItem       : [{position: 180}]}
      //      @EndUserText.label          : 'Profit Center Long name'
      //      ProfitCenterLongName        : abap.char(30);


      @UI                         : {lineItem       : [{position: 160}]}
      @EndUserText.label          : 'Document Item Text'
      DocumentItemText            : abap.char(30);


      @UI                         : {lineItem       : [{position: 170}]}
      @EndUserText.label          : 'Purchasing Document'
      PurchasingDocument          : abap.char(30);

      @UI                         : {lineItem       : [{position: 180}]}
      @EndUserText.label          : 'PurchasingDocumentItem'
      PurchasingDocumentItem      : abap.char(30);

      @UI                         : {lineItem       : [{position: 190}]}
      @EndUserText.label          : 'Due Date/Baseline Date'
      NetDueDate                  : abap.dats(8);

      @UI                         : {lineItem       : [{position:200}]}
      @EndUserText.label          : 'Payment Blocked'
      PaymentIsBlockedForSupplier : abap.char(30);

      @UI                         : {lineItem       : [{position: 210}]}
      @EndUserText.label          : 'Payment Terms'
      PaymentTerms                : abap.char(30);


      @UI                         : {lineItem       : [{position: 220}]}
      @EndUserText.label          : 'Transaction Currency'
      TransactionCurrency         : abap.cuky(5);


      @UI                         : {lineItem       : [{position: 230}]}
      @EndUserText.label          : 'Amount in CoCode Currency'
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'

      amountincompanycodecurrency : abap.curr(16,2);




      //      @UI                         : {lineItem       : [{position:240}]}
      //      @EndUserText.label          : 'AmountInTransactionCurrency'
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      AmountInTransactionCurrency : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position: 250 } ]}

      @EndUserText.label          : 'Less than 0'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_00                     : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position: 260 } ]}
      @EndUserText.label          : 'Days_0_to_30 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_0_to_30                : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position: 270 } ]}
      @EndUserText.label          : 'Days_31_to_45 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_31_to_45               : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position: 280 } ]}
      @EndUserText.label          : 'Days_46_to_60 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_46_to_60               : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position: 290 } ]}
      @EndUserText.label          : 'Days_61_to_90 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_61_to_90               : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position:300 } ]}
      @EndUserText.label          : 'Days_91_to_100 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_91_to_100              : abap.curr(16,2);

      @UI                         : {      lineItem: [ { position:310 } ]}
      @EndUserText.label          : 'Days_101_to_180 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_101_to_180             : abap.curr(16,2);

      @UI                         : { lineItem: [ { position:320 } ]}
      @EndUserText.label          : 'Greater than 180 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_greater_180            : abap.curr(16,2);

      @UI                         : { lineItem: [ { position:330} ]}
      @EndUserText.label          : 'Unadjusted Debit '
      //      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SpecialGLAmount             : abap.curr(16,2);

      @UI                         : {lineItem  : [{position: 340}]}
      @EndUserText.label          : 'Account Type'

      financialaccountype         : abap.char(30);





      @Consumption.filter         : {

                   selectionType  : #SINGLE,
                   multipleSelections: false

               }
      @EndUserText.label          : 'Open Items At Key Date'
      @Consumption.filter.mandatory:true
      @UI                         : {

       selectionField             : [{position: 3}]}
      //      @EndUserText.label          : 'Open Key Date'
      //       @Consumption.filter.mandatory: true
      //@Consumption: {
      //
      //
      //
      //
      //    filter: {
      //        mandatory: true,
      //
      //        selectionType: #INTERVAL,
      //        multipleSelections: true
      //
      //    }
      //    }
      //
      //   // }
      //}
      open_item_date              : abap.dats(8);


}

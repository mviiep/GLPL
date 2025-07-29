@ObjectModel.query.implementedBy: 'ABAP:ZCL_CUSTOMER_AEGING_REPORT'
@EndUserText.label: 'Customer Ageing report'



define custom entity ZDEV_CUSTOMER_AGEING_REPORT
{






      @UI                         : {
           lineItem               : [{position: 10, importance: #HIGH}],

           selectionField         : [{position: 1}]}
      @EndUserText.label          : 'Company Code'
  key CompanyCode                 : abap.char(30);


      @UI                         : {
       lineItem                   : [{position: 20, importance: #HIGH}],
      //       identification             : [ { position: 20} ],
       selectionField             : [{position: 2}]}
      @EndUserText.label          : 'Customer Code'
  key Customer                    : abap.char(30);



      @UI                         : {lineItem       : [{position: 30}]}
      //      @UI                         : {  identification         : [ { position: 30} ] }
      @EndUserText.label          : ' AccountingDocument/Invoice Reference'
  key AccountingDocument          : abap.char(30);


      @UI                         : {lineItem       : [{position: 40}]}
      //      @UI                         : {  identification         : [ { position: 40} ] }
      @EndUserText.label          : 'Due Date/Baseline Date'
      NetDueDate                  : abap.dats(8);


      @UI                         : {lineItem            : [{position: 50}]}
      //      @UI                         : {  identification         : [ { position: 50} ] }
      @EndUserText.label          : 'Flat Code'
      RoomNumber                  : abap.char(50);


      @UI                         : {lineItem            : [{position: 60}]}
      //      @UI                         : {  identification         : [ { position: 60} ] }
      @EndUserText.label          : 'Customer Name'
      CustomerName                : abap.char(50);





      @UI                         : {lineItem           : [{position: 70}]}
      @EndUserText.label          : 'Currency'
      TransactionCurrency         : abap.cuky(5);


      @UI                         : {lineItem            : [{position: 80}]}

      @EndUserText.label          : 'Billed during the F. Year'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalBill_FY                : abap.curr(16,2);


      @UI                         : {lineItem            : [{position: 90}]}
      @EndUserText.label          : 'Billed during the month'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Billed_During_Month         : abap.curr(16,2);
      
      
      
      @UI                         : {lineItem            : [{position: 100}]}

      @EndUserText.label          : 'Credits Adjusted during the F. Year'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      credit_year               : abap.curr(16,2);


      @UI                         : {lineItem            : [{position: 110}]}
      @EndUserText.label          : 'Credits Adjusted during the month'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      credit_month        : abap.curr(16,2);
      
      
      
       
      

      @UI                         : {lineItem            : [{position: 120}]}
      @EndUserText.label          : 'Collected during the F. Year'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Collected_YTD               : abap.curr(16,2);


      @UI                         : {lineItem            : [{position: 130}]}
      @EndUserText.label          : 'Collected during the month'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      Collected_Month             : abap.curr(16,2);





      //      @UI                         : {lineItem          : [{position: 120}]}
      //      @EndUserText.label          : 'Amount'
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      AmountInTransactionCurrency : abap.curr(16,2);

      //   @UI                         : { lineItem: [ { position: 130 } ]}

      @UI                         : {lineItem          : [{position: 140}]}
      @EndUserText.label          : 'Amount in CoCode Currencyy'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      amountincompanycodecurrency : abap.curr(16,2);
      @UI                         : { lineItem: [ { position: 150 } ]}

      @EndUserText.label          : 'Less than 0'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_00                     : abap.curr(16,2);

      @UI                         : {  lineItem: [ { position: 160 } ]}
      @EndUserText.label          : 'Days_0_to_30 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_0_to_30                : abap.curr(16,2);

      @UI                         : {  lineItem: [ { position: 170 } ]}
      @EndUserText.label          : 'Days_31_to_60 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_31_to_60               : abap.curr(16,2);

      @UI                         : {  lineItem: [ { position: 180 } ]}
      @EndUserText.label          : 'Days_61_to_90 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_61_to_90               : abap.curr(16,2);

      @UI                         : {  lineItem: [ { position: 190 } ]}
      @EndUserText.label          : 'Days_91_to_180'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_91_to_180              : abap.curr(16,2);

      @UI                         : { lineItem: [ { position:200 } ]}
      @EndUserText.label          : 'Greater than 180 '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      days_greater_180            : abap.curr(16,2);

      @UI                         : {lineItem           : [{position: 210}]}
      @EndUserText.label          : 'Sales Organization'
      SalesOrganization           : abap.char(50);


      @UI                         : {lineItem           : [{position: 220}]}
      @EndUserText.label          : 'Telephone Number'
      PhoneNumber                 : abap.char(50);

      @UI                         : {identification            : [{position: 230}]}
      @EndUserText.label          : 'Mobile Number'
      MobilePhoneNumber           : abap.char(50);

      @UI                         : {lineItem           : [{position: 240}]}
      @EndUserText.label          : 'Email Address'
      EmailAddress                : abap.char(50);

      @UI                         : { lineItem: [ { position:250} ]}
      @EndUserText.label          : 'Unadjusted Credit '
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      SpecialGLAmount             : abap.curr(16,2);

      @UI                         : {lineItem            : [{position: 260}]}
      @EndUserText.label          : 'Financial Account Type'
      FinancialAccountType        : abap.char(50);

      @Consumption.filter         : {

                  selectionType   : #SINGLE,
                  multipleSelections: false

              }
      @EndUserText.label          : 'Open Items At Key Date'
      @Consumption.filter.mandatory:true
      @UI                         : {

       selectionField             : [{position: 3}]}
//      @UI selectionField             :{ [{position: 2}]}



      open_item_date              : abap.dats(8);



}

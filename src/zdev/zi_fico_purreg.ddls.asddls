@EndUserText.label: 'FICO PURCHASE REGISTER'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FICO_PURCHASE_REGISTER'
define custom entity ZI_FICO_PURREG
  //with parameters parameter_name : parameter_type


{


      @UI.facet              : [{
                 id          :'ficoreg',
                 label       : 'FICO Purchase Register',
                 type        : #IDENTIFICATION_REFERENCE,
             //          targetQualifier:'Sales_Tender.SoldToParty',
                 position    : 10
                 }
                 ]


      @UI                    : {lineItem: [{ position: 10,label: 'Accounting Document ' }]}
      @UI                    : {identification: [{  position: 10,label: 'Accounting Document ' }] }
      @EndUserText           : {label: 'Accounting Document '}
      @UI.selectionField     : [ { position: 10}]
  key accountingdocument     : abap.char( 10 );


      @UI                    : {lineItem: [{ position: 15,label: 'Accounting Document Item ' }]}
      @UI                    : {identification: [{  position: 15,label: 'Accounting Document Item' }] }
      @EndUserText           : {label: 'Accounting Document Item'}
  key accountingdocumentitem : abap.char( 10 );

      @UI                    : {lineItem: [{ position: 20,label: 'Posting Date' }]}
      @UI                    : {identification: [{  position: 20,label: 'Posting Date' }] }
      @EndUserText           : {label: 'Posting Date '}
      @UI.selectionField     : [ { position: 20}]
      @Consumption.filter    : {
          mandatory          : true
      }
  key postingdate            : abap.dats; //Postingdate
  
    @UI                    : {lineItem: [{ position: 50,label: 'Vendor' }]}
      @UI                    : {identification: [{  position: 50,label: 'Vendor' }] }
      @EndUserText           : {label: 'Vendor'}
   key   supplier               : abap.char( 10 ); //vendor

      @UI                    : {lineItem: [{ position: 30,label: 'Business Place' }]}
      @UI                    : {identification: [{  position: 30,label: 'Business Place' }] }
      @EndUserText           : {label: 'Business Place'}
      Branch                 : abap.char( 4 ); //Businessplace

      @UI                    : {lineItem: [{ position: 40,label: 'GSTIN' }]}
      @UI                    : {identification: [{  position: 40,label: 'GSTIN' }] }
      @EndUserText           : {label: 'GSTIN'}
      Bptaxnumber            : abap.char( 20 ); //GSTIN

    

      @UI                    : {lineItem: [{ position: 60,label: 'GST Vendor Classification' }]}
      @UI                    : {identification: [{  position: 60,label: 'GST Vendor Classification' }] }
      @EndUserText           : {label: 'GST Vendor Classification'}
      vendorregis            : abap.char(40); //GST Vendor Classification

      @UI                    : {lineItem: [{ position: 70,label: 'Supplier Name ' }]}
      @UI                    : {identification: [{  position: 70,label: 'Supplier Name ' }] }
      @EndUserText           : {label: 'Supplier Name '}
      suppliername           : abap.char( 80 ); //name1

      @UI                    : {lineItem: [{ position: 80,label: 'Invoice Number' }]}
      @UI                    : {identification: [{  position: 80,label: 'Invoice Number' }] }
      @EndUserText           : {label: 'Invoice Number'}
      documentreferid        : abap.char( 16 ); //Invoice number

      @UI                    : {lineItem: [{ position: 90,label: 'RCM Invoice Number' }]}
      @UI                    : {identification: [{  position: 90,label: 'RCM Invoice Number' }] }
      @EndUserText           : {label: 'RCM Invoice Number'}
      documentreferenceidRCM : abap.char( 16 ); // RCM Invoice number

      @UI                    : {lineItem: [{ position: 100,label: 'Invoice Date' }]}
      @UI                    : {identification: [{  position: 100,label: 'Invoice Date' }] }
      @EndUserText           : {label: 'Invoice Date'}
      documentdate           : abap.dats; //invoicedate


      @UI                    : {lineItem: [{ position: 110,label: 'Invoice Value' }]}
      @UI                    : {identification: [{  position: 110,label: 'Invoice Value' }] }
      @EndUserText           : {label: 'Invoice Value'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      amountintrnscur        : abap.dec( 23 , 2 ); // Invoice Value


      @UI                    : {lineItem: [{ position: 120,label: 'Rate % RCM' }]}
      @UI                    : {identification: [{  position: 120,label: 'Rate % RCM' }] }
      @EndUserText           : {label: 'Rate % RCM'}
//      @Semantics.amount.currencyCode: 'companycodecurrency'
//      
//      raterevision           : abap.curr( 23 , 2 ); // raterevision
      raterevision           :abap.dec( 23 , 2 ); // raterevision

      @UI                    : {lineItem: [{ position: 130,label: 'Rate %' }]}
      @UI                    : {identification: [{  position: 130,label: 'Rate %' }] }
      @EndUserText           : {label: 'Rate %'}
     // @Semantics.amount.currencyCode: 'companycodecurrency'
      //rate                   : abap.curr( 23 , 2 ); // rate
      rate                   : abap.dec( 23 , 2 ); // rate
      

      @UI                    : {lineItem: [{ position: 140,label: 'Taxable Value' }]}
      @UI                    : {identification: [{  position: 140,label: 'Taxable Value' }] }
      @EndUserText           : {label: 'Taxable Value'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      taxablevalue           : abap.curr( 23 , 2 ); // taxablevalue

      @UI                    : {lineItem: [{ position: 150,label: 'Place Of Supply' }]}
      @UI                    : {identification: [{  position: 150,label: 'Place Of Supply' }] }
      @EndUserText           : {label: 'Place Of Supply'}
      gstplaceoofsupply      : abap.char( 3 );


      @UI                    : {lineItem: [{ position: 160,label: 'Integrated Tax Amount' }]}
      @UI                    : {identification: [{  position: 160,label: 'Integrated Tax Amount' }] }
      @EndUserText           : {label: 'Integrated Tax Amount'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      inttaxamount           : abap.curr( 23 , 2 ); // integrated tax amount

      @UI                    : {lineItem: [{ position: 170,label: 'Central Tax Amount' }]}
      @UI                    : {identification: [{  position: 170,label: 'Central Tax Amount' }] }
      @EndUserText           : {label: 'Central Tax Amount'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      centraltaxamt          : abap.curr( 23 , 2 ); // Central Tax Amount

      @UI                    : {lineItem: [{ position: 180,label: 'State/UT Tax Amount' }]}
      @UI                    : {identification: [{  position: 180,label: 'State/UT Tax Amount' }] }
      @EndUserText           : {label: 'State/UT Tax Amount'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      stateuttaxamt          : abap.curr( 23 , 2 ); // State UT Tax Amountt


      @UI                    : {lineItem: [{ position: 190,label: 'Reverse Charge Applicable Indicater' }]}
      @UI                    : {identification: [{  position: 190,label: 'Reverse Charge Applicable Indicater' }] }
      @EndUserText           : {label: 'Reverse Charge Applicable Indicater'}
      Reversecgeindicator    : abap.char( 1 );

      @UI                    : {lineItem: [{ position: 200,label: 'Integrated ITC Tax Amount' }]}
      @UI                    : {identification: [{  position: 200,label: 'Integrated ITC Tax Amount' }] }
      @EndUserText           : {label: 'Integrated ITC Tax Amount'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      integratedITCamt       : abap.curr( 23 , 2 ); // Integrated ITC tax amount


      @UI                    : {lineItem: [{ position: 210,label: 'Central ITC Tax Amount' }]}
      @UI                    : {identification: [{  position: 210,label: 'Central ITC Tax Amount' }] }
      @EndUserText           : {label: 'Central ITC Tax Amount'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      centralITCamt          : abap.curr( 23 , 2 ); // Central ITC tax amount

      @UI                    : {lineItem: [{ position: 220,label: 'State/UT ITC Tax Amount' }]}
      @UI                    : {identification: [{  position: 220,label: 'State/UT ITC Tax Amount' }] }
      @EndUserText           : {label: 'State/UT ITC Tax Amount'}
      @Semantics.amount.currencyCode: 'companycodecurrency'
      stateUtITCamt          : abap.curr( 23 , 2 ); // State UT ITC tax amount

      @UI                    : {lineItem: [{ position: 230,label: 'Original GSTIN' }]}
      @UI                    : {identification: [{  position: 230,label: 'Original GSTIN' }] }
      @EndUserText           : {label: 'Original GSTIN'}
      originaltaxnumber      : abap.char( 20 ); //Original GSTIN

      @UI                    : {lineItem: [{ position: 240,label: 'Company Code' }]}
      @UI                    : {identification: [{  position: 240,label: 'Company Code' }] }
      @EndUserText           : {label: 'Company Code'}
      companycode            : abap.char( 4 ); //Comapny code

      @UI                    : {lineItem: [{ position: 250,label: 'Invoice Item Number' }]}
      @UI                    : {identification: [{  position: 250,label: 'Invoice Item Number' }] }
      @EndUserText           : {label: 'Invoice Item Number'}
      ledgerglitem           : abap.char( 6 ); //Invoice item number

      @UI                    : {lineItem: [{ position: 260,label: 'Fiscal Year' }]}
      @UI                    : {identification: [{  position: 260,label: 'Fiscal Year' }] }
      @EndUserText           : {label: 'Fiscal Year'}
      fiscalyear             : abap.numc( 4 ); //fiscal year

      @UI                    : {lineItem: [{ position: 270,label: 'Document Type' }]}
      @UI                    : {identification: [{  position: 270,label: 'Document Type' }] }
      @EndUserText           : {label: 'Document Type'}
      documenttype           : abap.char( 2 ); //documenttype

      @UI                    : {lineItem: [{ position: 280,label: 'Tax Code' }]}
      @UI                    : {identification: [{  position: 280,label: 'Tax Code' }] }
      @EndUserText           : {label: 'Tax Code'}
      taxcode                : abap.char(2); //taxcode

      @UI                    : {lineItem: [{ position: 290,label: 'Profit Center' }]}
      @UI                    : {identification: [{  position: 290,label: 'Profit Center' }] }
      @EndUserText           : {label: 'Profit Center'}
      profitcenter           : abap.char( 10 ); //Profit center

      @UI                    : {lineItem: [{ position: 300,label: 'Reversed with' }]}
      @UI                    : {identification: [{  position: 300,label: 'Reversed with' }] }
      @EndUserText           : {label: 'Reversed with'}
      reversedocument        : abap.char( 10 ); // Reversed with

      @UI                    : {lineItem: [{ position: 310,label: 'Reverse Document Fiscal Year' }]}
      @UI                    : {identification: [{  position: 310,label: 'Reverse Document Fiscal Year' }] }
      @EndUserText           : {label: 'Reverse Document Fiscal Year'}
      reversedocumentyear    : abap.char( 4 ); // Reverse Docuement Fiscal Year

      @UI                    : {lineItem: [{ position: 320,label: 'HSN/SAC Code' }]}
      @UI                    : {identification: [{  position: 320,label: 'HSN/SAC Code' }] }
      @EndUserText           : {label: 'HSN/SAC Code'}
      hsncode                : abap.char( 16 ); // HSN/SAC Code

      @UI                    : {lineItem: [{ position: 330,label: 'CR/DR Ind' }]}
      @UI                    : {identification: [{  position: 330,label: 'CR/DR Ind' }] }
      @EndUserText           : {label: 'CR/DR Ind'}
      debitcreditcode        : abap.char( 1 ); //CN/DN Ind

      @UI                    : {lineItem: [{ position: 340,label: 'GL Account' }]}
      @UI                    : {identification: [{  position: 340,label: 'GL Account' }] }
      @EndUserText           : {label: 'GL Account'}
      glaccount              : abap.char( 10 ); //GL Account

      @UI                    : {lineItem: [{ position: 350,label: 'Cost Center' }]}
      @UI                    : {identification: [{  position: 350,label: 'Cost Center' }] }
      @EndUserText           : {label: 'Cost Center'}
      costcenter             : abap.char( 10 ); //Cost Center

      @UI                    : {lineItem: [{ position: 360,label: 'Ledger Text' }]}
      @UI                    : {identification: [{  position: 360,label: 'Ledger Text' }] }
      @EndUserText           : {label: 'Ledger Text'}
      glaccountlongname      : abap.char( 50 ); // Ledger Text

      @UI                    : {lineItem: [{ position: 370,label: 'User ID' }]}
      @UI                    : {identification: [{  position: 370,label: 'User ID' }] }
      @EndUserText           : {label: 'User ID'}
      accountingdocreatedby  : abap.char( 12 ); //username

      @UI                    : {lineItem: [{ position: 380,label: 'Purchasing Document' }]}
      @UI                    : {identification: [{  position: 380,label: 'Purchasing Document' }] }
      @EndUserText           : {label: 'Purchasing Document'}
      purchasingdocument     : ebeln; //Purchasing Document

      @UI                    : {lineItem: [{ position: 390,label: 'Purchase Group' }]}
      @UI                    : {identification: [{  position: 390,label: 'Purchase Group' }] }
      @EndUserText           : {label: 'Purchase Group'}
      purchasegroup          : abap.char( 3 ); // Purchase Group


      @UI                    : {lineItem: [{ position: 400,label: 'PO Created BY' }]}
      @UI                    : {identification: [{  position: 400,label: 'PO Created BY' }] }
      @EndUserText           : {label: 'PO Created BY'}
      pocreatedby            : abap.char( 12 ); //PO Created BY


      @UI                    : {lineItem: [{ position: 410,label: 'PO Creator Mail ID' }]}
      @UI                    : {identification: [{  position: 410,label: 'PO Creator Mail ID' }] }
      @EndUserText           : {label: 'PO Creator Mail ID'}
      pocreatormailid        : abap.char( 50 ); // po creator mail id   //look again

      @UI                    : {lineItem: [{ position: 420,label: 'Fixed Asset' }]}
      @UI                    : {identification: [{  position: 420,label: 'Fixed Asset' }] }
      @EndUserText           : {label: 'Fixed Asset'}
      fixedasset             : abap.char( 4 ); // Fixed Asset

      @UI                    : {lineItem: [{ position: 430,label: 'Order Quantity' }]}
      @UI                    : {identification: [{  position: 430,label: 'Order Quantity' }] }
      @EndUserText           : {label: 'Order Quantity'}
      @Semantics.quantity.unitOfMeasure: 'baseunit'
      orderquantity          : abap.quan( 13, 3 ); // Order Quantity

      @UI                    : {lineItem: [{ position: 440,label: 'Base Unit Of Measure' }]}
      @UI                    : {identification: [{  position: 440,label: 'Base Unit Of Measure' }] }
      @EndUserText           : {label: 'Base Unit Of Measure'}
      baseunit               : abap.unit( 3 ); // Base Unit Of Measure


      @UI                    : {lineItem: [{ position: 450,label: 'Profit Center Description' }]}
      @UI                    : {identification: [{  position: 450,label: 'Profit Center Description' }] }
      @EndUserText           : {label: 'Profit Center Description'}
      profitcenterdesc       : abap.char( 40 ); // Proft center Description

      @UI                    : {lineItem: [{ position: 460,label: 'Entry Date' }]}
      @UI                    : {identification: [{  position: 460,label: 'Entry Date' }] }
      @EndUserText           : {label: 'Entry Date'}
      entrydate              : abap.dats; //Entry Date
      companycodecurrency    : abap.cuky( 5 );
      transdetermination     : abap.char( 3 );
      //percentage : abap.char( 1 ); 

}

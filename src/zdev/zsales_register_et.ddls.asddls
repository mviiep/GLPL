@EndUserText.label: 'Sales register entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SALES_REG'

define custom entity zsales_register_et
 //with parameters INV_DATE : budat
{
 @UI.facet                : [
                        {
                          id         :  'Product',
                          purpose    :  #STANDARD,
                          type       :     #IDENTIFICATION_REFERENCE,
                          label      : 'Sales register',
                          position   : 10 }
                      ]
      
      
      
@UI.identification: [{ position: 140, label: 'Accounting Document' }]
     @UI              :{lineItem: [{ position: 140,label: 'Accounting Document' }]}
key AccountingDocument : abap.char(10);

     @UI                    : {lineItem: [{ position: 150,label: 'Accounting Document Item ' }]}
      @UI                    : {identification: [{  position: 150,label: 'Accounting Document Item' }] }
      @EndUserText           : {label: 'Accounting Document Item'}
  key accountingdocumentitem : abap.char( 10 );

     @UI              :{lineItem: [{ position: 20,label: 'Invoice Number' }]}
     @UI.identification: [{ position: 20,label: 'Invoice Number' }]
    DocumentReferenceID : abap.char(16);
    
     @UI              :{lineItem: [{ position: 40,label: 'Invoice Date' }]}
     @UI.identification: [{ position: 40,label: 'Invoice Date' }]
    CreationDate : abap.dats(8);
    
     @UI              :{lineItem: [{ position: 50,label: 'Posting Date' }]}
     @UI.identification: [{ position: 50,label: 'Posting Date' }]
     @UI.selectionField: [{ position: 10 }]
    PostingDate  : abap.dats(8);
    
     @UI              :{lineItem: [{ position: 80,label: 'Taxable Value' }]}
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
     @UI.identification: [{ position: 80,label: 'Taxable Value' }]
    tax_amt : abap.curr( 23, 2 );
    
     @UI              :{lineItem: [{ position: 110,label: 'Central Tax Amount' }]}
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      @UI.identification: [{ position: 110,label: 'Central Tax Amount' }]
    Central_amount : abap.curr( 23, 2 ) ;
    
     @UI              :{lineItem: [{ position: 120,label: 'State/UT Tax Amount' }]}
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
     @UI.identification: [{ position: 120,label: 'State/UT Tax Amount' }]
    stut_amt : abap.curr( 23, 2 );
    
     @UI              :{lineItem: [{ position: 130,label: 'Company Code' }]}
     @UI.identification: [{ position: 130,label: 'Company Code' }]
    CompanyCode : abap.char( 4 );
    
     @UI              :{lineItem: [{ position: 150,label: 'Fiscal Year' }]}
     @UI.identification: [{ position: 150,label: 'Fiscal Year' }]
     @UI.selectionField: [{ position: 20 }]
    FiscalYear  : abap.char( 4 );
    
     @UI              :{lineItem: [{ position: 170,label: 'Document Type' }]}
     @UI.identification: [{ position: 170,label: 'Document Type' }]
    AccountingDocumentType : abap.char( 4 );
    
     @UI              :{lineItem: [{ position: 180,label: 'Line Item Value' }]}
     @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
     @UI.identification: [{ position: 180,label: 'Line Item Value' }]
     item_val : abap.curr( 23, 2 );
    
     @UI              :{lineItem: [{ position: 200,label: 'Customer' }]}
     @UI.identification: [{ position: 200,label: 'Customer' }]
    Customer : abap.char(10);
    
     @UI              :{lineItem: [{ position: 210,label: 'G/L Account' }]}
     @UI.identification: [{ position: 210,label: 'G/L Account' }]
    GLAccount : abap.char(10);
    
     @UI              :{lineItem: [{ position: 140,label: 'Entry Date' }]}
     @UI.identification: [{ position: 140,label: 'Entry Date' }]
    CreationDat : abap.dats(8);
    
     @UI              :{lineItem: [{ position: 150,label: 'Company Code Currency' }]}
     @UI.identification: [{ position: 150,label: 'Company Code Currency' }]
    CompanyCodeCurrency : abap.cuky( 5 );
    
    @UI              :{lineItem: [{ position: 10,label: 'Business Place' }]}
    @UI.identification: [{ position: 10,label: 'Business Place' }]
    BUSINESSPLACE : abap.char( 4 );
    
    @UI              :{lineItem: [{ position: 20,label: 'GSTIN' }]}
    @UI.identification: [{ position: 20,label: 'GSTIN' }]
    BPTAXLONGNUMBER : abap.char( 60 );
    
    @UI              :{lineItem: [{ position: 160,label: 'HSN/SAC Code' }]}
    @UI.identification: [{ position: 160,label: 'HSN/SAC Code' }]
    IN_HSNORSACCODE :  abap.char( 16 );
    
    @UI              :{lineItem: [{ position: 190,label: 'Customer Name' }]}
    @UI.identification: [{ position: 190,label: 'Customer Name' }]
    BUSINESSPARTNERNAME1 : abap.char( 40);
    
    @UI              :{lineItem: [{ position: 220,label: 'G/L Description' }]}
    @UI.identification: [{ position: 220,label: 'G/L Description' }]
    GLACCOUNTLONGNAME : abap.char( 50 );
    
    @UI              :{lineItem: [{ position: 230,label: 'Profit Center' }]}
    @UI.identification: [{ position: 230,label: 'Profit Center' }]
    PROFITCENTER : abap.char( 10 );
    
    @UI              :{lineItem: [{ position: 240,label: 'Profitcenter Description' }]}
    @UI.identification: [{ position: 240,label: 'Profitcenter Description' }]
    profitcenterdesc : abap.char( 50 );
    
//     @UI              :{lineItem: [{ position: 30,label: 'Invoice Item Number' }]}
//     @UI.identification: [{ position: 30, label: 'Invoice Item Number' }]
    LEDGERGLLINEITEM : abap.char( 6 );
    
     @UI              :{lineItem: [{ position: 90,label: 'Place Of Supply' }]}
     @UI.identification: [{ position: 90,label: 'Place Of Supply' }]
     place_supply : abap.char( 3 );
   
    @UI              :{lineItem: [{ position: 100,label: 'Integrated Tax Amount' }]}
   @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} } 
   @UI.identification: [{ position: 100,label: 'Integrated Tax Amount' }]
    int_tax_amt : abap.curr( 23, 2 ) ;
    
    
    @UI              :{lineItem: [{ position: 60,label: 'Invoice Value' }]}
     @UI.identification: [{ position: 60, label: 'Invoice Value' }]
    inv_val : abap.dec( 16, 2 );
    
    @UI              :{lineItem: [{ position: 70,label:'Rate' }]}
     @UI.identification: [{ position: 70, label: 'Rate' }]
    rate : abap.char( 4 );
    
    @UI              :{lineItem: [{ position: 250,label:'Invoice Reference Number' }]}
     @UI.identification: [{ position: 250, label: 'Invoice Reference Number' }]
    inv_ref : abap.char( 64 );
      
}

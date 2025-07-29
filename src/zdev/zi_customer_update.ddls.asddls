//@AbapCatalog.sqlViewName: 'ZZI_CUST_UPDATE'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Customer data update'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_CUSTOMER_UPDATE
  as select distinct from I_Customer as a
  association [0..1] to I_BuPaIdentification as b    on  a.Customer             = b.BusinessPartner
                                                     and b.BPIdentificationType = 'PAN'
  association [0..1] to I_CustSalesAreaTax   as JOIG on  a.Customer               = JOIG.Customer
                                                     and JOIG.CustomerTaxCategory = 'JOIG'
  //                                                     and a._CustomerSalesArea.Division = JOIG.Division
  association [0..1] to I_BusinessPartner    as c    on  a.Customer = c.BusinessPartner
  association [0..1] to zcust_zoho_statu     as f    on  a.Customer = f.customer
{
      @UI.facet         : [{
                          id      :'Customer',
                          label   : 'Customer',
                          type    : #IDENTIFICATION_REFERENCE,
                          position: 10 }]
      @UI : {  lineItem       : [ { position: 10 },{ type: #FOR_ACTION, dataAction: 'Update_Customer', label: 'Update Customer'} ],
               identification : [ { position: 10 },{ type: #FOR_ACTION, dataAction: 'Update_Customer', label: 'Update Customer'} ],
               selectionField: [ { position:1  } ]}
      @EndUserText.label: 'Customer'
  key a.Customer,
      @UI : {  lineItem       : [ { position: 13 } ],
               identification : [ { position: 13 } ]}
      @EndUserText.label: 'Code'
      case
      when c.LastChangeDate is initial
      then 0
      when c.LastChangeDate is not initial and f.clastchangedate is initial
      then 200
      when c.LastChangeDate <> f.clastchangedate and c.LastChangeTime <> f.clastchangetime
      then 200
//      when c.LastChangeDate = f.clastchangedate and c.LastChangeTime = f.clastchangetime
//      then 203
      when f.message = 'Data Updated Successfully'
      then 201
      //      else 202
       end                                                                              as code,

      @UI : {  lineItem       : [ { position: 17} ],
               identification : [ { position: 17 } ]}
      @EndUserText.label: 'Message'
      case
      when c.LastChangeDate is initial
      then ''
      when c.LastChangeDate is not initial and f.clastchangedate is initial
      then 'To be sent to ZOHO'
      when c.LastChangeDate <> f.clastchangedate and c.LastChangeTime <> f.clastchangetime
      then 'To be sent to ZOHO'
      when c.LastChangeDate = f.clastchangedate and c.LastChangeTime = f.clastchangetime
      then f.message
      else 'To be sent to ZOHO'
      end                                                                              as message,

      //      @UI : {  lineItem       : [ { position: 260 } ],
      //               identification : [ { position: 260 } ]}
      //      @EndUserText.label: 'Division'
      //  key a._CustomerSalesArea.Division,
      @UI : {  lineItem       : [ { position: 20 } ],
               identification : [ { position: 20 } ]}
      @EndUserText.label: 'SearchTerm1'
      a.AddressSearchTerm1,
      @UI : {  lineItem       : [ { position: 30 } ],
               identification : [ { position: 30 } ]}
      @EndUserText.label: 'Name1'
      a.BusinessPartnerName1,
      @UI : {  lineItem       : [ { position: 40 } ],
               identification : [ { position: 40 } ]}
      @EndUserText.label: 'Name2'
      a.BusinessPartnerName2,
      @UI : {  lineItem       : [ { position: 50 } ],
               identification : [ { position: 50 } ]}
      @EndUserText.label: 'Name3'
      a.BusinessPartnerName3,
      @UI : {  lineItem       : [ { position: 60 } ],
               identification : [ { position: 60 } ]}
      @EndUserText.label: 'Name4'
      a.BusinessPartnerName4,
      @UI : {  lineItem       : [ { position: 70 } ],
               identification : [ { position: 70 } ]}
      @EndUserText.label: 'Street Name'
      a.StreetName,
      @UI : {  lineItem       : [ { position: 80 } ],
               identification : [ { position: 80 } ]}
      @EndUserText.label: 'House Number'
      a._AddressRepresentation.HouseNumber,
      @UI : {  lineItem       : [ { position: 90 } ],
               identification : [ { position: 90 } ]}
      @EndUserText.label: 'Street 2'
      a._AddressRepresentation.StreetPrefixName1                                        as street2,
      @UI : {  lineItem       : [ { position: 100 } ],
               identification : [ { position: 100 } ]}
      @EndUserText.label: 'Street 3'
      a._AddressRepresentation.StreetPrefixName2                                        as street3,
      @UI : {  lineItem       : [ { position: 105 } ],
               identification : [ { position: 105 } ]}
      @EndUserText.label: 'City Name'
      a._AddressRepresentation.CityName,
      @UI : {  lineItem       : [ { position: 107 } ],
               identification : [ { position: 107 } ]}
      @EndUserText.label: 'District'
      a._AddressRepresentation.DistrictName,
      @UI : {  lineItem       : [ { position: 110 } ],
               identification : [ { position: 110 } ]}
      @EndUserText.label: 'Country'
      a._AddressRepresentation.Country,
      @UI : {  lineItem       : [ { position: 117 } ],
               identification : [ { position: 117 } ]}
      @EndUserText.label: 'Country'
      a._AddressRepresentation._Country._Text[ Language = 'E' ].CountryName,
      @UI : {  lineItem       : [ { position: 120 } ],
               identification : [ { position: 120 } ]}
      @EndUserText.label: 'Region'
      a._AddressRepresentation.Region,
      @UI : {  lineItem       : [ { position: 125 } ],
               identification : [ { position: 125 } ]}
      @EndUserText.label: 'Region'
      a._AddressRepresentation._Region._RegionText[ Language = 'E' and Country = 'IN' ].RegionName,
      @UI : {  lineItem       : [ { position: 130 } ],
               identification : [ { position: 130 } ]}
      @EndUserText.label: 'PO Box'
      a._AddressRepresentation.POBox,
      @UI : {  lineItem       : [ { position: 140 } ],
               identification : [ { position: 140 } ]}
      @EndUserText.label: 'Postal Code'
      a._AddressRepresentation.PostalCode,
      @UI : {  lineItem       : [ { position: 150 } ],
               identification : [ { position: 150 } ]}
      @EndUserText.label: 'Language'
      a.Language,
      @UI : {  lineItem       : [ { position: 160 } ],
               identification : [ { position: 160 } ]}
      @EndUserText.label: 'Telephone'
      a.TelephoneNumber1                                                                as Telephone,
      @UI : {  lineItem       : [ { position: 170 } ],
               identification : [ { position: 170 } ]}
      @EndUserText.label: 'Phone'
      a.TelephoneNumber2                                                                as Phone,
      @UI : {  lineItem       : [ { position: 180 } ],
               identification : [ { position: 180 } ]}
      @EndUserText.label: 'Fax Number'
      a.FaxNumber,
      @UI : {  lineItem       : [ { position: 190 } ],
               identification : [ { position: 190 } ]}
      @EndUserText.label: 'Tax Number3'
      a.TaxNumber3,
      @UI : {  lineItem       : [ { position: 195 } ],
               identification : [ { position: 195 } ]}
      @EndUserText.label: 'PAN Number'
      b.BPIdentificationNumber,
      @UI : {  lineItem       : [ { position: 200 } ],
               identification : [ { position: 200 } ]}
      @EndUserText.label: 'Company Code'
      a._CustomerCompany.CompanyCode,
      @UI : {  lineItem       : [ { position: 210 } ],
               identification : [ { position: 210 } ]}
      @EndUserText.label: 'Reconciliation Account'
      a._CustomerCompany.ReconciliationAccount,
      case a._CustomerCompany.ReconciliationAccount
      when '0020701010'
      then 'Trade Receivables_Domestic'
      when '0020701020'
      then 'Trade Receivables_Export'
      when '0020701030'
      then 'Trade Receivables_Group Companies'
      end                                                                               as ReconciliationAccountName,
      //      @UI : {  lineItem       : [ { position: 220 } ],
      //               identification : [ { position: 220 } ]}
      //      @EndUserText.label: 'Customer Payment Terms'
      //      a._CustomerSalesArea.CustomerPaymentTerms,
      @UI : {  lineItem       : [ { position: 230 } ],
               identification : [ { position: 230 } ]}
      @EndUserText.label: 'Email Address'
      a._AddressRepresentation._EmailAddress.EmailAddress,
      @UI : {  lineItem       : [ { position: 240 } ],
               identification : [ { position: 240 } ]}
      @EndUserText.label: 'Sales Organization'
      a._CustomerSalesArea.SalesOrganization,
      @UI : {  lineItem       : [ { position: 250 } ],
               identification : [ { position: 250 } ]}
      @EndUserText.label: 'DistributionChannel'
      a._CustomerSalesArea.DistributionChannel,
      @UI : {  lineItem       : [ { position: 250 } ],
               identification : [ { position: 250 } ]}
      @EndUserText.label: 'DistributionChannel Name'
      a._CustomerSalesArea._DistributionChannel._Text[ Language = 'E' ].DistributionChannelName,

      @UI : {  lineItem       : [ { position: 270 } ],
               identification : [ { position: 270 } ]}
      @EndUserText.label: 'Sales District'
      a._CustomerSalesArea.SalesDistrict,
      @UI : {  lineItem       : [ { position: 280 } ],
               identification : [ { position: 280 } ]}
      @EndUserText.label: 'Currency'
      a._CustomerSalesArea.Currency,
      a.DeletionIndicator,
      a._CustomerSalesArea._Currency._Text[Language = 'E'].CurrencyName,
      @UI : {  lineItem       : [ { position: 290 } ],
               identification : [ { position: 290 } ]}
      @EndUserText.label: 'Customer Pricing Procedure'
      a._CustomerSalesArea.CustomerPricingProcedure,
      case a._CustomerSalesArea.CustomerPricingProcedure
      when  '01'
      then 'Procedure 01'
      when '02'
      then 'Procedure 02' end                                                           as custompricprocedescription,
      @UI : {  lineItem       : [ { position: 300 } ],
               identification : [ { position: 300 } ]}
      @EndUserText.label: 'Customer Account Assignment Group'
      a._CustomerSalesArea.CustomerAccountAssignmentGroup,
      case a._CustomerSalesArea.CustomerAccountAssignmentGroup
      when  '01'
      then 'Domestic Revenues'
      when '02'
      then 'Foreign Revenues' end                                                       as CustAccAssignGroupDesc,
      @UI : {  lineItem       : [ { position: 310 } ],
               identification : [ { position: 310 } ]}
      @EndUserText.label: 'Tax_Category_1_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOIG' ].CustomerTaxCategory       as Tax_Category_1_Code,
      @UI : {  lineItem       : [ { position: 320 } ],
               identification : [ { position: 320 } ]}
      @EndUserText.label: 'Tax_Classification_1_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOIG' ].CustomerTaxClassification as Tax_Classification_1_Code,
      case a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOIG' ].CustomerTaxClassification
      when  '0'
      then 'GST Registered'
      when '1'
      then 'Not Registered' end                                                         as Tax_Classification_1_descr,
      @UI : {  lineItem       : [ { position: 330 } ],
               identification : [ { position: 330 } ]}
      @EndUserText.label: 'Tax_Category_2_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOCG' ].CustomerTaxCategory       as Tax_Category_2_Code,
      @UI : {  lineItem       : [ { position: 340 } ],
               identification : [ { position: 340 } ]}
      @EndUserText.label: 'Tax_Classification_2_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOCG' ].CustomerTaxClassification as Tax_Classification_2_Code,
      case a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOCG' ].CustomerTaxClassification
      when  '0'
      then 'GST Registered'
      when '1'
      then 'Not Registered' end                                                         as Tax_Classification_2_descr,
      @UI : {  lineItem       : [ { position: 350 } ],
               identification : [ { position: 350 } ]}
      @EndUserText.label: 'Tax_Category_3_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOSG' ].CustomerTaxCategory       as Tax_Category_3_Code,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Classification_3_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOSG' ].CustomerTaxClassification as Tax_Classification_3_Code,
      case a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOSG' ].CustomerTaxClassification
      when  '0'
      then 'GST Registered'
      when '1'
      then 'Not Registered' end                                                         as Tax_Classification_3_descr,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Category_4_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOUG' ].CustomerTaxCategory       as Tax_Category_4_Code,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Classification_4_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOUG' ].CustomerTaxClassification as Tax_Classification_4_Code,
      case a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JOUG' ].CustomerTaxClassification
      when  '0'
      then 'GST Registered'
      when '1'
      then 'Not Registered' end                                                         as Tax_Classification_4_descr,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Category_5_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JCOS' ].CustomerTaxCategory       as Tax_Category_5_Code,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Classification_5_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JCOS' ].CustomerTaxClassification as Tax_Classification_5_Code,
      case a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JCOS' ].CustomerTaxClassification
      when  '0'
      then 'GST Registered'
      when '1'
      then 'Not Registered' end                                                         as Tax_Classification_5_descr,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Category_6_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JTC1' ].CustomerTaxCategory       as Tax_Category_6_Code,
      @UI : {  lineItem       : [ { position: 360 } ],
               identification : [ { position: 360 } ]}
      @EndUserText.label: 'Tax_Classification_6_Code'
      a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JTC1' ].CustomerTaxClassification as Tax_Classification_6_Code,
      case a._CustomerSalesAreaTax[ CustomerTaxCategory = 'JTC1' ].CustomerTaxClassification
      when  '0'
      then 'GST Registered'
      when '1'
      then 'Not Registered' end                                                         as Tax_Classification_6_descr,
      c.LastChangeDate,
      c.LastChangeTime

}

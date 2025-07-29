@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Supplier Master'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SUPPLIER_MASTER
  as select distinct from I_Supplier
  association [1..1] to ZI_ZohoSupplier            as ZOHO_Supplier on  I_Supplier.Supplier = ZOHO_Supplier.supplier
  association [1..1] to I_AddressEmailAddress_2    as address       on  I_Supplier.AddressID = address.AddressID
  association [1..1] to I_SupplierCompany          as code          on  I_Supplier.Supplier = code.Supplier
  association [1..1] to I_SupplierPurchasingOrg    as org           on  I_Supplier.Supplier = org.Supplier
  association [1..1] to I_AddrOrgNamePostalAddress as house         on  I_Supplier.AddressID = house.AddressID
  association [1..1] to I_BusinessPartnerSupplier  as partner       on  I_Supplier.Supplier = partner.Supplier

  association [1..1] to I_Businesspartnertaxnumber as taxcatin3     on  I_Supplier.Supplier = taxcatin3.BusinessPartner
                                                                    and taxcatin3.BPTaxType = 'IN3'

  association [1..1] to I_Businesspartnertaxnumber as taxcatin5     on  I_Supplier.Supplier = taxcatin5.BusinessPartner
                                                                    and taxcatin5.BPTaxType = 'IN5'

  association [1..1] to I_Address_2                as street        on  I_Supplier.AddressID = street.AddressID
  association [1..1] to I_SupplierPurchasingOrg    as grp           on  I_Supplier.Supplier = grp.Supplier
  association [1..1] to I_BusinessPartner          as bussiness     on  I_Supplier.Supplier = bussiness.BusinessPartner



{

            @UI.facet         : [{
                              id      :'Supplier',
                              label   :'Supplier',
                              type    :#IDENTIFICATION_REFERENCE,
                              position:10}]

            @UI:{ lineItem: [{ position: 10} , { type: #FOR_ACTION , dataAction: 'CreateSupplier' , label: 'Create Supplier' } ] ,
                selectionField         : [{position: 1}]}
            @UI.identification: [{ position: 10, label: 'Supplier' }]

            @EndUserText.label: 'Supplier'
  key       Supplier,

            @UI:{ lineItem: [{ position: 20, label: 'ZOHO Supplier' }],
                identification: [{ position: 20, label: 'ZOHO Supplier' }]  }
            @EndUserText.label: 'ZOHO Supplier'
            ZOHO_Supplier.res_supplier,


            @UI:{ lineItem: [{ position:30 , label: 'Status'  }],
            identification: [{ position:30 , label: 'Status'   }]  ,
            selectionField         : [{position: 2}]}
            @EndUserText.label: 'Status'

            case

            when  bussiness.CreationDate >= bussiness.LastChangeDate and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            then  ZOHO_Supplier.status

            when  bussiness.CreationDate >= bussiness.LastChangeDate and
                           bussiness.CreationTime <> bussiness.LastChangeTime and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            then  ZOHO_Supplier.status

            when  bussiness.CreationDate = bussiness.LastChangeDate and
                           bussiness.CreationTime <> bussiness.LastChangeTime and bussiness.LastChangeTime > ZOHO_Supplier.cr_time and  ZOHO_Supplier.flag = 'C'
            then ZOHO_Supplier.status

            when ZOHO_Supplier.flag = 'C'
            then ZOHO_Supplier.status

            when ZOHO_Supplier.flag = 'U' and bussiness.LastChangeDate >= ZOHO_Supplier.ch_date and bussiness.LastChangeTime > ZOHO_Supplier.ch_time
            then ZOHO_Supplier.status

            when ZOHO_Supplier.flag = 'U' and ZOHO_Supplier.res_supplier is not initial
            then ZOHO_Supplier.status


            when ZOHO_Supplier.status = '202' and ZOHO_Supplier.msg is not initial
            then ZOHO_Supplier.status

            else ZOHO_Supplier.status
            end                             as status,

            @UI:{ lineItem: [{ position:40 , label: 'Message'  }],
            identification: [{ position:40 , label: 'Message'   }]  }
            @EndUserText.label: 'Message'


            case

            when  bussiness.CreationDate >= bussiness.LastChangeDate and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            then 'To be created in ZOHO'

            when  bussiness.CreationDate >= bussiness.LastChangeDate and
                           bussiness.CreationTime <> bussiness.LastChangeTime and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            then 'To be updated in ZOHO'

            when  bussiness.CreationDate = bussiness.LastChangeDate and
                           bussiness.CreationTime <> bussiness.LastChangeTime and bussiness.LastChangeTime > ZOHO_Supplier.cr_time and  ZOHO_Supplier.flag = 'C'
            then 'To be updated in ZOHO'

            when ZOHO_Supplier.flag = 'C'
            then 'Created in ZOHO Successfully'

            when ZOHO_Supplier.flag = 'U' and bussiness.LastChangeDate >= ZOHO_Supplier.ch_date and bussiness.LastChangeTime > ZOHO_Supplier.ch_time
            then 'To be updated in ZOHO'

            when ZOHO_Supplier.flag = 'U' and bussiness.LastChangeDate > ZOHO_Supplier.ch_date
            then 'To be updated in ZOHO'

            when ZOHO_Supplier.flag = 'U' and ZOHO_Supplier.res_supplier is not initial
            then 'Data Updated Successfully'


            when ZOHO_Supplier.status = '202' and ZOHO_Supplier.msg is not initial
            then ZOHO_Supplier.msg

            else 'To be Created in ZOHO'

            end                             as message,

            @UI.identification: [{ position: 50, label: 'AC Group' }]
            @UI:{ lineItem: [{ position: 50} , { type: #FOR_ACTION , dataAction: 'UpdateSupplier' , label: 'Update Supplier' } ] ,
            selectionField         : [{position: 3}]}


            @EndUserText.label: 'Ac Group'
            SupplierAccountGroup,


            @UI:{ lineItem: [{ position: 50, label: 'Supplier Name' }],
                identification: [{ position: 50, label: 'Supplier Name' }]  }
            @EndUserText.label: 'Supplier Name'
            SupplierName,


            @UI:{ lineItem: [{ position: 60, label: 'Search Item1' }],
                identification: [{ position: 60, label: 'Search Item1' }]  }
            @EndUserText.label: 'Search Item1'
            AddressSearchTerm1,

            @UI:{ lineItem: [{ position: 70, label: 'Name1' }],
                identification: [{ position: 70, label: 'Name1' }]  }
            @EndUserText.label: 'Name1'
            BusinessPartnerName1,


            @UI:{ lineItem: [{ position: 80, label: 'Name2' }],
                identification: [{ position: 80, label: 'Name2' }]  }
            @EndUserText.label: 'Name2'
            BusinessPartnerName2,



            @UI:{ lineItem: [{ position: 90, label: 'Name3' }],
                identification: [{ position: 90, label: 'Name3' }]  }
            @EndUserText.label: 'Name3'
            BusinessPartnerName3,


            @UI:{ lineItem: [{ position: 100, label: 'Name4' }],
                identification: [{ position: 100, label: 'Name4' }]  }
            @EndUserText.label: 'Name4'
            BusinessPartnerName4,



            @UI:{ lineItem: [{ position: 110, label: 'Street Name' }],
                identification: [{ position: 110, label: 'Street Name' }]  }
            @EndUserText.label: 'Street Name'
            BPAddrStreetName,



            @UI:{ lineItem: [{ position: 120, label: 'City Name'  }],
                identification: [{ position: 120, label: 'City Name' }]  }
            @EndUserText.label: 'City Name'
            BPAddrCityName,


            @UI:{ lineItem: [{ position: 130, label: 'District Name' }],
                identification: [{ position: 130, label: 'District Name' }]  }
            @EndUserText.label: 'District Name'
            DistrictName,



            @UI:{ lineItem: [{ position: 140, label: 'Country' }],
                identification: [{ position: 140, label: 'Country' }]  }
            @EndUserText.label: 'Country'
            Country,


            @UI:{ lineItem: [{ position: 150, label: 'Region'  }],
              identification: [{ position: 150, label: 'Region' }]  }
            @EndUserText.label: 'Region'
            Region,


            @UI:{ lineItem: [{ position: 160, label: 'Postal Code'  }],
                identification: [{ position: 160, label: 'Postal Code' }]  }
            @EndUserText.label: 'Postal Code'
            PostalCode,

            @UI:{ lineItem: [{ position: 170, label: 'Language'  }],
                identification: [{ position: 170, label: 'Language' }]  }
            @EndUserText.label: 'Language'
            SupplierLanguage,

            @UI:{ lineItem: [{ position: 180, label: 'Telephone'  }],
                identification: [{ position: 180, label: 'Telephone' }]  }
            @EndUserText.label: 'Telephone'
            PhoneNumber2,

            @UI:{ lineItem: [{ position: 190, label: 'Mobile'  }],
                identification: [{ position: 190, label: 'Mobile' }]  }
            @EndUserText.label: 'Mobile'
            PhoneNumber1,


            @UI:{ lineItem: [{ position: 200, label: 'Fax'  }],
                identification: [{ position: 200, label: 'Fax' }]  }
            @EndUserText.label: 'Fax'
            FaxNumber,

            @UI:{ lineItem: [{ position: 210, label: 'Pan number'  }],
               identification: [{ position: 210, label: 'Pan Number' }]  ,
                selectionField         : [{position: 4}]}
            @EndUserText.label: 'Pan Number'

            BusinessPartnerPanNumber,


            @UI:{ lineItem: [{ position: 220, label: 'PaymentTerms'  }],
               identification: [{ position:220, label: 'PaymentTerms' }]  }
            @EndUserText.label: 'PaymentTerms'
            code.PaymentTerms               as payment,


            @UI:{ lineItem: [{ position: 230, label: 'Email' }],
             identification: [{ position: 230, label: 'Email' }]  }
            @EndUserText.label: 'Email'
            address.EmailAddress            as email,


            @UI:{ lineItem: [{ position: 240, label: 'Company Code' }],
             identification: [{ position: 240, label: 'Company Code' }]  }
            @EndUserText.label: 'Company Code'

            code.CompanyCode                as companycode,

            @UI:{ lineItem: [{ position: 250, label: 'Purchase Org' }],
             identification: [{ position: 250, label: 'Purchase Org' }]  }
            @EndUserText.label: 'Purchase Org'

            org.PurchasingOrganization      as purchaseorg,

            @UI:{ lineItem: [{ position: 260 , label: 'Reconciliation Account  ' }],
             identification: [{ position: 260 , label: 'Reconciliation Account' }]  }
            @EndUserText.label: 'Reconciliation Account'
            code.ReconciliationAccount      as account,

            @UI:{ lineItem: [{ position:270 , label: 'House Number' }],
             identification: [{ position:270 , label: 'House Number' }]  }
            @EndUserText.label: 'House Number'

            house.HouseNumber               as house,


            @UI:{ lineItem: [{ position:280, label: 'Business Partner Category       '                                                                                                                                                                                                                                                                                                                                                                                                                                                                   }],
             identification: [{ position:280 , label: 'Business Partner Category       '                                                                                                                                                                                                                                                                                                                                                                                                                                                                   }]  }
            @EndUserText.label: 'Business Partner Category       '
            partner.BusinessPartnerCategory as partner,


            @UI:{ lineItem: [{ position:290 , label: 'Title '  }],
             identification: [{ position:290 , label: 'Title '   }]  }
            @EndUserText.label: 'Title'
            partner.FormOfAddress           as title,


            @UI:{ lineItem: [{ position:300 , label: 'TaxNumberCategory:GST '  }],
             identification: [{ position:300 , label: 'TaxNumberCategory:GST'   }]  }
            @EndUserText.label: 'TaxNumberCategory: GST'
            taxcatin3.BPTaxType             as taxNumberCategory_gst,


            @UI:{ lineItem: [{ position:310 , label: 'TaxNumber Category: MSME'  }],
            identification: [{ position:310 , label: 'TaxNumber Category:  MSME '   }]  }
            @EndUserText.label: 'TaxNumber Category: MSME'
            taxcatin5.BPTaxType             as taxNumberCategory_msme,

            @UI:{ lineItem: [{ position:320 , label: 'TaxNumberLong: GST  '  }],
             identification: [{ position:320 , label: 'TaxNumberLong: GST'   }]  ,
             selectionField         : [{position: 5}]}
            @EndUserText.label: 'TaxNumberLong: GST'
            taxcatin3.BPTaxNumber           as taxNumberLong_gst,

            @UI:{ lineItem: [{ position:330 , label: 'taxNumberLong :MSME'  }],
             identification: [{ position:330 , label: 'taxNumberLong : MSME'   }]  }
            @EndUserText.label: 'taxNumberLong: MSME'
            taxcatin5.BPTaxLongNumber       as taxNumberLong_msme,


            @UI:{ lineItem: [{ position:340 , label: ' street2 '  }],
             identification: [{ position:340 , label: ' street2'   }]  }
            @EndUserText.label: 'street2'
            street.StreetPrefixName1        as street2,


            @UI:{ lineItem: [{ position:350 , label: ' street3 '  }],
             identification: [{ position:350 , label: ' street3'   }]  }
            @EndUserText.label: 'street3'
            street.StreetPrefixName2        as street3,

            @UI:{ lineItem: [{ position:360 , label: ' Schema Group Supplier '  }],
             identification: [{ position:360 , label: ' Schema Group Supplier'   }]  }
            @EndUserText.label: 'Schema Group Supplier'
            grp.CalculationSchemaGroupCode  as groupsupplier,

            @UI:{ lineItem: [{ position:370 , label: ' invoice '  }],
             identification: [{ position:370 , label: ' invoice'   }]  }
            @EndUserText.label: 'invoice'
            grp.InvoiceIsGoodsReceiptBased  as invoice,


            //            @UI:{ lineItem: [{ position:360 , label: 'Status'  }],
            //            identification: [{ position:360 , label: 'Status'   }]  }
            //            @EndUserText.label: 'Status'
            //
            //            case
            //
            //            when  bussiness.CreationDate >= bussiness.LastChangeDate and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            //            then  ZOHO_Supplier.status
            //
            //            when  bussiness.CreationDate >= bussiness.LastChangeDate and
            //                           bussiness.CreationTime <> bussiness.LastChangeTime and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            //            then  ZOHO_Supplier.status
            //
            //            when  bussiness.CreationDate = bussiness.LastChangeDate and
            //                           bussiness.CreationTime <> bussiness.LastChangeTime and bussiness.LastChangeTime > ZOHO_Supplier.cr_time and  ZOHO_Supplier.flag = 'C'
            //            then ZOHO_Supplier.status
            //
            //            when ZOHO_Supplier.flag = 'C'
            //            then ZOHO_Supplier.status
            //
            //            when ZOHO_Supplier.flag = 'U' and bussiness.LastChangeDate >= ZOHO_Supplier.ch_date and bussiness.LastChangeTime > ZOHO_Supplier.ch_time
            //            then ZOHO_Supplier.status
            //
            //            when ZOHO_Supplier.flag = 'U' and ZOHO_Supplier.res_supplier is not initial
            //            then ZOHO_Supplier.status
            //
            //
            //            when ZOHO_Supplier.status = '202' and ZOHO_Supplier.msg is not initial
            //            then ZOHO_Supplier.status
            //
            //            else ZOHO_Supplier.status
            //            end                             as status,
            //
            //            @UI:{ lineItem: [{ position:370 , label: 'Message'  }],
            //            identification: [{ position:370 , label: 'Message'   }]  }
            //            @EndUserText.label: 'Message'
            //
            //
            //            case
            //
            //            when  bussiness.CreationDate >= bussiness.LastChangeDate and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            //            then 'To be created in ZOHO'
            //
            //            when  bussiness.CreationDate >= bussiness.LastChangeDate and
            //                           bussiness.CreationTime <> bussiness.LastChangeTime and ZOHO_Supplier.flag is initial and ZOHO_Supplier.status <> '202'
            //            then 'To be updated in ZOHO'
            //
            //            when  bussiness.CreationDate = bussiness.LastChangeDate and
            //                           bussiness.CreationTime <> bussiness.LastChangeTime and bussiness.LastChangeTime > ZOHO_Supplier.cr_time and  ZOHO_Supplier.flag = 'C'
            //            then 'To be updated in ZOHO'
            //
            //            when ZOHO_Supplier.flag = 'C'
            //            then 'Created in ZOHO Successfully'
            //
            //            when ZOHO_Supplier.flag = 'U' and bussiness.LastChangeDate >= ZOHO_Supplier.ch_date and bussiness.LastChangeTime > ZOHO_Supplier.ch_time
            //            then 'To be updated in ZOHO'
            //
            //            when ZOHO_Supplier.flag = 'U' and bussiness.LastChangeDate > ZOHO_Supplier.ch_date
            //            then 'To be updated in ZOHO'
            //
            //            when ZOHO_Supplier.flag = 'U' and ZOHO_Supplier.res_supplier is not initial
            //            then 'Data Updated Successfully'
            //
            //
            //            when ZOHO_Supplier.status = '202' and ZOHO_Supplier.msg is not initial
            //            then ZOHO_Supplier.msg
            //
            //            else 'To be Created in ZOHO'
            //
            //            end                             as message,








            bussiness.CreationDate          as creationdate,
            bussiness.CreationTime          as CreationTime,
            //            LastChangeDate                  as lc_date,

            bussiness.LastChangeTime        as lc_time,

            bussiness.LastChangeDate        as lastchangedate

}

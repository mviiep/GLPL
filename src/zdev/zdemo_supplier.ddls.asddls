@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Supplier Master'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZDEMO_SUPPLIER
  as select from I_Supplier
  association to I_AddressEmailAddress_2      as address on I_Supplier.AddressID = address.AddressID
  association to I_SupplierCompany            as code    on I_Supplier.Supplier = code.Supplier
  association to I_SupplierPurchasingOrg      as org     on I_Supplier.Supplier = org.Supplier
  association to I_AddrOrgNamePostalAddress   as house   on I_Supplier.AddressID = house.AddressID
  association to I_BusinessPartnerSupplier    as partner on I_Supplier.Supplier = partner.Supplier
  
  {

       @UI.facet         : [{
                         id      :'Supplier',
                         label   : 'Supplier',
                         type    : #IDENTIFICATION_REFERENCE,
                         position: 10}]

       @UI:{ lineItem: [{ position: 10, label: 'Supplier' }],
             identification: [{ position: 10, label: 'Supplier' }],
             selectionField: [{ position: 10 }]  }
       @EndUserText.label: 'Supplier'
  key  Supplier,

       @UI:{ lineItem: [{ position: 20, label: 'Ac Group' }],
           identification: [{ position: 20, label: 'Ac Group' }]  }
       @EndUserText.label: 'A/c Group'
       SupplierAccountGroup,


       @UI:{ lineItem: [{ position: 30, label: 'Supplier Name' }],
           identification: [{ position: 30, label: 'Supplier Name' }]  }
       @EndUserText.label: 'Supplier Name'
       SupplierName,


       @UI:{ lineItem: [{ position: 40, label: 'Search Item1' }],
           identification: [{ position: 40, label: 'Search Item1' }]  }
       @EndUserText.label: 'Search Item1'
       AddressSearchTerm1,

       @UI:{ lineItem: [{ position: 50, label: 'Name1' }],
           identification: [{ position: 50, label: 'Name1' }]  }
       @EndUserText.label: 'Name1'
       BusinessPartnerName1,


       @UI:{ lineItem: [{ position: 60, label: 'Name2' }],
           identification: [{ position: 60, label: 'Name2' }]  }
       @EndUserText.label: 'Name2'
       BusinessPartnerName2,



       @UI:{ lineItem: [{ position: 70, label: 'Name3' }],
           identification: [{ position: 70, label: 'Name3' }]  }
       @EndUserText.label: 'Name3'
       BusinessPartnerName3,


       @UI:{ lineItem: [{ position: 80, label: 'Name4' }],
           identification: [{ position: 80, label: 'Name4' }]  }
       @EndUserText.label: 'Name4'
       BusinessPartnerName4,



       @UI:{ lineItem: [{ position: 90, label: 'Street Name' }],
           identification: [{ position: 90, label: 'Street Name' }]  }
       @EndUserText.label: 'Street Name'
       BPAddrStreetName,



       @UI:{ lineItem: [{ position: 100, label: 'City Name'  }],
           identification: [{ position: 100, label: 'City Name' }]  }
       @EndUserText.label: 'City Name'
       BPAddrCityName,


       @UI:{ lineItem: [{ position: 110, label: 'District Name' }],
           identification: [{ position: 110, label: 'District Name' }]  }
       @EndUserText.label: 'District Name'
       DistrictName,



       @UI:{ lineItem: [{ position: 120, label: 'Country' }],
           identification: [{ position: 120, label: 'Country' }]  }
       @EndUserText.label: 'Country'
       Country,


       @UI:{ lineItem: [{ position: 130, label: 'Region'  }],
         identification: [{ position: 130, label: 'Region' }]  }
       @EndUserText.label: 'Region'
       Region,


       @UI:{ lineItem: [{ position: 140, label: 'Postal Code'  }],
           identification: [{ position: 140, label: 'Postal Code' }]  }
       @EndUserText.label: 'Postal Code'
       PostalCode,

       @UI:{ lineItem: [{ position: 150, label: 'Language'  }],
           identification: [{ position: 150, label: 'Language' }]  }
       @EndUserText.label: 'Language'
       SupplierLanguage,

       @UI:{ lineItem: [{ position: 160, label: 'Telephone'  }],
           identification: [{ position: 160, label: 'Telephone' }]  }
       @EndUserText.label: 'Telephone'
       PhoneNumber2,

       @UI:{ lineItem: [{ position: 170, label: 'Mobile'  }],
           identification: [{ position: 170, label: 'Mobile' }]  }
       @EndUserText.label: 'Mobile'
       PhoneNumber1,


       @UI:{ lineItem: [{ position: 180, label: 'Fax'  }],
           identification: [{ position: 180, label: 'Fax' }]  }
       @EndUserText.label: 'Fax'
       FaxNumber,

       @UI:{ lineItem: [{ position: 190, label: 'Pan number'  }],
          identification: [{ position: 190, label: 'Pan Number' }]  }
       @EndUserText.label: 'Email'
       BusinessPartnerPanNumber,


       @UI:{ lineItem: [{ position: 200, label: 'PaymentTerms'  }],
          identification: [{ position:200, label: 'PaymentTerms' }]  }
       @EndUserText.label: 'PaymentTerms'
       code.PaymentTerms               as payment,


       @UI:{ lineItem: [{ position: 210, label: 'Email' }],
        identification: [{ position: 210, label: 'Email' }]  }
       @EndUserText.label: 'Email'
       address.EmailAddress            as email,


       @UI:{ lineItem: [{ position: 220, label: 'Company Code' }],
        identification: [{ position: 220, label: 'Company Code' }]  }
       @EndUserText.label: 'Company Code'

       code.CompanyCode                as companycode,

       @UI:{ lineItem: [{ position: 230, label: 'Purchase Org' }],
        identification: [{ position: 230, label: 'Purchase Org' }]  }
       @EndUserText.label: 'Purchase Org'

       org.PurchasingOrganization      as purchaseorg,

       @UI:{ lineItem: [{ position: 240 , label: 'Reconciliation Account  ' }],
        identification: [{ position: 240 , label: 'Reconciliation Account' }]  }
       @EndUserText.label: 'Reconciliation Account'
       code.ReconciliationAccount      as account,

       @UI:{ lineItem: [{ position:250 , label: 'House Number' }],
        identification: [{ position:250 , label: 'House Number' }]  }
       @EndUserText.label: 'House Number'

       house.HouseNumber               as house,


       @UI:{ lineItem: [{ position:260, label: 'Business Partner Category
       '                                    }],
        identification: [{ position:260 , label: 'Business Partner Category
        '                                    }]  }
       @EndUserText.label: 'Business Partner Category
       '
       partner.BusinessPartnerCategory as partner,


       @UI:{ lineItem: [{ position:270 , label: 'Title '  }],
        identification: [{ position:270 , label: 'Title '   }]  }
       @EndUserText.label: 'Title'

       partner.FormOfAddress           as title

       //@UI:{ lineItem: [{ position: 280 , label: 'Tax Number Category' }],
       // identification: [{ position: 280 , label: 'Tax Number Category' }]  }
       //@EndUserText.label: 'Tax Number Category'
       //tax.BPTaxType                   as tax


}

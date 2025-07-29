@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Defination for customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zcustomer_dd as select from I_Customer as _customer
association[0..1] to I_Address_2 as _address on  _customer.Customer = $projection.AddressID
{ 
    
   _customer.AddressID, 
   _customer.Customer,
   _address.StreetName,
   _address.StreetPrefixName1,
   _address.StreetPrefixName2,
   _address.CityName,
   _address.PostalCode
}

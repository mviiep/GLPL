@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for PO for Address details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_mm_address
  as select from I_Plant as a
  association [0..1] to I_IN_PlantBusinessPlaceDetail as b on a.Plant = b.Plant
{
  key a.Plant,
      a.PlantName,
      a._OrganizationAddress.StreetName,
      a._OrganizationAddress.HouseNumber,
      a._OrganizationAddress.CityName,
      a._OrganizationAddress._Country._Text[ Language = 'E' ].CountryName     as Country,
      //      a._OrganizationAddress._Region.Region,
      a._OrganizationAddress._Region._RegionText[ Language = 'E' ].RegionName as Region,
      a._OrganizationAddress.PostalCode,
      b._BusinessPlace.IN_GSTIdentificationNumber
}

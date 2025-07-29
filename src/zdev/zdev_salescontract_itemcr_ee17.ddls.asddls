@EndUserText.label: 'ZDEV_SalesContract_ItemCr_EE17 generated'
define root abstract entity ZDEV_SalesContract_ItemCr_EE17
{
  @Event.element.externalName: 'DistributionChannel'
  DistributionChannel : abap.strg;
  @Event.element.externalName: 'EventRaisedDateTime'
  EventRaisedDateTime : TIMESTAMPL;
  @Event.element.externalName: 'OrganizationDivision'
  OrganizationDivision : abap.strg;
  @Event.element.externalName: 'Product'
  Product : abap.strg;
  @Event.element.externalName: 'SalesContract'
  SalesContract : abap.strg;
  @Event.element.externalName: 'SalesContractItem'
  SalesContractItem : abap.strg;
  @Event.element.externalName: 'SalesContractItemCategory'
  SalesContractItemCategory : abap.strg;
  @Event.element.externalName: 'SalesContractType'
  SalesContractType : abap.strg;
  @Event.element.externalName: 'SalesOrganization'
  SalesOrganization : abap.strg;
  @Event.element.externalName: 'SoldToParty'
  SoldToParty : abap.strg;
  
}

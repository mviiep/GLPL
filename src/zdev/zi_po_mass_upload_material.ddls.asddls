@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Purchase Order Mass Upload'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PO_MASS_Upload_Material
  as select from I_Product
  association to I_ProductText on I_Product.Product = I_ProductText.Product
{
  key     Product                   as Material,
          I_ProductText.ProductName as Materialtext
}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'value help for collectioncommitment'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity zcollectioncommitment_F4 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZWEEK' )  //zweek_f4help
{
   //key week as Week
   key domain_name,
   key value_position,
   key language,
   value_low,
   text
}
//where week <> 'Weekst'

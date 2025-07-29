@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Month'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.dataCategory: #VALUE_HELP
//@ObjectModel.usageType.dataClass: #CUSTOMIZING
//@ObjectModel.usageType.serviceQuality: #A
//@ObjectModel.usageType.sizeCategory: #S
//@ObjectModel.supportedCapabilities: [#CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE, #SQL_DATA_SOURCE, #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY]

@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{
    sortOrder: [{ by: 'Value_position' }]}]
define view entity ZVH_Month
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMONTH')
{
  key  value_position,
  key  value_low
}
group by
  value_position,
  value_low

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for ZOHO Cost Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_zoho_Cost_Center
  as select from zdb_cost_center
{
  key costcenter     as Costcenter,
      zohocostcenter as Zohocostcenter,
      creationdate   as Creationdate,
      creationtime   as Creationtime,
      updateddate    as Updateddate,
      updatedtime    as Updatedtime,
      flag           as Flag
}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Asset Master from ZOHO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zI_zoho_asset_master
  as select from zdb_asset_master
{
  key fixedasset       as Fixedasset,
      zohoassetcode    as Zohoassetcode,
      creationdate     as Creationdate,
      creationdatetime as Creationdatetime,
      updateddate      as Updateddate,
      updateddatetime  as Updateddatetime,
      flag             as Flag
}

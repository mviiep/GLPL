@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
//@AbapCatalog.sqlViewName:''
@EndUserText.label: 'Interface View for Asset Master API'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK", "CARDINALITY_CHECK" ]  } */
define root view entity Zi_Asset_Master
  as select from I_FixedAsset as _FixedAsset
  association to I_FixedAssetAssgmt   as _FixedAssetAssgmt on  _FixedAsset.CompanyCode      = _FixedAssetAssgmt.CompanyCode
                                                           and _FixedAsset.MasterFixedAsset = _FixedAssetAssgmt.MasterFixedAsset
                                                           and _FixedAsset.FixedAsset       = _FixedAssetAssgmt.FixedAsset
  association to zI_zoho_asset_master as _zohotab          on  _FixedAsset.MasterFixedAsset = _zohotab.Fixedasset
{

      @UI.facet: [{ id: 'DS',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Asset Master',
                position: 01 }]


      @UI.lineItem: [{ position: 10,label: 'Fixed Asset' }, { type: #FOR_ACTION , dataAction: 'createasset' , label: 'Create Asset' } ]
      @UI.identification: [{ position: 10 }]
  key _FixedAsset.MasterFixedAsset,

      @UI.lineItem: [{ position: 20,label: 'ZOHO ID' }]
      @UI.identification: [{ position: 20 }]
      _zohotab.Zohoassetcode,

      @UI.lineItem: [{ position: 30,label: 'Fixed Asset Description' }, { type: #FOR_ACTION , dataAction: 'updateasset' , label: 'Update Asset' } ]
      @UI.identification: [{ position: 30,label: 'Fixed Asset Description'}]
      _FixedAsset.FixedAssetDescription,

      @UI: { lineItem:       [ { position: 40, label: 'Asset Additional Description'}],
           identification: [ { position: 40, label: 'Asset Additional Description'}] }
      _FixedAsset.AssetAdditionalDescription,

      @UI: { lineItem:       [ { position: 50, label: 'Serial Number'}],
           identification: [ { position: 50, label: 'Serial Number'}] }
      _FixedAsset.AssetSerialNumber,

      @UI: { lineItem:       [ { position: 60}],
           identification: [ { position: 60}] }
      _FixedAsset.Inventory,

      @UI: { lineItem:       [ { position: 70}],
           identification: [ { position: 70}] }
      _FixedAssetAssgmt.CostCenter,

      @UI: { lineItem:       [ { position: 80, label: 'Location'}],
           identification: [ { position: 80, label: 'Location'}] }
      _FixedAssetAssgmt.AssetLocation,

      @UI: { lineItem:       [ { position: 90}],
           identification: [ { position: 90}] }
      _FixedAssetAssgmt.Room,

      @UI: { lineItem:       [ { position: 100}],
           identification: [ { position: 100}] }
      _FixedAssetAssgmt.ProfitCenter,

      @UI: { lineItem:       [ { position: 110}],
           identification: [ { position: 110}] }
      _FixedAssetAssgmt.Segment,

      @UI: { lineItem:       [ { position: 120}],
                       identification: [ { position: 120}] }
      case
      when _zohotab.Flag = 'C'
      then 201

      when _zohotab.Flag = 'U'
      and _FixedAsset.LastChangeDateTime <> _zohotab.Updateddatetime
      then 200

      when _zohotab.Flag = 'U'
      and _FixedAsset.LastChangeDateTime = _zohotab.Updateddatetime
      then 202

      else 200
      end as Status,

      @UI: { lineItem:       [ { position: 130}],
                 identification: [ { position: 130}] }
      case

      when _zohotab.Flag = 'C'
      and _FixedAsset.CreationDateTime = _FixedAsset.LastChangeDateTime
      then 'Created in ZOHO Successfully'

      when _zohotab.Flag = 'C'
      and _FixedAsset.LastChangeDateTime = _zohotab.Updateddatetime
      then 'Created in ZOHO Successfully'
            
      when _zohotab.Flag = 'C'
      and _FixedAsset.LastChangeDateTime <> _zohotab.Updateddatetime
      then 'To be Updated in ZOHO'

      when _zohotab.Flag = 'U'
      and _FixedAsset.LastChangeDateTime <> _zohotab.Updateddatetime
      then 'To be Updated in ZOHO'

      when _zohotab.Flag = 'U'
      and _FixedAsset.LastChangeDateTime = _zohotab.Updateddatetime
      then 'Data Updated Successfully'

      else 'To be Created in ZOHO'
      end as Message,

      _zohotab.Flag,
      @UI: { lineItem:       [ { hidden: true } ],
           identification: [ { hidden: true } ] }
      _FixedAsset.AccountIsBlockedForPosting,
      _FixedAsset.CreationDate,
      _FixedAsset.CreationDateTime,
      _FixedAsset.LastChangeDate,
      _FixedAsset.LastChangeDateTime



}

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for ZOHO Cost Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZAPI_Cost_Center
  as select from I_CostCenter as main
  association to I_CostCenterChangeLog as _costcenterchangelog on  main.CostCenter = _costcenterchangelog.CostCenter
  association to Zi_zoho_Cost_Center   as _zoho_cost_center    on  main.CostCenter = _zoho_cost_center.Costcenter
  association to I_ProfitCenterText    as _profitcentertext    on  main.ProfitCenter = _profitcentertext.ProfitCenter
  association to I_CostCenterText      as _COSTCENTERTEXT      on  main.CostCenter = _COSTCENTERTEXT.CostCenter
  association to I_RegionText          as _regiontext          on  main.Region          = _regiontext.Region
                                                               and main.Country         = _regiontext.Country
                                                               and _regiontext.Language = 'E'
{
      @UI.facet: [{ id: 'DS',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Cost Center',
                position: 01 }]

      @UI.lineItem: [{ position: 10,label: 'Cost Center Code' }, { type: #FOR_ACTION , dataAction: 'createcostcenter' , label: 'Create Cost Center' } ]
      @UI.identification: [{ position: 10 }]
  key main.CostCenter,

      @UI.lineItem: [{ position: 20,label: 'ZOHO ID' }]
      @UI.identification: [{ position: 20 }]
      case
      when _zoho_cost_center.Zohocostcenter is not initial
      then _zoho_cost_center.Zohocostcenter
      else '' end as Zohocostcenter,

      @UI.lineItem: [{ position: 30,label: 'Cost Center Description' }]
      @UI.identification: [{ position: 30 }]
      _COSTCENTERTEXT.CostCenterDescription,

      @UI.lineItem: [{ position: 40,label: 'Profit Center Code' }]
      @UI.identification: [{ position: 40 }]
      main.ProfitCenter,

      @UI.lineItem: [{ position: 40,label: 'Profit Center Description' }]
      @UI.identification: [{ position: 40 }]
      _profitcentertext.ProfitCenterLongName,

      @UI.lineItem: [{ position: 50,label: 'State Code' }]
      @UI.identification: [{ position: 50 }]
      main.Region,

      @UI.lineItem: [{ position: 60,label: 'State Description' }]
      @UI.identification: [{ position: 60 }]
      _regiontext.RegionName,

      @UI: { lineItem:       [ { position: 120}],
                       identification: [ { position: 120}] }
      case
      when _zoho_cost_center.Flag = 'C'
      then 201

      else 200
      end         as Status,

      @UI: { lineItem:       [ { position: 130}],
                 identification: [ { position: 130}] }
      case

      when _zoho_cost_center.Flag = 'C'
      and main.CostCenterLastChangedOnDate is initial
      then 'Created in ZOHO Successfully'

      when _zoho_cost_center.Flag = 'C'
      and ( main.CostCenterLastChangedOnDate = _zoho_cost_center.Updateddate
      and main.CostCenterLastChangedAtTime = _zoho_cost_center.Updatedtime )
      then 'Created in ZOHO Successfully'

      when _zoho_cost_center.Flag = 'C'
       and ( main.CostCenterLastChangedOnDate <> _zoho_cost_center.Updateddate
      and main.CostCenterLastChangedAtTime <> _zoho_cost_center.Updatedtime )
      then 'To be Updated in ZOHO'

      //      when _zoho_cost_center.Flag = 'U'
      //      and _FixedAsset.LastChangeDateTime <> _zoho_cost_center.Updateddatetime
      //      then 'To be Updated in ZOHO'
      //
      //      when _zoho_cost_center.Flag = 'U'
      //      and _FixedAsset.LastChangeDateTime = _zoho_cost_center.Updateddatetime
      //      then 'Data Updated Successfully'

      else 'To be Created in ZOHO'
      end         as Message,

      _zoho_cost_center.Flag,

      main.CostCenterCreationDate,
      main.CostCenterCreationTime as creationtime
}

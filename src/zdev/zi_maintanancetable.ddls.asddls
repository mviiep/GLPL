@EndUserText.label: 'maintanancetable'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_Maintanancetable
  as select from ZCHECK
  association to parent ZI_Maintanancetable_S as _MaintanancetableAll on $projection.SingletonID = _MaintanancetableAll.SingletonID
{
  key CHEC as Chec,
  @Consumption.hidden: true
  1 as SingletonID,
  _MaintanancetableAll
  
}

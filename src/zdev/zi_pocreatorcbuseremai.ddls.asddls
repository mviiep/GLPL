@EndUserText.label: 'PoCreator CB_User & email id'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PocreatorCbUserEmai
  as select from ZTAB_PO_CREATE
  association to parent ZI_PocreatorCbUserEmai_S as _PocreatorCbUserEAll on $projection.SingletonID = _PocreatorCbUserEAll.SingletonID
{
  key CB_USER as CbUser,
  EMAIL_ID as EmailId,
  @Consumption.hidden: true
  1 as SingletonID,
  _PocreatorCbUserEAll
  
}

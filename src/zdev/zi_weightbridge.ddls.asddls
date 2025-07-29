//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Weight Bridge Camera Details'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define root view entity ZI_WEIGHTBRIDGE as select from zweightbridge
{ 
@EndUserText.label: 'Plant 1'
     key plant1  as Plant1,
@EndUserText.label: 'Plant 2'
  key plant2 ,//as plant2,
  @EndUserText.label: 'Weight Bridge ID'
  key wbid  ,//  as weightbridgeid,
   @EndUserText.label: 'Weighbridge Port No.'
  wbpn      ,//   as weightbridgeportno,
   @EndUserText.label: 'IP Address for Camera 1'
  ipc1     ,//    as IPAddresscamera1,
   @EndUserText.label: 'Port No. for Camera 1'
  pnc1     ,//    as Portnocamera1,
   @EndUserText.label: 'Login ID for Camera 1'
  lidc1    ,//    as loginidcamera1,
   @EndUserText.label: 'Password for Camera 1'
  pwc1      ,//   as Passwordcamera1,
   @EndUserText.label: 'IP Address for Camera 2'
  ipc2     ,//    as IPAddresscamera2,
   @EndUserText.label: 'Port No. for Camera 2'
  pnc2    ,//     as Portnocamera2,
   @EndUserText.label: 'Login ID for Camera 2'
  lidc2    ,//    as loginidcamera2,
   @EndUserText.label: 'Password for Camera 2'
  pwc2     ,//    as Passwordcamera2,
   @EndUserText.label: 'MC ID address of Local Machine'
  mcid     ,//    as MCID,
   @EndUserText.label: 'Host Name  of Local Machine'
  host  ,//      as HO,
   @EndUserText.label: 'Setup Completed Flag'
  setupflag    as SETUPFLAG,
   @EndUserText.label: 'Date on which Weigh. Utility is Setup'
  datewusetup  as datewusetup,
   @EndUserText.label: 'Time on which Weigh. Utility is Setup'
  timewusetup  as timewusetup,
   @EndUserText.label: 'Sync Status'
  syncstatus   as syncstatus,
   @EndUserText.label: 'Date on which last Sync is done'
  datelastsync as datelastsync,
   @EndUserText.label: 'Time on which last Sync is done'
  timelastsync as timelastsync,
  @Semantics.user.createdBy: true
   @EndUserText.label: 'Created By'
  createdby    as createdby,
  @Semantics.systemDateTime.createdAt:true
   @EndUserText.label: 'Created On Date'
  createdond   as createdond,
//  @Semantics.systemDateTime.createdAt: true
 //  @EndUserText.label: 'Created On Time'
 // createdont   as createdont,
 @Semantics.user.localInstanceLastChangedBy: true
   @EndUserText.label: 'Changed By'
  changeby     as changeby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
   //@Semantics.systemDateTime.lastChangedAt: true
   @EndUserText.label: 'Changed On Date'
  changeond    as changeond
//@Semantics.systemDateTime.lastChangedAt: true
 //  @EndUserText.label: 'Changed On Time '
 // changeont    as changeont
}

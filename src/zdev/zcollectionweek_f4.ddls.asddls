@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ' f4 for week'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet: {
    sizeCategory: #XS
} 
@VDM.viewType: #BASIC
define view entity zcollectionweek_f4 as select from zcollectionweek as z

{
    
    key z.week as week
} group by z.week





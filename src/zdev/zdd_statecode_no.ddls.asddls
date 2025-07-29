@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA Defination of ZDD_STATECODE_NO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZDD_STATECODE_NO
  as select from zstatecode_no
{

       @UI.facet: [{ label: 'Sales Contract Info',
                      id: 'SALESCONTRACT',
                     type:#IDENTIFICATION_REFERENCE,
                     position: 215,
                     purpose: #STANDARD
                      }]

       @UI                         : {
            lineItem               : [{position: 10, importance: #HIGH}],
      identification: [{ position: 01 }],
      selectionField         : [{position: 01}]}
       @EndUserText.label          : 'State Code'
  key  statecode   as Statecode,


       @UI                         : {
        lineItem                   : [{position: 20, importance: #HIGH}],
        identification             : [ { position: 02} ],
        selectionField             : [{position: 2}]}
       @EndUserText.label          : 'State Code No'
       statecodeno as Statecodeno











}

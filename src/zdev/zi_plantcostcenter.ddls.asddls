//@AbapCatalog.sqlViewName: 'ZZI_PLANTCOST'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Plant cost center PO BADI'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PlantCostCenter as select from ztab_plantcc
{   
    @UI.facet         : [{
                      id      :'Plant',
                      label   : 'BADI',
                      type    : #IDENTIFICATION_REFERENCE,
                      position: 10}]
          @UI : {  lineItem: [ { position: 10 } ],
                   identification : [ { position:10 } ]}
          @EndUserText.label: 'Plant'
    key plant as Plant,
     @UI : {  lineItem       : [ { position: 20 } ],
              identification : [ { position:20 } ]}
          @EndUserText.label: 'Plant Description'
    key plantdesc as Plantdesc,
        @UI : {  lineItem       : [ { position: 30 } ],
              identification : [ { position: 30 } ]}
          @EndUserText.label: 'Cost Center'
    key costcenter as Costcenter,
        @UI : {  lineItem       : [ { position: 40 } ],
              identification : [ { position: 40 } ]}
          @EndUserText.label: 'Cost Center Description'
    key costcenterdesc as Costcenterdesc
}

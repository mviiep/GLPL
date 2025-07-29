@EndUserText.label: 'custom collection'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CUSTOMREPORT'
define root custom entity zce_coll
// with parameters parameter_name : parameter_type
{
 @UI.facet              : [{
                 id          :'ficoreg',
                 label       : 'Collection Register1',
                 type        : #IDENTIFICATION_REFERENCE,
             //          targetQualifier:'Sales_Tender.SoldToParty',
                 position    : 10
                 }
                 ]


            
      @UI            : {lineItem: [{ position: 20,label: 'PurchaseOrder' } , { type: #FOR_ACTION , dataAction: 'updatesstatus' , label: 'Update Status', navigationAvailable: false  }]}
      @UI            : {identification: [{  position: 20,label: 'PurchaseOrder' }] }
      @EndUserText   : {label: 'PurchaseOrder'}
      @UI.selectionField     : [ { position: 20}]
  key PurchaseOrder     : abap.char( 10 );

      @UI            : {lineItem: [{ position: 30,label: 'PurchaseOrderitem' }]}
      @UI            : {identification: [{  position: 30,label: 'PurchaseOrderitem' }] }
      @EndUserText   : {label: 'PurchaseOrderitem'}
      @UI.selectionField     : [ { position: 30}]
  key PurchaseOrderitem : abap.numc( 6 );


      @UI            : {lineItem: [{ position: 60,label: 'week1' }]}
      @UI            : {identification: [{  position: 60,label: 'week1' }] }
      @EndUserText   : {label: 'week1'}
      week1          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 70,label: 'week2' }]}
      @UI            : {identification: [{  position: 70,label: 'week2' }] }
      @EndUserText   : {label: 'week2'}
      week2          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 80,label: 'week3' }]}
      @UI            : {identification: [{  position: 80,label: 'week3' }] }
      @EndUserText   : {label: 'week3'}
      week3          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 90,label: 'week4' }]}
      @UI            : {identification: [{  position: 90,label: 'week4' }] }
      @EndUserText   : {label: 'week4'}
      week4          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 100,label: 'week5' }]}
      @UI            : {identification: [{  position: 100,label: 'week5' }] }
      @EndUserText   : {label: 'week5'}
      week5          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 200,label: 'week6' }]}
      @UI            : {identification: [{  position: 200,label: 'week6' }] }
      @EndUserText   : {label: 'week6'}
      week6          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 210,label: 'week7' }]}
      @UI            : {identification: [{  position: 210,label: 'week7' }] }
      @EndUserText   : {label: 'week7'}
      week7          : abap.char( 1000 );
      
     @UI            : {lineItem: [{ position: 25,label: 'weekstatus' }]}
      @UI            : {identification: [{  position: 25,label: 'weekstatus' }] }
      @EndUserText   : {label: 'weekstatus'}
      weekstatus : abap.char( 10 );
  
}

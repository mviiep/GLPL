@EndUserText.label: 'Collection report CE'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_COLLECTIONREPORT'

@UI: {
  headerInfo: {
    typeName: 'Collection',
    typeNamePlural: 'Collections',
    title: { value: 'week1' },
    description: { label: '(WeekStatusselection)' },
    typeImageUrl: 'https://th.bing.com/th/id/OIP.b6zG3mKetPGmyzrn_Fxx4gHaEH?w=305&h=180&c=7&r=0&o=5&pid=1.7',
    description.value: 'Customer'  
    
//    description: {
//        type: #STANDARD,
//        label: 'Hello Icon Url',
//        iconUrl: 'https://th.bing.com/th/id/OIP.b6zG3mKetPGmyzrn_Fxx4gHaEH?w=305&h=180&c=7&r=0&o=5&pid=1.7',
//      //  criticality: 'week1',
//     //   criticalityRepresentation: #WITHOUT_ICON,
//        value: 'PurchaseOrder',
//        valueQualifier: '',
//        targetElement: '',
//        url: ''
  //  }
  }
}
define root custom entity zcollectionreport
  // with parameters parameter_name : parameter_type
{
        
//      @UI.facet              : [{
//                 id          :'ficoreg',
//                 label       : 'Collection Register',
//                 type        : #IDENTIFICATION_REFERENCE,
//                 //      targetQualifier:'',
//                 position    : 10
//                 }
//                 ]


        @UI.facet      : [
    {
      id         : 'FacetControlHeader',
      label      : 'Collection Information',
      type       : #COLLECTION,
      purpose    : #STANDARD,
      position: 10
      //targetQualifier: 'CONTROL_HEADER'
      //parentId: 'super'
    },
    {
      id         : 'FacetFieldArea',
      label      : ' Week Information',
      type       : #FIELDGROUP_REFERENCE,
      purpose    : #STANDARD,
      position: 20,
      targetQualifier: 'FIELD_AREA',
      parentId: 'FacetControlHeader'
      
    }  ,  
    {
      id         : 'controlSection',
      purpose: #STANDARD,
      type       : #FIELDGROUP_REFERENCE,
      position   : 30,
      targetQualifier: 'field_area1',
      parentId: 'FacetControlHeader'
    }
  ]


            
      @UI            : {lineItem: [{ position: 20,label: 'PurchaseOrder' }, { type: #FOR_ACTION , dataAction: 'zstatus' , label: 'Validate week' }]}
    //  @UI            : {identification: [{  position: 20,label: 'PurchaseOrder' }] }
     @UI.fieldGroup: [{ position: 20 , label: 'PurchaseOrder' , qualifier: 'FIELD_AREA' }]
      @EndUserText   : {label: 'PurchaseOrder'}
      @UI.selectionField     : [ { position: 20}]
  key PurchaseOrder     : abap.char( 10 );

      @UI            : {lineItem: [{ position: 30,label: 'PurchaseOrderitem' }]}
   //   @UI            : {identification: [{  position: 30,label: 'PurchaseOrderitem' }] }
      @UI.fieldGroup: [{ position: 30 , label: 'PurchaseOrder' , qualifier: 'FIELD_AREA' }]
      @EndUserText   : {label: 'PurchaseOrderitem'}
  //    @UI.selectionField     : [ { position: 30}]
  key PurchaseOrderitem : abap.numc( 6 );
  
        @UI            : {lineItem: [{ position: 35,label: 'WeekStatusselection' }]}
      @UI            : {identification: [{  position: 35,label: 'FIELD_AREA' }] }
      @EndUserText   : {label: 'WeekStatusselection'}
      @UI.selectionField     : [ { position: 30}]
//      @Consumption.filter: {
//          mandatory: true
//      }
//      @Consumption.valueHelpDefinition: [{
//          entity: {
//              name: 'zcollectionweek_f4',
//              element: 'week'
//          }
//          }]

//@Consumption: {
// 
//    filter: {
//        mandatory: true,
//      
//        selectionType: #SINGLE 
//       // multipleSelections: false
//        
//        
//    },
//    valueHelpDefinition: [{
//        qualifier: '',
//        entity: {
//            name: 'zcollectionweek_f4',
//            element: 'week'
//        },
//        distinctValues: true,
//        useForValidation: true
//    }]
//   
//      
//    }
//}
//@Consumption.valueHelpDefinition: [{presentationVariantQualifier: 'Abc'}]
 @UI.fieldGroup: [{ position: 40 , label: 'Week Selection' , qualifier: 'FIELD_AREA' }]

       
      
  key WeekStatusselection : abap.char( 5 );

      @UI            : {lineItem: [{ position: 40,label: 'CompanyCode' } ]} //, { type: #FOR_ACTION , dataAction: 'zglobal' , label: 'Global' }]}
      @UI            : {identification: [{  position: 40,label: 'CompanyCode' }] }
      @EndUserText   : {label: 'CompanyCode'}
      CompanyCode       : abap.char( 49 );

      @UI            : {lineItem: [{ position: 50,label: 'Customer' }]}
      @UI            : {identification: [{  position: 50,label: 'Customer' }] }
      @EndUserText   : {label: 'Customer'}

      Customer    : abap.dats;

      @UI            : {lineItem: [{ position: 60,label: 'week1' }]}
      //@UI            : {identification: [{  position: 60,label: 'week1' }] }
      @UI.fieldGroup: [{ position: 40 , label: 'week1' , qualifier: 'FIELD_AREA1' }]
     
      @EndUserText   : {label: 'week1'}
      week1          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 70,label: 'week2' }]}
    //  @UI            : {identification: [{  position: 70,label: 'week2' }] }
     
      @UI.fieldGroup: [{ position: 40 , label: 'week2' , qualifier: 'FIELD_AREA1' }]
      @EndUserText   : {label: 'week2'}
      week2          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 80,label: 'week3' }]}
      //@UI            : {identification: [{  position: 80,label: 'week3' }] }
     @UI.fieldGroup: [{ position: 40 , label: 'week3' , qualifier: 'FIELD_AREA1' }]
      @EndUserText   : {label: 'week3'}
      week3          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 90,label: 'week4' }]}
     // @UI            : {identification: [{  position: 90,label: 'week4' }] }
       @UI.fieldGroup: [{ position: 40 , label: 'week4' , qualifier: 'FIELD_AREA1' }]
      @EndUserText   : {label: 'week4'}
      week4          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 100,label: 'week5' }]}
   //   @UI            : {identification: [{  position: 100,label: 'week5' }] }
      @UI.fieldGroup: [{ position: 40 , label: 'week5' , qualifier: 'FIELD_AREA1' }]
      @EndUserText   : {label: 'week5'}
      week5          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 200,label: 'week6' }]}
    //  @UI            : {identification: [{  position: 200,label: 'week6' }] }
      @UI.fieldGroup: [{ position: 40 , label: 'week6' , qualifier: 'FIELD_AREA1' }]
      @EndUserText   : {label: 'week6'}
      week6          : abap.char( 1000 );

      @UI            : {lineItem: [{ position: 210,label: 'week7' }]}
   //   @UI            : {identification: [{  position: 210,label: 'week7' }] }
     @UI.fieldGroup: [{ position: 40 , label: 'week7' , qualifier: 'FIELD_AREA1' }]
      @EndUserText   : {label: 'week7'}
      week7          : abap.char( 1000 );
      
//     @UI            : {lineItem: [{ position: 25,label: 'weekstatus' }]}
//      @UI            : {identification: [{  position: 25,label: 'weekstatus' }] }
//      @EndUserText   : {label: 'weekstatus'}
//      weekstatus : abap.char( 10 );


}

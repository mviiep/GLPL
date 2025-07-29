@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view entity for MSME Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define root view entity ZFIR_MSME_REPORT_ as select from zmsme_tb

{


@UI.facet                : [
                  {
                    id         :  'Supplier',
                    purpose    :  #STANDARD,
                    type       :     #IDENTIFICATION_REFERENCE,
                    label      : 'MSME Report',
                    position   : 10 }
                ]


 @UI.lineItem: [{ position: 10 }, { type: #FOR_ACTION , dataAction: 'SAVE' , label: 'SAVE' } ]
 @UI.identification: [{ position: 10 }]
  key supplier,   
   @UI                     :{lineItem: [{ position: 20,label: 'Sno' }]}
   sno,
   @UI                     :{lineItem: [{ position: 30,label: 'Name of MSE Supplier' }]}
   bp_name,      
   @UI                     :{lineItem: [{ position: 40,label: 'PAN of the Supplier' }]}
   pan_no,                   
   @UI                     :{lineItem: [{ position: 50,label: 'NO.Items paid within 45 days' }]}
   no1,                 
   @UI                     :{lineItem: [{ position: 60,label: 'Sum of amt paid within 45 days' }]}
   amt1,
   
   @UI                     :{lineItem: [{ position: 70,label: 'NO.Items paid after 45 days' }]}
   no2,
   @UI                     :{lineItem: [{ position: 80,label: 'Sum of amt paid after 45 days' }]}
   amt2,
   
   @UI                     :{lineItem: [{ position: 90,label: 'NO.Items Outstanding  within 45 days' }]}
   no3,
   @UI                     :{lineItem: [{ position: 100,label: 'Amt Outstanding  within 45 days' }]}
   amt3,
   
    @UI                     :{lineItem: [{ position: 110,label: 'NO.Items Outstanding after45 days' }]}
   no4,
   @UI                     :{lineItem: [{ position: 120,label: 'Amt Outstanding  after 45 days' }]}
   amt4 ,
    @UI                     :{lineItem: [{ position: 130,label: 'Comment' }]}
   zcomment
  
                   
   
    
   
                     

}

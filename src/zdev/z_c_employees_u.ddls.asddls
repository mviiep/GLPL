@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view for employees data'
@ UI: { 
    headerInfo:{ typeName: 'Employees', typeNamePlural:'Employees',title: { type : #STANDARD, value : 'Name' } } }
define root view entity Z_C_EMPLOYEES_U as select from 
Z_I_EMPLOYEES_U 
{
    @EndUserText.label: 'Employees Num'
    @UI. facet: [{ 
    label : 'General Information',
    id : 'GeneralInfo',
    purpose: #STANDARD,
    position:10,
    type:#IDENTIFICATION_REFERENCE
    
     }]
     
     @UI.identification: [{ position: 20 }]
     
     @UI.lineItem : [{ position: 20 }]
     @UI.selectionField:  [{ position: 20 }]
     
     key Num,
     @EndUserText.label: 'Name'
       @UI.identification: [{ position: 20 }]
     
     @UI.lineItem : [{ position: 20 }]
     @UI.selectionField:  [{ position: 20 }]
     
     Name,
     @EndUserText.label: 'Age'
       @UI.identification: [{ position: 30 }]
     
     @UI.lineItem : [{ position: 30 }]
     @UI.selectionField:  [{ position: 30 }]
     
     Age
  
}

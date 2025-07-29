@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee base CDS'
define root view entity Z_I_EMPLOYEES_U 
  as select from zt01_employee

{
    key num as Num,
    name as Name,
    age as Age
  
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view for emp'
@Metadata.allowExtensions: true
define root view entity ZI_EMP as select from zemployee
{
  @EndUserText.label: 'Employee ID'
    key num as empid,
  @EndUserText.label: 'Employee name'
  name as Empname,
  @EndUserText.label: 'Employee Age'
   age as Empage,
  @EndUserText.label: 'Created On'
    createdon as Createdon,
   @EndUserText.label: 'Created By'
   createdby as Createdby
   
    
   
}

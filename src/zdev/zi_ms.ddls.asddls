@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view for MS'
@Metadata.allowExtensions: true
define root view entity ZI_MS as select from zmm_tb_demo

{
    @EndUserText.label: 'Supplier'
   key supplier  as supplier,
   @EndUserText.label: 'SNo'
   sno as sno,
   @EndUserText.label: 'Business partner' 
     bp_name as Bp_name,
   @EndUserText.label: 'NO of item within 45 days'
     no1 as No1,
   @EndUserText.label: 'Amt within 45 days'
   amt1 as amt1,
   @EndUserText.label: 'No of item after 45 days'
    no2 as no2,
    @EndUserText.label: 'Amt after 45'
    amt2 as amt2,
    @EndUserText.label: 'No of line items out within 45'
    no3 as no3,
    @EndUserText.label: 'Amt out within 45 days'
    amt3 as amt3,
    @EndUserText.label: 'No of line items out after 45'
    no4 as no4,
    @EndUserText.label: 'Amt out after 45'
    amt4 as amt4
  
}

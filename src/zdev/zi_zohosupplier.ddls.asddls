@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Zoho Supplier'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ZohoSupplier
  as select from zmm_supplier
{
  key supplier     as Supplier,
      res_supplier as res_supplier,
      id           as Id,
      status       as Status,
      msg          as Msg,
      cr_date      as cr_date,
      cr_time      as cr_time,
      ch_date      as ch_date,
      ch_time      as ch_time,
      flag         as Flag
}

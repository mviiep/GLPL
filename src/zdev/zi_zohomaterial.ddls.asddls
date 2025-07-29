@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Zoho Material'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_Zohomaterial as select from zmm_material
{
  key matnr          as Matnr,
  key plant          as Plant,
  key sale_org       as sale_org,
  key distr_chnl     as distr_chnl,
      res_matnr      as res_matnr,
      status         as Status,
      msg            as Msg,
      createdate     as Createdate,
      createdatetime as Createdatetime,
      createtime     as Createtime,
      updatedate     as Updatedate,
      updatedatetime as Updatedatetime,
      updatetime     as Updatetime,
      flag           as Flag
}

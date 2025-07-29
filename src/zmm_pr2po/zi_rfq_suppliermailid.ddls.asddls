@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for RFQ Supplier Mail IDs'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_RFQ_SupplierMailID
  as select from zirfq_suppmail

{
  key requestforquotation as Requestforquotation,
  key rec_counter         as rec_counter,
      supplier            as Supplier,
      suppliername        as Suppliername,
      mail1               as Mail1,
      mail2               as Mail2,
      mail3               as Mail3,
      cc1                 as Cc1,
      cc2                 as Cc2,
      cc3                 as Cc3,
      cc4                 as Cc4,
      cc5                 as Cc5,
      mail_sentflag       as mailsent_flag,
      reminder_flg1       as reminder_flg1,
      reminder_flg2       as reminder_flg2,   
      unreg_flag          as unreg_flag   
//      ,
//      originaldate        as originaldate

}

@ObjectModel.query.implementedBy: 'ABAP:ZCL_RFQ_SUPPLIERS'
@EndUserText.label: 'Interface View for RFQ Supplier Mail IDs'
define root custom entity ZI_RFQ_Suppliers
{
  key RequestForQuotation : ebeln;
  key rec_counter         : abap.numc(2);
      Supplier            : abap.numc(10);
      SupplierName        : abap.char(80);
      Mail1               : abap.char(80);
      Mail2               : abap.char(80);
      Mail3               : abap.char(80);
      Cc1                 : abap.char(80);
      Cc2                 : abap.char(80);
      Cc3                 : abap.char(80);
      Cc4                 : abap.char(80);
      Cc5                 : abap.char(80);
      mail_sentflag       : abap.char( 1 );
      reminder_Flg1       : abap.char( 1 );
      reminder_Flg2       : abap.char( 1 );
      unreg_flag          : abap.char(1);
//      originaldate        : abap.datn;
}

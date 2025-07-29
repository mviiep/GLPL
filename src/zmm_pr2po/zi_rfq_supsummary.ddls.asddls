@ObjectModel.query.implementedBy: 'ABAP:ZCL_RFQ_SUPSUMMARY'
//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RFQ Supplier Summary Header Record'
//@Metadata.ignorePropagatedAnnotations: true

define root custom entity ZI_RFQ_SupSummary 
{
    key RequestForQuotation : ebeln;
    CreationDate           : abap.dats;
    supplier_code1          : lifnr;
    supplier_code2          : lifnr;
    supplier_code3          : lifnr;
    supplier_code4          : lifnr;
    supplier_code5          : lifnr;
 
    aprl_flg1               : abap.char(1);
    aprl_flg2               : abap.char(1);
    aprl_flg3               : abap.char(1);
    aprl_flg4               : abap.char(1);
    aprl_flg5               : abap.char(1);
    ProfitCenter            : prctr;
    AddressName             : name1_gp;
    StreetAddressName       : abap.char( 35 );
    CityName                : abap.char( 35 );
    PostalCode              : pstlz;
    District                : ort02_gp;
      suppliername1     : abap.char( 80 );
      suppliername2     : abap.char( 80 );
      suppliername3     : abap.char( 80 );
      suppliername4     : abap.char( 80 );
      suppliername5     : abap.char( 80 );
      comp_comments     : abap.char(80);  
      unreg_flag1       : abap.char(1);
      unreg_flag2       : abap.char(1);
      unreg_flag3       : abap.char(1);
      unreg_flag4       : abap.char(1);
      unreg_flag5       : abap.char(1);
      RFQ_description   : abap.char(60);
}

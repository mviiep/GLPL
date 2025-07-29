@ObjectModel.query.implementedBy: 'ABAP:ZCL_RFQ_SUPPLIERS_ITEMS'
@EndUserText.label: 'Inter. View for RFQ Items for Suppliers'
//@Metadata.ignorePropagatedAnnotations: true

define root custom entity ZI_RFQ_Suppliersitms 
{
  key RequestForQuotation   : ebeln;
  key rfq_item   : ebelp ;
  material                : matnr;
  material_text           : txz01;
  baseunit                : meins;
  @Semantics.quantity.unitOfMeasure : 'baseunit'
  requestedqty            : bamng;  
  supplier_code1 : lifnr;
  @Semantics.amount.currencyCode : 'currency_code'
  item_rate1     : abap.curr(12,2);
  @Semantics.amount.currencyCode : 'currency_code'
  basic_value1            : abap.curr(17,2);
 
  supplier_code2          : lifnr ;
  @Semantics.amount.currencyCode : 'currency_code'
  item_rate2              : abap.curr(12,2);
  @Semantics.amount.currencyCode : 'currency_code'
  basic_value2            : abap.curr(17,2);
  supplier_code3          : lifnr ;
  @Semantics.amount.currencyCode : 'currency_code'
  item_rate3              : abap.curr(12,2);
  @Semantics.amount.currencyCode : 'currency_code'
  basic_value3            : abap.curr(17,2);
  supplier_code4          : lifnr;
  @Semantics.amount.currencyCode : 'currency_code'
  item_rate4              : abap.curr(12,2);
  @Semantics.amount.currencyCode : 'currency_code'
  basic_value4            : abap.curr(17,2);
  supplier_code5          : lifnr;
  @Semantics.amount.currencyCode : 'currency_code'
  item_rate5              : abap.curr(12,2);
  @Semantics.amount.currencyCode : 'currency_code'
  basic_value5            : abap.curr(17,2);

  suppliername1     : abap.char( 80 );
  suppliername2     : abap.char( 80 );
  suppliername3     : abap.char( 80 );
  suppliername4     : abap.char( 80 );
  suppliername5     : abap.char( 80 );     
  
  currency_code  : abap.cuky;
  aprl_flag      : abap.char(1);
  @Semantics.amount.currencyCode : 'currency_code'  
  target_rate    : abap.curr(12,2);
  @Semantics.amount.currencyCode : 'currency_code'  
  target_value   : abap.curr(17,2);
  
//  aprl_flag2     : abap.char(1);
//  aprl_flag3     : abap.char(1);
//  aprl_flag4     : abap.char(1);
//  aprl_flag5     : abap.char(1);
 
} 
 

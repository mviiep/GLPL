//@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for table ZCDS_RFQSUPLRRITM'

define root custom entity zcds_rfqsuplrritm

 {
    key rfq_number  : ebeln;
    key rfq_item    : ebelp;
    key rec_counter     : abap.numc(2);   
        supplier_code1  : lifnr;
        supplier_name   : abap.char( 80 );
        material        : matnr;
        materialtext    : maktx;
        @Semantics.quantity.unitOfMeasure : 'baseunit'
        requestedqty    : bamng;
        baseunit        : meins;
//          @Semantics.amount.currencyCode : 'currency_code'
//        item_rate1      : abap.curr(12,2);
          item_rate1    : abap.char(13);
//          @Semantics.amount.currencyCode : 'currency_code'
//        target_rate     : abap.curr(12,2);
        target_rate     : abap.char(13);
        currency_code   : abap.cuky( 5 );
        itemremarks     : abap.char( 100 );
        headerremarks   : abap.char(100);
        vendorremarks   : abap.char(100);
}

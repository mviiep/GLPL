CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zcds_rfqsuplrritm AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

"    TYPES tdata TYPE TABLE OF ty_buffer.
    types tdata type table of zcds_rfqsuplrritm.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead    TYPE TABLE OF zcds_rfqsuplrritm,
               tdel     type table of zcds_rfqsuplrritm.
ENDCLASS.


CLASS lhc_zcds_rfqsuplrritm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcds_rfqsuplrritm RESULT result.

 METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zcds_rfqsuplrritm.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcds_rfqsuplrritm.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcds_rfqsuplrritm.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcds_rfqsuplrritm RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcds_rfqsuplrritm.

ENDCLASS.

CLASS lhc_zcds_rfqsuplrritm IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

"*********************************************************************
" Create Method
"*********************************************************************
  METHOD create.
     DATA: mapgen   LIKE LINE OF mapped-zcds_rfqsuplrritm,
          tgdt      LIKE LINE OF loc=>mt_data,
          wa_mail   TYPE zcds_rfqsuplrritm.

      LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zcds_rfqsuplrritm.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.
"*********************************************************************
" Update Method
"*********************************************************************
  METHOD update.
     DATA: mapgen   LIKE LINE OF mapped-zcds_rfqsuplrritm,
          tgdt      LIKE LINE OF loc=>mt_data,
          wa_mail   TYPE zcds_rfqsuplrritm.

     LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zcds_rfqsuplrritm.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

  method delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.
ENDCLASS.

CLASS lsc_zcds_rfqsuplrritm DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcds_rfqsuplrritm IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
*&-------------------------------------------------------------------&*
* CHECK_BEFORE_SAVE Method to throw errors if any
*&-------------------------------------------------------------------&*
 data:   it_data       type STANDARD TABLE OF ztb_rfqsuplrritm,
          wa_data       type ztb_rfqsuplrritm,
          lv_errflg     type c LENGTH 1.
   DATA: wa_record LIKE LINE OF reported-zcds_rfqsuplrritm,
         wa_error   like line of failed-zcds_rfqsuplrritm,
         lv_numchk type string,
         lv_msgcntr     type zcds_rfqsuplrritm-rec_counter.

* Data validation
    if loc=>thead is not INITIAL.
        select  from zirfq_suppmail
        FIELDS
        requestforquotation,
        rec_counter,
        supplier,
        suppliername,
        suppliername  as uppername

        FOR ALL ENTRIES IN @loc=>thead
        where requestforquotation   = @loc=>thead-rfq_number
        INTO TABLE @data(it_suppmail).
        sort it_suppmail by requestforquotation rec_counter.
        delete ADJACENT DUPLICATES FROM it_suppmail COMPARING requestforquotation rec_counter.

        loop at it_suppmail ASSIGNING FIELD-SYMBOL(<f1>).
            <f1>-uppername = to_upper(  <f1>-uppername ).
        ENDLOOP.

        sort it_suppmail by requestforquotation uppername.
    endif.

*     MOVE-CORRESPONDING loc=>thead TO it_data.
       data(lt_temp) = loc=>thead.

* Validate RFQ and item
        sort lt_temp by rfq_number rfq_item.
        delete lt_temp where rfq_number is INITIAL.
        delete lt_temp where rfq_number = '0000000000'.

        delete ADJACENT DUPLICATES FROM lt_temp COMPARING  rfq_number.
        clear: lv_msgcntr.

        if lt_temp is not INITIAL.
            data(lv_rfqno) = value #( lt_Temp[ 1 ]-rfq_number OPTIONAL ).
            select * from I_RfqItem_Api01 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @lt_temp
            where RequestForQuotation = @lt_temp-rfq_number
            INTO TABLE @DATA(lt_rfqitm).

           sort lt_rfqitm by RequestForQuotation RequestForQuotationItem.

* Read bidders from RFQ
           select * from I_RfqBidder_Api01 WITH PRIVILEGED ACCESS
                      FOR ALL ENTRIES IN @lt_temp
                      where RequestForQuotation = @lt_temp-rfq_number
                      into table @data(it_bidder).
           sort it_bidder by RequestForQuotation Supplier.

           lt_temp = loc=>thead.
           sort lt_temp by rfq_number rfq_item.
           delete ADJACENT DUPLICATES FROM lt_temp COMPARING  rfq_number rfq_item.

           LOOP AT lt_rfqitm INTO data(lwa_rfqitm).
            delete lt_temp WHERE rfq_number = lwa_rfqitm-RequestForQuotation
                             and rfq_item   = lwa_rfqitm-RequestForQuotationItem.
           ENDLOOP.

           if lines( lt_temp ) > 0.
              lv_msgcntr = lv_msgcntr + 1.
              data(wa_msg) = me->new_message(
                                          id       = '8i'
                                          number   = 000
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = |RFQ { value #( lt_temp[ 1 ]-rfq_number optional ) } Line item { value #( lt_temp[ 1 ]-rfq_item OPTIONAL ) alpha = out } Suppl. { value #( lt_temp[ 1 ]-supplier_code1 OPTIONAL ) alpha = out } |
                                          v2       = |-Invalid RFQ/Item { value #( lt_temp[ 1 ]-rfq_item OPTIONAL ) alpha = out } |
                                        ).

                wa_error-%tky-%key-rfq_number = value #( lt_rfqitm[ 1 ]-RequestForQuotation OPTIONAL ).
                wa_error-%tky-%key-rec_counter = lv_msgcntr.
                wa_error-%fail-cause = if_abap_behv=>cause-conflict.
                APPEND wa_error TO failed-zcds_rfqsuplrritm.

                wa_record-%msg = wa_msg.
                wa_record-%tky-rfq_number   = value #( lt_rfqitm[ 1 ]-RequestForQuotation OPTIONAL ).
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                append wa_record to reported-zcds_rfqsuplrritm.
                lv_errflg = 'X'.
           endif.
        else.
* in case initial/invalid RFQ
*            lv_msgcntr = lv_msgcntr + 1.
*            wa_msg = me->new_message(
*                                  id       = '8i'
*                                  number   = 000
*                                  severity = if_abap_behv_message=>severity-error
*                                  v1       = |RFQ{ value #( lt_rfqitm[ 1 ]-RequestForQuotation OPTIONAL ) alpha = out } |
*                                  v2       = | Invalid RFQ { value #( lt_rfqitm[ 1 ]-RequestForQuotation OPTIONAL ) alpha = out } |  ).
*            wa_record-%msg = wa_msg.
*            wa_record-%tky-%key-rfq_number = value #( lt_rfqitm[ 1 ]-RequestForQuotation OPTIONAL ).
*            wa_record-%tky-%key-rec_counter = lv_msgcntr.
*            APPEND wa_record TO reported-zcds_rfqsuplrritm.
*
*            wa_error-%tky-%key-rfq_number = value #( lt_rfqitm[ 1 ]-RequestForQuotation OPTIONAL ).
*            wa_error-%tky-%key-rec_counter = lv_msgcntr.
*            wa_error-%fail-cause = if_abap_behv=>cause-conflict.
*            APPEND wa_error TO failed-zcds_rfqsuplrritm.
*
*            lv_errflg = 'X'.
        endif.


       LOOP AT loc=>thead into data(wa_head).
* Material code Validation
            data(lv_idx)    = sy-tabix.
            lv_idx          = lv_idx + 1.
            clear: lwa_rfqitm.
            lwa_rfqitm = VALUE #( lt_rfqitm[ RequestForQuotation     = wa_head-rfq_number
                                             RequestForQuotationItem = wa_head-rfq_item ] OPTIONAL ).
            if lwa_rfqitm-Material <> wa_head-material.
             lv_msgcntr = lv_msgcntr + 1.
             wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = |Row:{ lv_idx } RFQ { wa_head-rfq_number } Line item { wa_head-rfq_item alpha = out } Suppl. { wa_head-supplier_code1 alpha = out } |
                                      v2       = |-Invalid RFQ Material { wa_head-material alpha = out }|
*                                      v3       = | let's see what happens|
                                        ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number =  wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.

                wa_error-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_error-%tky-%key-rec_counter = lv_msgcntr.
                wa_error-%fail-cause = if_abap_behv=>cause-conflict.
                APPEND wa_error TO failed-zcds_rfqsuplrritm.

                lv_errflg = 'X'.
            endif.
* Supplier code Validation
           if wa_head-supplier_code1 <> '0000000000'.
            data(wa_suppmail) = VALUE #( it_suppmail[ requestforquotation = wa_head-rfq_number
                                                      supplier            = wa_head-supplier_code1 ] OPTIONAL ).
           else.
            wa_suppmail = VALUE #( it_suppmail[ requestforquotation = wa_head-rfq_number
                                                uppername           = to_upper( wa_head-supplier_name ) ] OPTIONAL ).

           endif.
            if wa_suppmail is INITIAL.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                          id       = '8i'
                                          number   = 000
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = |Row:{ lv_idx } RFQ { wa_head-rfq_number } Line item { wa_head-rfq_item alpha = out } Suppl. { wa_head-supplier_code1 alpha = out } |
                                          v2       = |-Mismatch supplier:{ wa_head-supplier_name }|
                                        ).

                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.

                wa_error-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_error-%tky-%key-rec_counter = lv_msgcntr.
                wa_error-%fail-cause = if_abap_behv=>cause-conflict.
                APPEND wa_error TO failed-zcds_rfqsuplrritm.

                lv_errflg = 'X'.
            endif.

* Check and validate supplier code exists
           data(lwa_bidder) = value #( it_bidder[ RequestForQuotation = wa_head-rfq_number
                                                  Supplier            = wa_head-supplier_code1 ] OPTIONAL ).
           if lwa_bidder is INITIAL and wa_head-supplier_code1 <> '0000000000'.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = |Row:{ lv_idx } RFQ { wa_head-rfq_number } Line item { wa_head-rfq_item alpha = out } Suppl. { wa_head-supplier_code1 alpha = out } |
                                      v2       = |-Bidder { wa_head-supplier_code1 alpha = out } not assgined to RFQ  | ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.

                 wa_error-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_error-%tky-%key-rec_counter = lv_msgcntr.
                wa_error-%fail-cause = if_abap_behv=>cause-conflict.
                APPEND wa_error TO failed-zcds_rfqsuplrritm.

                lv_errflg = 'X'.

           endif.
* Check amount
            lv_numchk = wa_head-item_rate1.
            CONDENSE lv_numchk.
            if matches( val     =  lv_numchk
                        regex   = '^\d+(\.\d{1,2})?$' ).
            else.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = |Row:{ lv_idx } RFQ { wa_head-rfq_number } Line item { wa_head-rfq_item alpha = out } Suppl. { wa_head-supplier_code1 alpha = out } |
                                      v2       = |-Item rate must be numeric { wa_head-item_rate1 } |  ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.

                wa_error-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_error-%tky-%key-rec_counter = lv_msgcntr.
                wa_error-%fail-cause = if_abap_behv=>cause-conflict.
                APPEND wa_error TO failed-zcds_rfqsuplrritm.

                lv_errflg = 'X'.

            ENDIF.

           lv_numchk = wa_head-target_rate.
           CONDENSE lv_numchk.
            if matches( val     =  lv_numchk
                        regex   = '^\d+(\.\d{1,2})?$' ).
            else.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = |Row:{ lv_idx } RFQ { wa_head-rfq_number } Line item { wa_head-rfq_item alpha = out } Suppl. { wa_head-supplier_code1 alpha = out } |
                                      v2       = |-Target rate must be numeric { wa_head-target_rate } |  ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.

                wa_error-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_error-%tky-%key-rec_counter = lv_msgcntr.
                wa_error-%fail-cause = if_abap_behv=>cause-conflict.
                APPEND wa_error TO failed-zcds_rfqsuplrritm.

                lv_errflg = 'X'.

            ENDIF.


            if lv_errflg is INITIAL.
               MOVE-CORRESPONDING wa_head to wa_data.
               wa_data-rec_counter      = wa_suppmail-rec_counter.
"               wa_data-supplier_code1   = wa_suppmail-supplier.
               append wa_data to it_data.
           endif.
           clear: wa_data, wa_suppmail, lwa_rfqitm, lwa_bidder, wa_error, wa_record.
       ENDLOOP.

  ENDMETHOD.

  "* Save Method
  METHOD save.
*&-------------------------------------------------------------------&*
* SAVE Method
*&-------------------------------------------------------------------&*
  data:   it_data       type STANDARD TABLE OF ztb_rfqsuplrritm,
          wa_data       type ztb_rfqsuplrritm,
          lv_errflg     type c LENGTH 1.
   DATA: wa_record LIKE LINE OF reported-zcds_rfqsuplrritm,
         lv_numchk type string,
         lv_msgcntr     type zcds_rfqsuplrritm-rec_counter.
"If Delete is requested
*    delete from ztb_rfqsuplrritm.
*    return.
    if loc=>tdel is not INITIAL.
        loop at loc=>tdel INTO data(lwa_del).
            delete from ztb_rfqsuplrritm where rfq_number = @lwa_del-rfq_number
                                           and rfq_item   = @lwa_del-rfq_item
                                           and supplier_code1 = @lwa_del-supplier_code1.
        endloop.
        clear: loc=>tdel.
        return.
    endif.
* Data validation
    if loc=>thead is not INITIAL.
        select  from zirfq_suppmail
        FIELDS
        requestforquotation,
        rec_counter,
        supplier,
        suppliername,
        suppliername  as uppername

        FOR ALL ENTRIES IN @loc=>thead
        where requestforquotation   = @loc=>thead-rfq_number
        INTO TABLE @data(it_suppmail).
        sort it_suppmail by requestforquotation rec_counter.
        delete ADJACENT DUPLICATES FROM it_suppmail COMPARING requestforquotation rec_counter.

        loop at it_suppmail ASSIGNING FIELD-SYMBOL(<f1>).
            <f1>-uppername = to_upper(  <f1>-uppername ).
        ENDLOOP.

        sort it_suppmail by requestforquotation uppername.
    endif.

*     MOVE-CORRESPONDING loc=>thead TO it_data.
       data(lt_temp) = loc=>thead.

* Validate RFQ and item
        sort lt_temp by rfq_number rfq_item.
        delete lt_temp where rfq_number is INITIAL.
        delete lt_temp where rfq_number = '0000000000'.

        delete ADJACENT DUPLICATES FROM lt_temp COMPARING  rfq_number.
        clear: lv_msgcntr.

        if lt_temp is not INITIAL.
            data(lv_rfqno) = value #( lt_Temp[ 1 ]-rfq_number OPTIONAL ).
            select * from I_RfqItem_Api01 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @lt_temp
            where RequestForQuotation = @lt_temp-rfq_number
            INTO TABLE @DATA(lt_rfqitm).

           sort lt_rfqitm by RequestForQuotation RequestForQuotationItem.

* Read bidders from RFQ
           select * from I_RfqBidder_Api01 WITH PRIVILEGED ACCESS
                      FOR ALL ENTRIES IN @lt_temp
                      where RequestForQuotation = @lt_temp-rfq_number
                      into table @data(it_bidder).
           sort it_bidder by RequestForQuotation Supplier.

           LOOP AT lt_rfqitm INTO data(lwa_rfqitm).
            delete lt_temp WHERE rfq_number = lwa_rfqitm-RequestForQuotation
                             and rfq_item   = lwa_rfqitm-RequestForQuotationItem.
           ENDLOOP.

           if lines( lt_temp ) > 0.
              lv_msgcntr = lv_msgcntr + 1.
              data(wa_msg) = me->new_message(
                                          id       = '8i'
                                          number   = 000
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = | Invalid RFQ Item { value #( lt_temp[ 1 ]-rfq_item OPTIONAL ) } |
*                                          v2       = wa_head-supplier_name
                                        ).

                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = value #( lt_temp[ 1 ]-rfq_number OPTIONAL ).
                wa_record-%tky-%key-rec_counter = lv_msgcntr.

                APPEND wa_record TO reported-zcds_rfqsuplrritm.
                lv_errflg = 'X'.
           endif.
        else.
* in case initial/invalid RFQ
            lv_msgcntr = lv_msgcntr + 1.
            wa_msg = me->new_message(
                                  id       = '8i'
                                  number   = 000
                                  severity = if_abap_behv_message=>severity-error
                                  v1       = | Invalid RFQ { value #( lt_temp[ 1 ]-rfq_number OPTIONAL ) } |  ).
            wa_record-%msg = wa_msg.
            wa_record-%tky-%key-rfq_number = value #( lt_temp[ 1 ]-rfq_number OPTIONAL ).
            wa_record-%tky-%key-rec_counter = lv_msgcntr.
            APPEND wa_record TO reported-zcds_rfqsuplrritm.
            lv_errflg = 'X'.
        endif.


       LOOP AT loc=>thead into data(wa_head).
* Material code Validation
            clear: lwa_rfqitm.
            lwa_rfqitm = VALUE #( lt_rfqitm[ RequestForQuotation     = wa_head-rfq_number
                                             RequestForQuotationItem = wa_head-rfq_item ] OPTIONAL ).
            if lwa_rfqitm-Material <> wa_head-material.
             lv_msgcntr = lv_msgcntr + 1.
             wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = | Invalid RFQ Material { lwa_rfqitm-material } |  ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number =  wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.
                lv_errflg = 'X'.
            endif.

* Check and validate supplier code exists
           data(lwa_bidder) = value #( it_bidder[ RequestForQuotation = wa_head-rfq_number
                                                  Supplier            = wa_head-supplier_code1 ] OPTIONAL ).
           if lwa_bidder is INITIAL and wa_head-supplier_code1 <> '0000000000'.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = | Bidder { wa_head-supplier_code1 } not assgined to RFQ |  ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.
                lv_errflg = 'X'.

           endif.
* Check amount
            lv_numchk = wa_head-item_rate1.
            CONDENSE lv_numchk.
            if matches( val     =  lv_numchk
                        regex   = '^\d+(\.\d{1,2})?$' ).
            else.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = | Item rate must be numerical { wa_head-item_rate1 } |  ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.
                lv_errflg = 'X'.

            ENDIF.

           lv_numchk = wa_head-target_rate.
           CONDENSE lv_numchk.
            if matches( val     =  lv_numchk
                        regex   = '^\d+(\.\d{1,2})?$' ).
            else.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                      id       = '8i'
                                      number   = 000
                                      severity = if_abap_behv_message=>severity-error
                                      v1       = | Target rate must be numerical { wa_head-target_rate } |  ).
                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.
                lv_errflg = 'X'.

            ENDIF.
*           if wa_head-supplier_code1 is not INITIAL.
*            data(wa_suppmail) = VALUE #( it_suppmail[ requestforquotation = wa_head-rfq_number
*                                                      supplier            = wa_head-supplier_code1 ] OPTIONAL ).
*           else.
            data(wa_suppmail) = VALUE #( it_suppmail[ requestforquotation = wa_head-rfq_number
                                                      uppername           = to_upper( wa_head-supplier_name ) ] OPTIONAL ).

*           endif.
            if wa_suppmail is INITIAL.
              lv_msgcntr = lv_msgcntr + 1.
              wa_msg = me->new_message(
                                          id       = '8i'
                                          number   = 000
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = 'Mismatch supplier:'
                                          v2       = wa_head-supplier_name
                                        ).

                wa_record-%msg = wa_msg.
                wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
                wa_record-%tky-%key-rec_counter = lv_msgcntr.
                APPEND wa_record TO reported-zcds_rfqsuplrritm.
            endif.
            if lv_errflg is INITIAL.
               MOVE-CORRESPONDING wa_head to wa_data.
               wa_data-rec_counter      = wa_suppmail-rec_counter.
"               wa_data-supplier_code1   = wa_suppmail-supplier.
               append wa_data to it_data.
           endif.
           clear: wa_data, wa_suppmail, lwa_rfqitm, lwa_bidder.
       ENDLOOP.

        if lv_errflg = 'X'.

          return.
        else.
          lv_msgcntr = lv_msgcntr + 1.
          wa_msg = me->new_message(  id       = '8i'
                                     number   = 000
                                     severity = if_abap_behv_message=>severity-success
                                     v1       = 'Supplier item rate updated for RFQ'
                                     v2       = wa_head-rfq_number ).
            wa_record-%msg = wa_msg.
            wa_record-%tky-%key-rfq_number = wa_head-rfq_number.
            wa_record-%tky-%key-rec_counter = lv_msgcntr.
            APPEND wa_record TO reported-zcds_rfqsuplrritm.
          if lines( it_data ) > 0.
            modify ztb_rfqsuplrritm from table @it_data.
            clear: loc=>thead.
          endif.

        endif.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.


ENDCLASS.

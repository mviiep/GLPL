*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   ZI_RFQ_Suppliersitms AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead    TYPE TABLE OF ZI_RFQ_Suppliersitms,
               tdel     type table of ZI_RFQ_Suppliersitms.
ENDCLASS.

CLASS lhc_zi_rfq_suppliersitms DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZI_RFQ_Suppliersitms RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZI_RFQ_Suppliersitms.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZI_RFQ_Suppliersitms.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZI_RFQ_Suppliersitms.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZI_RFQ_Suppliersitms RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZI_RFQ_Suppliersitms.

ENDCLASS.

CLASS lhc_zi_rfq_suppliersitms IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-ZI_RFQ_Suppliersitms,
          tgdt    LIKE LINE OF loc=>mt_data,
          wa_mail TYPE zi_rfq_suppliers.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-ZI_RFQ_Suppliersitms.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-ZI_RFQ_Suppliersitms,
          tgdt    LIKE LINE OF loc=>mt_data,
          wa_mail TYPE ZI_RFQ_Suppliersitms.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-ZI_RFQ_Suppliersitms.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
  data: lwa_line type ZI_RFQ_Suppliersitms.
    loop at keys INTO data(lwa_key).
    lwa_line-requestforquotation = lwa_key-RequestForQuotation.
    lwa_line-rfq_item      = lwa_key-rfq_item.
    append lwa_line to loc=>tdel.
    clear: lwa_line.
    ENDLOOP.
  ENDMETHOD.

*end of delete method

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

"**************************************************************************"
" SAVER Class definition and implementation
"**************************************************************************"
CLASS lsc_zi_rfq_suppliersitms DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_rfq_suppliersitms IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

"***************************************************************"
" SAVE Method
"***************************************************************"
  METHOD save.
"    delete from zirfq_suppmail.
    DATA : lt_itab      type STANDARD TABLE OF ZI_RFQ_Suppliersitms,
           lt_data      TYPE STANDARD TABLE OF ztb_rfqsuplrritm,
           wa_data      type ztb_rfqsuplrritm,
           upd_flag     type c.

"If Delete is requested
    if loc=>tdel is not INITIAL.
        loop at loc=>tdel INTO data(lwa_del).
            delete from ztb_rfqsuplrritm where rfq_number = @lwa_del-RequestForQuotation
                                           and rfq_item   = @lwa_del-rfq_item.
        endloop.
        clear: loc=>tdel.
        return.
    endif.

* In Case of approval flag
"    MOVE-CORRESPONDING loc=>thead TO lt_data.
    MOVE-CORRESPONDING loc=>thead TO lt_itab.

    loop at lt_itab INTO data(lwa_itab).
        wa_Data-rfq_number  = lwa_itab-RequestForQuotation.
        wa_data-rfq_item    = lwa_itab-rfq_item.

*        if lwa_itab-aprl_flag1 is not INITIAL.
*            wa_data-supplier_code1 = lwa_itab-supplier_code1.
*        endif.
*       if lwa_itab-aprl_flag2 is not INITIAL.
*            wa_data-supplier_code1 = lwa_itab-supplier_code2.
*        endif.
*        if lwa_itab-aprl_flag3 is not INITIAL.
*            wa_data-supplier_code1 = lwa_itab-supplier_code3.
*        endif.
*       if lwa_itab-aprl_flag4 is not INITIAL.
*            wa_data-supplier_code1 = lwa_itab-supplier_code4.
*        endif.
*        if lwa_itab-aprl_flag5 is not INITIAL.
*            wa_data-supplier_code1 = lwa_itab-supplier_code5.
*        endif.

        if wa_data-supplier_code1 is not INITIAL.
            wa_data-apprl_flag = 'X'.
            append wa_data to lt_data.
        endif.
        clear: wa_data.
    ENDLOOP.

    sort lt_data by rfq_number supplier_code1.
    delete ADJACENT DUPLICATES FROM lt_data COMPARING rfq_number supplier_code1.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<f1>).

        UPDATE ztb_rfqsuplrritm set apprl_flag = 'X'
                                    WHERE rfq_number = @<f1>-rfq_number
"                                      AND rfq_item   = @<f1>-rfq_item
                                      and supplier_code1 = @<f1>-supplier_code1.
        upd_flag = 'X'.
    ENDLOOP.

    IF upd_flag is not INITIAL.

" Publish RFQ
 "       data(lv_rfq) = VALUE #(  lt_Data[ 1 ]-rfq_number OPTIONAL ).
 "       zcl_rfq_utility=>rfq_publish( iv_rfqno = lv_rfq ).

    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

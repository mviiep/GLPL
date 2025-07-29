CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   zi_rfq_suppliers AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead    TYPE TABLE OF zi_rfq_suppliers,
               tdel     type table of zi_rfq_suppliers.
ENDCLASS.

CLASS lhc_zi_rfq_suppliers DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_rfq_suppliers RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_rfq_suppliers.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_rfq_suppliers.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_rfq_suppliers.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_rfq_suppliers RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_rfq_suppliers.

ENDCLASS.

CLASS lhc_zi_rfq_suppliers IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-zi_rfq_suppliers,
          tgdt    LIKE LINE OF loc=>mt_data,
          wa_mail TYPE zi_rfq_suppliers.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zi_rfq_suppliers.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

  METHOD update.

**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-zi_rfq_suppliers,
          tgdt    LIKE LINE OF loc=>mt_data,
          wa_mail TYPE zi_rfq_suppliers.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zi_rfq_suppliers.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

  ENDMETHOD.

  METHOD delete.
  data: lwa_line type zi_rfq_suppliers.
    loop at keys INTO data(lwa_key).
    lwa_line-requestforquotation = lwa_key-RequestForQuotation.
    lwa_line-rec_counter         = lwa_key-rec_counter.
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

CLASS lsc_zi_rfq_suppliers DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_rfq_suppliers IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  "* Save Method
  METHOD save.
"    delete from zirfq_suppmail.
    DATA : lt_data   TYPE STANDARD TABLE OF zirfq_suppmail,
           lv_cntr   TYPE n LENGTH 2,
           mailtable TYPE STANDARD TABLE OF zi_rfq_suppliers.

"If Delete is requested
    if loc=>tdel is not INITIAL.
        loop at loc=>tdel INTO data(lwa_del).
            delete from zirfq_suppmail where requestforquotation = @lwa_del-RequestForQuotation
                                         and rec_counter         = @lwa_del-rec_counter.
        endloop.
        clear: loc=>tdel.
        return.
    endif.

    MOVE-CORRESPONDING loc=>thead TO lt_data.

    "* Read RFQ Number
    DATA(lv_rfqnumber) = VALUE #( lt_data[  1 ]-requestforquotation OPTIONAL  ).
    SELECT count( * ) FROM zirfq_suppmail
             WHERE requestforquotation = @lv_rfqnumber
             into @data(lv_ecount).

    lv_cntr = lv_ecount.  "Check if records already exists in custom table

    " Delete empty records if any
    DELETE lt_data WHERE requestforquotation IS INITIAL.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<f1>).

        if <f1>-supplier    = '0000000000' or
           <f1>-supplier    is INITIAL.
           <f1>-unreg_flag  = 'X'.
        endif.
    ENDLOOP.

    IF lines(  lt_data ) > 0.
      MODIFY zirfq_suppmail FROM TABLE @lt_data.

    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

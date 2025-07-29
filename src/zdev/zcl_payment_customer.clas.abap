CLASS zcl_payment_customer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PAYMENT_CUSTOMER IMPLEMENTATION.


METHOD if_rap_query_provider~select.
  IF io_request->is_data_requested( ).

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 60.
        lv_top = 10000.
      ENDIF.



      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
      DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).
      DATA(lt_sort)    = io_request->get_sort_elements( ).
      DATA : lv_orderby TYPE string.
      DATA(lv_conditions) =  io_request->get_filter( )->get_as_sql_string( ).

      TRY.
          DATA(it_input) =  io_request->get_filter(  )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option) ##NO_HANDLER.
      ENDTRY.
Types :BEGIN OF ty_final,
       CustomerId type kunnr,
       Supplier TYPE lifnr,
       AccDocNo type belnr_d,
       InvNo type xblnr,
       InvDate type bldat,
       Amt type znetwr,
       clearing type bldat,


       END OF ty_final.
data:lt_final type STANDARD TABLE OF ty_final,
     ls_final type ty_final.


    TYPES: BEGIN OF r_sup,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE lifnr,
               high   TYPE lifnr,
             END OF r_sup.


           DATA: r_sup TYPE TABLE OF r_sup,
            w_sup TYPE r_sup.

  READ TABLE it_input INTO DATA(wa_input) WITH KEY name = 'CUSTOMERID'.
      IF sy-subrc = 0.
        DATA(lv_range) = wa_input-range.
        IF lv_range IS NOT INITIAL.
          READ TABLE lv_range INTO DATA(wa_range) INDEX 1.
          IF sy-subrc = 0.
            MOVE-CORRESPONDING wa_range TO w_sup.
            APPEND w_sup TO r_sup.
            CLEAR: w_sup.
          ENDIF.
        ENDIF.
      ENDIF.


    SELECT from I_JournalEntryItem
      FIELDS SourceLedger,
             companycode,
             FiscalYear,
             LedgerGLLineItem,
             ledger,
             AccountingDocument,
             Documentdate,
             customer,
             supplier,
             ClearingDate,
             DebitAmountInTransCrcy
            WHERE customer in   @r_sup
             and Ledger eq '0L'
            ORDER BY supplier
            INTO TABLE @DATA(lt_journal)
            UP TO @lv_top ROWS OFFSET @lv_skip.
  if lt_journal is not  INITIAL.
   SELECT FROM i_supplier
      FIELDS supplier,
             SupplierName,
              BusinessPartnerPanNumber
              FOR ALL ENTRIES IN @lt_journal
              WHERE supplier = @lt_journal-supplier
              INTO TABLE @DAta(lt_sup).

               SELECT FROM I_JournalEntry
      FIELDS companycode,
             FiscalYear,
              AccountingDocument,
               DocumentReferenceID
              FOR ALL ENTRIES IN @lt_journal
              WHERE companycode = @lt_journal-companycode
              and    FiscalYear = @lt_journal-fiscalyear
              and AccountingDocument = @lt_journal-AccountingDocument
              INTO TABLE @DAta(lt_jour).
   endif.
   CLEAr :lt_final.
LOOP AT lt_journal ASSIGNING FIELD-SYMBOL(<ls_journal>) .
ls_final-customerid = <ls_journal>-customer.
READ TABLE lt_sup ASSIGNING FIELD-SYMBOL(<ls_sup>) with KEY supplier = <ls_journal>-supplier.
ls_final-supplier = <ls_sup>-supplier.
ls_final-accdocno = <ls_journal>-AccountingDocument.
Ls_final-clearing = <ls_journal>-ClearingDate.
ls_final-amt        = <ls_journal>-DebitAmountInTransCrcy.
READ TABLE lt_jour ASSIGNING FIELD-SYMBOL(<ls_jour>) with key companycode = <ls_journal>-CompanyCode
                                                               FiscalYear = <ls_journal>-FiscalYear
                                                               accountingdocument = <ls_journal>-AccountingDocument.
ls_final-invno = <ls_jour>-DocumentReferenceID.
ls_final-invdate    = <ls_journal>-DocumentDate.
APPEND ls_final to lt_final.
clear ls_final.
endloop.
 IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( 1000000 ).
        io_response->set_data( lt_final ).

endif.

      ENDIF.
     ENDMETHOD.
ENDCLASS.

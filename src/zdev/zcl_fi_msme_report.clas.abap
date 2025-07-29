CLASS zcl_fi_msme_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FI_MSME_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
      IF io_request->is_data_requested( ).
      DATA(off) = io_request->get_paging( )->get_offset(  ).
      DATA(pag) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE pag ).
      DATA lv_rows TYPE int8.

      lv_rows = lv_max_rows.
      DATA(lsort) = io_request->get_sort_elements( ) .

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

      DATA(lv_max_rows_top) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE lv_top ).

      DATA(lt_fields)  = io_request->get_requested_elements( ).
      DATA(lt_sort)    = io_request->get_sort_elements( ).

      DATA(set) = io_request->get_requested_elements( ).
      DATA(lvs) = io_request->get_search_expression( ).
      DATA(filter1) = io_request->get_filter(  ).
      DATA(p1) = io_request->get_parameters(  ).
      DATA(p2) = io_request->get_requested_elements(  ).

      DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


      TRY.
          DATA(it_input) =  io_request->get_filter(  )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option) ##NO_HANDLER.
      ENDTRY.

      TYPES :BEGIN OF  ty_final,
               client   TYPE mandt,
               sno      TYPE lifnr,
               supplier TYPE lifnr,
               bp       TYPE zchar40,
               pan      TYPE zchar40,
               no1      TYPE lifnr,
               amt1     TYPE  znetwr,
               no2      TYPE lifnr,
               amt2     TYPE  znetwr,
               no3      TYPE lifnr,
               amt3     TYPE  znetwr,
               no4      TYPE lifnr,
               amt4     TYPE   znetwr,
               zcomment TYPE zcomment,
             END OF ty_final.

      TYPES : BEGIN OF ty_bp,
                businesspartner TYPE i_businesspartnertaxnumber-businesspartner,
              END OF ty_bp.

      TYPES : BEGIN OF ty_sup,
                suppliername             TYPE i_supplier-suppliername,
                businesspartnerpannumber TYPE  i_supplier-businesspartnerpannumber,
              END OF ty_sup.

      TYPES : BEGIN OF ty_jour,
                clearingdate TYPE  i_journalentryitem-clearingdate,
                netduedate   TYPE i_journalentryitem-netduedate,
              END OF ty_jour.

      TYPES: BEGIN OF r_sup,
               sign   TYPE zsign,
               option TYPE zoption,
               low    TYPE lifnr,
               high   TYPE lifnr,
             END OF r_sup.

      DATA: it_temp_msme TYPE TABLE OF zmsme_tb,
            ls_temp_msme TYPE zmsme_tb.
      DATA:lt_final  TYPE STANDARD TABLE OF ty_final,
           wa_final  TYPE ty_final,
           lt_result TYPE STANDARD TABLE OF ty_final.
      DATA:lt_final1 TYPE STANDARD TABLE OF zmsme_tb .


      DATA: r_sup TYPE TABLE OF r_sup,
            w_sup TYPE r_sup,
            date1 TYPE d,
            date2 TYPE d,
            date3 TYPE zdays.

      DATA: lv_amt1 TYPE zchar40,
            lv_amt2 TYPE zchar40,
            lv_amt3 TYPE zchar40,
            lv_amt4 TYPE zchar40.
      DATA: n  TYPE i,
            n2 TYPE i.

      READ TABLE it_input INTO DATA(wa_input) WITH KEY name = 'SUPPLIER'.
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

      SELECT businesspartner,supplier,suppliername,businesspartnerpannumber
      FROM i_businesspartnertaxnumber
      LEFT OUTER JOIN i_supplier AS _supplier ON _supplier~supplier = i_businesspartnertaxnumber~businesspartner
      WHERE businesspartner IN @r_sup
      AND bptaxtype = 'IN5'
      ORDER BY businesspartner
      INTO TABLE @DATA(lt_bp)
      UP TO @lv_top ROWS OFFSET @lv_skip.


      IF lt_bp IS NOT INITIAL.
*        SELECT FROM i_supplier
*        FIELDS supplier,
*               suppliername,
*               businesspartnerpannumber
*                FOR ALL ENTRIES IN @lt_bp
*                WHERE supplier = @lt_bp-businesspartner
*                INTO TABLE @DATA(lt_sup).

*        IF  lt_sup IS NOT INITIAL.

        SELECT FROM i_journalentryitem
          FIELDS sourceledger,
                companycode,
                fiscalyear,
                ledgergllineitem,
                 ledger,
                accountingdocument,
                 documentdate,
                 accountingdocumenttype,
                 supplier,
                clearingdate,
                netduedate,
                "" CreditAmountInCoCodeCrcy
                 amountincompanycodecurrency
                FOR ALL ENTRIES IN @lt_bp
                WHERE supplier = @lt_bp-supplier
                AND companycode = '1000' AND ledger EQ '0L' AND
                "CreditAmountInCoCodeCrcy ne ' '
                amountincompanycodecurrency NE ' '
                 AND  financialaccounttype = 'K'
                INTO TABLE @DATA(lt_journal).

      ENDIF.

      "select single  from zmsme_tb FIELDS zcomment WHERE supplier in @r_sup into  @data(ls_comments).
      SELECT  FROM zmsme_tb FIELDS supplier, zcomment WHERE supplier IN @r_sup INTO TABLE  @DATA(it_comments). "Addition on 15-04-2024
      LOOP AT lt_journal ASSIGNING FIELD-SYMBOL(<ls_journal>) GROUP BY ( key1 = <ls_journal>-supplier fiscalyear = <ls_journal>-fiscalyear ).
        n2 = n2 + (  n + 1  ).
        wa_final-sno = n2.
        "wa_final-sno = <ls)journal>-row.

        READ TABLE lt_bp INTO DATA(ls_sup) WITH KEY supplier = <ls_journal>-supplier.
        wa_final-supplier = ls_sup-supplier.
        wa_final-pan = ls_sup-businesspartnerpannumber.
        wa_final-bp = ls_sup-suppliername.


        ""Addition on 15-04-2024
        wa_final-zcomment = VALUE #( it_comments[ supplier = <ls_journal>-supplier ]-zcomment OPTIONAL ).
        "wa_final-zcomment = ls_comments.
        LOOP AT GROUP  <ls_journal> ASSIGNING FIELD-SYMBOL(<ls_journal1>).
          date1 = <ls_journal1>-clearingdate.
          date2 = <ls_journal1>-netduedate.
          <ls_journal1>-amountincompanycodecurrency = -1 * <ls_journal1>-amountincompanycodecurrency.
          IF date1 IS NOT INITIAL.
            date3 = date1 - date2 .
            CONDENSE date3 NO-GAPS.
            IF ( date3 = '0' OR date3 CA '-' ) AND <ls_journal1>-accountingdocumenttype = 'KR'.
              wa_final-no1 = wa_final-no1 + 1 .
              wa_final-amt1 = wa_final-amt1 + <ls_journal1>-amountincompanycodecurrency.

            ELSEIF date3 > '0' AND  <ls_journal1>-accountingdocumenttype = 'KR'..
              wa_final-no2 = wa_final-no2  + 1.
              wa_final-amt2 = wa_final-amt2 + <ls_journal1>-amountincompanycodecurrency.
            ENDIF.

          ELSE.

            date1 = syst-datum.
            date2 = <ls_journal1>-netduedate.
            date3 = date1 - date2 .
            CONDENSE date3 NO-GAPS.
            IF date3 = '0'  OR date3 CA '-'..
              wa_final-no3 =  wa_final-no3 + 1.
              wa_final-amt3 = wa_final-amt3 + <ls_journal1>-amountincompanycodecurrency.

            ELSEIF date3 > '0'.
              wa_final-no4 = wa_final-no4 + 1.
              wa_final-amt4 = wa_final-amt4 + <ls_journal1>-amountincompanycodecurrency.

            ENDIF.
          ENDIF.
          CLEAR :date1,date2,date3.
        ENDLOOP.
        "lv_amt1 =  wa_final-amt1.
        "lv_amt2 =  wa_final-amt2.
        "lv_amt3 = wa_final-amt3.
        "lv_amt4 = wa_final-amt4.
        ""clear :wa_final-amt1,wa_final-amt2,wa_final-amt3,wa_final-amt4.
        "if lv_amt1 ca '-'.
        "CONDENSE lv_amt1.
        "wa_final-amt1 = -1 * lv_amt1.
        "ENDIF.
        "IF lv_amt2 ca '-'.

        "CONDENSE lv_amt2.
        "wa_final-amt2 = -1 * lv_amt2.
        "endif.

        "IF lv_amt3 ca '-'.

        "CONDENSE lv_amt3.
        "wa_final-amt3 = -1 * lv_amt3.
        "ENDIF.
        "IF lv_amt4 ca '-'.

        "CONDENSE lv_amt4.
        "wa_final-amt4 = -1 * lv_amt4.
        "endif.
        APPEND wa_final TO lt_final.
        CLEAR wa_final.



      ENDLOOP.


      "Addition on 15-04-2024


      SELECT supplier FROM zmsme_tb WHERE supplier IN @r_sup INTO TABLE @DATA(it_supplier).
      ""naga 22-01-2025
      IF it_supplier[] IS  INITIAL.
        LOOP AT lt_final ASSIGNING FIELD-SYMBOL(<ls_final>).
          ls_temp_msme-client = sy-mandt.
          ls_temp_msme-supplier = <ls_final>-supplier.
          ls_temp_msme-sno = <ls_final>-sno.
          ls_temp_msme-bp_name = <ls_final>-bp.
          ls_temp_msme-pan_no = <ls_final>-pan.
          ls_temp_msme-no1 = <ls_final>-no1.
          ls_temp_msme-amt1 = <ls_final>-amt1.
          ls_temp_msme-no2 = <ls_final>-no2.
          ls_temp_msme-amt2 = <ls_final>-amt2.
          ls_temp_msme-no3 = <ls_final>-no3.
          ls_temp_msme-amt3 = <ls_final>-amt3.
          ls_temp_msme-no4 = <ls_final>-no4.
          ls_temp_msme-amt4 = <ls_final>-amt4.
          ls_temp_msme-zcomment = <ls_final>-zcomment.
          APPEND ls_temp_msme TO it_temp_msme.
          CLEAR ls_temp_msme.
        ENDLOOP.
        "  MODIFY zmsme_tb FROM TABLE @it_temp_msme.
        "if sy-subrc = 0.
        "commit work.
        " ENDIF.
        LOOP AT it_temp_msme INTO data(l_temp_msme).
          MODIFY zmsme_tb FROM @l_temp_msme.
          CLEAR l_temp_msme.
        ENDLOOP.
        CLEAR n2.
      ENDIF.
      "" eoc naga on 22-01-2022


    SELECT * FROM @lt_final AS it_final3                "#EC CI_NOWHERE
               ORDER BY supplier DESCENDING
               INTO TABLE @DATA(it_fin1)
               OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
    SELECT COUNT( * )
        FROM @lt_final AS it_final3                     "#EC CI_NOWHERE
        INTO @DATA(lv_totcount).






      "IF io_request->is_total_numb_of_rec_requested(  ).
       io_response->set_total_number_of_records( lv_totcount ).
    io_response->set_data( lt_final ).

      "ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.

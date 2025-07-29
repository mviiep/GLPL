CLASS zcl_collection_rpt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_final,
              fiscalyear     TYPE c LENGTH 4,
              month1         TYPE c LENGTH 15,
              currency_code  TYPE c LENGTH 18,
*              curr type c LENGTH 6,
*              profitcenter1   TYPE c LENGTH 10,
              profitcenter   TYPE c LENGTH 40,
              open_withindd  TYPE p DECIMALS 2 LENGTH 16,
              open_beyonddd  TYPE p DECIMALS 2 LENGTH 16,
              bill_month     TYPE p DECIMALS 2 LENGTH 16,
              rec_month      TYPE p DECIMALS 2 LENGTH 16,
              close_withindd TYPE p DECIMALS 2 LENGTH 16,
              close_beyonddd TYPE p DECIMALS 2 LENGTH 16,
              days_0_to_30   TYPE p DECIMALS 2 LENGTH 16,
              days_31_to_60  TYPE p DECIMALS 2 LENGTH 16,
              days_61_to_90  TYPE p DECIMALS 2 LENGTH 16,
              days_91        TYPE p DECIMALS 2 LENGTH 16,

            END OF ty_final.

    DATA : it_final TYPE TABLE OF ty_final,
           wa_final TYPE ty_final.

    DATA: s_year  TYPE RANGE OF i_journalentry-fiscalyear,
          s_month TYPE RANGE OF zmonth.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COLLECTION_RPT IMPLEMENTATION.


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
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
      ENDTRY.
    ENDIF.

    READ TABLE lt_filter_cond INTO DATA(year) WITH KEY name = 'FISCALYEAR'.
    MOVE-CORRESPONDING year-range TO s_year.
    DATA : lv_year(4) TYPE c.
    READ TABLE s_year INTO DATA(wa_year) INDEX 1.
    IF wa_year IS NOT INITIAL.
      lv_year = wa_year-low.
    ENDIF.
    READ TABLE lt_filter_cond INTO DATA(posting) WITH KEY name = 'MONTH1'.
    MOVE-CORRESPONDING posting-range TO s_month.
    DATA : lv_month TYPE zmonth.
    READ TABLE s_month INTO DATA(wa_month) INDEX 1.
    IF wa_month IS NOT INITIAL.
      lv_month = wa_month-low.
    ENDIF.
    DATA lv_inmonth TYPE sy-datum.  "1st Day of the Selection Month
    DATA lv_lastday TYPE sy-datum.  "1st Day of Next Month
    CASE lv_month.
      WHEN 'JANUARY'.
        lv_inmonth = |{ lv_year + 1 }0101|.
        lv_lastday = |{ lv_year + 1 }0201|.
      WHEN 'FEBRUARY'.
        lv_inmonth = |{ lv_year + 1 }0201|.
        lv_lastday = |{ lv_year + 1 }0301|.

      WHEN 'MARCH'.
        lv_inmonth = |{ lv_year + 1 }0301|.
        lv_lastday = |{ lv_year + 1 }0401|.
      WHEN 'APRIL'.
        lv_inmonth = |{ lv_year }0401|.
        lv_lastday = |{ lv_year }0501|.
      WHEN 'MAY'.
        lv_inmonth = |{ lv_year }0501|.
        lv_lastday = |{ lv_year }0601|.
      WHEN 'JUNE'.
        lv_inmonth = |{ lv_year }0601|.
        lv_lastday = |{ lv_year }0701|.
      WHEN 'JULY'.
        lv_inmonth = |{ lv_year }0701|.
        lv_lastday = |{ lv_year }0801|.
      WHEN 'AUGUST'.
        lv_inmonth = |{ lv_year }0801|.
        lv_lastday = |{ lv_year }0901|.
      WHEN 'SEPTEMBER'.
        lv_inmonth = |{ lv_year }0901|.
        lv_lastday = |{ lv_year }1001|.
      WHEN 'OCTOBER'.
        lv_inmonth = |{ lv_year }1001|.
        lv_lastday = |{ lv_year }1101|.
      WHEN 'NOVEMBER'.
        lv_inmonth = |{ lv_year }1101|.
        lv_lastday = |{ lv_year }1201|.
      WHEN 'DECEMBER'.
        lv_inmonth = |{ lv_year }1201|.
        lv_lastday = |{ lv_year + 1 }0101|.
    ENDCASE.
    DATA lastday TYPE sy-datum.
    DATA firstday TYPE sy-datum.
    DATA prev_lastday TYPE sy-datum.

    lastday = lv_lastday - 1.    "Last Day of selection Month
    firstday = lv_inmonth.       "First Day of selection Month
    prev_lastday = firstday - 1. "Last Day of Previous Month

    SELECT A~amountincompanycodecurrency, A~clearingdate , A~debitamountincocodecrcy , A~creditamountincocodecrcy,
    A~postingdate , A~netduedate , a~accountingdocumenttype , B~profitcenterstandardhierarchy AS PROFITCENTER, A~ACCOUNTINGDOCUMENT
     FROM i_journalentryitem as A
     LEFT OUTER JOIN I_PROFITCENTER AS B
     ON A~ProfitCenter = B~ProfitCenter where  Ledger = '0L' and Customer is not INITIAL
AND ClearingDate is INITIAL and a~FinancialAccountType = 'D' "AND A~AccountingDocument IN ( '1800000075', '1800000074'  )   "WHERE postingdate GE @lv_inmonth AND postingdate LE @lv_lastday
* and a~AccountingDocument in ( '1800000113' ,'1600000007', '1800000114' )
     INTO TABLE @DATA(it_jl) .

      SELECT A~amountincompanycodecurrency, A~clearingdate , A~debitamountincocodecrcy , A~creditamountincocodecrcy,
    A~postingdate , A~netduedate ,  a~accountingdocumenttype , B~profitcenterstandardhierarchy AS PROFITCENTER, A~ACCOUNTINGDOCUMENT
     FROM i_journalentryitem as A
     LEFT OUTER JOIN I_PROFITCENTER AS B
     ON A~ProfitCenter = B~ProfitCenter where  Ledger = '0L' and Customer is not INITIAL
*AND ClearingDate is INITIAL "AND A~AccountingDocument IN ( '1800000075', '1800000074'  )   "WHERE postingdate GE @lv_inmonth AND postingdate LE @lv_lastday
*and a~AccountingDocument in ( '1800000113' ,'1600000007', '1800000114' )
and a~ClearingDate >= @firstday and a~ClearingDate <= @lastday  and a~FinancialAccountType = 'D'
 APPENDING CORRESPONDING FIELDS OF TABLE @it_jl .
sort it_jl by AccountingDocumentType.
delete it_jl where AccountingDocumentType = ' '.
    DATA : open_wdd   TYPE  i_journalentryitem-amountincompanycodecurrency,
           open_bdd   TYPE  i_journalentryitem-amountincompanycodecurrency,
           close_wdd  TYPE  i_journalentryitem-amountincompanycodecurrency,
           close_bdd  TYPE  i_journalentryitem-amountincompanycodecurrency,
           bill_month TYPE  i_journalentryitem-amountincompanycodecurrency,
           rec_month  TYPE  i_journalentryitem-amountincompanycodecurrency.
    SORT it_jl BY profitcenter.
*    delete it_jl where not AccountingDocument in ( '1800000113' ,'1600000007', '1800000114' ) .
    LOOP AT it_jl ASSIGNING FIELD-SYMBOL(<f1>) GROUP BY ( key1 = <f1>-profitcenter ) .
      LOOP AT GROUP <f1> ASSIGNING FIELD-SYMBOL(<f2>).
        IF <f2> IS ASSIGNED.
          IF <f2>-clearingdate = '00000000'.

            IF lv_inmonth - <f2>-netduedate LE 0 AND <f2>-postingdate < lv_inmonth.
              wa_final-open_withindd = wa_final-open_withindd + <f2>-amountincompanycodecurrency.
            ENDIF.
            IF lv_inmonth - <f2>-netduedate > 0 AND <f2>-postingdate < lv_inmonth.
              wa_final-open_beyonddd = wa_final-open_beyonddd + <f2>-amountincompanycodecurrency.
            ENDIF.
            IF lastday - <f2>-netduedate LE 0 AND <f2>-postingdate < lastday.
              wa_final-close_withindd = wa_final-close_withindd + <f2>-amountincompanycodecurrency.
            ENDIF.
            IF lastday - <f2>-netduedate > 0 AND <f2>-postingdate < lastday.
              wa_final-close_beyonddd = wa_final-close_beyonddd + <f2>-amountincompanycodecurrency.
            ENDIF.
            data days_diff1 type i.
            days_diff1 = lastday - <f2>-netduedate  .
            DATA(days_diff2) = <f2>-postingdate - lastday.
            IF ( days_diff1 le 30 ) AND days_diff2 LE 0.
              wa_final-days_0_to_30 = wa_final-days_0_to_30 + <f2>-amountincompanycodecurrency.
            ELSEIF ( days_diff1 BETWEEN 31 AND 60 ) AND days_diff2 LE 0.
              wa_final-days_31_to_60 = wa_final-days_31_to_60 + <f2>-amountincompanycodecurrency.
            ELSEIF ( days_diff1 BETWEEN 61 AND 90 ) AND days_diff2 LE 0.
              wa_final-days_61_to_90 = wa_final-days_61_to_90 + <f2>-amountincompanycodecurrency.
            ELSEIF ( days_diff1 > 90 ) AND days_diff2 LE 0.
              wa_final-days_91 = wa_final-days_91 + <f2>-amountincompanycodecurrency.
            ENDIF.
          ENDIF.
          if  <F2>-PostingDate GE lv_inmonth and <f2>-postingdate le lastday.
          if    <f2>-AccountingDocumenttype <> 'DZ'.
          bill_month = bill_month + <f2>-AmountInCompanyCodeCurrency . " <f2>-debitAmountInCoCodeCrcy.
          elseif <f2>-AccountingDocumenttype = 'DZ'.
          rec_month  = rec_month  + <f2>-AmountInCompanyCodeCurrency . "<f2>-CreditAmountInCoCodeCrcy.
           endif.
          endif.
        ENDIF.
      ENDLOOP.

*      select single sum( debitAmountInCoCodeCrcy ) from i_journalentryitem where

      wa_final-bill_month = bill_month.
      wa_final-rec_month  = rec_month.
      WA_FINAL-profitcenter = <F2>-profitcenter.
      APPEND wa_final TO it_final.
      CLEAR : wa_final , bill_month , rec_month.
    ENDLOOP.

    DO 2 TIMES.
      READ TABLE it_final ASSIGNING FIELD-SYMBOL(<f>) WITH KEY profitcenter = 'Total'.
      IF <f> IS ASSIGNED.
        wa_final-profitcenter = 'Grand Total'.
        wa_final-open_beyonddd = <f>-open_beyonddd + <f>-open_withindd.
        wa_final-close_beyonddd = <f>-close_withindd + <f>-close_beyonddd.
        wa_final-bill_month = <f>-bill_month.
        wa_final-rec_month = <f>-rec_month.
        wa_final-days_91 = <f>-days_0_to_30 + <f>-days_31_to_60 + <f>-days_61_to_90 + <f>-days_91.
        APPEND wa_final TO it_final.
        CLEAR : wa_final.
        CONTINUE.
      ENDIF.
      wa_final-profitcenter = 'Total'.
      select sum( open_withindd ) ,
             sum( open_beyonddd ) ,
             sum( close_withindd ) ,
             sum( close_beyonddd ) ,
             sum( bill_month ),
             sum( rec_month ),
             sum( days_0_to_30 ),
             sum( days_31_to_60 ),
             sum( days_61_to_90 ),
             sum( days_91 )
             from @it_final as a into ( @WA_FINAL-open_withindd , @WA_FINAL-open_beyonddd ,
                                        @WA_FINAL-close_withindd, @WA_FINAL-close_beyonddd,
                                        @WA_FINAL-bill_month , @WA_FINAL-rec_month, @WA_FINAL-days_0_to_30,
                                        @WA_FINAL-days_31_to_60 , @WA_FINAL-days_61_to_90 , @WA_FINAL-days_91  ).
      APPEND wa_final TO it_final.
      CLEAR : wa_final.
    ENDDO.

    SELECT * FROM @it_final AS it_final3                "#EC CI_NOWHERE
               ORDER BY profitcenter DESCENDING
               INTO TABLE @DATA(it_fin1)
               OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
    SELECT COUNT( * )
        FROM @it_final AS it_final3                     "#EC CI_NOWHERE
        INTO @DATA(lv_totcount).

    io_response->set_total_number_of_records( lv_totcount ).
    io_response->set_data( it_final ).


  ENDMETHOD.
ENDCLASS.

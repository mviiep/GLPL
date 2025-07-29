CLASS zcl_customer_aeging_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_final,

             companycode                 TYPE c LENGTH 30,
             customer                    TYPE c LENGTH 10,
             roomnumber                  TYPE c LENGTH 30,
             customername                TYPE c LENGTH 30,
             totalbill_fy                TYPE p DECIMALS 2 LENGTH 16,
             billed_during_month         TYPE  p DECIMALS 2 LENGTH 16,
             credit_year                 TYPE  p DECIMALS 2 LENGTH 16,
             credit_month                TYPE  p DECIMALS 2 LENGTH 16,
             collected_ytd               TYPE  p DECIMALS 2 LENGTH 16,
             collected_month             TYPE  p DECIMALS 2 LENGTH 16,
             accountingdocument          TYPE c LENGTH 30,
             netduedate                  TYPE dats,
             specialglcode               TYPE   c LENGTH 30,
             transactioncurrency         TYPE c LENGTH 5,
             amountincompanycodecurrency TYPE  p DECIMALS 2 LENGTH 16,
*             amountintransactioncurrency TYPE  p DECIMALS 2 LENGTH 16,
             days_00                     TYPE  p DECIMALS 2 LENGTH 16,
             days_0_to_30                TYPE  p DECIMALS 2 LENGTH 16,
             days_31_to_60               TYPE  p DECIMALS 2 LENGTH 16,
             days_61_to_90               TYPE  p DECIMALS 2 LENGTH 16,
             days_91_to_180              TYPE  p DECIMALS 2 LENGTH 16,
             days_greater_180            TYPE  p DECIMALS 2 LENGTH 16,
             salesorganization           TYPE c LENGTH 30,
             phonenumber                 TYPE c LENGTH 30,
             mobilephonenumber           TYPE c LENGTH 30,
             emailaddress                TYPE c LENGTH 30,
             specialglamount             TYPE  p DECIMALS 2 LENGTH 16,
             financialaccounttype        TYPE  c LENGTH 30,
             documentdate                TYPE dats,



           END OF ty_final.


    TYPES: BEGIN OF ty_final1,

             companycode                 TYPE c LENGTH 30,
             customer                    TYPE c LENGTH 30,
             roomnumber                  TYPE c LENGTH 30,
             customername                TYPE c LENGTH 30,
             totalbill_fy                TYPE p DECIMALS 2 LENGTH 16,
             billed_during_month         TYPE  p DECIMALS 2 LENGTH 16,
             lt_credit_year              TYPE  p DECIMALS 2 LENGTH 16,
             lt_credit_month             TYPE  p DECIMALS 2 LENGTH 16,
             collected_ytd               TYPE  p DECIMALS 2 LENGTH 16,
             collected_month             TYPE  p DECIMALS 2 LENGTH 16,
             accountingdocument          TYPE c LENGTH 30,
             netduedate                  TYPE dats,
             specialglcode               TYPE   c LENGTH 30,
             transactioncurrency         TYPE c LENGTH 5,
             amountincompanycodecurrency TYPE  p DECIMALS 2 LENGTH 16,
*             amountintransactioncurrency TYPE  p DECIMALS 2 LENGTH 16,
             days_00                     TYPE  p DECIMALS 2 LENGTH 16,
             days_0_to_30                TYPE  p DECIMALS 2 LENGTH 16,
             days_31_to_60               TYPE  p DECIMALS 2 LENGTH 16,
             days_61_to_90               TYPE  p DECIMALS 2 LENGTH 16,
             days_91_to_180              TYPE  p DECIMALS 2 LENGTH 16,
             days_greater_180            TYPE  p DECIMALS 2 LENGTH 16,
             salesorganization           TYPE c LENGTH 30,
             phonenumber                 TYPE c LENGTH 30,
             mobilephonenumber           TYPE c LENGTH 30,
             emailaddress                TYPE c LENGTH 30,
             specialglamount             TYPE  p DECIMALS 2 LENGTH 16,
             financialaccounttype        TYPE  c LENGTH 30,
             documentdate                TYPE dats,



           END OF ty_final1.



    DATA: lt_final  TYPE STANDARD TABLE OF ty_final,
          wa_final  TYPE ty_final,
          it_final1 TYPE TABLE OF ty_final1,
          wa_final1 TYPE ty_final1,
          it_final3 TYPE TABLE OF ty_final1,
          wa_final3 TYPE ty_final1.

    DATA: due_net   TYPE sy-datum,
          days_diff TYPE i.





    DATA: lv_company  TYPE RANGE OF i_journalentryitem-companycode,
          lv_customer TYPE RANGE OF i_journalentryitem-customer,
          lv_date     TYPE RANGE OF i_journalentryitem-postingdate.





    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOMER_AEGING_REPORT IMPLEMENTATION.


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
    DATA : sup(10) TYPE n.
    DATA : ls_amount TYPE ty_final.
    DATA : lv_total_amount TYPE  p DECIMALS 2 LENGTH 16.

    READ TABLE lt_filter_cond INTO DATA(companyfil) WITH KEY name = 'COMPANYCODE '.

    MOVE-CORRESPONDING companyfil-range TO lv_company.


    READ TABLE lt_filter_cond INTO DATA(posting) WITH KEY name = 'OPEN_ITEM_DATE'.
    MOVE-CORRESPONDING posting-range TO lv_date.
    DATA : lv_pdate TYPE sy-datum.
    READ TABLE lv_date INTO DATA(wa_post) INDEX 1.
    IF wa_post IS NOT INITIAL.
      REPLACE ALL OCCURRENCES OF '-' IN  wa_post WITH ''.
      lv_pdate = wa_post-low.
    ENDIF.

*   DATA : sup(10) TYPE n.
    READ TABLE lt_filter_cond INTO DATA(supfilter) WITH KEY name = 'CUSTOMER'.
    IF supfilter IS NOT INITIAL.
      DATA(lv_cust) = lv_customer.
*    loop at supfilter-range
      DATA(temp) = supfilter-range.
      DATA(high) = temp[ 1 ]-high.
      DATA(low)  = temp[ 1 ]-low.

      DATA temp1 TYPE n LENGTH 10 .
      DATA temp2 TYPE n LENGTH 10.

      temp1 = low.
      temp2 = high.

*      CONCATENATE '00000' low  INTO temp1.
*      CONCATENATE '00000' high  INTO temp2.

      " CONCATENATE '00000' low  into
      supfilter-range[ 1 ]-low = temp1.
      supfilter-range[ 1 ]-high = temp2.
      MOVE-CORRESPONDING supfilter-range TO lv_customer.

    ENDIF.
*    ENDIF.

    SELECT  a~customer,a~addressid, a~customername, b~companycode, b~amountintransactioncurrency, b~transactioncurrency,
     b~netduedate, b~accountingdocument, b~specialglcode, b~financialaccounttype, b~amountincompanycodecurrency,
    b~documentdate, b~invoicereference
    FROM  i_customer  AS a
    INNER JOIN i_operationalacctgdocitem AS b ON a~customer = b~customer
    WHERE a~customer <> '' AND a~customer IN @lv_customer AND
    b~companycode IN @lv_company AND b~specialglcode NE 'H'
    AND b~postingdate <= @lv_pdate
     AND b~financialaccounttype EQ 'D' AND ( b~invoicereference EQ 'V' OR b~invoicereference = ''  )
      AND ( b~clearingdate >  @lv_pdate OR b~clearingdate ='00000000' )
*     AND b~clearingjournalentry = ''

   INTO TABLE @DATA(lt_customer).


*   select from @lt_customer as it FIELDS * INTO table @data(it_cust).

    IF sy-subrc = 0.
    ENDIF.



    SELECT customer , accountingdocument , invoicereference, amountincompanycodecurrency
    FROM i_operationalacctgdocitem
    FOR ALL   ENTRIES IN @lt_customer WHERE invoicereference = @lt_customer-accountingdocument
    INTO TABLE @DATA(it_operational).


*    TYPES : BEGIN OF ty_temp,
*
*              customer           TYPE c LENGTH 30,
*              amount             TYPE  p DECIMALS 2 LENGTH 16,
*              amountincompanycodecurrency TYPE  p DECIMALS 2 LENGTH 16,
*
*            END OF ty_temp.
*
*            DATA : lt_temp TYPE TABLE OF ty_temp,
*                   wa_temp type ty_temp.
**
*    loop at lt_customer into DATA(wa_customer).
*     clear : wa_temp.
*       loop at it_operational into data(wa_operational) WHERE customer = wa_customer-customer.
*
*         endloop.
*         wa_temp-customer = wa_customer-Customer.
*         APPEND wa_temp to lt_temp.
*
*    endloop.







    SORT lt_customer BY customer ASCENDING.
    SELECT companycode, customer,accountingdocument, fiscalyear, amountincompanycodecurrency
    FROM i_operationalacctgdocitem
    FOR ALL ENTRIES IN @lt_customer
    WHERE customer IN @lv_customer AND postingdate <= @lv_pdate AND financialaccounttype EQ 'D' AND
    accountingdocumenttype <> 'DZ' AND  companycode IN @lv_company
    AND accountingdocument = @lt_customer-accountingdocument INTO TABLE @DATA(lt_total_billed).

    SORT lt_total_billed ASCENDING BY customer.
*
*    TYPES : BEGIN OF  ty_tempfinal1,
*              companycode TYPE c LENGTH 30,
*              customer    TYPE c LENGTH 30,
*              amount      TYPE  p DECIMALS 2 LENGTH 16,
*              accountingdocument     TYPE c LENGTH 30,
*            END OF ty_tempfinal1.
*
*    DATA : lt_tempfinal1 TYPE TABLE OF ty_tempfinal1,
*           wa_tempfinal1 TYPE  ty_tempfinal1.
*
*
*    DATA(lt_temp1) = lt_total_billed.
*    DELETE ADJACENT DUPLICATES FROM lt_temp1 COMPARING customer.
**    DATA: lv_total TYPE i_journalentryitem-amountincompanycodecurrency.
*
*    LOOP AT lt_temp1 INTO DATA(wa_lt_temp1).
*      CLEAR: wa_tempfinal1.
*
*      LOOP AT lt_total_billed INTO DATA(wa_total_billed) WHERE customer = wa_lt_temp1-customer.
*
*        wa_tempfinal1-amount = wa_tempfinal1-amount  +  wa_total_billed-amountincompanycodecurrency.
*
*      ENDLOOP.
*      wa_tempfinal1-customer = wa_lt_temp1-customer.
*      wa_tempfinal1-companycode = wa_lt_temp1-companycode.
*
*      APPEND wa_tempfinal1 TO lt_tempfinal1.
*
*    ENDLOOP.









    IF  lv_pdate+4(2) = '04'.
      DATA(lv_period) = '001'.
    ELSEIF lv_pdate+4(2) = '05'.
      lv_period = '002'.
    ELSEIF lv_pdate+4(2) = '06'.
      lv_period = '003'.
    ELSEIF lv_pdate+4(2) = '07'.
      lv_period = '004'.
    ELSEIF lv_pdate+4(2) = '08'.
      lv_period = '005'.
    ELSEIF lv_pdate+4(2) = '09'.
      lv_period = '006'.
    ELSEIF lv_pdate+4(2) = '10'.
      lv_period = '007'.
    ELSEIF lv_pdate+4(2) = '11'.
      lv_period = '008'.
    ELSEIF lv_pdate+4(2) = '12'.
      lv_period = '009'.
    ELSEIF lv_pdate+4(2) = '01'.
      lv_period = '010'.
    ELSEIF lv_pdate+4(2) = '02'.
      lv_period = '011'.
    ELSEIF lv_pdate+4(2) = '03'.
      lv_period = '012'.


    ENDIF.

    SELECT companycode, customer,fiscalyear,amountincompanycodecurrency, fiscalperiod,accountingdocument
    FROM i_operationalacctgdocitem
    FOR ALL ENTRIES IN @lt_customer
    WHERE customer IN @lv_customer AND postingdate <= @lv_pdate AND financialaccounttype EQ 'D' AND
    accountingdocumenttype <> 'DZ' AND  companycode IN @lv_company  AND accountingdocument = @lt_customer-accountingdocument
    AND fiscalperiod = @lv_period

    INTO TABLE @DATA(lt_total_month).
    SORT lt_total_month ASCENDING BY customer.





*    TYPES : BEGIN OF  ty_tempfinal2,
*
*              customer TYPE c LENGTH 30,
*              amount   TYPE  p DECIMALS 2 LENGTH 16,
*            END OF ty_tempfinal2.
*    DATA : lt_tempfinal2 TYPE TABLE OF ty_tempfinal2,
*           wa_tempfinal2 TYPE  ty_tempfinal2.
*
*    DATA(lt_temp2) = lt_total_month.
*    DELETE ADJACENT DUPLICATES FROM lt_temp2 COMPARING customer.
*    LOOP AT lt_temp2 INTO DATA(wa_lt_temp2).
*      CLEAR : wa_tempfinal2.
*      LOOP AT lt_total_month INTO DATA(wa_total_month)  WHERE customer = wa_lt_temp2-customer.
*
*        wa_tempfinal2-amount  =  wa_tempfinal2-amount + wa_total_month-amountincompanycodecurrency.
*
*      ENDLOOP.
*      wa_tempfinal2-customer = wa_lt_temp2-customer.
*
*      APPEND wa_tempfinal2 TO lt_tempfinal2.
*    ENDLOOP.


    SELECT companycode, customer,fiscalyear, amountincompanycodecurrency,invoicereference
    FROM i_operationalacctgdocitem
    FOR ALL ENTRIES IN @lt_customer
    WHERE customer IN @lv_customer AND clearingdate <= @lv_pdate AND financialaccounttype EQ 'D' AND
    accountingdocumenttype <> 'DZ' AND  companycode IN @lv_company AND invoicereference = @lt_customer-accountingdocument
     INTO TABLE @DATA(lt_credit_year).
    SORT lt_credit_year ASCENDING BY customer.



    SELECT companycode, customer,fiscalyear,amountincompanycodecurrency, fiscalperiod, invoicereference
     FROM i_operationalacctgdocitem
     FOR ALL ENTRIES IN @lt_customer
      WHERE customer IN @lv_customer AND clearingdate <= @lv_pdate AND financialaccounttype EQ 'D' AND
       accountingdocumenttype <> 'DZ' AND  companycode IN @lv_company
      AND fiscalperiod = @lv_period AND invoicereference = @lt_customer-accountingdocument

     INTO TABLE @DATA(lt_credit_month).
    SORT lt_credit_month ASCENDING BY customer.





    SELECT companycode, customer,fiscalyear, amountincompanycodecurrency,invoicereference
    FROM i_operationalacctgdocitem
    FOR ALL ENTRIES IN @lt_customer
    WHERE customer IN @lv_customer AND clearingdate <= @lv_pdate AND financialaccounttype EQ 'D' AND
    accountingdocumenttype = 'DZ' AND  companycode IN @lv_company AND invoicereference = @lt_customer-accountingdocument
     INTO TABLE @DATA(lt_collected_ytd).
    SORT lt_collected_ytd ASCENDING BY customer.


*    TYPES : BEGIN OF  ty_tempfinal1,
*
*              invoicereference TYPE c LENGTH 30,
*              amount           TYPE  p DECIMALS 2 LENGTH 16,
*
*            END OF ty_tempfinal1.
*    DATA : lt_tempfinal1 TYPE TABLE OF ty_tempfinal1,
*           wa_tempfinal1 TYPE  ty_tempfinal1.
*
*
    DATA :lv_total TYPE i_operationalacctgdocitem-amountincompanycodecurrency.
    DATA :   lv_sum TYPE i_operationalacctgdocitem-amountincompanycodecurrency.
    DATA: lv_col_month  TYPE      i_operationalacctgdocitem-amountincompanycodecurrency,
          lv_cred_year  TYPE i_operationalacctgdocitem-amountincompanycodecurrency,
          lv_cred_month TYPE i_operationalacctgdocitem-amountincompanycodecurrency.
*    DATA(lt_temp1) = lt_collected_ytd.



*    LOOP AT lt_temp1 INTO DATA(wa_lt_temp1).
*      CLEAR : wa_tempfinal1.
*      LOOP AT lt_collected_ytd INTO  DATA(wa_lt_collected_ytd) WHERE invoicereference =
*
*        lv_total = REDUCE #( INIT sum = 0
*                              FOR ls_data IN  lt_collected_ytd
*                              NEXT sum = sum + ls_data-amountincompanycodecurrency   ).
*        wa_tempfinal1-amount = lv_total.
*      ENDLOOP.
*      wa_tempfinal1-invoicereference = wa_lt_temp1-invoicereference.
*
*      APPEND wa_tempfinal1 TO lt_tempfinal1.
*    ENDLOOP.



*    TYPES : BEGIN OF  ty_tempfinal3,
*
*              customer TYPE c LENGTH 30,
*              amount   TYPE  p DECIMALS 2 LENGTH 16,
*            END OF ty_tempfinal3.
*    DATA : lt_tempfinal3 TYPE TABLE OF ty_tempfinal3,
*           wa_tempfinal3 TYPE  ty_tempfinal3.
*
*    DATA(lt_temp3) = lt_total_month.
*    DELETE ADJACENT DUPLICATES FROM lt_temp3 COMPARING customer.
*
*    LOOP AT lt_temp3 INTO DATA(wa_lt_temp3).
*      CLEAR:  wa_tempfinal3.
*      LOOP AT lt_collected_ytd INTO DATA(wa_collected_ytd) WHERE customer = wa_lt_temp3-customer.
*
*        wa_tempfinal3-amount =  wa_final3-collected_ytd + wa_collected_ytd-amountincompanycodecurrency.
*
*      ENDLOOP.
*      wa_tempfinal3-customer = wa_lt_temp3-customer.
*
*      APPEND wa_tempfinal3 TO lt_tempfinal3.
*    ENDLOOP.




    SELECT companycode, customer,fiscalyear,amountincompanycodecurrency, fiscalperiod, invoicereference
    FROM i_operationalacctgdocitem
    FOR ALL ENTRIES IN @lt_customer
     WHERE customer IN @lv_customer AND clearingdate <= @lv_pdate AND financialaccounttype EQ 'D' AND
      accountingdocumenttype = 'DZ' AND  companycode IN @lv_company
     AND fiscalperiod = @lv_period AND invoicereference = @lt_customer-accountingdocument

    INTO TABLE @DATA(lt_collected_month).
    SORT lt_collected_month ASCENDING BY customer.


*    TYPES : BEGIN OF  ty_tempfinal4,
*
*              customer TYPE c LENGTH 30,
*              amount   TYPE  p DECIMALS 2 LENGTH 16,
*            END OF ty_tempfinal4.
*    DATA : lt_tempfinal4 TYPE TABLE OF ty_tempfinal4,
*           wa_tempfinal4 TYPE  ty_tempfinal4.
*
*    DATA(lt_temp4) = lt_total_month.
*    DELETE ADJACENT DUPLICATES FROM lt_temp4 COMPARING customer.
*
*    LOOP AT lt_temp3 INTO DATA(wa_lt_temp4).
*
*      CLEAR : wa_tempfinal4.
*      LOOP AT lt_collected_month INTO DATA(wa_collected_month) WHERE customer = wa_lt_temp4-customer.
*
*        wa_tempfinal4-amount =  wa_tempfinal4-amount + wa_collected_month-amountincompanycodecurrency.
*      ENDLOOP.
*      wa_tempfinal4-customer = wa_lt_temp4-customer.
*
*      APPEND wa_tempfinal4 TO lt_tempfinal4.
*    ENDLOOP.


*    LOOP AT lt_tempfinal1 INTO wa_tempfinal1.
*      SHIFT wa_tempfinal1-customer LEFT DELETING LEADING '0'.
*      wa_final-customer = wa_tempfinal1-customer.
*      wa_final-totalbill_fy = wa_tempfinal1-amount.
*      wa_final-companycode = wa_tempfinal1-companycode.
*
*      READ TABLE lt_tempfinal2 INTO wa_tempfinal2  WITH KEY  customer = wa_tempfinal1-customer.
*      wa_final-billed_during_month =  wa_tempfinal2-amount.
*      READ TABLE lt_tempfinal3 INTO wa_tempfinal3  WITH KEY  customer = wa_tempfinal1-customer.
*      wa_final-collected_ytd = wa_tempfinal3-amount.
*      READ TABLE lt_tempfinal4 INTO wa_tempfinal4  WITH KEY  customer = wa_tempfinal1-customer.
*      wa_final-collected_month = wa_tempfinal4-amount.
*
*      APPEND :wa_final TO lt_final.
*      CLEAR : wa_final,wa_tempfinal1,wa_tempfinal2,wa_tempfinal3, wa_tempfinal4.
*
*    ENDLOOP.


    SELECT customer, specialglcode, isusedinpaymenttransaction,accountingdocument
    FROM i_operationalacctgdocitem
    WHERE financialaccounttype EQ 'D'  AND customer IN @lv_customer AND companycode IN @lv_company
    AND postingdate <= @lv_pdate AND ( clearingdate >  @lv_pdate OR clearingdate ='00000000 ' )
    AND (  specialglcode <> 'F' AND  specialglcode <> 'H')
    INTO TABLE @DATA(lt_op).
    SORT lt_op BY customer accountingdocument ASCENDING.
    IF sy-subrc = 0.

    ENDIF.

*    wa_final-companycode = wa_total_billed-companycode .
*    wa_final-customer = wa_total_billed-customer.
*
*    APPEND wa_final TO lt_final.
*    CLEAR : wa_final.




    SELECT addressid, roomnumber,phonenumber,mobilephonenumber
     FROM  i_bpcontacttoaddress
     FOR ALL ENTRIES IN @lt_customer
     WHERE addressid = @lt_customer-addressid
    INTO TABLE @DATA(lt_addressid).

    IF sy-subrc = 0.
    ENDIF.

    SELECT addressid,emailaddress
    FROM i_addressemailaddress_2
    FOR ALL ENTRIES IN @lt_customer
     WHERE addressid = @lt_customer-addressid
     INTO TABLE @DATA(lt_emailaddress).

    IF sy-subrc = 0.
    ENDIF.



    LOOP AT lt_customer INTO DATA(wa_customer).


      wa_final-companycode = wa_customer-companycode .
      SHIFT wa_customer-customer LEFT DELETING LEADING '0'.
      wa_final-customer = wa_customer-customer.
      wa_final-customername = wa_customer-customername.
      wa_final-accountingdocument = wa_customer-accountingdocument.
*      wa_final-amountintransactioncurrency =  .
*      wa_final-amountincompanycodecurrency =
      wa_final-transactioncurrency = wa_customer-transactioncurrency.
      wa_final-financialaccounttype = wa_customer-financialaccounttype.
      wa_final-netduedate = wa_customer-netduedate.
      wa_final-specialglcode = wa_customer-specialglcode.
*      Read table lt_credit_year into data(wa_credit_year)  WITH KEY invoicereference = wa_customer-accountingdocument.
*       IF sy-subrc = 0.
*      wa_final-credit_year = wa_credit_year-AmountInCompanyCodeCurrency.
*       ENDIF.
*      Read table lt_credit_month into data(wa_credit_month) WITH KEY invoicereference = wa_customer-accountingdocument.
*       IF sy-subrc = 0.
*      wa_final-credit_month = wa_credit_month-AmountInCompanyCodeCurrency.
*         ENDIF.
      lv_cred_year = REDUCE #( INIT sum = 0
                              FOR la_data IN  lt_credit_year WHERE ( invoicereference = wa_customer-accountingdocument )
                              NEXT sum = sum + la_data-amountincompanycodecurrency   ).
      wa_final-credit_year = lv_cred_year.

      lv_cred_month = REDUCE #( INIT sum = 0
                            FOR lb_data IN  lt_credit_month WHERE ( invoicereference = wa_customer-accountingdocument )
                            NEXT sum = sum + lb_data-amountincompanycodecurrency   ).
      wa_final-credit_month = lv_cred_month.


      READ TABLE lt_addressid  INTO DATA(wa_addressid) WITH KEY  addressid = wa_customer-addressid.

      wa_final-roomnumber = wa_addressid-roomnumber.
      wa_final-phonenumber = wa_addressid-phonenumber.

      wa_final-mobilephonenumber = wa_addressid-mobilephonenumber.

      READ TABLE lt_emailaddress INTO DATA(wa_emailaddress) WITH KEY addressid = wa_customer-addressid.

      wa_final-emailaddress = wa_emailaddress-emailaddress.

      READ TABLE lt_op INTO DATA(wa_op) WITH KEY accountingdocument = wa_customer-accountingdocument.

      READ TABLE lt_total_billed INTO DATA(wa_lt_total_billed) WITH KEY accountingdocument = wa_customer-accountingdocument.
      IF sy-subrc = 0.
        wa_final-totalbill_fy = wa_lt_total_billed-amountincompanycodecurrency.
      ENDIF.
      READ TABLE lt_total_month INTO DATA(wa_lt_total_month)  WITH KEY accountingdocument = wa_customer-accountingdocument.
      IF sy-subrc = 0.
        wa_final-billed_during_month = wa_lt_total_month-amountincompanycodecurrency.
      ENDIF.


      lv_total = REDUCE #( INIT sum = 0
                             FOR ls_data IN  lt_collected_ytd WHERE ( invoicereference = wa_customer-accountingdocument )
                             NEXT sum = sum + ls_data-amountincompanycodecurrency   ).
      wa_final-collected_ytd = lv_total.

*      READ TABLE lt_collected_month INTO DATA(wa_lt_collected_month) WITH KEY invoicereference = wa_customer-accountingdocument.
*      IF sy-subrc = 0.
*
*        wa_final-collected_month = wa_lt_collected_month-amountincompanycodecurrency.
*      ENDIF.
      lv_col_month = REDUCE #( INIT sum = 0
                            FOR lm_data IN  lt_collected_month WHERE ( invoicereference = wa_customer-accountingdocument )
                            NEXT sum = sum + lm_data-amountincompanycodecurrency   ).
      wa_final-collected_month = lv_col_month.




      READ TABLE it_operational INTO DATA(wa_operational)  WITH KEY invoicereference = wa_customer-accountingdocument.
      IF sy-subrc = 0.
        lv_sum = REDUCE #( INIT sum = 0
                               FOR lp_data IN  it_operational WHERE ( invoicereference = wa_customer-accountingdocument )
                               NEXT sum = sum + lp_data-amountincompanycodecurrency   ).
        wa_final-amountincompanycodecurrency = lv_sum + wa_customer-amountincompanycodecurrency.

      ELSE .
        wa_final-amountincompanycodecurrency = wa_customer-amountincompanycodecurrency.

      ENDIF.

*      due_net = wa_customer-netduedate.
*      REPLACE ALL OCCURRENCES OF '-' IN  due_net WITH ''.
*
*      days_diff = lv_pdate - due_net.

      due_net = wa_customer-documentdate.
      REPLACE ALL OCCURRENCES OF '-' IN  due_net WITH ''.

      days_diff = lv_pdate - due_net.



      IF days_diff LE 00 AND wa_customer-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.
        wa_final-days_00 = wa_final-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 0  AND 30 AND wa_customer-specialglcode = ''  AND wa_op-isusedinpaymenttransaction NE 'X'.
        wa_final-days_0_to_30  = wa_final-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 31 AND 60 AND wa_customer-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_31_to_60 = wa_final-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 61 AND 90 AND wa_customer-specialglcode = ''  AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_61_to_90 = wa_final-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 91 AND 180 AND wa_customer-specialglcode = ''  AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_91_to_180 = wa_final-amountincompanycodecurrency.

      ELSEIF days_diff >  180 AND wa_customer-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.
        wa_final-days_greater_180   = wa_final-amountincompanycodecurrency.

      ELSE.

        wa_final-specialglamount = wa_final-amountincompanycodecurrency.
      ENDIF.

*      READ TABLE it_operational INTO DATA(wa_operational)  WITH KEY invoicereference = wa_customer-accountingdocument.
*      IF sy-subrc = 0.
*        lv_sum = REDUCE #( INIT sum = 0
*                               FOR lp_data IN  it_operational WHERE ( invoicereference = wa_customer-accountingdocument )
*                               NEXT sum = sum + lp_data-amountincompanycodecurrency   ).
*        wa_final-amountincompanycodecurrency = lv_sum + wa_customer-amountincompanycodecurrency.
*
*      ELSE .
*        wa_final-amountincompanycodecurrency = wa_customer-amountincompanycodecurrency.
*
*      ENDIF.


      APPEND wa_final TO lt_final.
      CLEAR : days_diff,due_net, wa_final,lv_total,lv_sum,lv_col_month, lv_cred_year,lv_cred_month.




    ENDLOOP.

    LOOP AT lt_final INTO wa_final.

      ls_amount-amountincompanycodecurrency = ls_amount-amountincompanycodecurrency + wa_final-amountincompanycodecurrency.
      ls_amount-specialglamount =  ls_amount-specialglamount + wa_final-specialglamount.
      ls_amount-days_00 = ls_amount-days_00 + wa_final-days_00.
      ls_amount-days_0_to_30 = ls_amount-days_0_to_30 + wa_final-days_0_to_30.
      ls_amount-days_31_to_60 =  ls_amount-days_31_to_60  + wa_final-days_31_to_60.
      ls_amount-days_61_to_90 = ls_amount-days_61_to_90  + wa_final-days_61_to_90.
      ls_amount-days_91_to_180 = ls_amount-days_91_to_180 + wa_final-days_91_to_180.
      ls_amount-days_greater_180 = ls_amount-days_greater_180 + wa_final-days_greater_180.



    ENDLOOP.

    APPEND ls_amount TO lt_final.









    SELECT * FROM @lt_final AS it_final3                "#EC CI_NOWHERE
*     where totalbill_fy <> 0 or totalbill_fy <> '0'
           ORDER BY  customer DESCENDING

           INTO TABLE @DATA(it_fin)

           OFFSET @lv_skip UP TO  @lv_max_rows ROWS.


    SELECT COUNT( * )
        FROM @lt_final AS it_final3                     "#EC CI_NOWHERE
        INTO @DATA(lv_totcount1).


    io_response->set_total_number_of_records( lv_totcount1 ).
    io_response->set_data( it_fin ).








  ENDMETHOD.
ENDCLASS.

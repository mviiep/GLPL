CLASS zcl_customer_aeging DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_final,
              companycode                 TYPE c LENGTH 30,
              supplier                    TYPE c LENGTH 30,
              suppliername                TYPE c LENGTH 50,
              cityname                    TYPE c LENGTH 30,
              region                      TYPE c LENGTH 30,
              supplieraccountgroup        TYPE c LENGTH 30,
              accountingdoccreatedbyuser  TYPE c LENGTH 30,
              specialglcode               TYPE c LENGTH 30,
              postingdate                 TYPE dats,
              documentdate                TYPE dats,
              accountingdocumenttype      TYPE c LENGTH 30,
              transactioncurrency         TYPE c LENGTH 5,
              documentreferenceid         TYPE c LENGTH 30,
              accountingdocument          TYPE c LENGTH 30,
              fiscalyear                  TYPE c LENGTH 30,
              ledgergllineitem            TYPE c LENGTH 30,
*              profitcenter                TYPE c LENGTH 30,
*              profitcenterlongname        TYPE c LENGTH 30,
              documentitemtext            TYPE c LENGTH 30,
              purchasingdocument          TYPE c LENGTH 30,
              purchasingdocumentitem      TYPE c LENGTH 30,
              netduedate                  TYPE dats,
              paymentisblockedforsupplier TYPE c LENGTH 30,
              paymentterms                TYPE c LENGTH 30,
              amountincompanycodecurrency TYPE  p DECIMALS 2 LENGTH 16,
*              amountintransactioncurrency TYPE  p DECIMALS 2 LENGTH 16,
              days_00                     TYPE  p DECIMALS 2 LENGTH 16,
              days_0_to_30                TYPE  p DECIMALS 2 LENGTH 16,
              days_31_to_45               TYPE  p DECIMALS 2 LENGTH 16,
              days_46_to_60               TYPE  p DECIMALS 2 LENGTH 16,
              days_61_to_90               TYPE  p DECIMALS 2 LENGTH 16,
              days_91_to_100              TYPE  p DECIMALS 2 LENGTH 16,
              days_101_to_180             TYPE  p DECIMALS 2 LENGTH 16,
              days_greater_180            TYPE  p DECIMALS 2 LENGTH 16,
              specialglamount             TYPE  p DECIMALS 2 LENGTH 16,
              financialaccountype         TYPE c LENGTH 30,
*              total_companycode           TYPE  p DECIMALS 2 LENGTH 16,
            END OF ty_final.

    TYPES : BEGIN OF ty_final1,
              companycode                 TYPE c LENGTH 30,
              supplier                    TYPE c LENGTH 30,
              suppliername                TYPE c LENGTH 50,
              cityname                    TYPE c LENGTH 30,
              region                      TYPE c LENGTH 30,
              supplieraccountgroup        TYPE c LENGTH 30,
              accountingdoccreatedbyuser  TYPE c LENGTH 30,
              specialglcode               TYPE c LENGTH 30,
              postingdate                 TYPE dats,
              documentdate                TYPE dats,
              accountingdocumenttype      TYPE c LENGTH 30,
              transactioncurrency         TYPE c LENGTH 5,
              documentreferenceid         TYPE c LENGTH 30,
              accountingdocument          TYPE c LENGTH 30,
              fiscalyear                  TYPE c LENGTH 30,
              ledgergllineitem            TYPE c LENGTH 30,
              profitcenter                TYPE c LENGTH 30,
              profitcenterlongname        TYPE c LENGTH 30,
              documentitemtext            TYPE c LENGTH 30,
              purchasingdocument          TYPE c LENGTH 30,
              purchasingdocumentitem      TYPE c LENGTH 30,
              netduedate                  TYPE dats,
              paymentisblockedforsupplier TYPE c LENGTH 30,
              paymentterms                TYPE c LENGTH 30,
*              amountintransactioncurrency TYPE  p DECIMALS 2 LENGTH 16,
              amountincompanycodecurrency TYPE  p DECIMALS 2 LENGTH 16,
              days_00                     TYPE  p DECIMALS 2 LENGTH 16,
              days_0_to_30                TYPE  p DECIMALS 2 LENGTH 16,
              days_31_to_45               TYPE  p DECIMALS 2 LENGTH 16,
              days_46_to_60               TYPE  p DECIMALS 2 LENGTH 16,
              days_61_to_90               TYPE  p DECIMALS 2 LENGTH 16,
              days_91_to_100              TYPE  p DECIMALS 2 LENGTH 16,
              days_101_to_180             TYPE  p DECIMALS 2 LENGTH 16,
              days_greater_180            TYPE  p DECIMALS 2 LENGTH 16,
              specialglamount             TYPE  p DECIMALS 2 LENGTH 16,
*              total_companycode           TYPE  p DECIMALS 2 LENGTH 16,
            END OF ty_final1.




    DATA: lv_company  TYPE RANGE OF i_journalentryitem-companycode,
          lv_supplier TYPE RANGE OF i_supplier-supplier,
          lv_date     TYPE RANGE OF i_journalentryitem-postingdate.

    DATA :days_diff TYPE i,
          due_net   TYPE sy-datum.

    DATA : lt_final  TYPE STANDARD TABLE OF ty_final,
           wa_final  TYPE ty_final,
           it_final1 TYPE TABLE OF ty_final1,
           wa_final1 TYPE ty_final1,
           it_final3 TYPE TABLE OF ty_final1,
           wa_final3 TYPE ty_final1.



    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOMER_AEGING IMPLEMENTATION.


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


    DATA :  lv_data(30) TYPE c.
    READ TABLE lt_filter_cond INTO DATA(supfilter) WITH KEY name = 'SUPPLIER'.

    IF supfilter IS NOT INITIAL.
      DATA(temp) = supfilter-range.
      DATA(high) = temp[ 1 ]-high.
      DATA(low)  = temp[ 1 ]-low.
      DATA temp1 TYPE string.
      DATA temp2 TYPE string.
      CONCATENATE '00000' low  INTO temp1.
      CONCATENATE '00000' high  INTO temp2.

      " CONCATENATE '00000' low  into
      supfilter-range[ 1 ]-low = temp1.
      supfilter-range[ 1 ]-high = temp2.


      MOVE-CORRESPONDING supfilter-range TO lv_supplier.
    ENDIF.
*    LOOP at lv_supplier into data(wa_supplier).
*      data(high)=    wa_supplier-low




*    LOOP at supfilter into

*
*    IF lv_supplier IS NOT INITIAL.
*      DATA(lv_cust) = lv_supplier.
*      CLEAR : lv_supplier.
*      READ TABLE lv_cust INTO DATA(supp) INDEX '1'.
**
*      IF  supp IS NOT INITIAL.
*        sup =     supp-low .
*        sup =  supp-high.
**        supp-low = sup.
*        APPEND supp TO lv_supplier.
*      ENDIF.


*    ENDIF.

    READ TABLE lt_filter_cond INTO DATA(companyfil) WITH KEY name = 'COMPANYCODE '.
    MOVE-CORRESPONDING companyfil-range TO lv_company.


    READ TABLE lt_filter_cond INTO DATA(posting) WITH KEY name = 'OPEN_ITEM_DATE'.
    MOVE-CORRESPONDING posting-range TO lv_date.
    DATA : lv_pdate TYPE sy-datum.
    READ TABLE lv_date INTO DATA(wa_post) INDEX 1.
    IF wa_post IS NOT INITIAL.
*      REPLACE ALL OCCURRENCES OF '-' IN  due_net WITH ''.
      REPLACE ALL OCCURRENCES OF '-' IN  wa_post WITH ''.
      lv_pdate = wa_post-low.
*      IF  lv_pdate = 0.
*        lv_pdate = sy-datum.
*      ENDIF.
    ENDIF.


    SELECT a~supplier, a~suppliername, a~cityname, a~region, a~supplieraccountgroup, a~paymentisblockedforsupplier,
            b~companycode, b~accountingdoccreatedbyuser, b~specialglcode, b~postingdate, b~documentdate,
            b~accountingdocumenttype, b~transactioncurrency, b~accountingdocument,
            b~fiscalyear, b~ledgergllineitem, b~documentitemtext, b~netduedate, b~amountintransactioncurrency, b~financialaccounttype,
            b~amountincompanycodecurrency, b~purchasingdocument, b~purchasingdocumentitem, b~clearingdate
       FROM i_supplier AS a
       INNER JOIN i_journalentryitem AS b ON a~supplier = b~supplier
       WHERE a~supplier IN @lv_supplier AND b~companycode IN @lv_company
         AND a~supplier <> ''
         AND b~postingdate <= @lv_pdate AND ( specialglcode <> 'F' AND  specialglcode <> 'H')
         AND b~financialaccounttype EQ 'K'
         AND ( b~clearingdate >  @lv_pdate OR b~clearingdate ='00000000 ' )

*         AND b~clearingjournalentry = '' " EQ '00000000'
         AND b~ledger = '0L'

     INTO TABLE @DATA(lt_supplier).

    SORT lt_supplier BY supplier accountingdocument ASCENDING.
*    DELETE ADJACENT DUPLICATES FROM lt_supplier COMPARING supplier accountingdocument.

    IF sy-subrc = 0.

    ENDIF.


    SELECT supplier, specialglcode, isusedinpaymenttransaction,accountingdocument
    FROM i_operationalacctgdocitem
    WHERE financialaccounttype EQ 'K'  AND supplier IN @lv_supplier AND companycode IN @lv_company
    AND postingdate <= @lv_pdate AND ( clearingdate >  @lv_pdate OR clearingdate ='00000000 ' )
    AND (  specialglcode <> 'F' AND  specialglcode <> 'H')
    INTO TABLE @DATA(lt_op).
    SORT lt_op BY supplier accountingdocument ASCENDING.
    IF sy-subrc = 0.

    ENDIF.



*    SELECT accountingdocument, specialglcode, isusedinpaymenttransaction
*    FROM i_operationalacctgdocitem
*    FOR ALL ENTRIES IN @lt_supplier
*    WHERE accountingdocument  = @lt_supplier-accountingdocument
*    INTO TABLE @DATA(lt_paytransaction).


*    SELECT profitcenter,profitcenterlongname
*    FROM  i_profitcentertext
*    FOR ALL ENTRIES IN @lt_supplier
*    WHERE  profitcenter = @lt_supplier-profitcenter
*    INTO TABLE @DATA(lt_profit_data).
*
*    IF sy-subrc = 0.
*
*    ENDIF.

    SELECT supplier,paymentterms
    FROM i_suppliercompany
    FOR ALL ENTRIES IN @lt_supplier
    WHERE  supplier = @lt_supplier-supplier
    INTO TABLE @DATA(lt_paymenterms).
    IF sy-subrc = 0.

    ENDIF.



    SELECT accountingdocument,   documentreferenceid
    FROM i_journalentry
    FOR ALL ENTRIES IN @lt_supplier
    WHERE accountingdocument = @lt_supplier-accountingdocument
    INTO TABLE @DATA(lt_documentreference).
    IF sy-subrc = 0.

    ENDIF.



    LOOP AT lt_supplier INTO DATA(wa_supplier).


      wa_final-companycode = wa_supplier-companycode.
      SHIFT wa_supplier-supplier LEFT DELETING LEADING '0'.
      wa_final-supplier = wa_supplier-supplier.

      wa_final-suppliername = wa_supplier-suppliername.
      wa_final-cityname = wa_supplier-cityname.
      wa_final-region = wa_supplier-region.
      wa_final-supplieraccountgroup = wa_supplier-supplieraccountgroup.
      wa_final-paymentisblockedforsupplier = wa_supplier-paymentisblockedforsupplier.
      wa_final-suppliername = wa_supplier-suppliername.
      wa_final-accountingdoccreatedbyuser = wa_supplier-accountingdoccreatedbyuser.
      wa_final-specialglcode = wa_supplier-specialglcode.
      wa_final-postingdate = wa_supplier-postingdate.
      wa_final-documentdate = wa_supplier-documentdate.
      wa_final-accountingdocumenttype = wa_supplier-accountingdocumenttype.
      wa_final-transactioncurrency = wa_supplier-transactioncurrency.
      wa_final-accountingdocument = wa_supplier-accountingdocument.
      wa_final-fiscalyear = wa_supplier-fiscalyear.
      wa_final-ledgergllineitem = wa_supplier-ledgergllineitem.
*    wa_final-profitcenter = wa_supplier-profitcenter.
      wa_final-documentitemtext = wa_supplier-documentitemtext.
      wa_final-purchasingdocument = wa_supplier-purchasingdocument.
      wa_final-purchasingdocumentitem = wa_supplier-purchasingdocumentitem.
      wa_final-financialaccountype = wa_supplier-financialaccounttype.

*    READ TABLE lt_profit_data INTO DATA(wa_profitdata) WITH KEY profitcenter = wa_supplier-profitcenter.
*    wa_final-profitcenterlongname = wa_profitdata-profitcenterlongname.
      READ TABLE lt_documentreference INTO DATA(wa_documentreference) WITH KEY accountingdocument = wa_supplier-accountingdocument.
      wa_final-documentreferenceid = wa_documentreference-documentreferenceid.

      READ TABLE lt_paymenterms INTO DATA(wa_paymenterms) WITH KEY supplier = wa_supplier-supplier.
      wa_final-paymentterms = wa_paymenterms-paymentterms.

      READ TABLE lt_op INTO DATA(wa_op) WITH KEY accountingdocument = wa_supplier-accountingdocument.


      wa_final-netduedate =      wa_supplier-netduedate.

*      due_net = wa_final-netduedate.
*      REPLACE ALL OCCURRENCES OF '-' IN  due_net WITH ''.
*
*      DATA(lv_sydate) =  lv_pdate.
**      DATA(lv_sydate) =  wa_post.
*      REPLACE ALL OCCURRENCES OF '-' IN  lv_sydate WITH ''.
*
*      days_diff =  lv_pdate -  due_net.

      due_net = wa_final-documentdate.
      REPLACE ALL OCCURRENCES OF '-' IN due_net WITH ''.

      DATA(lv_sydate) =  lv_pdate.
*      DATA(lv_sydate) =  wa_post.
      REPLACE ALL OCCURRENCES OF '-' IN  lv_sydate WITH ''.

      days_diff =  lv_pdate -  due_net.




*        days_diff =  wa_post -  due_net.

      IF days_diff LE 00 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_00  =    wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 0 AND 30 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_0_to_30  =  wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 31 AND 45 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_31_to_45 =   wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 46 AND 60 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_46_to_60 =   wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 61 AND 90 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_61_to_90 =   wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 91 AND 100 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_91_to_100 =  wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff BETWEEN 101 AND 180 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_101_to_180 =  wa_supplier-amountincompanycodecurrency.

      ELSEIF days_diff > 180 AND wa_supplier-specialglcode = '' AND wa_op-isusedinpaymenttransaction NE 'X'.

        wa_final-days_greater_180 = wa_supplier-amountincompanycodecurrency.

      ELSE.

        wa_final-specialglamount = wa_supplier-amountincompanycodecurrency.

      ENDIF.

      wa_final-amountincompanycodecurrency = wa_supplier-amountincompanycodecurrency.
*      wa_final-total_companycode = 0 + wa_supplier-amountincompanycodecurrency.


      APPEND wa_final TO lt_final.

      CLEAR:  days_diff,lv_sydate, due_net, wa_final.
    ENDLOOP.




    LOOP AT lt_final INTO wa_final.

      ls_amount-amountincompanycodecurrency = ls_amount-amountincompanycodecurrency + wa_final-amountincompanycodecurrency.
      ls_amount-specialglamount =  ls_amount-specialglamount + wa_final-specialglamount.
      ls_amount-days_00 = ls_amount-days_00 + wa_final-days_00.
      ls_amount-days_0_to_30 = ls_amount-days_0_to_30 + wa_final-days_0_to_30.
      ls_amount-days_101_to_180 =  ls_amount-days_101_to_180  + wa_final-days_101_to_180.
      ls_amount-days_31_to_45 = ls_amount-days_31_to_45  + wa_final-days_31_to_45.
      ls_amount-days_46_to_60 = ls_amount-days_46_to_60 + wa_final-days_46_to_60.
      ls_amount-days_61_to_90 = ls_amount-days_61_to_90 + wa_final-days_61_to_90.
      ls_amount-days_91_to_100 = ls_amount-days_91_to_100 + wa_final-days_91_to_100.
      ls_amount-days_greater_180 = ls_amount-days_greater_180 + wa_final-days_greater_180.


    ENDLOOP.

    APPEND ls_amount TO lt_final.



    SELECT * FROM @lt_final AS it_final3                "#EC CI_NOWHERE
           ORDER BY supplier DESCENDING
           INTO TABLE @DATA(it_fin)
           OFFSET @lv_skip UP TO  @lv_max_rows ROWS.


    SELECT COUNT( * )
        FROM @lt_final AS it_final3                     "#EC CI_NOWHERE
        INTO @DATA(lv_totcount1).




    io_response->set_total_number_of_records( lv_totcount1 ) .
    io_response->set_data( it_fin ).




  ENDMETHOD.
ENDCLASS.

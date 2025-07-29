CLASS zcl_collectioncommitment DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_COLLECTIONCOMMITMENT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    TYPES: BEGIN OF it_stcdata,
             accountingdocument          TYPE i_journalentryitem-accountingdocument,
             companycode                 TYPE i_journalentryitem-companycode,
             fiscalyear                  TYPE i_journalentryitem-fiscalyear,
             documentdate                TYPE i_journalentryitem-documentdate,
             clearingdate                TYPE i_journalentryitem-clearingdate,
             customer                    TYPE i_journalentryitem-customer,

             amountincompanycodecurrency TYPE i_journalentryitem-amountincompanycodecurrency,
             companycodecurrency         TYPE i_journalentryitem-companycodecurrency,
             documentreferenceid         TYPE i_journalentry-documentreferenceid,
           END OF it_stcdata.

*           BEGIN OF stc_db_collection,
*             accountingdocument TYPE zcollectioncomnt-accountingdocument,
*             fiscalyear         TYPE zcollectioncomnt-fiscalyear,
*             companycode        TYPE zcollectioncomnt-companycode,
*           END OF stc_db_collection.
*    DATA: it_db_data TYPE STANDARD TABLE OF stc_db_collection.

    DATA: it_data TYPE STANDARD TABLE OF it_stcdata.
    DATA : lv_high TYPE c LENGTH 10.
    DATA : lv_low TYPE c LENGTH 10.
    DATA : lv_flag TYPE c LENGTH 1 VALUE '0'. "value '0'.
    DATA ls_week TYPE zweekstatus.


    DATA: lv_outstanding TYPE i_journalentryitem-amountincompanycodecurrency,
          ls_final       TYPE  zcollectioncommitment,
          it_final       TYPE TABLE OF zcollectioncommitment.
    DATA : it_db_collection TYPE TABLE OF zcollectioncomnt,
           ls_db_collection TYPE zcollectioncomnt.

    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE pag ).
    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
    DATA(lsort) = io_request->get_sort_elements( ) .
*    data(page) = io_request->
    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
    ENDTRY.

    DATA(lt_fields)  = io_request->get_requested_elements( ).
    DATA(lt_sort)    = io_request->get_sort_elements( ).

    DATA(set) = io_request->get_requested_elements( )."  --> could be used for optimizations
    DATA(lvs) = io_request->get_search_expression( ).
    DATA(filter1) = io_request->get_filter(  ).
    DATA(p1) = io_request->get_parameters(  ).
    DATA(p2) = io_request->get_requested_elements(  ).


    TRY.
        DATA(ran) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.               "#EC NO_HANDLER
        "handle exception
    ENDTRY.
    LOOP AT ran ASSIGNING FIELD-SYMBOL(<ls_ran>).
      CASE <ls_ran>-name.
        WHEN  'CUST_ID'.
          DATA(lv_customerid) = <ls_ran>-range.
        WHEN 'ACCOUNTINGNUMBER'.
          DATA(lv_accountingdocument) = <ls_ran>-range.

        WHEN 'WEEKSTATUS'.
          DATA(lv_weekstatus) = <ls_ran>-range.

*        WHEN 'CLEARING_DATE'.
*
*          DATA(lv_clearingdate) = <ls_ran>-range.

      ENDCASE.
    ENDLOOP.

*if lv_customerid is not INITIAL and lv_flag = '0'.
*    lv_low = lv_customerid[ 1 ]-low.
*    lv_high = lv_customerid[ 1 ]-high.
*    CONCATENATE '00000' lv_low INTO lv_low .
*    CONCATENATE '00000' lv_high INTO lv_high .
*
*    lv_customerid[ 1 ]-low = lv_low.
*    lv_customerid[ 1 ]-high = lv_high.
*    lv_flag = '1'.
*endif.

    "data it_data type zcollecti

    IF lv_customerid IS INITIAL.

      SELECT FROM i_journalentryitem AS i
       INNER JOIN i_journalentry AS h
       ON i~accountingdocument = h~accountingdocument
       AND i~fiscalyear = h~fiscalyear
       AND i~companycode = h~companycode
       FIELDS DISTINCT i~accountingdocument, i~companycode, i~fiscalyear, i~documentdate,i~clearingdate,i~customer, i~amountincompanycodecurrency,
      i~companycodecurrency,
       h~documentreferenceid
       WHERE i~ledger = '0L'
       AND i~financialaccounttype = 'D'
       AND i~accountingdocumenttype IN ( 'DR', 'RV', 'ZA', 'OP' )
     "  AND i~accountingdocument in @lv_customerid
     "  AND i~clearingdate IS INITIAL
       INTO  TABLE @it_data .

    ELSEIF lv_customerid IS NOT INITIAL.

      SELECT FROM i_journalentryitem AS i
       INNER JOIN i_journalentry AS h
       ON i~accountingdocument = h~accountingdocument
       AND i~fiscalyear = h~fiscalyear
       AND i~companycode = h~companycode
       FIELDS DISTINCT i~accountingdocument, i~companycode, i~fiscalyear, i~documentdate,i~clearingdate, i~customer," ltrim( i~customer , '0' ) ,
       i~amountincompanycodecurrency, i~companycodecurrency,
       h~documentreferenceid
       WHERE i~ledger = '0L'
       AND i~financialaccounttype = 'D'
       AND i~accountingdocumenttype IN ( 'DR', 'RV', 'ZA', 'OP' )
       AND   i~customer   IN  @lv_customerid
"       AND  ltrim( i~customer, '0' )   IN  @lv_customerid
   "    AND i~clearingdate IS INITIAL
       "and i~AccountingDocument in @lv_accountingdocument
       INTO  TABLE @it_data .

    ENDIF.

    IF sy-subrc = 0.

      SELECT FROM i_customer AS s INNER JOIN @it_data AS i
      ON ltrim( s~customer ,'0' ) = ltrim( i~customer, '0' )
      FIELDS DISTINCT  s~customer , s~customername
       INTO TABLE @DATA(it_customer).

    ENDIF.

    IF it_data[] IS NOT INITIAL.

      SELECT FROM i_journalentryitem AS i INNER JOIN @it_data AS id
      ON i~invoicereference = id~accountingdocument
      AND i~fiscalyear = id~fiscalyear
      AND i~companycode = id~companycode
      AND i~ledger = '0L'
      FIELDS DISTINCT i~amountincompanycodecurrency, i~fiscalyear, i~companycode, i~accountingdocument, i~invoicereference
      INTO TABLE @DATA(it_outstanding1).

      SELECT FROM zcollectioncomnt AS z INNER JOIN @it_data AS i
      ON z~accountingdocument = i~accountingdocument
      AND z~companycode = i~companycode
      AND z~fiscalyear = i~fiscalyear
      FIELDS DISTINCT  z~accountingdocument,z~companycode,z~fiscalyear, z~week1, z~week2,z~week3,z~week4,z~week5,z~week6,z~week7,z~week8,z~week9,z~week10,
  z~week11,z~week12,z~week13,z~week14,z~week15,z~week16,z~week17,z~week18,z~week19,z~week20,
  z~week21,z~week22,z~week23,z~week24,z~week25,z~week26,z~week27,z~week28,z~week29,z~week30,
  z~week31,z~week32,z~week33,z~week34,z~week35,z~week36,z~week37,z~week38,z~week39,z~week40,
  z~week41,z~week42,z~week43,z~week44,z~week45,z~week46,z~week47,z~week48,z~week49,z~week50,z~week51,z~week52
  WHERE z~accountingdocument IN @lv_accountingdocument

      INTO TABLE @DATA(it_collection).

      DATA(lv_week) = lv_weekstatus[ 1 ]-low.
*      select from zweekstatus FIELDS * where id = '1' into table @data(it_table).
*      it_table[ 1 ]-id = '1'.
*      it_table[ 1 ]-weekstatus = lv_week.
*      modify zweekstatus from table @it_table.
      SELECT FROM zweekstatus FIELDS * INTO TABLE @DATA(it_weekstatus).
      IF it_weekstatus IS INITIAL.
        ls_week-id = '1'.
        ls_week-weekstatus = lv_week.
        INSERT zweekstatus FROM @ls_week.
        CLEAR ls_week.
      ENDIF.

      UPDATE zweekstatus SET weekstatus = @lv_week WHERE id = '1'.



      LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>). " WHERE ( clearingdate IS INITIAL ).
        ls_final-accountingnumber = <ls_data>-accountingdocument.
        ls_final-clearing_date = <ls_data>-clearingdate.
        ls_final-companycodecurrency = <ls_data>-amountincompanycodecurrency.
        ls_final-cust_id = <ls_data>-customer.
        ls_final-companycode = <ls_data>-companycode.
        "  ls_final-accountingnumber = <ls_data>-accountingdocument.
        ls_final-fiscalyear = <ls_data>-fiscalyear.
        ls_final-invoice_number = <ls_data>-documentreferenceid.
        ls_final-invoiceamount = <ls_data>-amountincompanycodecurrency.
        ls_final-invoicedate = <ls_data>-documentdate.
        ls_final-cust_name = VALUE #( it_customer[ customer = <ls_data>-customer ]-customername OPTIONAL ).

        lv_outstanding = REDUCE #( INIT sum = 0
                                        FOR ls_outstanding1 IN it_outstanding1 WHERE ( invoicereference  = <ls_data>-accountingdocument
                                        AND companycode = <ls_data>-companycode AND fiscalyear = <ls_data>-fiscalyear  )
                                       NEXT  sum = sum + ls_outstanding1-amountincompanycodecurrency   ).
        lv_outstanding = lv_outstanding +  it_data[ accountingdocument = <ls_data>-accountingdocument
                                         companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear  ]-amountincompanycodecurrency.

        ls_final-outstanding_amt = lv_outstanding.
        ls_final-companycodecurrency = <ls_data>-companycodecurrency.
        ls_final-weekstatus = lv_week.
        ls_final-week1 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week1 OPTIONAL ).
        ls_final-week2 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week2 OPTIONAL ).
        ls_final-week3 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week3 OPTIONAL ).
        ls_final-week4 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week4 OPTIONAL ).
        ls_final-week5 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week5 OPTIONAL ).
        ls_final-week6 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week6 OPTIONAL ).
        ls_final-week7 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week7 OPTIONAL ).
        ls_final-week8 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week8 OPTIONAL ).
        ls_final-week9 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week9 OPTIONAL ).
        ls_final-week10 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week10 OPTIONAL ).
        ls_final-week11 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week11 OPTIONAL ).
        ls_final-week12 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week12 OPTIONAL ).
        ls_final-week13 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week13 OPTIONAL ).
        ls_final-week14 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week14 OPTIONAL ).
        ls_final-week15 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week15 OPTIONAL ).
        ls_final-week16 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week16 OPTIONAL ).
        ls_final-week17 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week17 OPTIONAL ).
        ls_final-week18 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week18 OPTIONAL ).
        ls_final-week19 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week19 OPTIONAL ).
        ls_final-week20 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week20 OPTIONAL ).
        ls_final-week21 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week21 OPTIONAL ).
        ls_final-week22 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week22 OPTIONAL ).
        ls_final-week23 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week23 OPTIONAL ).
        ls_final-week24 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week24 OPTIONAL ).
        ls_final-week25 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week25 OPTIONAL ).
        ls_final-week26 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week26 OPTIONAL ).
        ls_final-week27 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week27 OPTIONAL ).
        ls_final-week28 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week28 OPTIONAL ).
        ls_final-week29 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week29 OPTIONAL ).
        ls_final-week30 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week30 OPTIONAL ).
        ls_final-week31 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week31 OPTIONAL ).
        ls_final-week32 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week32 OPTIONAL ).
        ls_final-week33 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week33 OPTIONAL ).
        ls_final-week34 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week34 OPTIONAL ).
        ls_final-week35 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week35 OPTIONAL ).
        ls_final-week36 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week36 OPTIONAL ).
        ls_final-week37 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week37 OPTIONAL ).
        ls_final-week38 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week38 OPTIONAL ).
        ls_final-week39 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week39 OPTIONAL ).
        ls_final-week40 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week40 OPTIONAL ).
        ls_final-week41 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week41 OPTIONAL ).
        ls_final-week42 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week42 OPTIONAL ).
        ls_final-week43 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week43 OPTIONAL ).
        ls_final-week44 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week44 OPTIONAL ).
        ls_final-week45 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week45 OPTIONAL ).
        ls_final-week46 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week46 OPTIONAL ).
        ls_final-week47 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week47 OPTIONAL ).
        ls_final-week48 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week48 OPTIONAL ).
        ls_final-week49 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week49 OPTIONAL ).
        ls_final-week50 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week50 OPTIONAL ).
        ls_final-week51 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week51 OPTIONAL ).
        ls_final-week52 = VALUE #( it_collection[ accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode fiscalyear = <ls_data>-fiscalyear ]-week52 OPTIONAL ).



        APPEND ls_final TO it_final.
        CLEAR ls_final.
        CLEAR lv_outstanding.
      ENDLOOP.

      "   IF lv_customerid IS NOT INITIAL.
      SELECT FROM @it_data AS i
      LEFT OUTER JOIN  zcollectioncomnt AS z
      ON i~accountingdocument = z~accountingdocument
      AND i~companycode = z~companycode
      AND i~fiscalyear = z~fiscalyear
      FIELDS DISTINCT i~accountingdocument, i~fiscalyear, i~companycode
      INTO TABLE @DATA(it_db_data).

      IF sy-subrc = 0.
        SELECT FROM @it_data AS i
        INNER JOIN  zcollectioncomnt AS z
        ON i~accountingdocument = z~accountingdocument
        AND i~companycode = z~companycode
        AND i~fiscalyear = z~fiscalyear
        FIELDS DISTINCT i~accountingdocument ", i~fiscalyear, i~companycode
        INTO TABLE @DATA(it_db_data1).
      ENDIF.

      LOOP AT it_db_data1 ASSIGNING FIELD-SYMBOL(<ls_db>).
        DELETE it_db_data WHERE accountingdocument = <ls_db>-accountingdocument.
      ENDLOOP.

      it_db_collection = CORRESPONDING #( it_db_data ).

      IF it_db_data IS NOT INITIAL.
        "  MODIFY zcollectioncomnt FROM TABLE @it_db_collection.
        MODIFY zcollectioncomnt FROM TABLE @it_db_collection.

      ENDIF.


      "  ELSEIF lv_customerid IS NOT INITIAL.
*      select from zcollectioncomnt as z
*      inner join @it_data as i
*      on z~accountingdocument = i~accountingdocument
*      and z~companycode = i~companycode
*      and z~fiscalyear = i~fiscalyear
*      FIELDS DISTINCT z~accountingdocument, z~fiscalyear, z~companycode
*      WHERE
*      into TABLE @it_db_data.

      "  ENDIF.


*      IF it_db_data IS INITIAL.
*        LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_db_insertdata>).
*          ls_db_collection-accountingdocument = <ls_db_insertdata>-accountingdocument.
*          ls_db_collection-companycode = <ls_db_insertdata>-companycode.
*          ls_db_collection-fiscalyear = <ls_db_insertdata>-fiscalyear.
*          APPEND ls_db_collection TO it_db_collection.
*
*        ENDLOOP.
      "        MODIFY zcollectioncomnt FROM TABLE @it_db_collection.
*
*      ENDIF.
      IF lv_customerid IS INITIAL.

        SELECT DISTINCT * FROM @it_final AS it_final    "#EC CI_NOWHERE

                 ORDER BY accountingnumber

                 INTO TABLE @DATA(it_output)
                 OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

        SELECT COUNT( * )
            FROM @it_final AS it_final                  "#EC CI_NOWHERE
            INTO @DATA(lv_totcount).

        io_response->set_total_number_of_records( lv_totcount ).
        io_response->set_data( it_output ).

      ELSE.
        SELECT DISTINCT * FROM @it_final AS it_final    "#EC CI_NOWHERE
     WHERE  cust_id IN @lv_customerid AND weekstatus = @lv_week AND accountingnumber IN @lv_accountingdocument
                ORDER BY accountingnumber

                INTO TABLE @DATA(it_output1)
                OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

        SELECT COUNT( * )
            FROM @it_output1 AS it_final                "#EC CI_NOWHERE
            INTO @DATA(lv_totcount1).

        io_response->set_total_number_of_records( lv_totcount1 ).
        io_response->set_data( it_output1 ).

      ENDIF.



    ENDIF.





  ENDMETHOD.
ENDCLASS.

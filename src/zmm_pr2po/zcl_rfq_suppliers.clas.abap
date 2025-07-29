CLASS zcl_rfq_suppliers DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:BEGIN OF ty_final,
            requestforquotation TYPE i_rfqbidder_api01-requestforquotation,
            rec_counter         TYPE zi_rfq_suppliermailid-rec_counter,
            supplier            TYPE i_supplier-supplier,
            "            supplier1            TYPE i_supplier-supplier,
            suppliername        TYPE i_supplier-suppliername,
            mail1               TYPE zi_rfq_suppliermailid-mail1,
            mail2               TYPE zi_rfq_suppliermailid-mail1,
            mail3               TYPE zi_rfq_suppliermailid-mail1,
            cc1                 TYPE zi_rfq_suppliermailid-mail1,
            cc2                 TYPE zi_rfq_suppliermailid-mail1,
            cc3                 TYPE zi_rfq_suppliermailid-mail1,
            cc4                 TYPE zi_rfq_suppliermailid-mail1,
            cc5                 TYPE zi_rfq_suppliermailid-mail1,
            mail_sentflag       TYPE zi_rfq_suppliermailid-mailsent_flag,
            reminder_flg1       TYPE zi_rfq_suppliermailid-reminder_flg1,
            reminder_flg2       TYPE zi_rfq_suppliermailid-reminder_flg2,
            unreg_flag          type ZI_RFQ_SupplierMailID-unreg_flag,
*            originaldate        TYPE zi_rfq_suppliermailid-originaldate,
          END OF ty_final.

    DATA:it_final TYPE STANDARD TABLE OF ty_final,
         wa_final TYPE ty_final.

    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_SUPPLIERS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
" Local variables
data: lv_cntr type n LENGTH 2.
*    select * from zirfq_suppmail
*            where requestforquotation = '7000000113'
*            into table @data(lt_temp).
*     loop at lt_temp ASSIGNING FIELD-SYMBOL(<ftemp>).
*        <ftemp>-mail_sentflag = ''.
*     endloop.
*    modify zirfq_suppmail from table @lt_temp.

    IF io_request->is_data_requested( ).

      DATA(off) = io_request->get_paging( )->get_offset( ).
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

      DATA(lv_where_clause) = io_request->get_filter( )->get_as_sql_string( ).

      DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
      ENDTRY.
    ENDIF.

    IF lv_where_clause IS NOT INITIAL.

" Check if records are already saved then it will be update
*        delete from zirfq_suppmail where Requestforquotation = '7000000092'.

        SELECT *
        FROM zi_rfq_suppliermailid
        WHERE (lv_where_clause)
        INTO TABLE @it_final.

     REPLACE all OCCURRENCES OF   'REQUESTFORQUOTATION' IN lv_where_clause WITH 'bidders~REQUESTFORQUOTATION'.
     REPLACE all OCCURRENCES OF   'REC_COUNTER' IN lv_where_clause WITH 'mailid~REC_COUNTER'.

     if it_final is INITIAL.
*          CONCATENATE 'bidders~' lv_where_clause INTO lv_where_clause.
          SELECT     FROM i_rfqbidder_api01 AS bidders
          LEFT OUTER JOIN  i_supplier            AS supplier ON  bidders~supplier = supplier~supplier
          LEFT OUTER JOIN zi_rfq_suppliermailid AS mailid   ON  bidders~requestforquotation = mailid~requestforquotation
                                                            AND bidders~supplier    = mailid~supplier
*          LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS _emailaddress ON _emailaddress~addressid = supplier~addressid
          FIELDS
                  bidders~requestforquotation,
                  mailid~rec_counter,
                  bidders~supplier,
                  supplier~suppliername,
                  mailid~mail1,
*                  _emailaddress~EmailAddress as mail1,
                  mailid~mail2,
                  mailid~mail3,
                  mailid~cc1,
                  mailid~cc2,
                  mailid~cc3,
                  mailid~cc4,
                  mailid~cc5,
                  mailid~mailsent_flag,
                  mailid~reminder_flg1,
                  mailid~reminder_flg2
*                  mailid~unreg_flag
*                  mailid~originaldate
           WHERE (lv_where_clause)
           ORDER BY bidders~requestforquotation,bidders~supplier
          INTO TABLE @it_final
          OFFSET @off UP TO @lv_max_rows  ROWS.

        if it_final is not INITIAL.
           data(it_final_temp) = it_final.
           delete it_final_temp where supplier is INITIAL.

* For multiple email ids
           select from i_supplier AS a
                      LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS b ON b~addressid = a~addressid
            FIELDS
                a~Supplier,
                b~EmailAddress
            FOR ALL ENTRIES IN @it_final
            WHERE a~Supplier    = @it_final-supplier
            into table @data(lt_emailid).
            sort lt_emailid by supplier.
        endif.

" Update sequence
        lv_cntr = 0.
        LOOP AT it_final ASSIGNING FIELD-SYMBOL(<f1>).
            lv_cntr = lv_cntr + 1.
            <f1>-rec_counter = lv_cntr.

            data(lv_idx) = 0.
            loop AT lt_emailid INTO data(lwa_emailid) where supplier = <f1>-supplier.
               lv_idx = lv_idx + 1.
               case lv_idx.
                when 1. <f1>-mail1 = lwa_emailid-EmailAddress.
                when 2. <f1>-mail2 = lwa_emailid-EmailAddress.
                when 3. <f1>-mail3 = lwa_emailid-EmailAddress.

                when 4. <f1>-cc1 = lwa_emailid-EmailAddress.
                when 5. <f1>-cc2 = lwa_emailid-EmailAddress.
                when 6. <f1>-cc3 = lwa_emailid-EmailAddress.
                when 7. <f1>-cc4 = lwa_emailid-EmailAddress.
                when 8. <f1>-cc5 = lwa_emailid-EmailAddress.
               ENDCASE.
            ENDLOOP.
            lv_idx = 0.
        ENDLOOP.
      else.
*          CONCATENATE 'bidders~' lv_where_clause INTO lv_where_clause.
          SELECT     FROM i_rfqbidder_api01 AS bidders
          LEFT OUTER JOIN  i_supplier            AS supplier ON  bidders~supplier = supplier~supplier
          LEFT OUTER JOIN zi_rfq_suppliermailid AS mailid   ON  bidders~requestforquotation = mailid~requestforquotation
                                                            AND bidders~supplier    = mailid~supplier
*          LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS _emailaddress ON _emailaddress~addressid = supplier~addressid
          FIELDS
                  bidders~requestforquotation,
                  mailid~rec_counter,
                  bidders~supplier,
                  supplier~suppliername,
                  mailid~mail1,
*                  _emailaddress~EmailAddress as mail1,
                  mailid~mail2,
                  mailid~mail3,
                  mailid~cc1,
                  mailid~cc2,
                  mailid~cc3,
                  mailid~cc4,
                  mailid~cc5,
                  mailid~mailsent_flag,
                  mailid~reminder_flg1,
                  mailid~reminder_flg2
*                  mailid~unreg_flag
*                  mailid~originaldate
           WHERE (lv_where_clause)
           ORDER BY bidders~requestforquotation,bidders~supplier
          INTO TABLE @data(it_finaltemp)
          OFFSET @off UP TO @lv_max_rows  ROWS.

          sort it_finaltemp by RequestForQuotation rec_counter supplier.

          data(lt_temp2) = it_final.
          loop at it_final INTO data(wa_final).
*            data(wa_finaltemp) = value #( it_finaltemp[ RequestForQuotation = wa_final-requestforquotation
*                                                        rec_counter         = wa_final-rec_counter
*                                                        Supplier            = wa_final-supplier ] OPTIONAL ).
            delete it_finaltemp where  RequestForQuotation = wa_final-requestforquotation
                                  and  rec_counter         = wa_final-rec_counter
                                  and  Supplier            = wa_final-supplier.
            delete lt_emailid where supplier = wa_final-supplier.
* from temp2
            delete lt_temp2 where  RequestForQuotation = wa_final-requestforquotation
                              and  rec_counter         = wa_final-rec_counter
                              and  Supplier            = wa_final-supplier.

          ENDLOOP.

* For multiple email ids
        if lt_temp2 is not INITIAL.
           select from i_supplier AS a
                      LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS b ON b~addressid = a~addressid
            FIELDS
                a~Supplier,
                b~EmailAddress
            FOR ALL ENTRIES IN @lt_temp2
            WHERE a~Supplier    = @lt_temp2-supplier
            into table @lt_emailid.
            sort lt_emailid by supplier.
        endif.

          if it_finaltemp is not INITIAL.
            lv_cntr = lines( it_final ).
            if lv_cntr < 5.
                loop at it_finaltemp  into data(wa_finaltemp).
                    lv_cntr = lv_cntr + 1.
                   wa_finaltemp-rec_counter = lv_cntr.
                   lv_idx = 0.
                    loop AT lt_emailid INTO lwa_emailid where supplier = wa_finaltemp-supplier.
                       lv_idx = lv_idx + 1.
                       case lv_idx.
                        when 1. wa_finaltemp-mail1 = lwa_emailid-EmailAddress.
                        when 2. wa_finaltemp-mail2 = lwa_emailid-EmailAddress.
                        when 3. wa_finaltemp-mail3 = lwa_emailid-EmailAddress.

                        when 4. wa_finaltemp-cc1 = lwa_emailid-EmailAddress.
                        when 5. wa_finaltemp-cc2 = lwa_emailid-EmailAddress.
                        when 6. wa_finaltemp-cc3 = lwa_emailid-EmailAddress.
                        when 7. wa_finaltemp-cc4 = lwa_emailid-EmailAddress.
                        when 8. wa_finaltemp-cc5 = lwa_emailid-EmailAddress.
                       ENDCASE.
                    ENDLOOP.
                    lv_idx = 0.
                    if lv_cntr <= 5.
                        append wa_finaltemp to it_final.
                    endif.
                ENDLOOP.
            endif.
          endif.

      endif.

    else.
*        data(lt_temp) = it_final.
*        sort lt_temp by supplier.
*        delete lt_temp where supplier = '0000000000'.
*        delete lt_temp where supplier is INITIAL.
*
*        select from zi_rfq_suppliermailid as a
*        LEFT OUTER JOIN  i_supplier            AS b ON  b~supplier = a~supplier
*        LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS c ON c~addressid = b~addressid
*        FIELDS
*        a~Supplier,
*        c~EmailAddress
*        for ALL ENTRIES IN @lt_temp
*        where a~Supplier = @lt_temp-supplier
*        into table @data(it_emailid).
*        sort it_emailid by supplier.
*
*        loop at it_final ASSIGNING FIELD-SYMBOL(<f2>).
*            <f2>-mail1 = VALUE #( it_emailid[ Supplier = <f2>-supplier ]-EmailAddress OPTIONAL ).
*        ENDLOOP.
    ENDIF.

    SORT it_final BY requestforquotation rec_counter.
    DELETE ADJACENT DUPLICATES FROM it_final COMPARING requestforquotation rec_counter.

*    SELECT DISTINCT *
*    FROM @it_final AS it ##ITAB_DB_SELECT
*     ORDER BY requestforquotation,supplier
*     INTO TABLE @DATA(it_fin)                           "#EC CI_NOWHERE
*     OFFSET @off UP TO @lv_max_rows  ROWS.

*    SELECT COUNT( * )
*    FROM @it_final AS it ##ITAB_DB_SELECT
*    INTO  @DATA(lv_child_lines) .                       "#EC CI_NOWHERE
    data(lv_rcount) = lines( it_final ).
    data lv_child_lines type int8.
         lv_child_lines = lv_rcount.

    io_response->set_total_number_of_records( iv_total_number_of_records = lv_child_lines ).
    "    io_response->set_data( it_fin ).

    io_response->set_data( it_final ).

  ENDMETHOD.
ENDCLASS.

CLASS zcl_rfq_logs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_rap_query_provider.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_LOGS IMPLEMENTATION.


    METHOD if_rap_query_provider~select.
" Local variables declaration
     DATA: lv_rows          TYPE int8,
           lv_Rec_Count     type int8,
           it_rfqlogs       type standard table of ztb_rfq_logs.

     IF io_request->is_data_requested( ).
      DATA(off) = io_request->get_paging( )->get_offset(  ).
      DATA(pag) = io_request->get_paging( )->get_page_size( ).
      DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                  ELSE pag ).
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
      DATA(it_filter1) = io_request->get_filter(  ).

* SQL query
        data(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).

"* Read Parameters from URI
      DATA(It_params) = io_request->get_parameters(  ).
      DATA(it_rqelements) = io_request->get_requested_elements(  ).

      DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
      ENDTRY.
      if lv_sql_filter is not INITIAL.
        select * from ztb_rfq_logs
            Where (lv_sql_filter)
            into table @it_rfqlogs.
      ENDIF.
     ENDIF.

data: it_rfqlog3 type standard table of ztb_rfq_logs.
    select * from @it_rfqlogs as it_rfqlog3             "#ITAB_KEY_IN_SELECT
            order by requestforquotation, recordcounter ASCENDING
               INTO TABLE @DATA(it_rfqfin)
           OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

    select count( * )
        from @it_rfqlogs as it_rfqlogs3              "#EC CI_NOWHERE
            into @data(lv_rcount).
*    SELECT * FROM @lt_final AS it_final3                "#EC CI_NOWHERE
*           ORDER BY supplier ASCENDING
*           INTO TABLE @DATA(it_fin)
*           OFFSET @lv_skip UP TO  @lv_max_rows ROWS.
*    SELECT COUNT( * )
*        FROM @lt_final AS it_final3                     "#EC CI_NOWHERE
*        INTO @DATA(lv_totcount1).
*" Get record count from internal table
*   lv_Rec_Count = lines( it_rfqlogs ).


    io_response->set_total_number_of_records( iv_total_number_of_records = lv_RCount ).
    io_response->set_data( it_rfqfin ).
    ENDMETHOD.
ENDCLASS.

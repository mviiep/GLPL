CLASS zcl_test2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST2 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA : it_test TYPE TABLE OF ztest2,
           ls_test_collection TYPE ztest2.

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
*    LOOP AT ran ASSIGNING FIELD-SYMBOL(<ls_ran>).
*      CASE <ls_ran>-name.
*        WHEN  'CUST_ID'.
*          DATA(lv_customerid) = <ls_ran>-range.
*        WHEN 'ACCOUNTINGNUMBER'.
*          DATA(lv_accountingdocument) = <ls_ran>-range.
*
*        WHEN 'WEEKSTATUS'.
*          DATA(lv_weekstatus) = <ls_ran>-range.
*
**        WHEN 'CLEARING_DATE'.
**
**          DATA(lv_clearingdate) = <ls_ran>-range.
*
*      ENDCASE.
*    ENDLOOP.

it_test = value #( ( cust_id = '001'
                     weekstatus = 'Monday'
                     accountingnumber = '456'        )
                     ( cust_id = '002'
                     weekstatus = 'Tuesday'
                     accountingnumber = '456456'        ) ).


        io_response->set_total_number_of_records( 1000 ).
        io_response->set_data( it_test ).


  ENDMETHOD.
ENDCLASS.

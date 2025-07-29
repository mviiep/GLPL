CLASS zcl_sales1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES1 IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
   DATA : lv_high TYPE c LENGTH 10.
    DATA : lv_low TYPE c LENGTH 10.
    DATA : lv_flag TYPE c LENGTH 1 VALUE '0'. "value '0'.
    DATA ls_week TYPE zweekstatus.


    DATA: lv_outstanding TYPE i_journalentryitem-amountincompanycodecurrency,
          ls_final       TYPE  zsales1,
          it_final       TYPE TABLE OF zsales1.
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

    it_final = VALUE #( ( sales = '001'
                          loc = '222'                   ) ).

    io_response->set_total_number_of_records( 10 ).
    io_response->set_data( it_final ).
  ENDMETHOD.
ENDCLASS.

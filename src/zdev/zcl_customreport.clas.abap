CLASS zcl_customreport DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CUSTOMREPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
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
        WHEN  'PURCHASEORDER'.
          DATA(lv_purchaseorder) = <ls_ran>-range.
        WHEN 'PURCHASEORDERITEM'.
          DATA(lv_purchaseorderitem) = <ls_ran>-range.
      ENDCASE.
    ENDLOOP.

    DATA : it_final TYPE TABLE OF zcollectionreport.
    DATA : ls_final TYPE  zcollectionreport.
    SELECT FROM I_PurchaseOrderItemAPI01
      FIELDS PurchaseOrder, PurchaseOrderItem, CompanyCode, Customer
      where PurchaseOrder in @lv_purchaseorder
    and PurchaseOrderItem in @lv_purchaseorderitem
    INTO TABLE @DATA(it_purchase).

*    select  from  zcollectionrpt FIELDS * WHERE purchaseorder in @lv_purchaseorder and purchaseorderitem in @lv_purchaseorderitem
*    into table @data(it_data).



*    SELECT FROM I_PurchaseOrderItemAPI01 AS s inner JOIN zcollectionrpt as z
*    on s~PurchaseOrder = z~purchaseorder
*    and s~PurchaseOrderItem = z~purchaseorderitem
*      FIELDS s~PurchaseOrder, s~PurchaseOrderItem, s~CompanyCode, s~Customer, z~week1, z~week2, z~week3, z~week4, z~week5, z~week6, z~week7
*    WHERE s~PurchaseOrder IN @lv_purchaseorder
*    and s~PurchaseOrderItem in @lv_purchaseorderitem
*    INTO TABLE @DATA(it_purchase1).

*loop at it_purchase ASSIGNING FIELD-SYMBOL(<ls_final>).
*ls_final-PurchaseOrder = <ls_final>-PurchaseOrder.
*ls_final-PurchaseOrderitem = <ls_final>-PurchaseOrderItem.
*ls_final-CompanyCode = <ls_final>-CompanyCode.
*ls_final-Customer = <ls_final>-Customer.
*
*read table it_data ASSIGNING FIELD-SYMBOL(<ls_data>) WITH KEY  purchaseorder = <ls_final>-PurchaseOrder purchaseorderitem = <ls_final>-PurchaseOrderItem.
*IF <ls_data> IS ASSIGNED.
*ls_final-week1 = <ls_data>-week1.
*ls_final-week2 = <ls_data>-week2.
*ls_final-week3 = <ls_data>-week3.
*ls_final-week4 = <ls_data>-week4.
*ls_final-week5 = <ls_data>-week5.
*ls_final-week6 = <ls_data>-week6.
*ls_final-week7 = <ls_data>-week7.
*ls_final-weekstatus = <ls_data>-weekstatus.
*ENDIF.
*append ls_final TO it_final.
*endloop.

   it_final = CORRESPONDING #( it_purchase ).

    IF lv_purchaseorder IS NOT INITIAL.



*      io_response->set_total_number_of_records( 1 ).
*      io_response->set_data( it_final ).

              SELECT DISTINCT * FROM @it_final AS it_final      "#EC CI_NOWHERE

               ORDER BY PurchaseOrder

               INTO TABLE @DATA(it_output)
               OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

      SELECT COUNT( * )
          FROM @it_final AS it_final                    "#EC CI_NOWHERE
          INTO @DATA(lv_totcount).

      io_response->set_total_number_of_records( lv_totcount ).
      io_response->set_data( it_output ).



    ELSE.
              SELECT DISTINCT * FROM @it_final AS it_final      "#EC CI_NOWHERE
   WHERE PurchaseOrderitem IN @lv_purchaseorderitem
              ORDER BY PurchaseOrder

              INTO TABLE @DATA(it_output1)
              OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

      SELECT COUNT( * )
          FROM @it_output1 AS it_final                  "#EC CI_NOWHERE
          INTO @DATA(lv_totcount1).

      io_response->set_total_number_of_records( lv_totcount1 ).
      io_response->set_data( it_output1 ).



*      io_response->set_total_number_of_records( 1000 ).
*      io_response->set_data( it_final ).
    ENDIF.




  ENDMETHOD.
ENDCLASS.

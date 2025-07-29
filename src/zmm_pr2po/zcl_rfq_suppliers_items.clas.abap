CLASS zcl_rfq_suppliers_items DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      TYPES:BEGIN OF ty_final,
            RFQNumber       TYPE ztb_rfqsuplrritm-rfq_number,
            RFQItem         TYPE ztb_rfqsuplrritm-rfq_item,
            supplier_code1  type ztb_rfqsuplrritm-supplier_code1,
            item_rate1      type ztb_rfqsuplrritm-item_rate1,
            currency_code   type ztb_rfqsuplrritm-currency_code,
          END OF ty_final,
          tty_final type STANDARD TABLE OF ty_final.

    DATA:it_final TYPE tty_final,
         wa_final TYPE ty_final.

    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_SUPPLIERS_ITEMS IMPLEMENTATION.


 METHOD if_rap_query_provider~select.
"Types declarations
types: Begin of ty_supplier_tot,
        rec_counter     type ztb_rfqsuplrritm-rec_counter,
        supplier_code1  type ztb_rfqsuplrritm-supplier_code1,
        item_rate1      type ztb_rfqsuplrritm-item_rate1,
        sort_order      type i,
        suppliername    type ZI_RFQ_Suppliersitms-suppliername1,
       end   of ty_supplier_tot,
       tty_supplier_tot type STANDARD TABLE OF ty_supplier_tot,

       begin of ty_levelSupplier,

        supplier_code1  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code2  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code3  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code4  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code5  type ztb_rfqsuplrritm-supplier_code1,
       end   of TY_LEVELSUPPLIER.

DATA: lv_rows       TYPE int8,
      lt_sup_tot    type tty_supplier_tot,
      wa_sup_tot    type ty_supplier_tot.

   data: it_ItemData    type standard table of zstr_rfq_supplieritem,
          wa_ItemData    type zstr_rfq_supplieritem ,
          lv_Rec_Count  type int8,
          lv_RFQNumber  type ebeln,
          lv_cntr       type i.
" Data declarations END

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
    eNDIF.

"* Comments goes here; Get parameters if passed
     loop at it_params into data(wa_params) WHERE parameter_name = 'REQUESTFORQUOTATION'.
        lv_RFQNumber = wa_params-value.
     ENDLOOP.

* Get filters if applied
   if lv_sql_filter is not INITIAL.
   else.
   "* tEMP CODE - Starts
   if  lv_RFQNumber is initial.
     lv_RFQNumber = '7000000001'.
    CONCATENATE ' RequestForQuotation = ' '''7000000001''' INTO lv_sql_filter.
   endif.
"* tEMP CODE - Ends
   endif.


"* Read RFQ/PR details
   select from I_RfqItem_Api01 as a
    left OUTER join I_PurchaseRequisitionItemAPI01 as b on
                                               a~PurchaseRequisition = b~PurchaseRequisition
                                           and a~PurchaseRequisitionItem = b~PurchaseRequisitionItem
   FIELDS
    a~RequestForQuotation,
    a~RequestForQuotationItem,
    b~Material,
    b~PurchaseRequisitionItemText,
    b~BaseUnit,
    b~RequestedQuantity,
    b~YY1_TargetRate_PRI

    Where (lv_sql_filter)
    into TABLE @DATA(it_RFQdt).

    if it_RFQDT is not INITIAL.
        sort it_RFQDt by RequestForQuotation RequestForQuotationItem.

"* Read data from custom table for supplier rate for individual records
     select from ztb_rfqsuplrritm as a
     FIELDS
     a~rfq_number       as RFQ_Number,
     a~rfq_item         as RFQ_Item,
     a~rec_counter      as rec_counter,
     a~supplier_code1   as Supplier_code1,
     a~item_rate1       as item_rate1

     FOR ALL ENTRIES IN @it_RFQDT
      where a~rfq_number = @it_RFQDT-RequestForQuotation
     into TABLE @data(it_suplritm).

* Read record counter/supplier code from email table
    if it_suplritm is not INITIAL.
        select * from zirfq_suppmail                        "#EC CI_ALL_FIELDS_NEEDED
                 for ALL ENTRIES IN @it_suplritm
                 WHERE requestforquotation = @it_suplritm-rfq_number
                 INTO TABLE @DATA(it_supmail).
       sort it_supmail by requestforquotation rec_counter.
       delete ADJACENT DUPLICATES FROM it_supmail COMPARING requestforquotation rec_counter.
    endif.

" Get totals for sorting based on value
        clear: lt_sup_tot, wa_sup_tot.
        LOOP AT it_suplritm INTO data(wa_supitem).
            MOVE-CORRESPONDING wa_supitem to wa_sup_tot.
            wa_sup_tot-suppliername = VALUE #( it_supmail[ requestforquotation = wa_supitem-rfq_number
                                                           rec_counter         = wa_supitem-rec_counter ]-suppliername OPTIONAL ).
            COLLECT wa_sup_tot INTO lt_sup_tot.
        endloop.

" Update sequence
        sort lt_sup_tot by item_rate1.
        lv_Cntr = 0.
        loop at lt_sup_tot ASSIGNING FIELD-SYMBOL(<f2>).
            lv_cntr = lv_cntr + 1.
            <f2>-sort_order = lv_cntr.
        endloop.
        sort lt_sup_tot by rec_counter.
    endif.

"* Data Massaging to display in the required format
   LOOP at it_RFQDt into data(wa_RFQDt).

"* Move header data
    wa_ItemData-requestforquotation = wa_RFQDt-RequestForQuotation.
    wa_ItemData-rfq_item         = wa_RFQDt-RequestForQuotationItem.
    wa_ItemData-material         = wa_RFQDt-Material.
    wa_ItemData-material_text    = wa_RFQDt-PurchaseRequisitionItemText.
    wa_ItemData-baseunit         = wa_RFQDt-BaseUnit.
    wa_ItemData-requestedqty     = Wa_RFQDt-RequestedQuantity.
    wa_ItemData-target_rate      = wa_RFQDT-YY1_TargetRate_PRI.
    wa_ItemData-target_value     = wa_ItemData-requestedqty * wa_RFQDT-YY1_TargetRate_PRI.

* Get supplier wise rate
    lv_Cntr = 0.
    LOOP at it_suplritm into wa_supitem where rfq_number = wa_RFQDt-RequestForQuotation
                                          and rfq_item   = wa_RFQDt-RequestForQuotationItem.
    clear: wa_sup_tot.
"        lv_cntr = VALUE #( lt_sup_tot[ supplier_code1 = wa_supitem-supplier_code1 ]-sort_order OPTIONAL ).
        wa_sup_tot = VALUE #( lt_sup_tot[ rec_counter = wa_supitem-rec_counter ] OPTIONAL ).
        lv_cntr         = wa_sup_tot-sort_order.
        data(lv_sname)  = wa_sup_tot-suppliername.
"
        case lv_cntr.
            when 1.
                wa_ItemData-supplier_code1   = wa_supitem-supplier_code1.
                wa_ItemData-item_rate1       = wa_supitem-item_rate1.
                wa_ItemData-basic_value1     = wa_ItemData-requestedqty * wa_supitem-item_rate1.
                wa_ItemData-suppliername1    = lv_sname.
            when 2.
                wa_ItemData-supplier_code2   = wa_supitem-supplier_code1.
                wa_ItemData-item_rate2       = wa_supitem-item_rate1.
                wa_ItemData-basic_value2     = wa_ItemData-requestedqty * wa_supitem-item_rate1.
                wa_ItemData-suppliername2 = lv_sname.

            when 3.
                wa_ItemData-supplier_code3   = wa_supitem-supplier_code1.
                wa_ItemData-item_rate3       = wa_supitem-item_rate1.
                wa_ItemData-basic_value3     = wa_ItemData-requestedqty * wa_supitem-item_rate1.
                wa_ItemData-suppliername3 = lv_sname.
            when 4.
                wa_ItemData-supplier_code4   = wa_supitem-supplier_code1.
                wa_ItemData-item_rate4       = wa_supitem-item_rate1.
                wa_ItemData-basic_value4     = wa_ItemData-requestedqty * wa_supitem-item_rate1.
                wa_ItemData-suppliername4 = lv_sname.
            when 5.
                wa_ItemData-supplier_code5   = wa_supitem-supplier_code1.
                wa_ItemData-item_rate5       = wa_supitem-item_rate1.
                wa_ItemData-basic_value5     = wa_ItemData-requestedqty * wa_supitem-item_rate1.
                wa_ItemData-suppliername5 = lv_sname.
        ENDCASE.
        clear: lv_cntr, lv_sname,wa_sup_tot.
    ENDLOOP.

    append wa_ItemData to it_ItemData.
    clear: wa_ItemData.
   ENDLOOP.

data: it_itemdata3 type standard table of zstr_rfq_supplieritem.
    select * from @it_ItemData as it_it_ItemData3             "#EC CI_NOWHERE
            order by requestforquotation, rfq_item ASCENDING
               INTO TABLE @DATA(it_itemdatafin)
           OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

    select count( * ) from @it_ItemData as it_itemdata3
            into @data(lv_rcount).

*" Get record count from internal table
*    lv_Rec_Count = lines( it_ItemData ).

    io_response->set_total_number_of_records( iv_total_number_of_records = lv_rcount ).
    io_response->set_data( it_itemdatafin ).

 ENDMETHOD.
ENDCLASS.

CLASS zcl_rfq_supsummary DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_SUPSUMMARY IMPLEMENTATION.


 METHOD if_rap_query_provider~select.

 types: begin of ty_header,
        RequestForQuotation type ztb_rfqsuplrritm-rfq_number,
        CreationDate        type datum,
        supplier_code1  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code2  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code3  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code4  type ztb_rfqsuplrritm-supplier_code1,
        supplier_code5  type ztb_rfqsuplrritm-supplier_code1,
        aprl_flg1      type ztb_rfqsuplrritm-apprl_flag,
        aprl_flg2      type ztb_rfqsuplrritm-apprl_flag,
        aprl_flg3      type ztb_rfqsuplrritm-apprl_flag,
        aprl_flg4      type ztb_rfqsuplrritm-apprl_flag,
        aprl_flg5      type ztb_rfqsuplrritm-apprl_flag,
        ProfitCenter        type I_ProfitCenter-ProfitCenter,
        AddressName         type I_ProfitCenter-AddressName,
        StreetAddressName   type I_ProfitCenter-StreetAddressName,
        CityName            type I_ProfitCenter-CityName,
        PostalCode          type I_ProfitCenter-PostalCode,
        District            type I_ProfitCenter-District,
        suppliername1       type zstr_rfq_supplieritem-suppliername1,
        suppliername2       type zstr_rfq_supplieritem-suppliername2,
        suppliername3       type zstr_rfq_supplieritem-suppliername3,
        suppliername4       type zstr_rfq_supplieritem-suppliername4,
        suppliername5       type zstr_rfq_supplieritem-suppliername5,
        comp_comments       type zirfq_suppmail-comp_comments,
        unreg_flag1         type zirfq_suppmail-unreg_flag,
        unreg_flag2         type zirfq_suppmail-unreg_flag,
        unreg_flag3         type zirfq_suppmail-unreg_flag,
        unreg_flag4         type zirfq_suppmail-unreg_flag,
        unreg_flag5         type zirfq_suppmail-unreg_flag,
        rfq_description     type ZI_RFQ_SupSummary-RFQ_description,
       end   of ty_header,
       tty_header type STANDARD TABLE OF ty_header.

" Local variables declaration
 DATA: lv_rows          TYPE int8,
       lv_cntr          type i,
       lv_Rec_Count     type int8,
       it_header        type tty_header,
       wa_header        type ty_header.


 IF io_request->is_data_requested( ).

 data: lv_rfqtemp type ebeln.
*     lv_rfqtemp = '0000000000'.
*     select * from ztb_rfqsuplrritm
*               where rfq_number = @lv_rfqtemp
*               INTO table @DATA(it_temp).
*      if it_temp is not INITIAL.
*        loop at it_temp ASSIGNING FIELD-SYMBOL(<f10>).
*            clear <f10>-apprl_flag.
*        ENDLOOP.
*        modify ztb_rfqsuplrritm from table @it_temp.
*      endif.
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

" Read entries
      if lv_sql_filter is not INITIAL.
      replace 'REQUESTFORQUOTATION' in lv_sql_filter with 'a~REQUESTFORQUOTATION'.

"* Read RFQ/PR details
       select from I_RfqItem_Api01 as a
        left OUTER join I_PurchaseRequisitionItemAPI01 as b on
                                                   a~PurchaseRequisition = b~PurchaseRequisition
                                               and a~PurchaseRequisitionItem = b~PurchaseRequisitionItem
        LEFT OUTER JOIN  ztb_rfqsuplrritm AS c on
                                                  c~rfq_number = a~requestforquotation
                                              and c~rfq_item   = a~requestforquotationItem
        left OUTER JOIN I_PurReqnAcctAssgmtAPI01 as d on
                                                    d~PurchaseRequisition   = a~PurchaseRequisition
                                                and d~PurchaseRequisitionItem = a~PurchaseRequisitionItem
                                                and d~PurchaseReqnAcctAssgmtNumber = '01'
       FIELDS
        a~RequestForQuotation,
        a~\_RequestForQuotation-CreationDate as CreationDate,
"        c~supplier_code1,
        c~rec_counter,
        c~apprl_flag,
        sum( b~RequestedQuantity * c~item_rate1 ) as BaseValue,
        a~\_RequestForQuotation-CompanyCode as CompanyCode,
        d~ProfitCenter as ProfitCenter,
        a~\_RequestForQuotation-RequestForQuotationName as rfq_description

        Where (lv_sql_filter)
        GROUP BY a~RequestForQuotation, a~\_RequestForQuotation-CreationDate,
*                 c~supplier_code1,
                 c~rec_counter,
                 d~ProfitCenter,  a~\_RequestForQuotation-CompanyCode, c~apprl_flag,
                 a~\_RequestForQuotation-RequestForQuotationName
        into TABLE @DATA(it_RFQdt).

" Read Profit center Address Starts
        if it_RFQdt is not INITIAL.
"            select from I_ProfitCenterForCompanyCode as a
            data(lv_system_date) = cl_abap_context_info=>get_system_date( ).
            select from I_ProfitCenter as a
                FIELDS
                a~ProfitCenter,
                a~AddressName,
                a~StreetAddressName,
                a~CityName,
                a~PostalCode,
                a~District

                FOR ALL ENTRIES IN @it_RFQdt
                WHERE a~ProfitCenter    = @it_RFQdt-profitcenter
*                  and a~ValidityEndDate   >= @sy-datum
                  and a~ValidityEndDate   >= @lv_system_date
                  INTO TABLE @data(it_PrctrAddr).
           sort it_PrctrAddr by ProfitCenter.

"* Read data from custom table for supplier rate for individual records
             select from ztb_rfqsuplrritm as a
                    left OUTER JOIN zirfq_suppmail as b on b~requestforquotation = a~rfq_number
                                                       and b~rec_counter         = a~rec_counter
             FIELDS
             a~rfq_number       as requestforquotation,
             a~rec_counter      as rec_counter,
             a~supplier_code1   as supplier_code1,

             b~suppliername     as suppliername1,
             b~suppliername     as nameupper,
             b~comp_comments    as comp_comments,
             b~unreg_flag       as unreg_flag
             FOR ALL ENTRIES IN @it_RFQDT
              where a~rfq_number = @it_RFQDT-RequestForQuotation
             into TABLE @data(it_suplritm).

             sort it_suplritm by requestforquotation rec_counter.
             delete ADJACENT DUPLICATES FROM it_suplritm COMPARING requestforquotation rec_counter.

             loop at it_suplritm ASSIGNING FIELD-SYMBOL(<f1>).
                <f1>-nameupper = to_upper( <f1>-nameupper ).
             ENDLOOP.
         endif.
" Read Profit center Address Ends

       sort it_rfqdt by RequestforQuotation BaseValue.

        lv_Cntr = 0.
        loop at it_rfqdt ASSIGNING FIELD-SYMBOL(<f2>).

            data(wa_prctr) = VALUE #( it_PrctrAddr[ ProfitCenter = <f2>-profitcenter ] OPTIONAL ).
            Move-CORRESPONDING wa_prctr to Wa_header.
            wa_Header-profitcenter = <f2>-profitcenter.

            wa_header-requestforquotation = <f2>-RequestForQuotation.
            wa_header-creationdate        = <f2>-CreationDate.
            data(wa_supitem) = VALUE #( it_suplritm[ requestforquotation = <f2>-RequestForQuotation
                                                     rec_counter         = <f2>-rec_counter ] OPTIONAL ).
            lv_cntr = lv_cntr + 1.

            case lv_cntr.
            when 1. wa_header-supplier_code1 = wa_supitem-supplier_code1.
                    wa_header-aprl_flg1      = <f2>-apprl_flag.
                    wa_header-suppliername1  = wa_supitem-suppliername1.
                    wa_header-unreg_flag1    = wa_supitem-unreg_flag.
            when 2. wa_header-supplier_code2 = wa_supitem-supplier_code1.
                    wa_header-aprl_flg2      = <f2>-apprl_flag.
                    wa_header-suppliername2  = wa_supitem-suppliername1.
                    wa_header-unreg_flag2    = wa_supitem-unreg_flag.
            when 3. wa_header-supplier_code3 = wa_supitem-supplier_code1.
                    wa_header-aprl_flg3      = <f2>-apprl_flag.
                    wa_header-suppliername3  = wa_supitem-suppliername1.
                    wa_header-unreg_flag3    = wa_supitem-unreg_flag.
            when 4. wa_header-supplier_code4 = wa_supitem-supplier_code1.
                    wa_header-aprl_flg4      = <f2>-apprl_flag.
                    wa_header-suppliername4  = wa_supitem-suppliername1.
                    wa_header-unreg_flag4    = wa_supitem-unreg_flag.
            when 5. wa_header-supplier_code5 = wa_supitem-supplier_code1.
                    wa_header-aprl_flg5      = <f2>-apprl_flag.
                    wa_header-suppliername5  = wa_supitem-suppliername1.
                    wa_header-unreg_flag5    = wa_supitem-unreg_flag.
            ENDCASE.
            wa_header-comp_comments = wa_supitem-comp_comments.
            clear: wa_supitem.
        endloop.
        wa_header-rfq_description = <f2>-rfq_description.
        if lv_cntr > 0.
            append wa_header to it_header.
        endif.

      endif.
    ENDIF.

*" Get record count from internal table
    lv_Rec_Count = lines( it_header ).

    io_response->set_total_number_of_records( iv_total_number_of_records = lv_Rec_Count ).
    io_response->set_data( it_header ).
 ENDMETHOD.
ENDCLASS.

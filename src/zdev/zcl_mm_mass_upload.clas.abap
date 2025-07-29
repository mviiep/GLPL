CLASS zcl_mm_mass_upload DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA it_set_cookie TYPE if_web_http_request=>cookies.

    TYPES:BEGIN OF ty_header,
            _payment_terms TYPE zi_po_mass_upload-paymentterms, "Payment Terms
          END OF ty_header.

    TYPES:BEGIN OF ty_accassign,
            _cost_center        TYPE zi_po_mass_upload-costcenter, "Cost Center
            _master_fixed_asset TYPE zi_po_mass_upload-masterfixedasset, "Master Fixed Asset
          END OF ty_accassign.

    TYPES:BEGIN OF ty_item,
            _order_quantity               TYPE zi_po_mass_upload-orderquantity, "Order Quantity
            _purchase_order_quantity_unit TYPE zi_po_mass_upload-purchaseorderquantityunit, "Unit of Measurement
            _net_price_amount             TYPE zi_po_mass_upload-netpriceamount, "Net Price
            _document_currency            TYPE zi_po_mass_upload-documentcurrency, "Currency
            _tax_code                     TYPE zi_po_mass_upload-taxcode, "TaxCode
            _is_completely_delivered      TYPE string,
          END OF ty_item.

    TYPES:BEGIN OF ty_schedule,

            _performance_period_start_date TYPE string, "Performance Start Date
            _performance_period_end_date   TYPE string, "Performance End Date
            _schedule_line_delivery_date   TYPE zi_po_mass_upload-schedulelinedeliverydate,
          END OF ty_schedule.

    DATA: wa_item                    TYPE ty_item,
          wa_header                  TYPE ty_header,
          wa_accassign               TYPE ty_accassign,
          wa_schedule                TYPE ty_schedule,
          lv_purchaseorder           TYPE zi_po_mass_upload-purchaseorder,
          lv_purchaseorderitem       TYPE zi_po_mass_upload-purchaseorderitem,
          lv_accountassignmentnumber TYPE zi_po_mass_upload-accountassignmentnumber,
          lv_purchaseorderschedule   TYPE zi_po_mass_upload-purchaseorderscheduleline.

    DATA:
      lv_access_token TYPE string,
      lv_dev(3)       TYPE c VALUE 'N7O',
      lv_qas(3)       TYPE c VALUE 'M2S',
      lv_prd(3)       TYPE c VALUE 'KSZ',
      lv_csrf_token   TYPE string,
      lv_set_cookie   TYPE string.

    INTERFACES if_http_service_extension.

    TYPES:BEGIN OF ty_token,
            token  TYPE string,
            cookie TYPE string,
          END OF ty_token.

    TYPES:BEGIN OF ty_response,
            code   TYPE i,
            reason TYPE string,
            text   TYPE string,
          END OF ty_response.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_token | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_token RETURNING VALUE(r_token) TYPE ty_token.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_MASS_UPLOAD IMPLEMENTATION.


  METHOD get_token.
*
    CASE sy-sysid.
      WHEN lv_dev.
        DATA(lo_url) = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaseorder }/{ lv_purchaseorderitem }|.
      WHEN lv_qas.
        lo_url = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaseorder }/{ lv_purchaseorderitem }|.
      WHEN lv_prd.
        lo_url = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaseorder }/{ lv_purchaseorderitem }|.
    ENDCASE.


* Read credentials
    SELECT SINGLE *
      FROM zi_cs_id
          WHERE systemid = @sy-mandt
          INTO @DATA(wa_idpass).

    TRY.
        DATA(lo_http_token) = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    " To fetch x-csrf-token
    DATA(lo_request_token) = lo_http_token->get_http_request( ).
    lo_request_token->set_header_fields(  VALUE #(
*                                             ( name = 'Cookie'  value = 'sap-XSRF_N7O_100=31O5V5TiqSpYjZHZ-LAIFg%3d%3d20250104123918vWr1npCAdlmH5e8h5PVX_ep0jOsvCxALXHGQNJo-3tc%3d; sap-usercontext=sap-client=100' )
                                             ( name = 'x-csrf-token'  value = 'fetch' )
                                             ( name = 'Accept' value = '*/*' )
                                            )
                                 ).

    lo_request_token->set_authorization_basic(
                       EXPORTING
                         i_username = wa_idpass-username
                         i_password = wa_idpass-password
                     ).

    TRY.
        DATA(lo_response) = lo_http_token->execute(
                            i_method  = if_web_http_client=>get ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

    lv_csrf_token = lo_response->get_header_field( EXPORTING i_name = 'x-csrf-token' ).

    TRY.
        lo_response->get_cookies(
          RECEIVING
            r_value = it_set_cookie
        ).
      CATCH cx_web_message_error.                       "#EC NO_HANDLER
    ENDTRY.


**********************************************************************




  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.
**********************************************************************
    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string.


**********************************************************************

    lv_request_uri         = request->get_header_field( i_name = '~request_uri' ).
    lv_request_method      = request->get_header_field( i_name = '~request_method' ).
    lv_content_type        = request->get_header_field( i_name = 'content-type' ).

    lv_req_body = request->get_text( ).


    IF lv_req_body IS NOT INITIAL.
      REPLACE ALL OCCURRENCES OF PCRE '[^[:print:]]' IN lv_req_body WITH space.
      REPLACE ALL OCCURRENCES OF PCRE '#' IN lv_req_body WITH space.
      CONDENSE lv_req_body.
    ENDIF.

    DATA(lt_params) = request->get_form_fields( ).
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'purchaseorder'.
    lv_purchaseorder = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'purchaseorderitem'.
    lv_purchaseorderitem = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'accountassignmentnumber'.
    lv_accountassignmentnumber = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'purchaseorderscheduleline'.
    lv_purchaseorderschedule = ls_params-value.

    IF lv_request_method = 'PATCH'.

**********************************************************************
***For Item data
**********************************************************************

      /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                  CHANGING data = wa_item ).

      CASE sy-sysid.
        WHEN lv_dev.
          DATA(lo_url_item)      = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaseorder }/{ lv_purchaseorderitem }|.
          DATA(lo_url_header)    = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/{ lv_purchaseorder }|.
          DATA(lo_url_accassign) = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderAccountAssignment/{ lv_purchaseorder }/{ lv_purchaseorderitem }/{ lv_accountassignmentnumber }|.
          DATA(lo_url_schedule)  = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderScheduleLine/{ lv_purchaseorder }/{ lv_purchaseorderitem }/{ lv_purchaseorderschedule }|.
        WHEN lv_qas.
          lo_url_item      = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaseorder }/{ lv_purchaseorderitem }|.
          lo_url_header    = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/{ lv_purchaseorder }|.
          lo_url_accassign = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderAccountAssignment/{ lv_purchaseorder }/{ lv_purchaseorderitem }/{ lv_accountassignmentnumber }|.
          lo_url_schedule  = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderScheduleLine/{ lv_purchaseorder }/{ lv_purchaseorderitem }/{ lv_purchaseorderschedule }|.
        WHEN lv_prd.
          lo_url_item      = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaseorder }/{ lv_purchaseorderitem }|.
          lo_url_header    = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/{ lv_purchaseorder }|.
          lo_url_accassign = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderAccountAssignment/{ lv_purchaseorder }/{ lv_purchaseorderitem }/{ lv_accountassignmentnumber }|.
          lo_url_schedule  = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderScheduleLine/{ lv_purchaseorder }/{ lv_purchaseorderitem }/{ lv_purchaseorderschedule }|.
      ENDCASE.


* Read credentials
      SELECT SINGLE *
      FROM zi_cs_id
      WHERE systemid = @sy-mandt
      INTO @DATA(wa_idpass).

      TRY.
          DATA(lo_http_client_item) = cl_web_http_client_manager=>create_by_http_destination(
                                  i_destination = cl_http_destination_provider=>create_by_url( lo_url_item ) ).

        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.


      DATA(csrf_token) = me->get_token( ).

      DATA(lo_request_item) = lo_http_client_item->get_http_request( ).
      lo_request_item->set_header_fields(  VALUE #(
                                               ( name = 'Content-Type'  value = 'application/json' )
                                               ( name = 'x-csrf-token'  value = lv_csrf_token )
                                               ( name = 'Accept'        value = '*/*' )
                                              )
                                   ).


      LOOP AT it_set_cookie INTO DATA(wa_set_cookie).
        TRY.
            lo_request_item->set_cookie(
              EXPORTING
                i_name    = wa_set_cookie-name
                i_value   = wa_set_cookie-value
            ).
          CATCH cx_web_message_error.                   "#EC NO_HANDLER
        ENDTRY.
      ENDLOOP.

      lo_request_item->set_authorization_basic(
                         EXPORTING
                           i_username = wa_idpass-username
                           i_password = wa_idpass-password
                       ).

      DATA:item_json TYPE string.
      /ui2/cl_json=>serialize( EXPORTING  data        = wa_item
                                          pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                               RECEIVING  r_json      = item_json ).

*      REPLACE ALL OCCURRENCES OF '""' IN item_json WITH 'null'.
      REPLACE ALL OCCURRENCES OF '"true"' IN item_json WITH 'true'.
      REPLACE ALL OCCURRENCES OF '"false"' IN item_json WITH 'false'.

      lo_request_item->append_text(
            EXPORTING
              data   = item_json
          ).

      TRY.
          DATA(lo_response_item) = lo_http_client_item->execute(
                              i_method  = if_web_http_client=>patch ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.

      DATA(lv_status_item) = lo_response_item->get_status( ).
      DATA(lv_json_response_item) = lo_response_item->get_text( ).

      IF lv_status_item-code = 200.
      ELSE.
        TRY.
            response->set_status(
              EXPORTING
                i_code   = lv_status_item-code
                i_reason = lv_status_item-reason
            ).
          CATCH cx_web_message_error.
        ENDTRY.

        response->set_text( lv_json_response_item ).

        CHECK lv_status_item-code = 200.
      ENDIF.


**********************************************************************
***for Header Data
**********************************************************************

      /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                  CHANGING data = wa_header ).


      IF wa_header-_payment_terms IS NOT INITIAL.
        TRY.
            DATA(lo_http_client_header) = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = cl_http_destination_provider=>create_by_url( lo_url_header ) ).

          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.


        DATA(lo_request_header) = lo_http_client_header->get_http_request( ).
        lo_request_header->set_header_fields(  VALUE #(
                                                 ( name = 'Content-Type'  value = 'application/json' )
                                                 ( name = 'x-csrf-token'  value = lv_csrf_token )
                                                 ( name = 'Accept'        value = '*/*' )
                                                )
                                     ).

        LOOP AT it_set_cookie INTO wa_set_cookie.
          TRY.
              lo_request_header->set_cookie(
                EXPORTING
                  i_name    = wa_set_cookie-name
                  i_value   = wa_set_cookie-value
              ).
            CATCH cx_web_message_error.                 "#EC NO_HANDLER
          ENDTRY.
        ENDLOOP.

        lo_request_header->set_authorization_basic(
                           EXPORTING
                             i_username = wa_idpass-username
                             i_password = wa_idpass-password
                         ).

        DATA:header_json TYPE string.
        /ui2/cl_json=>serialize( EXPORTING  data        = wa_header
                                            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 RECEIVING  r_json      = header_json ).

        REPLACE ALL OCCURRENCES OF '""' IN header_json WITH 'null'.

        lo_request_header->append_text(
              EXPORTING
                data   = header_json
            ).

        TRY.
            DATA(lo_response_header) = lo_http_client_header->execute(
                                i_method  = if_web_http_client=>patch ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

        DATA(lv_status_header) = lo_response_header->get_status( ).
        DATA(lv_json_response_header) = lo_response_header->get_text( ).

        IF lv_status_header-code = 200.
        ELSE.
          TRY.
              response->set_status(
                EXPORTING
                  i_code   = lv_status_header-code
                  i_reason = lv_status_header-reason
              ).
            CATCH cx_web_message_error.
          ENDTRY.

          response->set_text( lv_json_response_header ).

          CHECK lv_status_header-code = 200.
        ENDIF.
      ENDIF.
**********************************************************************
***for Account Assignment Data
**********************************************************************

      /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                  CHANGING data = wa_accassign ).


      IF wa_accassign-_master_fixed_asset IS NOT INITIAL.
        TRY.
            DATA(lo_http_client_accassign) = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = cl_http_destination_provider=>create_by_url( lo_url_accassign ) ).

          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.


        DATA(lo_request_accassign) = lo_http_client_accassign->get_http_request( ).
        lo_request_accassign->set_header_fields(  VALUE #(
                                                 ( name = 'Content-Type'  value = 'application/json' )
                                                 ( name = 'x-csrf-token'  value = lv_csrf_token )
                                                 ( name = 'Accept'        value = '*/*' )
                                                )
                                     ).


        LOOP AT it_set_cookie INTO wa_set_cookie.
          TRY.
              lo_request_accassign->set_cookie(
                EXPORTING
                  i_name    = wa_set_cookie-name
                  i_value   = wa_set_cookie-value
              ).
            CATCH cx_web_message_error.                 "#EC NO_HANDLER
          ENDTRY.
        ENDLOOP.

        lo_request_accassign->set_authorization_basic(
                           EXPORTING
                             i_username = wa_idpass-username
                             i_password = wa_idpass-password
                         ).

        DATA:accassign_json TYPE string.
        /ui2/cl_json=>serialize( EXPORTING  data        = wa_accassign
                                            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 RECEIVING  r_json      = accassign_json ).

        lo_request_accassign->append_text(
              EXPORTING
                data   = accassign_json
            ).

        TRY.
            DATA(lo_response_accassign) = lo_http_client_accassign->execute(
                                i_method  = if_web_http_client=>patch ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

        DATA(lv_status_accassign) = lo_response_accassign->get_status( ).
        DATA(lv_json_response_accassign) = lo_response_accassign->get_text( ).

        IF lv_status_accassign-code = 200.

          response->set_text( |Updated Purchase Order { lv_purchaseorder } Successfully.| ).

        ELSE.
          TRY.
              response->set_status(
                EXPORTING
                  i_code   = lv_status_accassign-code
                  i_reason = lv_status_accassign-reason
              ).
            CATCH cx_web_message_error.
          ENDTRY.

          response->set_text( lv_json_response_accassign ).

          CHECK lv_status_accassign-code = 200.
        ENDIF.

      ENDIF.
    ENDIF.

**********************************************************************
***For Schedule Line
**********************************************************************
    /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                CHANGING data = wa_schedule ).



    TRY.
        DATA(lo_http_client_schedule) = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lo_url_schedule ) ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.


    DATA(lo_request_schedule) = lo_http_client_schedule->get_http_request( ).
    lo_request_schedule->set_header_fields(  VALUE #(
                                             ( name = 'Content-Type'  value = 'application/json' )
                                             ( name = 'x-csrf-token'  value = lv_csrf_token )
                                             ( name = 'Accept'        value = '*/*' )
                                            )
                                 ).

    LOOP AT it_set_cookie INTO wa_set_cookie.
      TRY.
          lo_request_schedule->set_cookie(
            EXPORTING
              i_name    = wa_set_cookie-name
              i_value   = wa_set_cookie-value
          ).
        CATCH cx_web_message_error.                     "#EC NO_HANDLER
      ENDTRY.
    ENDLOOP.

    lo_request_schedule->set_authorization_basic(
                       EXPORTING
                         i_username = wa_idpass-username
                         i_password = wa_idpass-password
                     ).

    DATA:schedule_json TYPE string.
    /ui2/cl_json=>serialize( EXPORTING  data        = wa_schedule
                                        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                             RECEIVING  r_json      = schedule_json ).

    REPLACE ALL OCCURRENCES OF '""' IN schedule_json WITH 'null'.

    lo_request_schedule->append_text(
          EXPORTING
            data   = schedule_json
        ).

    TRY.
        DATA(lo_response_schedule) = lo_http_client_schedule->execute(
                            i_method  = if_web_http_client=>patch ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    DATA(lv_status_schedule) = lo_response_schedule->get_status( ).
    DATA(lv_json_response_schedule) = lo_response_schedule->get_text( ).

    IF lv_status_schedule-code = 200.
    ELSE.
      TRY.
          response->set_status(
            EXPORTING
              i_code   = lv_status_schedule-code
              i_reason = lv_status_schedule-reason
          ).
        CATCH cx_web_message_error.
      ENDTRY.

      response->set_text( lv_json_response_schedule ).

      CHECK lv_status_schedule-code = 200.
    ENDIF.

**********************************************************************
    CLEAR: lv_purchaseorder,lv_purchaseorderitem,lv_accountassignmentnumber,wa_header,wa_item,wa_schedule,accassign_json,item_json,header_json.
**********************************************************************
  ENDMETHOD.
ENDCLASS.

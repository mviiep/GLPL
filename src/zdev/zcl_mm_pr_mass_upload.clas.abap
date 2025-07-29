CLASS zcl_mm_pr_mass_upload DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    DATA it_set_cookie TYPE if_web_http_request=>cookies.

    TYPES:BEGIN OF ty_header,
            _payment_terms       TYPE zi_po_mass_upload-paymentterms, "Payment Terms
            _validity_start_date TYPE string, "Validity Start Date
            _validity_end_date   TYPE string, "Validity End Date
          END OF ty_header.

    TYPES:BEGIN OF ty_accassign,
            _cost_center        TYPE zi_po_mass_upload-costcenter, "Cost Center
            _master_fixed_asset TYPE zi_po_mass_upload-masterfixedasset, "Master Fixed Asset
          END OF ty_accassign.

    TYPES:BEGIN OF ty_item,
            _requested_quantity            TYPE zi_pr_mass_upload-requestedquantity, "Order Quantity
            _delivery_date                 TYPE zi_pr_mass_upload-deliverydate, "Delivery Date
            _base_unit                     TYPE zi_pr_mass_upload-baseunit, "Unit of Measurement
            _base_unit_i_s_o_code          TYPE zi_pr_mass_upload-baseunit, "Unit of Measurement
            _purchase_requisition_price    TYPE zi_pr_mass_upload-purchaserequisitionprice, "Net Price
            _pur_reqn_item_currency        TYPE zi_pr_mass_upload-purreqnitemcurrency, "Currency
            _tax_code                      TYPE zi_pr_mass_upload-taxcode, "TaxCode
            _performance_period_start_date TYPE zi_pr_mass_upload-performanceperiodstartdate, "TaxCode
            _performance_period_end_date   TYPE zi_pr_mass_upload-performanceperiodenddate, "TaxCode
            _is_closed                     TYPE string, "TaxCode
          END OF ty_item.

    DATA: wa_item                    TYPE ty_item,
          wa_header                  TYPE ty_header,
          wa_accassign               TYPE ty_accassign,
          lv_purchaserreqn           TYPE zi_pr_mass_upload-purchaserequisition,
          lv_purchaserreqnitem       TYPE zi_pr_mass_upload-purchaserequisitionitem,
          lv_accountassignmentnumber TYPE zi_pr_mass_upload-purchasereqnacctassgmtnumber.

    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string.

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



CLASS ZCL_MM_PR_MASS_UPLOAD IMPLEMENTATION.


  METHOD get_token.
*
    CASE sy-sysid.
      WHEN lv_dev.
        DATA(lo_url) = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/|.
      WHEN lv_qas.
        lo_url = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/|.
      WHEN lv_prd.
        lo_url = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/|.
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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'purchaserequisition'.
    lv_purchaserreqn = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'purchaserequisitionitem'.
    lv_purchaserreqnitem = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'accountassignmentnumber'.
    lv_accountassignmentnumber = ls_params-value.

    IF lv_request_method = 'PATCH'.

**********************************************************************
***For Item data
**********************************************************************

      /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                  CHANGING data = wa_item ).

      CASE sy-sysid.
        WHEN lv_dev.
          DATA(lo_url_item)      = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/PurchaseReqnItem/{ lv_purchaserreqn }/{ lv_purchaserreqnitem }|.
          DATA(lo_url_header)    = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/{ lv_purchaserreqn }|.
          DATA(lo_url_accassign) = |https://my417176-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/PurchaseReqnAcctAssgmt/{ lv_purchaserreqn }/{ lv_purchaserreqnitem }/{ lv_accountassignmentnumber
}|.
        WHEN lv_qas.
          lo_url_item      = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/PurchaseReqnItem/{ lv_purchaserreqn }/{ lv_purchaserreqnitem }|.
          lo_url_header    = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/{ lv_purchaserreqn }|.
          lo_url_accassign = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaserequisition_2/srvd_a2x/sap/purchaserequisition/0001/PurchaseReqnAcctAssgmt/{ lv_purchaserreqn }/{ lv_purchaserreqnitem }/{ lv_accountassignmentnumber }|.
        WHEN lv_prd.
          lo_url_item      = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrderItem/{ lv_purchaserreqn }/{ lv_purchaserreqnitem }|.
          lo_url_header    = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001/PurchaseOrder/{ lv_purchaserreqn }|.
          lo_url_accassign = |https://my418964-api.s4hana.cloud.sap/sap/opu/odata4/sap/api_purchaseorder_2/srvd_a2x/sap/purchaseorder/0001//PurchaseOrderAccountAssignment/{ lv_purchaserreqn }/{ lv_purchaserreqnitem }/{ lv_accountassignmentnumber }|.
      ENDCASE.


* Read credentials
      SELECT SINGLE *
      FROM zi_cs_id
      WHERE systemid = @sy-mandt
      INTO @DATA(wa_idpass).

**********************************************************************
*      SELECT SINGLE *
*      FROM zi_pr_mass_upload
*      WHERE purchaserequisition = @lv_purchaserreqn
*      AND purchaserequisitionitem = @lv_purchaserreqnitem
*      INTO @DATA(wa_pr_upload).

*      IF wa_pr_upload-performanceperiodenddate IS INITIAL AND wa_pr_upload-performanceperiodstartdate IS INITIAL.
*        wa_item-_performance_period_end_date = ''.
*        wa_item-_performance_period_start_date = ''.
*      ENDIF.

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
                                               ( name = 'If-Match'      value = '*' )
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



      REPLACE ALL OCCURRENCES OF '"null"' IN item_json WITH 'null'.
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
***for Account Assignment Data
**********************************************************************

      /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                  CHANGING data = wa_accassign ).



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
                                               ( name = 'If-Match'      value = '*' )
                                              )
                                   ).


      LOOP AT it_set_cookie INTO wa_set_cookie.
        TRY.
            lo_request_accassign->set_cookie(
              EXPORTING
                i_name    = wa_set_cookie-name
                i_value   = wa_set_cookie-value
            ).
          CATCH cx_web_message_error.                   "#EC NO_HANDLER
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

        response->set_text( |Updated Purchase Requisition { lv_purchaserreqn } Successfully.| ).

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

  ENDMETHOD.
ENDCLASS.

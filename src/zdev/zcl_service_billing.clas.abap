CLASS zcl_service_billing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS update_billing.


    TYPES:BEGIN OF ty_data,
            _billing___document___number TYPE i_billingdocumentitem-billingdocument,
            _billing_period_from___date  TYPE c LENGTH 18,
            _net__value                  TYPE string,
            _zoho___crm___id             TYPE zsales_order-salesorder,
          END OF ty_data.

    TYPES:BEGIN OF ty_final,
            data TYPE STANDARD TABLE OF ty_data WITH EMPTY KEY,
          END OF ty_final.


    DATA:wa_final TYPE ty_final,
         wa_data  TYPE ty_data.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN'.

    DATA: lo_url TYPE string.

    DATA:lv_json TYPE string,
         lv_url  TYPE string.

    TYPES:BEGIN OF ty_zohotab,
            client(3)    TYPE c,
            salesorder   TYPE i_salesorder-salesorder,
            zohocode(18) TYPE c,
            msg(10)      TYPE c,
          END OF ty_zohotab.

    DATA : wa_zohotab TYPE ty_zohotab.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SERVICE_BILLING IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    me->update_billing( ).


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
      CATCH cx_apj_rt_content.                          "#EC NO_HANDLER
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD update_billing.


    DATA: lt_data TYPE TABLE OF string,
          ls_item TYPE string.

*    DATA lr_data TYPE REF TO data.

    DATA: lv_url1        TYPE string,  " VALUE 'https://glpl-nonprod-apim-02.azure-api.net/ServiceBilling/Sales_Orders',
          lo_http_client TYPE REF TO if_web_http_client,
          lv_payload     TYPE string.

    TYPES : BEGIN OF ty_errorresult,
              message      TYPE string,
              errormessage TYPE string,
              infodtls     TYPE string,
              status       TYPE string,
              code(3),
              requestid    TYPE string,
            END OF ty_errorresult.

    TYPES : BEGIN OF ty_error,
              results TYPE ty_errorresult,
            END OF ty_error.
    DATA wa_error TYPE ty_error.

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <templates>           TYPE data,
      <templates_result>    TYPE any,
      <metafield_result>    TYPE data,
      <metadata_result>     TYPE data,
      <metadata>            TYPE STANDARD TABLE,
      <pdf_based64_encoded> TYPE any.

    TYPES: BEGIN OF ty_user,
             name TYPE string,
             id   TYPE string,
           END OF ty_user.

    TYPES: BEGIN OF ty_details,
             modified_time TYPE string,
             created_time  TYPE string,
             modified_by   TYPE ty_user,
             created_by    TYPE ty_user,
             id            TYPE string,
           END OF ty_details.

    TYPES: BEGIN OF ty_data1,
             code    TYPE string,
             details TYPE ty_details,
             message TYPE string,
             status  TYPE string,
           END OF ty_data1.

    TYPES: tt_data TYPE STANDARD TABLE OF ty_data1 WITH EMPTY KEY.


    DATA: lt_res TYPE tt_data.


    TYPES : BEGIN OF ty_det,
              modi_time(20) TYPE c,
            END OF ty_det,

            BEGIN OF ty_data,
              code(10)    TYPE c,
              details(10) TYPE c,
              message(10) TYPE c,
              status(10)  TYPE c,
            END OF ty_data.

    DATA : data TYPE TABLE OF ty_data WITH EMPTY KEY.
    DATA : wa_mat TYPE zsales_order.

    TYPES:BEGIN OF ty_datafin,
            data LIKE data,
          END OF ty_datafin.

    DATA: data1 TYPE STANDARD TABLE OF ty_datafin WITH EMPTY KEY.


*  READ ENTITIES OF zapi_sales_order IN LOCAL MODE
*    ENTITY zapi_sales_order
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(result_data)
*    FAILED DATA(failed_data)
*    REPORTED DATA(reported_data).
*    READ TABLE keys INTO DATA(wa_key) INDEX 1.
*    READ TABLE result_data INTO DATA(wa_data) INDEX 1.

*  READ TABLE keys INTO DATA(wa_key1) INDEX 1.\

    DATA(curr_date) = cl_abap_context_info=>get_system_date( ).

    SELECT *
        FROM zapi_sales_order
*        WHERE Lastchanged = @curr_date
        INTO TABLE  @DATA(it_zoho).


    LOOP AT it_zoho INTO DATA(ls_so).
      DATA(lv_test)     =   ls_so-lastchanged.
      DATA(datetest) = lv_test+0(8).
      IF datetest NE curr_date.
        DELETE it_zoho WHERE salesorder = ls_so-salesorder.
      ENDIF.
    ENDLOOP.





    LOOP AT it_zoho INTO DATA(wa_zoho).

      DATA(lv_date) = wa_zoho-billingdocumentdate.
      DATA(lv_new_date) = |{ lv_date+6(2) }-{ lv_date+4(2) }-{ lv_date+0(4) }|.

      wa_zoho-billingdocumentdate = lv_new_date.


      IF wa_zoho-zohoid IS NOT INITIAL OR wa_zoho-zbillingdoc IS NOT INITIAL.

        wa_data-_billing___document___number            = wa_zoho-zbillingdoc.
        wa_data-_billing_period_from___date              = lv_new_date.
        wa_data-_net__value                             =  wa_zoho-totalnetamount.
        wa_data-_zoho___crm___id                        = wa_zoho-zohoid.

        APPEND wa_data TO wa_final-data.
        /ui2/cl_json=>serialize( EXPORTING data   = wa_final
                                 pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                                 RECEIVING r_json = lv_json
        ).


        REPLACE 'BillingPeriodFrom_Date' IN lv_json WITH 'Billing_Period_From_Date'.
        REPLACE 'Zoho_Crm_Id' IN lv_json WITH 'Zoho_CRM_ID'.
        REPLACE 'Net_value' IN lv_json WITH 'Net_Value'.

**********************************************************************
**API Call
**API Call
        DATA lv_sub TYPE string.
        CASE sy-sysid.
          WHEN lv_dev.
            lv_url1  = |https://glpl-nonprod-apim-02.azure-api.net/ServiceBilling/Sales_Orders/{ wa_zoho-zohoid }|.
            CONCATENATE lv_url1 '/' wa_zoho-zohoid INTO lo_url.
            lv_sub = '3f3c78ff8cad477c831527f03f71a041' .
          WHEN lv_qas.
            lv_url1  = |https://glpl-nonprod-apim-02.azure-api.net/ServiceBilling/Sales_Orders/{ wa_zoho-zohoid }|.
            CONCATENATE lv_url1 '/' wa_zoho-zohoid INTO lo_url.
            lv_sub = '3f3c78ff8cad477c831527f03f71a041' .
          WHEN lv_prd.
            lv_url1  = |https://glpl-prod-apim-02.azure-api.net/ServiceBilling/Sales_Orders/{ wa_zoho-zohoid }|.
            CONCATENATE lv_url1 '/' wa_zoho-zohoid INTO lo_url.
            lv_sub = '90dee5bd8a9d415c924fa4dc008d91ee'.
        ENDCASE.

*
*      TRY.
*          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
*          i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
*        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
*          "handle exception
*      ENDTRY.
        TRY.
            lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
            i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.


        DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_fields(  VALUE #(
                   (  name = 'Accept'                     value = '*/*' )
                   (  name = 'Content-Type'                value = 'application/json' )
                   (  name = 'Authorization'              value = lv_token )
                   (  name = 'Cache-Control'              value = 'no-cache' )
                   (  name = 'Ocp-Apim-Subscription-Key'  value = lv_sub ) )
                    ).

        lo_request->append_text(
              EXPORTING
                data   = lv_json
            ).


        TRY.
            DATA(lv_response) = lo_http_client->execute(
                                i_method  = if_web_http_client=>put ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

        DATA(status) = lv_response->get_status(  ).
        DATA(lv_json_response) = lv_response->get_text( ).


        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json = lv_json_response
          CHANGING
            data = lt_res.

*
* loop at lt_res into data(wa_res) .
*
*if wa_res-code EQ 'SUCCESS'.
        FIND FIRST OCCURRENCE OF '"code":"SUCCESS"' IN lv_json_response.
        IF sy-subrc EQ 0.
          FIND FIRST OCCURRENCE OF '"code":"SUCCESS"' IN lv_json_response.
          wa_zohotab-zohocode = wa_data-_zoho___crm___id.

          wa_mat-salesorder = wa_zoho-salesorder.
          wa_mat-zohosocode = wa_zohotab-zohocode.
          wa_mat-msg = 'SUCCESS'.
          wa_mat-lastchangedate = wa_zoho-lastchanged.
          MODIFY zsales_order FROM @wa_mat.


*
*        data(wa_msg) = me->new_message(
*                                id       = 'ZMSG_SALES_ORDER'
*                                number   = 001
*                                severity = if_abap_behv_message=>severity-success
*                                v1       = wa_zoho-zohoid
*                              ).

* DATA wa_record LIKE LINE OF reported-zapi_sales_order.
*    wa_record-%msg = wa_msg.
*        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
*        APPEND wa_record TO reported-zapi_sales_order.



        ENDIF.




        FIND FIRST OCCURRENCE OF '"code":"INVALID_DATA"' IN lv_json_response.
        IF sy-subrc EQ 0.

*    wa_msg = me->new_message(
*                              id       = 'ZMSG_SALES_ORDER'
*                              number   = 002
*                              severity = if_abap_behv_message=>severity-error
*                              v1       = wa_zoho-SalesOrder
*                            ).
*
*     wa_record-%msg = wa_msg.
*        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
*        APPEND wa_record TO reported-zapi_sales_order.
          wa_zohotab-zohocode = wa_data-_zoho___crm___id.

          wa_mat-salesorder = wa_zoho-salesorder.
          wa_mat-zohosocode = wa_zohotab-zohocode.
          wa_mat-msg = 'INVALID_DATA'.

          MODIFY zsales_order FROM @wa_mat.



        ENDIF.


        FIND FIRST OCCURRENCE OF '"code":"INVALID_URL_PATTERN"' IN lv_json_response.
        IF sy-subrc EQ 0.

*    wa_msg = me->new_message(
*                              id       = 'ZMSG_SALES_ORDER'
*                              number   = 004
*                              severity = if_abap_behv_message=>severity-error
*                              v1       = wa_zoho-SalesOrder
*                            ).
*
*     wa_record-%msg = wa_msg.
*        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
*        APPEND wa_record TO reported-zapi_sales_order.


          wa_mat-salesorder = wa_zoho-salesorder.
          wa_mat-zohosocode = wa_zohotab-zohocode.
          wa_mat-msg = 'INVALID_URL_PATTERN'.

          MODIFY zsales_order FROM @wa_mat.



        ENDIF.





        FIND FIRST OCCURRENCE OF '"statusCode": 404' IN lv_json_response.
        IF sy-subrc EQ 0.
*
*    wa_msg = me->new_message(
*                              id       = 'ZMSG_SALES_ORDER'
*                              number   = 003
*                              severity = if_abap_behv_message=>severity-error
*                              v1       = wa_zoho-SalesOrder
*                            ).
*
*     wa_record-%msg = wa_msg.
*        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
*        APPEND wa_record TO reported-zapi_sales_order.

          wa_mat-salesorder = wa_zoho-salesorder.
          wa_mat-zohosocode = wa_zohotab-zohocode.
          wa_mat-msg = 'statusCode": 404'.

          MODIFY zsales_order FROM @wa_mat.

        ENDIF.




*wa_msg = me->new_message(
*                              id       = 'ZMSG_SALES_ORDER'
*                              number   = 003
*                              severity = if_abap_behv_message=>severity-error
*                              v1       = wa_zoho-SalesOrder
*                            ).
*
*     wa_record-%msg = wa_msg.
*        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
*        APPEND wa_record TO reported-zapi_sales_order.

*ENDLOOP.

*MODIFY zsales_order from @wa_mat.

      ENDIF.

      CLEAR:  lv_json, wa_zoho, lv_json_response, lo_url, wa_final , wa_mat.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.

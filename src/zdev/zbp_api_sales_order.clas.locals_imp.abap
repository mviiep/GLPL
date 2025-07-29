CLASS lhc_zapi_sales_order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

   TYPES:BEGIN OF ty_data,
           _Billing___Document___Number type i_billingdocumentitem-BillingDocument,
           _Billing_Period_From___Date type C LENGTH 18,
           _Net__value type string,
           _zoho___crm___id type zsales_order-salesorder,
          END OF ty_data.

    TYPES:BEGIN OF ty_final,
             data TYPE STANDARD TABLE OF ty_data WITH EMPTY KEY,
          END OF ty_final.


    DATA:wa_final TYPE ty_final,
         wa_data type ty_data.

    DATA : lv_tenent TYPE c LENGTH 8,
         lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN'.

    DATA: lo_url TYPE string.

    DATA:lv_json TYPE string,
           lv_url     TYPE string.

  TYPES:BEGIN OF ty_zohotab,
            client(3)    TYPE c,
            Salesorder   TYPE I_SalesOrder-SalesOrder,
            zohocode(18) TYPE c,
            msg(10) type c,
          END OF ty_zohotab.

    DATA : wa_zohotab TYPE ty_zohotab.



    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zapi_sales_order RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zapi_sales_order RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zapi_sales_order.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE zapi_sales_order.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE zapi_sales_order.

    METHODS read FOR READ
      IMPORTING keys FOR READ zapi_sales_order RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zapi_sales_order.

    METHODS updatebilling FOR MODIFY
      IMPORTING keys FOR ACTION zapi_sales_order~updatebilling RESULT result.

ENDCLASS.

CLASS lhc_zapi_sales_order IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD updatebilling.


  DATA: lt_data TYPE TABLE OF string,
          ls_item TYPE string.

*    DATA lr_data TYPE REF TO data.

      DATA: lv_url         TYPE string VALUE 'https://glpl-nonprod-apim-02.azure-api.net/ServiceBilling/Sales_Orders',
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

    DATA(it_key) = keys.


  READ ENTITIES OF zapi_sales_order IN LOCAL MODE
    ENTITY zapi_sales_order
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(reported_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.
*    READ TABLE result_data INTO DATA(wa_data) INDEX 1.

  READ TABLE keys INTO DATA(wa_key1) INDEX 1.
    SELECT SINGLE *
        FROM zapi_sales_order
        WHERE SalesOrder = @wa_key1-SalesOrder
        INTO  @DATA(wa_zoho).

data(lv_date) = wa_zoho-BillingDocumentDate.
data(lv_new_date) = |{ lv_date+6(2) }-{ lv_date+4(2) }-{ lv_date+0(4) }|.


wa_zoho-BillingDocumentDate = lv_new_date.




    IF wa_zoho-zohoid IS NOT INITIAL or wa_zoho-zbillingdoc is not INITIAL.

      wa_data-_billing___document___number            = wa_zoho-zbillingdoc.
      wa_data-_billing_period_from___date              = lv_new_date.
      wa_data-_net__value                             =  wa_zoho-TotalNetAmount.
      wa_data-_zoho___crm___id                        = wa_zoho-zohoid.

APPEND wa_data to wa_final-data.
      /ui2/cl_json=>serialize( EXPORTING data   = wa_final
                               pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                               RECEIVING r_json = lv_json
      ).


   REPLACE 'BillingPeriodFrom_Date' IN lv_json WITH 'Billing_Period_From_Date'.
   REPLACE 'Zoho_Crm_Id' IN lv_json WITH 'Zoho_CRM_ID'.
   REPLACE 'Net_value' IN lv_json WITH 'Net_Value'.

**********************************************************************
**API Call
data lv_sub TYPE string.
      CASE sy-sysid.
        WHEN lv_dev.
          lo_url = |https://glpl-nonprod-apim-02.azure-api.net/ServiceBilling/Sales_Orders/{ wa_zoho-zohoid }|.
           CONCATENATE lv_url '/' wa_zoho-zohoid into lo_url.
           lv_sub = '3f3c78ff8cad477c831527f03f71a041' .
        WHEN lv_qas.
          lo_url = |https://glpl-nonprod-apim-02.azure-api.net/ServiceBilling/Sales_Orders/{ wa_zoho-zohoid }|.
   CONCATENATE lv_url '/' wa_zoho-zohoid into lo_url.
    lv_sub = '3f3c78ff8cad477c831527f03f71a041' .
        WHEN lv_prd.
          lo_url = |https://glpl-prod-apim-02.azure-api.net/ServiceBilling/Sales_Orders/{ wa_zoho-zohoid }|.
   CONCATENATE lv_url '/' wa_zoho-zohoid into lo_url.
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



*    lv_url = 'https://glpl-nonprod-apim-02.azure-api.net/crmsandboxtoken/'.
   DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).





      DATA(lo_request) = lo_http_client->get_http_request( ).

      lo_request->set_header_fields(  VALUE #(
                 (  name = 'Accept'                     value = '*/*' )
                 (  name = 'Content-Type'                value = 'application/json' )
                 (  name = 'Authorization'              value = lv_token )
                 (  name = 'Cache-Control'              value = 'no-cache' )
                 (  name = 'Ocp-Apim-Subscription-Key'  value =  lv_sub ) )
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


*  loop at lt_res into data(wa_res) .

*    if wa_res-code EQ 'SUCCESS'.
    FIND FIRST OCCURRENCE OF '"code":"SUCCESS"' IN lv_json_response.
    IF sy-subrc EQ 0.
 FIND FIRST OCCURRENCE OF '"code":"SUCCESS"' IN lv_json_response.
  wa_zohotab-zohocode = wa_data-_zoho___crm___id.

wa_mat-salesorder = wa_zoho-salesorder.
wa_mat-zohosocode = wa_zohotab-zohocode.
wa_mat-msg = 'SUCCESS'.
wa_mat-lastchangedate = wa_zoho-Lastchanged.
MODIFY zsales_order from @wa_mat.


        data(wa_msg) = me->new_message(
                                id       = 'ZMSG_SALES_ORDER'
                                number   = 001
                                severity = if_abap_behv_message=>severity-success
                                v1       = wa_zoho-zohoid
                              ).






 DATA wa_record LIKE LINE OF reported-zapi_sales_order.
    wa_record-%msg = wa_msg.
        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
        APPEND wa_record TO reported-zapi_sales_order.

    ENDIF.
*    ENDIF.



       FIND FIRST OCCURRENCE OF '"code":"INVALID_DATA"' IN lv_json_response.
    IF sy-subrc EQ 0.


wa_zohotab-zohocode = wa_data-_zoho___crm___id.

wa_mat-salesorder = wa_zoho-salesorder.
wa_mat-zohosocode = wa_zohotab-zohocode.
wa_mat-msg = 'INVALID_DATA'.


    wa_msg = me->new_message(
                              id       = 'ZMSG_SALES_ORDER'
                              number   = 002
                              severity = if_abap_behv_message=>severity-error
                              v1       = wa_zoho-SalesOrder
                            ).

     wa_record-%msg = wa_msg.
        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
        APPEND wa_record TO reported-zapi_sales_order.
endif.


       FIND FIRST OCCURRENCE OF '"code":"INVALID_URL_PATTERN"' IN lv_json_response.
    IF sy-subrc EQ 0.




wa_mat-salesorder = wa_zoho-salesorder.
wa_mat-zohosocode = wa_zohotab-zohocode.
wa_mat-msg = 'INVALID_URL_PATTERN'.

MODIFY zsales_order from @wa_mat.



    wa_msg = me->new_message(
                              id       = 'ZMSG_SALES_ORDER'
                              number   = 004
                              severity = if_abap_behv_message=>severity-error
                              v1       = wa_zoho-SalesOrder
                            ).

     wa_record-%msg = wa_msg.
        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
        APPEND wa_record TO reported-zapi_sales_order.
endif.





FIND FIRST OCCURRENCE OF '"statusCode": 404' IN lv_json_response.
    IF sy-subrc EQ 0.


wa_mat-salesorder = wa_zoho-salesorder.
wa_mat-zohosocode = wa_zohotab-zohocode.
wa_mat-msg = 'statusCode": 404'.

MODIFY zsales_order from @wa_mat.
    wa_msg = me->new_message(
                              id       = 'ZMSG_SALES_ORDER'
                              number   = 003
                              severity = if_abap_behv_message=>severity-error
                              v1       = wa_zoho-SalesOrder
                            ).

     wa_record-%msg = wa_msg.
        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
        APPEND wa_record TO reported-zapi_sales_order.
endif.




  else.

wa_msg = me->new_message(
                              id       = 'ZMSG_SALES_ORDER'
                              number   = 003
                              severity = if_abap_behv_message=>severity-error
                              v1       = wa_zoho-SalesOrder
                            ).

     wa_record-%msg = wa_msg.
        wa_record-%tky-%key-SalesOrder = wa_zoho-SalesOrder.
        APPEND wa_record TO reported-zapi_sales_order.


 endif.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zapi_sales_order DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zapi_sales_order IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

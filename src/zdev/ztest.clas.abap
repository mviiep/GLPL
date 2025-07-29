CLASS ztest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZTEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*  "

    "DATA(lv_url) = 'https://my417176.s4hana.cloud.sap/sap/opu/odata/sap/ZSB_FICO_PURREG/'.
    DATA(lv_url) = 'https://glpl-nonprod-apim-02.azure-api.net/Material_Master/Products'.
    DATA: lo_http_client TYPE REF TO if_web_http_client,
          lv_payload     TYPE string,
          lv_json TYPE string.

    types:   BEGIN OF ty_data,
                  code    TYPE c LENGTH 10,
                  details TYPE c LENGTH 100,
                  message TYPE c LENGTH 30,
                  status  TYPE c LENGTH 10,
                END OF ty_data.

        DATA : data TYPE TABLE OF ty_data WITH EMPTY KEY.

 "READ TABLE lt_mat INTO DATA(lw_mat) WITH KEY status = '201'.
          CONCATENATE  lv_url  '/'  '1900000008'  INTO DATA(gv_url).

          TRY.
              lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
              i_destination = cl_http_destination_provider=>create_by_url( gv_url ) ).
            CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          ENDTRY.

          DATA(lo_request) = lo_http_client->get_http_request( ).


          DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).
          lo_request->set_header_fields(
          VALUE #(
                  ( name = 'Content-Type'  value = 'application/json' )
                  ( name = 'Cache-Control' value = 'no-cache' )
                  ( name = 'Ocp-Apim-Subscription-Key' value = '3f3c78ff8cad477c831527f03f71a041' )
                  ( name = 'Authorization' value = lv_token )
                 ) ).


          lo_request->append_text(
                EXPORTING
                  data   = lv_json
              ).

          TRY.
              DATA(lv_response) = lo_http_client->execute(
                                  i_method  = if_web_http_client=>put ).
            CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          ENDTRY.
          DATA(status) = lv_response->get_status( ).
          DATA(lv_response_text) = lv_response->get_text( ).

          CALL METHOD /ui2/cl_json=>deserialize(
            EXPORTING
              pretty_name = /ui2/cl_json=>pretty_mode-camel_case
            CHANGING
              data        = data
          ).

       "   lr_data = /ui2/cl_json=>generate( json = lv_response_text  pretty_name  = /ui2/cl_json=>pretty_mode-user ).





  ENDMETHOD.
ENDCLASS.

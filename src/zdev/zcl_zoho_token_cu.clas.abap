CLASS zcl_zoho_token_cu DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS tokenmethod
      IMPORTING lv_url         TYPE string
      RETURNING VALUE(r_token) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZOHO_TOKEN_CU IMPLEMENTATION.


  METHOD tokenmethod.
    DATA: token_url TYPE string ."VALUE 'https://glpl-nonprod-apim-02.azure-api.net/crmsandboxtoken/'.
    DATA: token_http_client TYPE REF TO if_web_http_client.

    token_url = lv_url.
    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( token_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(token_request) = token_http_client->get_http_request( ).

    token_request->set_header_fields(  VALUE #(
                (  name = 'Cache-Control'             value = 'no-cache' )
                (  name = 'Content-Length'            value = '0' )
                (  name = 'Ocp-Apim-Subscription-Key' value = '3f3c78ff8cad477c831527f03f71a041' )
                ) ).


    TRY.
        DATA(lv_response) = token_http_client->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

    DATA(status) = lv_response->get_status( ).
    DATA(lv_json_response) = lv_response->get_text( ).

    TYPES:BEGIN OF ty_token,
            access_token TYPE string,
            scope        TYPE string,
            api_domain   TYPE string,
            token_type   TYPE string,
            expires_in   TYPE string,
          END OF ty_token.

    DATA:wa_token TYPE ty_token.
    CALL METHOD /ui2/cl_json=>deserialize
      EXPORTING
        json = lv_json_response
      CHANGING
        data = wa_token.

    CONCATENATE wa_token-token_type wa_token-access_token INTO r_token SEPARATED BY space.
  ENDMETHOD.
ENDCLASS.

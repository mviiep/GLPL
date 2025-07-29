CLASS zcl_zoho_token DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_token | <p class="shorttext synchronized" lang="en"></p>
    CLASS-METHODS tokenmethod
      RETURNING VALUE(r_token) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZOHO_TOKEN IMPLEMENTATION.


  METHOD tokenmethod.

****************token****************

    DATA: token_url TYPE string VALUE 'https://accounts.zoho.in/oauth/v2/token'.
    DATA: token_http_client TYPE REF TO if_web_http_client.


    TRY.
        token_http_client = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( token_url  ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(token_request) = token_http_client->get_http_request( ).

    token_request->set_header_fields(  VALUE #(
                (  name = 'Accept'        value = '*/*' )
                ) ).


    TRY.
        token_request->set_form_fields( VALUE #(
                            (  name = 'refresh_token' value = '1000.296dd02510f88b312c4e50ef4bb0123c.34e0438a8a7dca83e8e5f9926662cedb' )
                            (  name = 'client_id'     value = '1000.EL4KQVVAS2GCIH19RT8PSLMUXBRQLH' )
                            (  name = 'client_secret' value = '23510d48e2c8f006264967c89c7dce08616bcd65b3' )
                            (  name = 'grant_type'    value = 'refresh_token' )
                            ) ).
      CATCH cx_web_message_error.
    ENDTRY.


    TRY.
        DATA(lv_response) = token_http_client->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error.
    ENDTRY.

    DATA(status) = lv_response->get_status( ).
    DATA(lv_json_response) = lv_response->get_text( ).

    TYPES:BEGIN OF ty_token,
            access_token TYPE string,
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

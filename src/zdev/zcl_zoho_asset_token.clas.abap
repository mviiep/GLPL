CLASS zcl_zoho_asset_token DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS tokenmethod
      RETURNING VALUE(r_token) TYPE string.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZOHO_ASSET_TOKEN IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->tokenmethod(
*  RECEIVING
*    r_token =
    ).
  ENDMETHOD.


  METHOD tokenmethod.


    DATA: token_url         TYPE string,
          token_http_client TYPE REF TO if_web_http_client,
          l_stmp            TYPE timestampl,
          lv_sub_key        TYPE string,
          lv_diff           TYPE p DECIMALS 0,
          lv_dev(3)         TYPE c VALUE 'N7O',
          lv_qas(3)         TYPE c VALUE 'M2S',
          lv_prd(3)         TYPE c VALUE 'MLN'.


    CASE sy-sysid.
      WHEN lv_dev.
        token_url = 'https://glpl-nonprod-apim-02.azure-api.net/CreatorAccesstoken'.
        lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
      WHEN lv_qas.
        token_url = 'https://glpl-nonprod-apim-02.azure-api.net/CreatorAccesstoken'.
        lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
      WHEN lv_prd.
        token_url = 'https://glpl-prod-apim-02.azure-api.net/CreatorAccesstoken'.
        lv_sub_key = '90dee5bd8a9d415c924fa4dc008d91ee'.
    ENDCASE.


    GET TIME STAMP FIELD l_stmp.

    SELECT SINGLE *
    FROM zdb_tokentable
    WHERE url_path = 'CreatorAccesstoken'
    AND token_timestamp LT @l_stmp
    INTO @DATA(wa_tokentable).


    TRY.
        lv_diff = cl_abap_tstmp=>subtract(
                 tstmp1 = l_stmp
                 tstmp2 = wa_tokentable-token_timestamp ).
      CATCH cx_parameter_invalid INTO DATA(lx_tstmp_error).
    ENDTRY.


    IF wa_tokentable-token IS INITIAL OR ( lv_diff GT 3600 ) .


      TRY.
          token_http_client = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = cl_http_destination_provider=>create_by_url( token_url  ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.

      DATA(token_request) = token_http_client->get_http_request( ).

      token_request->set_header_fields(  VALUE #(
                  (  name = 'Cache-Control'              value = 'no-cache' )
                  (  name = 'Content-Length'             value = '0' )
                  (  name = 'Ocp-Apim-Subscription-Key'  value = lv_sub_key )
                  ) ).


      TRY.
          DATA(lv_response) = token_http_client->execute(
                              i_method  = if_web_http_client=>post ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.

      DATA(status) = lv_response->get_status( ).
      DATA(lv_json_response) = lv_response->get_text( ).

      IF status-code = 200.
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

        DATA:wa_tokentab TYPE zdb_tokentable.

        IF wa_token-access_token IS NOT INITIAL.
          wa_tokentab-url_path = 'CreatorAccesstoken'.
          wa_tokentab-url             = token_url.
          wa_tokentab-token           = r_token.
          wa_tokentab-token_timestamp = l_stmp.

          MODIFY zdb_tokentable FROM @wa_tokentab.
        ENDIF.
      ENDIF.


    ELSE.

      r_token =  wa_tokentable-token.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

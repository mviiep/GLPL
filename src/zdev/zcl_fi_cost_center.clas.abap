CLASS zcl_fi_cost_center DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
** Data Definition
**********************************************************************

    TYPES: BEGIN OF ty_layout,
             id TYPE string,
           END OF ty_layout.

    TYPES: BEGIN OF ty_data,
             _layout                    TYPE ty_layout,
             _name                      TYPE zapi_cost_center-costcenterdescription, " Unique Cost Center Description
             _state___name              TYPE zapi_cost_center-regionname, " State Description
             _profit___center___code    TYPE zapi_cost_center-profitcenter,
             _cost___center___status(8) TYPE c, " Default Hardcoded
             _sources(3)                TYPE c, " Default Hardcoded
             _state___code              TYPE zapi_cost_center-region,
             _profit___center___name    TYPE zapi_cost_center-profitcenterlongname, " Profit Center Description
             _environment(4)            TYPE c, " Mandatory
             _cost___center___code      TYPE zapi_cost_center-costcenter, " Mandatory
             _profit___center           TYPE zapi_cost_center-profitcenter, " Profit Center Lookup for future
           END OF ty_data.

    DATA ty_data_table TYPE STANDARD TABLE OF ty_data.


    TYPES:BEGIN OF ty_final,
            data LIKE ty_data_table,
          END OF ty_final.

    DATA:wa_final TYPE ty_final.

    DATA : lv_tenent  TYPE c LENGTH 8,
           lv_dev(3)  TYPE c VALUE 'N7O',
           lv_qas(3)  TYPE c VALUE 'M2S',
           lv_prd(3)  TYPE c VALUE 'MLN',
           lo_url     TYPE string,
           lv_sub_key TYPE string.

    DATA:lv_json TYPE string.


**********************************************************************
**Response JSON
**********************************************************************

    TYPES: BEGIN OF ty_details,
             api_name TYPE string,
             id       TYPE string,
           END OF ty_details,

           BEGIN OF ty_data_response,
             code    TYPE string,
             details TYPE ty_details,
             message TYPE string,
             status  TYPE string,
           END OF ty_data_response.

    DATA ty_data_responsetab TYPE TABLE OF ty_data_response.

    TYPES:BEGIN OF ty_response,
            data LIKE ty_data_responsetab,
          END OF ty_response.

    DATA: wa_data_response TYPE ty_response,
          wa_zohotab       TYPE zdb_cost_center.

**********************************************************************


    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FI_COST_CENTER IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.


    DATA(curr_date) = cl_abap_context_info=>get_system_date( ).

    SELECT _cost_center~costcenter,profitcenter,costcenterdescription,profitcenterlongname,region,regionname,
    costcentercreationdate, _cost_center~creationtime,zohocostcenter
  FROM zapi_cost_center AS _cost_center
  WHERE zohocostcenter = ''
  INTO TABLE @DATA(it_costcenter).




    IF it_costcenter[] IS NOT INITIAL.

      DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).

      LOOP AT it_costcenter INTO DATA(wa_data).


        READ TABLE wa_final-data INTO DATA(wa_data_json) INDEX 1.

        CASE sy-sysid.
          WHEN lv_dev.
            wa_data_json-_layout-id = '723303000002686870'.
          WHEN lv_qas.
            wa_data_json-_layout-id = '723303000002686870'.
          WHEN lv_prd.
            wa_data_json-_layout-id = '726575000001073352'.
        ENDCASE.

        wa_data_json-_cost___center___code     = wa_data-costcenter.
        SHIFT wa_data_json-_cost___center___code LEFT DELETING LEADING '0'.
        wa_data_json-_name                     = wa_data-costcenterdescription.
        wa_data_json-_profit___center___code   = wa_data-profitcenter.
        SHIFT wa_data_json-_profit___center___code LEFT DELETING LEADING '0'.
        wa_data_json-_profit___center___name   = wa_data-profitcenterlongname.
        wa_data_json-_state___code             = wa_data-region.
        wa_data_json-_state___name             = wa_data-regionname.
        wa_data_json-_sources                  = 'SAP'.
        wa_data_json-_cost___center___status   = 'Active'.

        CASE sy-sysid.
          WHEN lv_dev.
            wa_data_json-_environment              = 'DEV'.
          WHEN lv_qas.
            wa_data_json-_environment              = 'QAS'.
          WHEN lv_prd.
            wa_data_json-_environment              = 'PROD'.
        ENDCASE.

        APPEND wa_data_json TO wa_final-data.

        /ui2/cl_json=>serialize( EXPORTING data   = wa_final
                                 pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                                 RECEIVING r_json = lv_json
        ).

**********************************************************************
**API Call

        CASE sy-sysid.
          WHEN lv_dev.
            lo_url = 'https://glpl-nonprod-apim-02.azure-api.net/Cost_Center/Cost_Center_Configuration'.
            lv_sub_key = '1e451aeebe7d4d1280d41162410b189d'.
          WHEN lv_qas.
            lo_url = 'https://glpl-nonprod-apim-02.azure-api.net/Cost_Center/Cost_Center_Configuration'.
            lv_sub_key = '1e451aeebe7d4d1280d41162410b189d'.
          WHEN lv_prd.
            lo_url = 'https://glpl-prod-apim-02.azure-api.net/Cost_Center/Cost_Center_Configuration'.
            lv_sub_key = '90dee5bd8a9d415c924fa4dc008d91ee'.
        ENDCASE.


        TRY.
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
            i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
            "handle exception
        ENDTRY.


        DATA(lo_request) = lo_http_client->get_http_request( ).



        DATA: wa_fields TYPE if_web_http_request=>name_value_pair,
              i_fields  TYPE if_web_http_request=>name_value_pairs.

        wa_fields-name = 'Accept'.
        wa_fields-value = '*'.
        APPEND wa_fields TO i_fields.

        IF sy-sysid <> lv_prd.
          wa_fields-name = 'environment'.
          wa_fields-value = 'development'.
          APPEND wa_fields TO i_fields.
        ENDIF.

        wa_fields-name = 'Authorization'.
        wa_fields-value = lv_token.
        APPEND wa_fields TO i_fields.

        wa_fields-name = 'Ocp-Apim-Subscription-Key'.
        wa_fields-value = lv_sub_key.
        APPEND wa_fields TO i_fields.

        lo_request->set_header_fields( i_fields ).

        lo_request->append_text(
              EXPORTING
                data   = lv_json
            ).

        TRY.
            DATA(lv_response) = lo_http_client->execute(
                                i_method  = if_web_http_client=>post ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.


        DATA(status) = lv_response->get_status( ).
        DATA(lv_json_response) = lv_response->get_text( ).



        /ui2/cl_json=>deserialize( EXPORTING
                                          json        = lv_json_response
                                          pretty_name = /ui2/cl_json=>pretty_mode-low_case
                                   CHANGING
                                          data        = wa_data_response
        ).

        DATA(wa_response) = VALUE #( wa_data_response-data[ 1 ] OPTIONAL ).

        IF wa_response-status EQ 'success'.
**Successfully Created

          wa_zohotab-costcenter       = wa_data-costcenter.
          wa_zohotab-zohocostcenter   = wa_response-details-id.
          wa_zohotab-creationdate     = wa_data-costcentercreationdate.
          wa_zohotab-creationtime     = wa_data-creationtime.
          wa_zohotab-flag             = 'C'.


          MODIFY zdb_cost_center FROM @wa_zohotab.
          CLEAR:wa_zohotab,wa_data_response,wa_final.

        ELSEIF ( wa_response-status EQ 'error' AND wa_response-code = 'DUPLICATE_DATA' ) AND wa_zohotab-zohocostcenter IS INITIAL.
**Duplicate Data but not present in SAP

          wa_zohotab-costcenter       = wa_data-costcenter.
          wa_zohotab-zohocostcenter   = wa_response-details-id.
          wa_zohotab-creationdate     = wa_data-costcentercreationdate.
          wa_zohotab-creationtime     = wa_data-creationtime.
          wa_zohotab-flag             = 'C'.


          MODIFY zdb_cost_center FROM @wa_zohotab.
          CLEAR: wa_zohotab,wa_data_response,wa_final.
        ENDIF.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
      CATCH cx_apj_rt_content.
        "handle exception
    ENDTRY.

  ENDMETHOD.
ENDCLASS.

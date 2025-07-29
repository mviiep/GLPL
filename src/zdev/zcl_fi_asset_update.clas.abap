CLASS zcl_fi_asset_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

**********************************************************************
** Data Definition
**********************************************************************
    TYPES:BEGIN OF ty_data,
            _asset___code             TYPE i_fixedasset-masterfixedasset,
            _additional___description TYPE i_fixedasset-assetadditionaldescription,
            _inventory___number       TYPE zi_asset_master-inventory,
            _serial___number          TYPE zi_asset_master-assetserialnumber,
            _cost___center            TYPE zi_asset_master-costcenter,
            _name                     TYPE zi_asset_master-fixedassetdescription,
            _location                 TYPE zi_asset_master-assetlocation,
            _room                     TYPE zi_asset_master-room,
            _profit___center          TYPE zi_asset_master-profitcenter,
            _purchase___date(20)      TYPE c,
            _segment                  TYPE zi_asset_master-segment,
            _sources(3)               TYPE c,
            _environment(3)           TYPE c,
            _status(8)                TYPE c,
          END OF ty_data.

    TYPES:BEGIN OF ty_final,
            data TYPE ty_data,
          END OF ty_final.

    CLASS-DATA:wa_final TYPE ty_final.

    CLASS-DATA : lv_tenent TYPE c LENGTH 8,
                 lv_dev(3) TYPE c VALUE 'N7O',
                 lv_qas(3) TYPE c VALUE 'M2S',
                 lv_prd(3) TYPE c VALUE 'MLN'.

    CLASS-DATA: lo_url     TYPE string,
                lv_sub_key TYPE string.

    CLASS-DATA:lv_json TYPE string.

    TYPES:BEGIN OF ty_responsedata,
            id TYPE string,
          END OF ty_responsedata,

          BEGIN OF ty_errorresponse,
            serial_number(100) TYPE c,
            cost_center(100)   TYPE c,
            name(100)          TYPE c,
            profit_center(100) TYPE c,
          END OF ty_errorresponse,

          BEGIN OF ty_response,
            code        TYPE string,
            data        TYPE ty_responsedata,
            message     TYPE string,
            description TYPE string,
            error       TYPE ty_errorresponse,
          END OF ty_response.

    CLASS-DATA : data TYPE ty_response.

    TYPES:BEGIN OF ty_zohotab,
            client(3)    TYPE c,
            fixedasset   TYPE i_fixedasset-masterfixedasset,
            zohocode(18) TYPE c,
          END OF ty_zohotab.

    CLASS-DATA : wa_zohotab TYPE zdb_asset_master.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FI_ASSET_UPDATE IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

**********************************************************************

    DATA(curr_date) = cl_abap_context_info=>get_system_date( ).

    SELECT masterfixedasset,_asset_master~zohoassetcode,fixedassetdescription,assetadditionaldescription,assetserialnumber,inventory,
    costcenter,assetlocation,room,profitcenter,segment,accountisblockedforposting,_asset_master~creationdate,_asset_master~creationdatetime,
    lastchangedate,lastchangedatetime
    FROM zi_asset_master AS _asset_master
    LEFT OUTER JOIN zi_zoho_asset_master AS _zohoasset ON fixedasset = _asset_master~masterfixedasset
    WHERE lastchangedate = @curr_date
    AND _zohoasset~zohoassetcode IS NOT INITIAL
    INTO TABLE @DATA(it_asset).




    IF it_asset[] IS NOT INITIAL.

      DATA(lv_token) = zcl_zoho_asset_token=>tokenmethod( ).

      LOOP AT it_asset INTO DATA(wa_data).

        wa_final-data-_asset___code             = wa_data-masterfixedasset.
        SHIFT wa_final-data-_asset___code LEFT DELETING LEADING '0'.
        wa_final-data-_name                     = wa_data-fixedassetdescription.
        wa_final-data-_additional___description = wa_data-assetadditionaldescription.
        wa_final-data-_inventory___number       = wa_data-inventory.
        wa_final-data-_location                 = wa_data-assetlocation.
        wa_final-data-_serial___number          = wa_data-assetserialnumber.
        wa_final-data-_room                     = wa_data-room.
        wa_final-data-_segment                  = wa_data-segment.
        wa_final-data-_cost___center            = wa_data-costcenter.
        SHIFT wa_final-data-_cost___center LEFT DELETING LEADING '0'.
        wa_final-data-_profit___center          = wa_data-profitcenter.
        SHIFT wa_final-data-_profit___center LEFT DELETING LEADING '0'.
        wa_final-data-_sources                  = 'SAP'.
        IF wa_data-accountisblockedforposting = 'X'.
          wa_final-data-_status                   = 'Inactive'.
        ELSE.
          wa_final-data-_status                   = 'Active'.
        ENDIF.


        /ui2/cl_json=>serialize( EXPORTING data   = wa_final
                                 pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
                                 RECEIVING r_json = lv_json
        ).

**********************************************************************
**API Call

        CASE sy-sysid.
        WHEN lv_dev.
          lo_url = |https://glpl-nonprod-apim-02.azure-api.net/CreatorAssetMaster/report/All_Asset_Masters/{ wa_data-zohoassetcode }|.
          lv_sub_key = '802944882ff341c4a540281f5fef0edb'.
        WHEN lv_qas.
          lo_url = |https://glpl-nonprod-apim-02.azure-api.net/CreatorAssetMaster/report/All_Asset_Masters/{ wa_data-zohoassetcode }|.
          lv_sub_key = '802944882ff341c4a540281f5fef0edb'.
        WHEN lv_prd.
          lo_url = |https://glpl-prod-apim-02.azure-api.net/CreatorAssetMaster/report/All_Asset_Masters/{ wa_data-zohoassetcode }|.
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
                                i_method  = if_web_http_client=>put ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.


        DATA(status) = lv_response->get_status( ).
        DATA(lv_json_response) = lv_response->get_text( ).


        /ui2/cl_json=>deserialize( EXPORTING
                                          json        = lv_json_response
                                          pretty_name = /ui2/cl_json=>pretty_mode-low_case
                                   CHANGING
                                          data        = data
        ).

        IF data-code EQ 3000.
**updated successfully
          wa_zohotab-fixedasset       = wa_data-masterfixedasset.
          wa_zohotab-zohoassetcode    = data-data-id.
          wa_zohotab-creationdate     = wa_data-creationdate.
          wa_zohotab-creationdatetime = wa_data-creationdatetime.
          wa_zohotab-updateddate      = wa_data-lastchangedate.
          wa_zohotab-updateddatetime  = wa_data-lastchangedatetime.
          wa_zohotab-flag             = 'U'.

          MODIFY zdb_asset_master FROM @wa_zohotab.
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

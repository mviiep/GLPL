CLASS lhc_zi_asset_master DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

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
            _environment(4)           TYPE c,
            _status(8)                TYPE c,
          END OF ty_data.

    TYPES:BEGIN OF ty_final,
            data TYPE ty_data,
          END OF ty_final.

    DATA:wa_final TYPE ty_final.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN'.

    DATA: lo_url     TYPE string,
          lv_sub_key TYPE string.

    DATA:lv_json TYPE string.

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

    DATA : data TYPE ty_response.

    TYPES:BEGIN OF ty_zohotab,
            client(3)    TYPE c,
            fixedasset   TYPE i_fixedasset-masterfixedasset,
            zohocode(18) TYPE c,
          END OF ty_zohotab.

    DATA : wa_zohotab TYPE zdb_asset_master.

**********************************************************************

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_asset_master RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_asset_master RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_asset_master RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_asset_master.

    METHODS createasset FOR MODIFY
      IMPORTING keys FOR ACTION zi_asset_master~createasset RESULT result.

    METHODS updateasset FOR MODIFY
      IMPORTING keys FOR ACTION zi_asset_master~updateasset RESULT result.

ENDCLASS.

CLASS lhc_zi_asset_master IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD createasset.

    READ ENTITIES OF zi_asset_master IN LOCAL MODE
    ENTITY zi_asset_master
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(reported_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.



    SELECT SINGLE *
    FROM zi_zoho_asset_master
    WHERE fixedasset = @wa_key-masterfixedasset
    INTO @DATA(wa_zoho).

    DATA(lv_token) = zcl_zoho_asset_token=>tokenmethod( ).

    IF lv_token IS NOT INITIAL.

      IF wa_zoho-zohoassetcode IS INITIAL.



        SELECT SINGLE *
        FROM zi_asset_master
        WHERE masterfixedasset = @wa_key-masterfixedasset
        INTO @DATA(wa_data).


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


        CASE sy-sysid.
          WHEN lv_dev.
            wa_final-data-_environment              = 'DEV'.
          WHEN lv_qas.
            wa_final-data-_environment              = 'QAS'.
          WHEN lv_prd.
            wa_final-data-_environment              = 'PROD'.
        ENDCASE.

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
            lo_url = 'https://glpl-nonprod-apim-02.azure-api.net/CreatorAssetMaster/form/Asset_Master'.
            lv_sub_key = '802944882ff341c4a540281f5fef0edb'.
          WHEN lv_qas.
            lo_url = 'https://glpl-nonprod-apim-02.azure-api.net/CreatorAssetMaster/form/Asset_Master'.
            lv_sub_key = '802944882ff341c4a540281f5fef0edb'.
          WHEN lv_prd.
            lo_url = 'https://glpl-prod-apim-02.azure-api.net/CreatorAssetMaster/form/Asset_Master'.
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
                                          data        = data
        ).

        IF data-code EQ 3000.
**Successfully Created

          wa_zohotab-fixedasset       = wa_data-masterfixedasset.
          wa_zohotab-zohoassetcode    = data-data-id.
          wa_zohotab-creationdate     = wa_data-creationdate.
          wa_zohotab-creationdatetime = wa_data-creationdatetime.
          wa_zohotab-updateddate      = wa_data-lastchangedate.
          wa_zohotab-updateddatetime  = wa_data-lastchangedatetime.
          wa_zohotab-flag             = 'C'.


          MODIFY zdb_asset_master FROM @wa_zohotab.

          DATA(wa_msg) = me->new_message(
                                  id       = 'ZMSG_ASSET_MASTER'
                                  number   = 001
                                  severity = if_abap_behv_message=>severity-success
                                  v1       = wa_zohotab-zohoassetcode
                                ).

          DATA wa_record LIKE LINE OF reported-zi_asset_master.
          wa_record-%msg = wa_msg.
          APPEND wa_record TO reported-zi_asset_master.

        ELSEIF data-code EQ 3002.
**Missing Values in Mandatory Fields

          CONCATENATE data-error-serial_number data-error-name data-error-profit_center data-error-cost_center INTO DATA(errormsg) SEPARATED BY space.

          wa_msg = me->new_message(
                                          id       = 'ZMSG_ASSET_MASTER'
                                          number   = 005
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = errormsg
                                        ).

          wa_record-%msg = wa_msg.
          APPEND wa_record TO reported-zi_asset_master.


        ENDIF.

      ELSEIF wa_zoho-zohoassetcode IS NOT INITIAL.
**Zoho ID Already Present

        wa_msg = me->new_message(
                                id       = 'ZMSG_ASSET_MASTER'
                                number   = 002
                                severity = if_abap_behv_message=>severity-error
                                v1       = wa_zoho-zohoassetcode
                              ).

        wa_record-%msg = wa_msg.
        APPEND wa_record TO reported-zi_asset_master.


      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD updateasset.

    READ ENTITIES OF zi_asset_master IN LOCAL MODE
    ENTITY zi_asset_master
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(reported_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.


    SELECT SINGLE *
    FROM zi_asset_master
    WHERE masterfixedasset = @wa_key-masterfixedasset
    INTO @DATA(wa_data).

    IF wa_data-zohoassetcode IS NOT INITIAL.

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
*      wa_final-data-_purchase___date          = '28-Nov-2024'.
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

      DATA(lv_token) = zcl_zoho_asset_token=>tokenmethod( ).

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

        DATA(wa_msg) = me->new_message(
                                id       = 'ZMSG_ASSET_MASTER'
                                number   = 003
                                severity = if_abap_behv_message=>severity-success
                                v1       = wa_zohotab-zohoassetcode
                              ).

        DATA wa_record LIKE LINE OF reported-zi_asset_master.
        wa_record-%msg = wa_msg.
        APPEND wa_record TO reported-zi_asset_master.

      ELSE.
**Error while Updating

        wa_msg = me->new_message(
                                        id       = 'ZMSG_ASSET_MASTER'
                                        number   = 004
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = wa_zohotab-zohoassetcode
                                      ).

        wa_record-%msg = wa_msg.
        APPEND wa_record TO reported-zi_asset_master.

      ENDIF.

    ELSEIF wa_data-zohoassetcode IS INITIAL.
**Asset is not created

      wa_msg = me->new_message(
                              id       = 'ZMSG_ASSET_MASTER'
                              number   = 006
                              severity = if_abap_behv_message=>severity-error
                            ).

      wa_record-%msg = wa_msg.
      APPEND wa_record TO reported-zi_asset_master.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_asset_master DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_asset_master IMPLEMENTATION.

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

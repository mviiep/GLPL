CLASS lhc_zi_supplier_master DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR supplier RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE supplier.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE supplier.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE supplier.

    METHODS read FOR READ
      IMPORTING keys FOR READ supplier RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK supplier.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR supplier RESULT result.
    METHODS createsupplier FOR MODIFY
      IMPORTING keys FOR ACTION supplier~createsupplier RESULT result.
    METHODS updatesupplier FOR MODIFY
      IMPORTING keys FOR ACTION supplier~updatesupplier RESULT result.


ENDCLASS.

CLASS lhc_zi_supplier_master IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD createsupplier.
    DATA: lv_url           TYPE string , "VALUE 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors',
          lv_token_url     TYPE string VALUE 'https://glpl-nonprod-apim-02.azure-api.net/crmsandboxtoken/',
          lo_http_client   TYPE REF TO if_web_http_client,
          lv_payload       TYPE string,
          lv_token_payload TYPE string.

    DATA: lt_data TYPE TABLE OF string,
          ls_item TYPE string.

    DATA : lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN'.


    TYPES: BEGIN OF ty_data,
             code    TYPE c LENGTH 10,
             details TYPE c LENGTH 100,
             message TYPE c LENGTH 30,
             status  TYPE c LENGTH 10,
           END OF ty_data.


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



    DATA lr_data TYPE REF TO data.

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <templates>           TYPE data,
      <templates_result>    TYPE any,
      <metafield_result>    TYPE data,
      <metadata_result>     TYPE data,
      <metadata>            TYPE STANDARD TABLE,
      <pdf_based64_encoded> TYPE any.

    DATA : data TYPE TABLE OF ty_data WITH EMPTY KEY.
    DATA : wa_id TYPE zmm_supplier.


    DATA(it_keys) = keys.

    READ TABLE it_keys  INTO DATA(wa_data) INDEX 1.
    DATA(wa_keys) =  wa_data.

    SELECT *
    FROM  zi_supplier_master
    WHERE supplier = @wa_keys-supplier INTO TABLE @DATA(it_supplier).

    DATA : lv_sys TYPE string .
    DATA: wa_zmm_supplier TYPE zmm_supplier.
    LOOP AT it_supplier INTO DATA(wa_supplier).

      CONSTANTS : c_true  TYPE string VALUE 'true',
                  c_false TYPE string VALUE 'false'.


      IF wa_supplier-invoice EQ 'X'.
        DATA(lv_invoice)  = c_true.
      ELSE.
        lv_invoice  = c_false.
      ENDIF.

      CASE sy-sysid.
        WHEN lv_dev.
          lv_sys = 'DEV'.
          DATA(lv_layout) = '723303000000000191'.
        WHEN lv_qas.
          lv_sys = 'QAS'.
          lv_layout = '723303000000000191'.
        WHEN lv_prd.
          lv_sys = 'PROD'.
          lv_layout = '726575000000000191'.
      ENDCASE.





      lv_payload = '{"data":[{' &&
                '"GSTIN":' && '"' && wa_supplier-taxnumberlong_gst && '"' && ',' &&
                '"State_Province_Code":' && '"' && wa_supplier-region && '"' && ',' &&
                '"Layout": {' &&
                  '"id":' &&
                  | "{ lv_layout }" | &&
                  ' }, ' &&
                '"Countries":' && '"' && wa_supplier-country && '"' && ',' &&
                  '"Street_3":' && '"' && wa_supplier-street2 && '"' && ',' &&
                  '"Street_2":' && '"' && wa_supplier-street3 && '"' && ',' &&
                  '"Contract_Status":null,' &&
                  '"Terms_Of_Payment":' && '"' && wa_supplier-payment && '"' && ',' &&
                  '"Vendor_Email":' && '"' && wa_supplier-email && '"' && ',' &&
                  '"Schema_Group_Supplier":' && '"' && wa_supplier-groupsupplier && '"' && ',' &&
                  '"Postal_Code":' && '"' && wa_supplier-postalcode && '"' && ',' &&
*                  '"Status":"Inactive",' &&
                  '"Status":"Active",' &&
                  '"Tax_Number_Category":' && '"' && wa_supplier-taxnumbercategory_gst && '"' && ',' &&
                  '"City":' && '"' && wa_supplier-bpaddrcityname && '"' && ',' &&
                  '"Sources":"SAP",' &&
                  '"Reminder_To_Renew":null,' &&
                  '"Country_Code":' && '"' && wa_supplier-country && '"' && ',' &&
                  '"Vendor_Phone":' && '"' && wa_supplier-phonenumber2 && '"' && ',' &&
                  '"Services_Provided":null,' &&
                  '"Annual_Revenue":"1",' &&
                  '"Name_3":' && '"' && wa_supplier-businesspartnername3 && '"' && ',' &&
*                  '"Title_Code":' && '"' && wa_supplier-title && '"' && ',' &&
                  '"Title":' && '"' && wa_supplier-title && '"' && ',' &&
                  '"District":' && '"' && wa_supplier-districtname && '"' && ',' &&
                  '"Name_2":' && '"' && wa_supplier-businesspartnername2 && '"' && ',' &&
                  '"Street_Address":' && '"' && wa_supplier-bpaddrstreetname && '"' && ',' &&
                  '"Purchase_Org":' && '"' && wa_supplier-purchaseorg && '"' && ',' &&
                  '"Vendor_Name":' && '"' && wa_supplier-suppliername && '"' && ',' &&
                  '"State_Province":"Maharashtra",' &&
                 '"Tax_Number_Long":' && '"' && wa_supplier-taxnumberlong_msme && '"' && ',' &&
                  '"Supplier_Code":' && '"' && wa_supplier-supplier && '"' && ',' &&
                  '"Bp_Group":' && '"' && wa_supplier-supplieraccountgroup && '"' && ',' &&
                  '"Number_of_Employees":"1",' &&
                  '"Language":' && '"' && wa_supplier-supplierlanguage && '"' && ',' &&
                  '"Bp_Group_Code":"ZDOM",' &&
                   '"Zoho_ID":' && '"' && wa_supplier-res_supplier && '"' && ',' &&
                  '"Vendor_Mobile":' && '"' && wa_supplier-phonenumber1 && '"' && ',' &&
                  '"Environment": ' && lv_sys && ',' &&
                  '"Company_Code":' && '"' && wa_supplier-companycode && '"' && ',' &&
                  '"Contract_End_Date":null,' &&
                  '"Year_Established":123,' &&
                  '"Industry_Category":null,' &&
                  '"GR_Based_Invoice_Verified":' && lv_invoice && ',' &&
                 '"Contract_Start_Date":null,' &&
                  '"Terms_Of_Payment_Code":"V045",' &&
                  '"GL_Account":"Sales-Software",' &&
                  '"House_Number":' && '"' && wa_supplier-house && '"' && ',' &&
                  '"PAN":' && '"' && wa_supplier-businesspartnerpannumber && '"' && ',' &&
                  '"FAX":' && '"' && wa_supplier-faxnumber && '"' && ',' &&
                  '"Property_Name":null,' &&
                  '"Search_Term_1":' && '"' && wa_supplier-addresssearchterm1 && '"' && ',' &&
                  '}]}'.
      IF wa_supplier-res_supplier IS INITIAL.

        DATA: lv_sub_key  TYPE string.
        CASE sy-sysid.
          WHEN lv_dev.
            lv_url = 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors'.
            lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
          WHEN lv_qas.
            lv_url = 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors'.
            lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
          WHEN lv_prd.
            lv_url = 'https://glpl-prod-apim-02.azure-api.net/suppliers/Vendors'.
            lv_sub_key = '90dee5bd8a9d415c924fa4dc008d91ee'.
        ENDCASE.

        TRY.
            lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
            i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

        DATA(lo_request) = lo_http_client->get_http_request( ).

        DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).
        lo_request->set_header_fields(
        VALUE #(
                ( name = 'Content-Type'  value = 'application/json' )
                ( name = 'Cache-Control' value = 'no-cache' )
                ( name = 'Ocp-Apim-Subscription-Key' value =  lv_sub_key )
*            ( name = 'Authorization' value = 'Bearer 1000.26c1be0b5324331934399579d6475d8f.28c77d31b0d6daf02eb9add6959969de' )
                 ( name = 'Authorization' value = lv_token )
               ) ).


        lo_request->append_text(
              EXPORTING
                data   = lv_payload
            ).

        TRY.
            DATA(lv_response) = lo_http_client->execute(
                                i_method  = if_web_http_client=>post ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.
        DATA(status) = lv_response->get_status( ).
        DATA(response_text) = lv_response->get_text( ).

        CLEAR: lv_invoice.
        DATA(json) = response_text.

        /ui2/cl_json=>deserialize(
          EXPORTING
            json             =  CONV #( json )
*    jsonx            =
         pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
*    assoc_arrays     =
*    assoc_arrays_opt =
*    name_mappings    =
*    conversion_exits =
*    hex_as_base64    =
          CHANGING
            data             = data
        ).

        lr_data = /ui2/cl_json=>generate( json = response_text  pretty_name  = /ui2/cl_json=>pretty_mode-user ).



        ASSIGN lr_data->* TO <data>.
        IF <data> IS ASSIGNED.
          ASSIGN COMPONENT 'DATA' OF STRUCTURE <data> TO <templates>.
        ENDIF.

        IF <templates> IS ASSIGNED.
          ASSIGN <templates>->* TO <templates_result>.
        ENDIF.

        IF <templates_result> IS ASSIGNED.
          ASSIGN <templates_result> TO <metadata>.
        ENDIF.

        IF <metadata> IS ASSIGNED.
          READ TABLE <metadata> ASSIGNING FIELD-SYMBOL(<metafield>) INDEX 1.
        ENDIF.

        IF <metafield> IS ASSIGNED.
          ASSIGN <metafield>->* TO <metafield_result>.
        ENDIF.

        IF <metafield_result> IS ASSIGNED.
          ASSIGN COMPONENT 'DETAILS' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata1>).
        ENDIF.
        IF  <mdata1> IS ASSIGNED.
          ASSIGN <mdata1>->* TO FIELD-SYMBOL(<mdata_result1>).
        ENDIF.

        IF <mdata_result1> IS ASSIGNED.
          ASSIGN COMPONENT 'ID' OF STRUCTURE <mdata_result1> TO FIELD-SYMBOL(<mdata2>).
        ENDIF.
        IF <mdata2> IS ASSIGNED.
          ASSIGN <mdata2>->* TO FIELD-SYMBOL(<mdata_result2>).
        ENDIF.
        IF <mdata_result2> IS ASSIGNED.


          wa_zmm_supplier-supplier = wa_supplier-supplier.
          wa_zmm_supplier-cr_time  = sy-uzeit.
          wa_zmm_supplier-cr_date  =  sy-datum.
          wa_zmm_supplier-flag = 'C'.
*      wa_zmm_supplier-res_supplier = <mdata_result3>.

          wa_zmm_supplier-res_supplier = <mdata_result2>.
          wa_zmm_supplier-status    = '201'.
          wa_zmm_supplier-msg       = 'Successfully Created'.

          wa_zmm_supplier-supplier = |{ wa_zmm_supplier-supplier ALPHA = IN }|.

          MODIFY zmm_supplier FROM @wa_zmm_supplier.
*          UPDATE zmm_supplier SET msg = 'Successfully Created',  cr_time = @wa_zmm_supplier-cr_time,
*                                cr_date = @wa_zmm_supplier-cr_date  WHERE supplier = @wa_keys-supplier.
        ENDIF.

        IF  wa_zmm_supplier-res_supplier IS NOT INITIAL.
          DATA(wa_msg) = me->new_message(
                               id       = 'ZMSG_SUPPLIER'
                               number   = 001
*                               severity = if_abap_behv_message=>severity-none
                                  severity = if_abap_behv_message=>severity-success
*                               v1       = wa_error-results-errormessage
                                v1       = wa_zmm_supplier-supplier
                             ).

          DATA wa_record LIKE LINE OF reported-supplier.
          wa_record-supplier = wa_zmm_supplier-res_supplier.
          wa_record-%msg = wa_msg.
          APPEND wa_record TO reported-supplier.
        ELSE.

          IF <data> IS ASSIGNED.
            ASSIGN COMPONENT 'DATA' OF STRUCTURE <data> TO <templates>.
            IF <templates> IS ASSIGNED.
              ASSIGN <templates>->* TO <templates_result>.
            ENDIF.
            IF <templates_result> IS ASSIGNED.
              ASSIGN <templates_result> TO <metadata>.
            ENDIF.
            IF <metadata> IS ASSIGNED.
              READ TABLE <metadata> ASSIGNING FIELD-SYMBOL(<metafield_1>) INDEX 1.
            ENDIF.
            IF <metafield_1> IS ASSIGNED.
              ASSIGN <metafield_1>->* TO <metafield_result>.
            ENDIF.
            IF  <metafield_result> IS ASSIGNED.
              ASSIGN COMPONENT 'DETAILS' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata_1>).
            ENDIF.
            IF <mdata_1> IS ASSIGNED.
              ASSIGN <mdata_1>->* TO FIELD-SYMBOL(<mdata_result_1>).
            ENDIF.
            IF <mdata_result_1> IS ASSIGNED.
              ASSIGN COMPONENT 'API_NAME' OF STRUCTURE <mdata_result_1> TO FIELD-SYMBOL(<mdata_2>).
            ENDIF.
            IF <mdata_2> IS ASSIGNED.
              ASSIGN <mdata_2>->* TO FIELD-SYMBOL(<mdata_result_2>).
            ENDIF.

            IF <mdata_result_2> IS ASSIGNED.
              ASSIGN COMPONENT 'MAXIMUM_LENGTH' OF STRUCTURE <mdata_result_1> TO FIELD-SYMBOL(<mdata_3>).
            ENDIF.
            IF <mdata_3> IS ASSIGNED.
              ASSIGN <mdata_3>->* TO FIELD-SYMBOL(<mdata_result_3>).
            ENDIF.
            IF <metafield_result> IS ASSIGNED.
              ASSIGN COMPONENT 'MESSAGE' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata_4>).
            ENDIF.
            IF <mdata_4> IS ASSIGNED.
              ASSIGN <mdata_4>->* TO FIELD-SYMBOL(<mdata_result_4>).
            ENDIF.
          ENDIF.

          DATA : lv_msg TYPE  char20.
          DATA : lv_msg1 TYPE char20.
          DATA : lv_msg2 TYPE char20.

          IF <mdata_result_2> IS ASSIGNED.
            lv_msg  =    <mdata_result_2>.
          ENDIF.
          IF <mdata_result_3> IS ASSIGNED.
            lv_msg1 =    <mdata_result_3>.
          ENDIF.
          IF <mdata_result_4> IS ASSIGNED.
            lv_msg2 =    <mdata_result_4>.
          ENDIF.

          CONCATENATE lv_msg lv_msg1 lv_msg2 'for Supplier' wa_supplier-supplier  INTO DATA(lv_text) SEPARATED BY space.

          wa_zmm_supplier-supplier   = wa_supplier-supplier.
          wa_zmm_supplier-status    = '202'.
          wa_zmm_supplier-cr_time  = sy-uzeit.
          wa_zmm_supplier-cr_date  =  sy-datum.
*          wa_zmm_supplier-flag = 'C'.
          wa_zmm_supplier-msg       = lv_text.
          wa_zmm_supplier-supplier = |{ wa_zmm_supplier-supplier ALPHA = IN }|.
          MODIFY zmm_supplier FROM @wa_zmm_supplier.
*          UPDATE zmm_supplier SET msg = 'Successfully Created',  cr_time = @wa_zmm_supplier-cr_time,
*                      cr_date = @wa_zmm_supplier-cr_date  WHERE supplier = @wa_keys-supplier.


          wa_msg = me->new_message(
                                id       = 'ZMSG_SUPPLIER'
                                number   = 002
*                                severity = if_abap_behv_message=>severity-error
                                   severity = if_abap_behv_message=>severity-success
                                v1       = lv_text
                              ).
          wa_record-supplier =  wa_zmm_supplier-res_supplier.
          wa_record-%msg = wa_msg.
          APPEND wa_record TO reported-supplier.
        ENDIF.
      ELSE.
        wa_msg = me->new_message(
                                 id       = 'ZMSG_SUPPLIER'
                                 number   = 003
                                 severity = if_abap_behv_message=>severity-error
                                 v1       =  wa_supplier-supplier
                               ).
        wa_record-supplier =  wa_zmm_supplier-res_supplier.
        wa_record-%msg = wa_msg.
        APPEND wa_record TO reported-supplier.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD updatesupplier.

    DATA: lv_url         TYPE string VALUE 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors/'.
    DATA: lo_http_client TYPE REF TO if_web_http_client,
          lv_payload     TYPE string.

    DATA: lt_data TYPE TABLE OF string,
          ls_item TYPE string.


    TYPES: BEGIN OF ty_data,
             code    TYPE char10,
             details TYPE char100,
             message TYPE char30,
             status  TYPE char10,
           END OF ty_data.

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
    DATA: wa_zmm_supplier TYPE zmm_supplier.


    DATA lr_data TYPE REF TO data.

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <templates>           TYPE data,
      <templates_result>    TYPE any,
      <metafield_result>    TYPE data,
      <metadata_result>     TYPE data,
      <metadata>            TYPE STANDARD TABLE,
      <pdf_based64_encoded> TYPE any.



    DATA : data TYPE TABLE OF ty_data WITH EMPTY KEY.
    DATA : wa_id TYPE zmm_supplier.



    DATA(it_keys) = keys.

    READ TABLE it_keys  INTO DATA(wa_data) INDEX 1.
    DATA(wa_keys) =  wa_data.

    SELECT *
    FROM  zi_supplier_master
    WHERE supplier = @wa_keys-supplier INTO TABLE @DATA(it_supplier).




*    loop at it_supplier


*    READ TABLE it_supplier INTO DATA(wa_supplier) INDEX 1.

    DATA : lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'KSZ',
           lv_sys    TYPE string.

    DATA: lv_string  TYPE  string.

    LOOP AT it_supplier INTO DATA(wa_supplier).


      CONSTANTS : c_true  TYPE string VALUE 'True',
                  c_false TYPE string VALUE 'False'.

      IF wa_supplier-invoice EQ 'X'.
        DATA(lv_invoice)  = c_true.
      ELSE.
        lv_invoice  = c_false.
      ENDIF.

      CASE sy-sysid.
        WHEN lv_dev.
          lv_sys = 'DEV'.
        WHEN lv_qas.
          lv_sys = 'QAS'.
        WHEN lv_prd.
          lv_sys = 'PROD'.
      ENDCASE.

      CONCATENATE lv_url wa_supplier-res_supplier INTO lv_string .

      CASE sy-sysid.
        WHEN lv_dev.
          lv_sys = 'DEV'.
          DATA(lv_layout) = '723303000000000191'.
        WHEN lv_qas.
          lv_sys = 'QAS'.
          lv_layout = '723303000000000191'.
        WHEN lv_prd.
          lv_sys = 'PROD'.
          lv_layout = '726575000000000191'.
      ENDCASE.

      lv_payload = '{"data":[{' &&
                '"GSTIN":' && '"' && wa_supplier-taxnumberlong_gst && '"' && ',' &&
                '"State_Province_Code":' && '"' && wa_supplier-region && '"' && ',' &&
                '"Layout": {' &&
                  '"id":' &&
                  | "{ lv_layout }" | &&
                  ' }, ' &&
                '"Countries":' && '"' && wa_supplier-country && '"' && ',' &&
                  '"Street_3":' && '"' && wa_supplier-street2 && '"' && ',' &&
                  '"Street_2":' && '"' && wa_supplier-street3 && '"' && ',' &&
                  '"Contract_Status":null,' &&
                  '"Terms_Of_Payment":' && '"' && wa_supplier-payment && '"' && ',' &&
                  '"Vendor_Email":' && '"' && wa_supplier-email && '"' && ',' &&
                  '"Schema_Group_Supplier":' && '"' && wa_supplier-groupsupplier && '"' && ',' &&
                  '"Postal_Code":' && '"' && wa_supplier-postalcode && '"' && ',' &&
                  '"Status":"Active",' &&
                  '"Tax_Number_Category":' && '"' && wa_supplier-taxnumbercategory_gst && '"' && ',' &&
                  '"City":' && '"' && wa_supplier-bpaddrcityname && '"' && ',' &&
                  '"Sources":"SAP",' &&
                  '"Reminder_To_Renew":null,' &&
                  '"Country_Code":' && '"' && wa_supplier-country && '"' && ',' &&
                  '"Vendor_Phone":' && '"' && wa_supplier-phonenumber2 && '"' && ',' &&
                  '"Services_Provided":null,' &&
                  '"Annual_Revenue":"1",' &&
                  '"Name_3":' && '"' && wa_supplier-businesspartnername3 && '"' && ',' &&
                  '"Title":' && '"' && wa_supplier-title && '"' && ',' &&
                  '"District":' && '"' && wa_supplier-districtname && '"' && ',' &&
                  '"Name_2":' && '"' && wa_supplier-businesspartnername2 && '"' && ',' &&
                  '"Street_Address":' && '"' && wa_supplier-bpaddrstreetname && '"' && ',' &&
                  '"Purchase_Org":' && '"' && wa_supplier-purchaseorg && '"' && ',' &&
                  '"Vendor_Name":' && '"' && wa_supplier-suppliername && '"' && ',' &&
                  '"State_Province":"Maharashtra",' &&
                  '"Tax_Number_Long":' && '"' && wa_supplier-taxnumberlong_msme && '"' && ',' &&
                  '"Supplier_Code":' && '"' && wa_supplier-supplier && '"' && ',' &&
                  '"Bp_Group":' && '"' && wa_supplier-supplieraccountgroup && '"' && ',' &&
                  '"Number_of_Employees":"1",' &&
                  '"Language":' && '"' && wa_supplier-supplierlanguage && '"' && ',' &&
                  '"Bp_Group_Code":"ZDOM",' &&
                  '"Zoho_ID":' && '"' && wa_supplier-res_supplier && '"' && ',' &&
                  '"Vendor_Mobile":' && '"' && wa_supplier-phonenumber1 && '"' && ',' &&
                   '"Environment": ' && lv_sys && ',' &&
                  '"Company_Code":' && '"' && wa_supplier-companycode && '"' && ',' &&
                  '"Contract_End_Date":null,' &&
                  '"Year_Established":123,' &&
                  '"Industry_Category":null,' &&
                  '"GR_Based_Invoice_Verified":' && lv_invoice && ',' &&
                 '"Contract_Start_Date":null,' &&
                  '"Terms_Of_Payment_Code":"V045",' &&
                  '"GL_Account":"Sales-Software",' &&
                  '"House_Number":' && '"' && wa_supplier-house && '"' && ',' &&
                  '"PAN":' && '"' && wa_supplier-businesspartnerpannumber && '"' && ',' &&
                  '"FAX":' && '"' && wa_supplier-faxnumber && '"' && ',' &&
                  '"Property_Name":null,' &&
                  '"Search_Term_1":' && '"' && wa_supplier-addresssearchterm1 && '"' && '}]}'.

      TRY.
          lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
          i_destination = cl_http_destination_provider=>create_by_url( lv_string ) ).
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
              data   = lv_payload
          ).


      TRY.
          DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>put ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.
      DATA(status) = lv_response->get_status( ).
      DATA(response_text) = lv_response->get_text( ).


      DATA(json) = response_text.

      /ui2/cl_json=>deserialize(
        EXPORTING
          json             =  CONV #( json )
*    jsonx            =
       pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
*    assoc_arrays     =
*    assoc_arrays_opt =
*    name_mappings    =
*    conversion_exits =
*    hex_as_base64    =
        CHANGING
          data             = data
      ).

      lr_data = /ui2/cl_json=>generate( json = response_text  pretty_name  = /ui2/cl_json=>pretty_mode-user ).



      ASSIGN lr_data->* TO <data>.
      IF <data> IS ASSIGNED.
        ASSIGN COMPONENT 'DATA' OF STRUCTURE <data> TO <templates>.
        IF <templates> IS ASSIGNED.
          ASSIGN <templates>->* TO <templates_result>.
        ENDIF.
        IF <templates_result> IS ASSIGNED.
          ASSIGN <templates_result> TO <metadata>.
        ENDIF.
        IF <metadata> IS ASSIGNED.
          READ TABLE <metadata> ASSIGNING FIELD-SYMBOL(<metafield>) INDEX 1.
        ENDIF.
        IF <metafield> IS ASSIGNED.
          ASSIGN <metafield>->* TO <metafield_result>.
        ENDIF.
        IF <metafield_result> IS ASSIGNED.
          ASSIGN COMPONENT 'DETAILS' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata1>).
        ENDIF.
        IF <mdata1> IS ASSIGNED.
          ASSIGN <mdata1>->* TO FIELD-SYMBOL(<mdata_result1>).
        ENDIF.

        IF <mdata_result1> IS ASSIGNED.
          ASSIGN COMPONENT 'ID' OF STRUCTURE <mdata_result1> TO FIELD-SYMBOL(<mdata2>).
        ENDIF.
        IF <mdata2> IS ASSIGNED.
          ASSIGN <mdata2>->* TO FIELD-SYMBOL(<mdata_result2>).
        ENDIF.
        IF <metafield_result> IS ASSIGNED.
          ASSIGN COMPONENT 'STATUS' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata3>).
        ENDIF.
        IF <mdata3> IS ASSIGNED.
          ASSIGN <mdata3>->* TO FIELD-SYMBOL(<mdata_result3>).
        ENDIF.
      ENDIF.
      IF <mdata_result3> IS ASSIGNED.
        IF <mdata_result3> EQ 'success'.


          IF <mdata_result2> IS ASSIGNED.

            wa_zmm_supplier-supplier = wa_supplier-supplier.
*      wa_zmm_supplier-res_supplier = <mdata_result3>.
            wa_zmm_supplier-ch_time  = sy-uzeit.
            wa_zmm_supplier-ch_date  =  sy-datum.
            wa_zmm_supplier-flag = 'U'.
            wa_zmm_supplier-res_supplier = <mdata_result2>.
            wa_zmm_supplier-status    = '200'.
            wa_zmm_supplier-msg       = 'Successfully Updated'.

            wa_zmm_supplier-supplier = |{ wa_zmm_supplier-supplier ALPHA = IN }|.

*          update zmm_supplier FROM @wa_zmm_supplier.
            UPDATE zmm_supplier SET msg = 'Successfully Updated',  ch_time = @wa_zmm_supplier-ch_time, flag = @wa_zmm_supplier-flag,
            ch_date = @wa_zmm_supplier-ch_date  WHERE supplier = @wa_keys-supplier.

          ENDIF.

          DATA(wa_msg) = me->new_message(
                               id       = 'ZMSG_SUPPLIER'
                               number   = 004
*                               severity = if_abap_behv_message=>severity-none
                                 severity = if_abap_behv_message=>severity-success
*                               v1       = wa_error-results-errormessage
                              v1       = wa_supplier-supplier
                             ).


          DATA wa_record LIKE LINE OF reported-supplier.
          wa_record-supplier = wa_zmm_supplier-res_supplier.
          wa_record-%msg = wa_msg.
          APPEND wa_record TO reported-supplier.
        ELSE.
          IF <mdata_result2> IS ASSIGNED.
            wa_zmm_supplier-supplier = wa_supplier-supplier.
*      wa_zmm_supplier-res_supplier = <mdata_result3>.

            wa_zmm_supplier-res_supplier = <mdata_result2>.
            wa_zmm_supplier-ch_time  = sy-uzeit.
            wa_zmm_supplier-ch_date  =  sy-datum.
            wa_zmm_supplier-status    = '200'.
            wa_zmm_supplier-msg       = 'Successfully Updated'.

            wa_zmm_supplier-supplier = |{ wa_zmm_supplier-supplier ALPHA = IN }|.
*            MODIFY zmm_supplier FROM @wa_zmm_supplier.
            INSERT zmm_supplier FROM @wa_zmm_supplier.


            wa_msg = me->new_message(
                                id       = 'ZMSG_SERVICE_MAT'
                                number   = 005
                                severity = if_abap_behv_message=>severity-error
                                v1       = wa_supplier-supplier
                              ).

            wa_record-supplier =  wa_zmm_supplier-res_supplier.
            wa_record-%msg = wa_msg.
            APPEND wa_record TO reported-supplier.
          ENDIF.

        ENDIF.
      ENDIF.


    ENDLOOP .
  ENDMETHOD.

ENDCLASS.


CLASS lsc_zi_supplier_master DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_supplier_master IMPLEMENTATION.

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

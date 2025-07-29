CLASS zbp_i_supplier_api_upt DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS update_supplier.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBP_I_SUPPLIER_API_UPT IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    me->update_supplier(  ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
      CATCH cx_apj_rt_content.                          "#EC NO_HANDLER
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD update_supplier.

    DATA: lv_url         TYPE string . " VALUE 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors/'.
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


    DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).

    SELECT a~invoice,b~res_supplier,a~supplier,a~taxnumberlong_gst,a~region,a~country,a~street2,a~street3,a~payment,
    a~email,a~groupsupplier,a~postalcode,a~taxnumbercategory_gst,a~bpaddrcityname,a~phonenumber2,a~businesspartnername3,
     a~title,a~districtname,a~businesspartnername2,a~bpaddrstreetname,a~purchaseorg,a~suppliername,a~taxnumberlong_msme,
     a~supplieraccountgroup,a~supplierlanguage,a~phonenumber1,a~companycode,a~house,a~businesspartnerpannumber,
     a~faxnumber,a~addresssearchterm1
    FROM  zi_supplier_master AS a LEFT OUTER JOIN zmm_supplier AS b ON b~supplier = a~supplier
    WHERE  a~lastchangedate = @lv_current_date AND b~res_supplier IS NOT INITIAL
    INTO TABLE @DATA(it_supplier).


*    SELECT *
*    FROM  zi_supplier_master
*    WHERE lc_date = @lv_current_date
*     INTO TABLE @DATA(it_supplier).
*
*    SELECT supplier
*    FROM zmm_supplier
*    WHERE res_supplier IS NOT INITIAL
*    INTO TABLE @DATA(it_data).
**
**
*    SORT it_supplier BY supplier.
*    SORT it_data BY supplier.
**
**
*    LOOP AT it_supplier INTO DATA(wa_supplier) .
*      READ TABLE  it_data INTO DATA(wa_data) WITH KEY  supplier = wa_supplier-supplier.
*      IF sy-subrc IS INITIAL.
*        DELETE it_supplier WHERE supplier = wa_supplier-supplier.
*      ENDIF.
*      CLEAR: wa_supplier, wa_data.
*
*    ENDLOOP.




    DATA : lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN',
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

            data: lv_sub_key  type string.
 CASE sy-sysid.
          WHEN lv_dev.
            lv_url = 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors/'.
            lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
          WHEN lv_qas.
          lv_url = 'https://glpl-nonprod-apim-02.azure-api.net/suppliers/Vendors/'.
            lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
          WHEN lv_prd.
            lv_url = 'https://glpl-prod-apim-02.azure-api.net/suppliers/Vendors/'.
            lv_sub_key = '90dee5bd8a9d415c924fa4dc008d91ee'.
        ENDCASE.


      CONCATENATE lv_url wa_supplier-res_supplier INTO lv_string .

*      CONCATENATE lv_url wa_supplier-res_supplier INTO lv_string .

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
              ( name = 'Ocp-Apim-Subscription-Key' value =  lv_sub_key )
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

      IF <mdata_result3> EQ 'success'.

        IF <mdata_result2> IS ASSIGNED.

          wa_zmm_supplier-supplier = wa_supplier-supplier.
*      wa_zmm_supplier-res_supplier = <mdata_result3>.

          wa_zmm_supplier-ch_date = sy-datum.
          wa_zmm_supplier-ch_time = sy-uzeit.
          wa_zmm_supplier-flag = 'U'.
          wa_zmm_supplier-res_supplier = <mdata_result2>.
          wa_zmm_supplier-status    = '200'.
          wa_zmm_supplier-msg       = 'Successfully Updated'.

          wa_zmm_supplier-supplier = |{ wa_zmm_supplier-supplier ALPHA = IN }|.

*          MODIFY zmm_supplier FROM @wa_zmm_supplier.
          INSERT zmm_supplier FROM @wa_zmm_supplier.
          CLEAR <mdata_result2>.
        ENDIF.

*        DATA(wa_msg) = me->new_message(
*                             id       = 'ZMSG_SUPPLIER'
*                             number   = 004
**                               severity = if_abap_behv_message=>severity-none
*                               severity = if_abap_behv_message=>severity-success
**                               v1       = wa_error-results-errormessage
*                            v1       = wa_supplier-supplier
*                           ).
*
*
*        DATA wa_record LIKE LINE OF reported-supplier.
*        wa_record-supplier = wa_zmm_supplier-res_supplier.
*        wa_record-%msg = wa_msg.
*        APPEND wa_record TO reported-supplier.
      ELSE.
        IF <mdata_result2> IS ASSIGNED.
          wa_zmm_supplier-supplier = wa_supplier-supplier.
*      wa_zmm_supplier-res_supplier = <mdata_result3>.
          wa_zmm_supplier-ch_date = sy-datum.
          wa_zmm_supplier-ch_time = sy-uzeit.
          wa_zmm_supplier-flag = 'U'.

          wa_zmm_supplier-res_supplier = <mdata_result2>.
          wa_zmm_supplier-status    = '202'.
          wa_zmm_supplier-msg       = 'Successfully Updated'.

          wa_zmm_supplier-supplier = |{ wa_zmm_supplier-supplier ALPHA = IN }|.
*          MODIFY zmm_supplier FROM @wa_zmm_supplier.
          INSERT zmm_supplier FROM @wa_zmm_supplier.
          CLEAR <mdata_result2>.

*          wa_msg = me->new_message(
*                              id       = 'ZMSG_SERVICE_MAT'
*                              number   = 005
*                              severity = if_abap_behv_message=>severity-error
*                              v1       = wa_supplier-supplier
*                            ).
*
*          wa_record-supplier =  wa_zmm_supplier-res_supplier.
*          wa_record-%msg = wa_msg.
*          APPEND wa_record TO reported-supplier.
        ENDIF.

*        ENDIF.
      ENDIF.


    ENDLOOP .
  ENDMETHOD.
ENDCLASS.

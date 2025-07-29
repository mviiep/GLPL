CLASS zc_i_customer_jobs DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS customer.
ENDCLASS.



CLASS ZC_I_CUSTOMER_JOBS IMPLEMENTATION.


  METHOD customer.

    TYPES: BEGIN OF ty_sap_line_information,
             _terms___of___payment___code TYPE string,
             _terms___of___payments       TYPE string,
             _division                    TYPE string,
             _division___code             TYPE string,
           END OF ty_sap_line_information.

    TYPES: BEGIN OF ty_data,
             _customer___code(10),
             _search___term(5),
             _account___name(30),
             _name2(30),
             _name3(30),
             _street___name(30),
             _street__2(30),
             _street3(30),
             _house___number(2),
             _city___name(20),
             _district(20),
             _country___code(2),
             _country___description(20),
             _region___code(2),
             _region___description(20),
             _p_o_box(10),
             _postal__code(10),
             _language___code(2),
             _telephone(15),
             _mobile___phone(15),
             _fax(20),
             _email(40),
             _pan___no(20),
             _tax___number___category___cod(3),
             _tax___number___long(15),
             _company___code                   TYPE i,
             _reconciliation___account         TYPE string,
             _reconciliation___account1        TYPE string,
             _sales___organization___code      TYPE string,
             _distribution___channel___code    TYPE string,
             _distribution___channel2          TYPE string,
             _sales_district___code            TYPE string,
             _sales_district___description     TYPE string,
             _currency___code                  TYPE string,
             _currency___description           TYPE string,
             _cust___pric___procedure3         TYPE string,
             _cust___pric___procedure4         TYPE string,
             _acct___assmt___grp___c5          TYPE string,
             _acct___assmt___grp___c6          TYPE string,
             _tax___category_1___code          TYPE string,
             _tax___classification_1___code    TYPE string,
             _tax___classification_1           TYPE string,
             _tax___category_2___code          TYPE string,
             _tax___classification_2___code    TYPE string,
             _tax___classification_2           TYPE string,
             _tax___category_3___code          TYPE string,
             _tax___classification_3___code    TYPE string,
             _tax___classification_3           TYPE string,
             _tax___category_4___code          TYPE string,
             _tax___classification_4___code    TYPE string,
             _tax___classification_4           TYPE string,
             _tax___category_5___code          TYPE string,
             _tax___classification_5___code    TYPE string,
             _tax___classification_5           TYPE string,
             _tax___category_6___code          TYPE string,
             _tax___classification_6___code    TYPE string,
             _tax___classification_6           TYPE string,
             _sources                          TYPE string,
             _environment                      TYPE string,
             _customer___status                TYPE string,
             _s_a_p___line___information       TYPE STANDARD TABLE OF ty_sap_line_information WITH EMPTY KEY,
           END OF ty_data.

    TYPES: BEGIN OF ty_final,
             data TYPE STANDARD TABLE OF ty_data WITH EMPTY KEY,
           END OF ty_final.
    DATA:wa_final   TYPE ty_final,
         wa_data    TYPE ty_data,
         it_data    TYPE TABLE OF ty_data,
         wa_sapline TYPE ty_sap_line_information,
         it_sapline TYPE TABLE OF ty_sap_line_information,
         lv_json    TYPE string,
         wa_update  TYPE zcust_zoho_statu,
         lv_url     TYPE string.


    DATA : lv_tenent  TYPE c LENGTH 8,
           lv_dev(3)  TYPE c VALUE 'N7O',
           lv_qas(3)  TYPE c VALUE 'M2S',
           lv_prd(3)  TYPE c VALUE 'MLN',
           lv_sub_key TYPE string.
*           lv_url    TYPE string.

    DATA: lo_url  TYPE string.

    DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).


**Current Time

    DATA: l_stmp          TYPE timestampl,
          result_time(14) TYPE c.


    GET TIME STAMP FIELD l_stmp.

    DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).
    DATA(lv_current_time) = cl_abap_context_info=>get_system_time( ).

    DATA(ts_minus_10) = cl_abap_tstmp=>subtractsecs_to_short(
                          tstmp = l_stmp
                          secs  = 900
                        ).

    result_time = ts_minus_10.
    DATA(minus_10_time) = result_time+8(6).


    SELECT  *
         FROM zi_customer_update
         WHERE lastchangedate = @lv_current_date
         and LastChangeTime BETWEEN @minus_10_time and @lv_current_time
         INTO TABLE @DATA(ls_zoho).

    SELECT  customerpaymentterms, division, customer
       FROM i_customersalesarea FOR ALL ENTRIES IN @ls_zoho
       WHERE customer = @ls_zoho-customer
       INTO TABLE @DATA(it_zoho).

    SELECT  *
        FROM i_salesdistricttext
        FOR ALL ENTRIES IN @ls_zoho
        WHERE salesdistrict = @ls_zoho-salesdistrict
        AND language = 'E'
        INTO TABLE  @DATA(it_salesdistrict).

    IF it_zoho IS NOT INITIAL.
      SELECT division, divisionname FROM i_divisiontext
          FOR ALL ENTRIES IN @it_zoho
          WHERE division = @it_zoho-division
            AND language = 'E'
          INTO TABLE @DATA(it_division).

      SELECT paymentterms, paymenttermsname
        FROM i_paymenttermstext
        FOR ALL ENTRIES IN @it_zoho
        WHERE paymentterms = @it_zoho-customerpaymentterms
          AND language = 'E'
        INTO TABLE @DATA(it_payment).
    ENDIF.

*    READ TABLE it_salesdistrict INTO DATA(wa_salesdistrict) INDEX 1.
*    wa_data-_sales_district___description  = wa_salesdistrict-salesdistrictname.

    IF ls_zoho IS NOT INITIAL.
      LOOP AT ls_zoho INTO DATA(wa_zoho).
        READ TABLE it_salesdistrict INTO DATA(wa_salesdistrict) WITH KEY salesdistrict = wa_zoho-salesdistrict.
        wa_data-_sales_district___description  = wa_salesdistrict-salesdistrictname.
        wa_data-_customer___code          = wa_zoho-customer.
        wa_data-_search___term            = wa_zoho-addresssearchterm1.
        wa_data-_account___name           = wa_zoho-businesspartnername1.
        wa_data-_name2                    = wa_zoho-businesspartnername2.
        wa_data-_name3                    = wa_zoho-businesspartnername3."name 4 zoho id
        wa_data-_street___name            = wa_zoho-streetname.
        wa_data-_street__2                = wa_zoho-street2.
        wa_data-_street3                  = wa_zoho-street3.
        wa_data-_house___number           = wa_zoho-housenumber.
        wa_data-_city___name              = wa_zoho-cityname.
        wa_data-_district                 = wa_zoho-districtname.
        wa_data-_country___code           = wa_zoho-country.
        wa_data-_country___description    = wa_zoho-countryname.
        wa_data-_region___code            = wa_zoho-region.
        wa_data-_region___description     = wa_zoho-regionname.
        wa_data-_p_o_box                  = wa_zoho-pobox.
        wa_data-_postal__code             = wa_zoho-postalcode.
        wa_data-_language___code          = wa_zoho-language.
        wa_data-_telephone                = wa_zoho-phone.
        wa_data-_mobile___phone           = wa_zoho-telephone.
        wa_data-_fax                      = wa_zoho-faxnumber.
        wa_data-_email                    = wa_zoho-emailaddress.
        wa_data-_pan___no                 = wa_zoho-bpidentificationnumber.
        wa_data-_tax___number___category___cod = 'IN3'.
        wa_data-_tax___number___long           = wa_zoho-taxnumber3.
        wa_data-_company___code                = wa_zoho-companycode.
        wa_data-_reconciliation___account1     = wa_zoho-reconciliationaccount.
        wa_data-_reconciliation___account      = wa_zoho-reconciliationaccountname.
        wa_data-_sales___organization___code   = wa_zoho-salesorganization.
        wa_data-_distribution___channel___code = wa_zoho-distributionchannel.
        wa_data-_distribution___channel2       = wa_zoho-distributionchannelname.
        wa_data-_sales_district___code         = wa_zoho-salesdistrict.

        wa_data-_currency___code               = wa_zoho-currency.
        wa_data-_currency___description        = wa_zoho-currencyname.
        wa_data-_cust___pric___procedure3      = wa_zoho-customerpricingprocedure.
        wa_data-_cust___pric___procedure4      = wa_zoho-custompricprocedescription.
        wa_data-_acct___assmt___grp___c5       = wa_zoho-customeraccountassignmentgroup.
        wa_data-_acct___assmt___grp___c6       = wa_zoho-custaccassigngroupdesc.
        wa_data-_tax___category_1___code       = wa_zoho-tax_category_1_code.
        wa_data-_tax___classification_1___code = wa_zoho-tax_classification_1_code.
        wa_data-_tax___classification_1        = wa_zoho-tax_classification_1_descr.
        wa_data-_tax___category_2___code       = wa_zoho-tax_category_2_code.
        wa_data-_tax___classification_2___code = wa_zoho-tax_classification_2_code.
        wa_data-_tax___classification_2        = wa_zoho-tax_classification_2_descr.
        wa_data-_tax___category_3___code       = wa_zoho-tax_category_3_code.
        wa_data-_tax___classification_3___code = wa_zoho-tax_classification_3_code.
        wa_data-_tax___classification_3        = wa_zoho-tax_classification_3_descr.
        wa_data-_tax___category_4___code       = wa_zoho-tax_category_4_code.
        wa_data-_tax___classification_4___code = wa_zoho-tax_classification_4_code.
        wa_data-_tax___classification_4        = wa_zoho-tax_classification_4_descr.
        wa_data-_tax___category_5___code       = wa_zoho-tax_category_5_code.
        wa_data-_tax___classification_5___code = wa_zoho-tax_classification_5_code.
        wa_data-_tax___classification_5        = wa_zoho-tax_classification_5_descr.
        wa_data-_tax___category_6___code       = wa_zoho-tax_category_6_code.
        wa_data-_tax___classification_6___code = wa_zoho-tax_classification_6_code.
        wa_data-_tax___classification_6        = wa_zoho-tax_classification_6_descr.
        wa_data-_sources                       = 'SAP'.

        CASE wa_zoho-deletionindicator.
          WHEN ''.
            wa_data-_customer___status = 'Active'.
          WHEN 'X'.
            wa_data-_customer___status = 'InActive'.
        ENDCASE.
        CASE sy-sysid.
          WHEN lv_dev.
            wa_data-_environment = 'DEV'.
          WHEN lv_qas.
            wa_data-_environment = 'QAS'.
          WHEN lv_prd.
            wa_data-_environment = 'PROD'.
        ENDCASE.
        LOOP AT it_zoho INTO DATA(wa_zoho1) WHERE customer = wa_zoho-customer.
          wa_sapline-_division___code = wa_zoho1-division.
          DATA(wa_div) = VALUE #( it_division[ division = wa_zoho1-division ] OPTIONAL ).
          wa_sapline-_division = wa_div-divisionname.
          wa_sapline-_terms___of___payment___code = wa_zoho1-customerpaymentterms.
          DATA(wa_payterms) = VALUE #( it_payment[ paymentterms = wa_zoho1-customerpaymentterms ] OPTIONAL ).
          wa_sapline-_terms___of___payments = wa_payterms-paymenttermsname.
          APPEND wa_sapline TO wa_data-_s_a_p___line___information.
        ENDLOOP.

        APPEND wa_data TO wa_final-data.
        lv_json = /ui2/cl_json=>serialize( data = wa_final
                                           compress = abap_false
                                           pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

        REPLACE 'Tax_Number_Category_Cod' IN lv_json WITH 'Tax_Number_Category_Code'.
        REPLACE 'Reconciliation_Account1' IN lv_json WITH 'Reconciliation_Account_Code'.
        REPLACE 'Distribution_Channel2' IN lv_json WITH 'Distribution_Channel_Description'.
        REPLACE 'Cust_Pric_Procedure3' IN lv_json WITH 'Cust_Pric_Procedure_Code'.
        REPLACE 'Cust_Pric_Procedure4' IN lv_json WITH 'Cust_Pric_Procedure_Description'.
        REPLACE 'Acct_Assmt_Grp_C5' IN lv_json WITH 'Acct_Assmt_Grp_Cust_Code'.
        REPLACE 'Acct_Assmt_Grp_C6' IN lv_json WITH 'Acct_Assmt_Grp_Cust_Description'.

        CASE sy-sysid.
          WHEN lv_dev.
            lo_url = |https://glpl-nonprod-apim-02.azure-api.net/Accounts/Accounts/{ wa_zoho-businesspartnername4 }|.
            lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
          WHEN lv_qas.
            lo_url = |https://glpl-nonprod-apim-02.azure-api.net/Accounts/Accounts/{ wa_zoho-businesspartnername4 }|.
            lv_sub_key = '3f3c78ff8cad477c831527f03f71a041'.
          WHEN lv_prd.
            lo_url = |https://glpl-prod-apim-02.azure-api.net/Accounts/Accounts/{ wa_zoho-businesspartnername4 }|.
            lv_sub_key = '90dee5bd8a9d415c924fa4dc008d91ee'.
        ENDCASE.

*        lo_url = |https://glpl-nonprod-apim-02.azure-api.net/Accounts/Accounts/{ wa_zoho-businesspartnername4 }|.
        CONDENSE lo_url.

        TRY.
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
            i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
            "handle exception
        ENDTRY.
        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_fields(  VALUE #(
                     (  name = 'Accept'                     value = '*/*' )
                     (  name = 'Content-Type'                value = 'application/json' )
                     (  name = 'Authorization'              value = lv_token )
                     (  name = 'Cache-Control'              value = 'no-cache' )
                     (  name = 'Ocp-Apim-Subscription-Key'  value = lv_sub_key ) )
                      ).
        lo_request->append_text(
         data   = lv_json
       ).
        TRY.
            DATA(lv_response) = lo_http_client->execute(
                                i_method  = if_web_http_client=>put ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

        DATA(status) = lv_response->get_status(  ).
        DATA(lv_json_response) = lv_response->get_text( ).
        FIND FIRST OCCURRENCE OF '"code":"SUCCESS"' IN lv_json_response.
        IF sy-subrc EQ 0.
          wa_update-customer = wa_zoho-customer.
          wa_update-clastchangedate = wa_zoho-lastchangedate.
          wa_update-clastchangetime = wa_zoho-lastchangetime.
          wa_update-message = 'Data Updated Successfully'.
          SELECT SINGLE * FROM zcust_zoho_statu WHERE customer = @wa_zoho-customer INTO @DATA(wa_rec).
          IF wa_rec IS INITIAL.
            MODIFY zcust_zoho_statu FROM @wa_update.
          ELSE.
            UPDATE zcust_zoho_statu
              SET clastchangedate = @wa_zoho-lastchangedate,
                  clastchangetime = @wa_zoho-lastchangetime,
                  message = 'Data Updated Successfully'
              WHERE customer = @wa_zoho-customer.
          ENDIF.
        ELSE.
          wa_update-customer        = wa_zoho-customer.
          wa_update-clastchangedate = wa_zoho-lastchangedate.
          wa_update-clastchangetime = wa_zoho-lastchangetime.
          wa_update-message         = 'Data Not Updated Successfully'.
          SELECT SINGLE * FROM zcust_zoho_statu WHERE customer = @wa_zoho-customer INTO @wa_rec.
          IF wa_rec IS INITIAL.
            MODIFY zcust_zoho_statu FROM @wa_update.
          ELSE.
            UPDATE zcust_zoho_statu
              SET clastchangedate = @wa_zoho-lastchangedate,
                  clastchangetime = @wa_zoho-lastchangetime,
                  message = 'Data Not Updated Successfully'
              WHERE customer = @wa_zoho-customer.
          ENDIF.
        ENDIF.
        FIND FIRST OCCURRENCE OF '"code":"INVALID_DATA"' IN lv_json_response.
        IF sy-subrc EQ 0.

        ENDIF.

      ENDLOOP.
    ENDIF.


  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    me->customer(  ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
      CATCH cx_apj_rt_content.                          "#EC NO_HANDLER
        "handle exception
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

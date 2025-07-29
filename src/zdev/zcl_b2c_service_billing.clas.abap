CLASS zcl_b2c_service_billing DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
**Data Defination
**********************************************************************

    TYPES:BEGIN OF ty_accountassignment,
            profitcenter TYPE i_journalentryitem-profitcenter,
          END OF ty_accountassignment.

    TYPES:BEGIN OF ty_profitabilitysupplement,
            salesorganization   TYPE i_salesdocument-salesorganization,
            distributionchannel TYPE i_salesdocument-distributionchannel,
            division            TYPE i_salesdocument-organizationdivision,
          END OF ty_profitabilitysupplement.

    TYPES:BEGIN OF ty_tax,
            taxcode      TYPE i_journalentryitem-taxcode,
            taxitemgroup TYPE i_operationalacctgdocitem-taxitemgroup,
          END OF ty_tax.

    TYPES:BEGIN OF ty_soapitem,
            referencedocumentitem           TYPE i_journalentryitem-referencedocumentitem,
            companycode                     TYPE i_journalentryitem-companycode,
            glaccount                       TYPE i_journalentryitem-glaccount,
            amountintransactioncurrency(20) TYPE c,
            debitcreditcode                 TYPE i_journalentryitem-debitcreditcode,
            documentitemtext                TYPE i_journalentryitem-documentitemtext,
            assignmentreference             TYPE i_journalentryitem-assignmentreference,
            businessplace                   TYPE i_businessplacevh-businessplace,
            housebank                       TYPE i_suplrbankdetailsbyintid-bank,
            housebankaccount                TYPE i_suplrbankdetailsbyintid-bankaccount,
            taxsection                      TYPE i_operationalacctgdocitem-taxsection,
            accountassignment               TYPE ty_accountassignment,
            profitabilitysupplement         TYPE ty_profitabilitysupplement,
            tax                             TYPE ty_tax,
          END OF ty_soapitem.

    DATA:item TYPE STANDARD TABLE OF ty_soapitem.

    TYPES:BEGIN OF ty_onetimecustomerdetails,
            name     TYPE i_customer-customername,
            cityname TYPE i_customer-cityname,
            country  TYPE i_customer-country,
            region   TYPE i_customer-region,
          END OF ty_onetimecustomerdetails.

    TYPES: BEGIN OF ty_debtoritem,
             referencedocumentitem           TYPE i_journalentryitem-referencedocumentitem,
             debtor                          TYPE i_customer-customer,
             amountintransactioncurrency(20) TYPE c,
             documentitemtext                TYPE i_journalentryitem-documentitemtext,
             businessplace                   TYPE i_operationalacctgdocitem-businessplace,
             onetimecustomerdetails          TYPE ty_onetimecustomerdetails,
           END OF ty_debtoritem.

    DATA:debtoritem TYPE STANDARD TABLE OF ty_debtoritem.

    TYPES:BEGIN OF ty_producttaxitem,
            taxcode                         TYPE i_journalentryitem-taxcode,
            taxitemgroup                    TYPE i_operationalacctgdocitem-taxitemgroup,
            taxitemclassification(4)        TYPE c,
            amountintransactioncurrency(20) TYPE c,
            taxbaseamountintranscrcy(20)    TYPE c,
          END OF ty_producttaxitem.

    DATA:producttaxitem TYPE TABLE OF ty_producttaxitem.

    TYPES:BEGIN OF ty_soapheader,
            originalreferencedocumenttype  TYPE i_journalentry-referencedocumenttype,
            originalrefdoclogicalsystem(7) TYPE c,
            businesstransactiontype(4)     TYPE c,
            accountingdocumenttype         TYPE i_journalentry-accountingdocumenttype,
            documentreferenceid            TYPE i_journalentry-documentreferenceid,
            documentheadertext             TYPE i_journalentry-accountingdocumentheadertext,
            createdbyuser(12)              TYPE c,
            companycode                    TYPE i_journalentry-companycode,
            documentdate(10)               TYPE c,
            postingdate(10)                TYPE c,
            postingfiscalyear(12)          TYPE c,
            taxreportingdate(10)           TYPE c,
            taxdeterminationdate(10)       TYPE c,
            reference1indocumentheader(25) TYPE c,
            reference2indocumentheader(25) TYPE c,
            item                           LIKE item,
            debtoritem                     LIKE debtoritem,
            producttaxitem                 LIKE producttaxitem,
          END OF ty_soapheader.

    DATA: req_table TYPE ty_soapheader.

    DATA : lv_tenent TYPE c LENGTH 8,
           lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN'.

    DATA: lo_url TYPE string.
**********************************************************************


    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_B2C_SERVICE_BILLING IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.


    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string.

    lv_request_uri         = request->get_header_field( i_name = '~request_uri' ).
    lv_request_method      = request->get_header_field( i_name = '~request_method' ).
    lv_content_type        = request->get_header_field( i_name = 'content-type' ).

    lv_req_body = request->get_text( ).

    IF lv_req_body IS NOT INITIAL.
      REPLACE ALL OCCURRENCES OF PCRE '[^[:print:]]' IN lv_req_body WITH space.
      REPLACE ALL OCCURRENCES OF PCRE '#' IN lv_req_body WITH space.
      CONDENSE lv_req_body.
    ENDIF.



    /ui2/cl_json=>deserialize( EXPORTING json = lv_req_body
                                  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                CHANGING data = req_table ).


***************time stamp

    DATA : timestamp  TYPE timestampl,
           fraction   TYPE string,
           timestamp2 TYPE string.

    GET TIME STAMP FIELD timestamp.

    DATA(tz) = 'INDIA'.
    DATA(time_stamp) = timestamp.


    CONVERT TIME STAMP time_stamp TIME ZONE tz
            INTO DATE DATA(dat) TIME DATA(tim)
            DAYLIGHT SAVING TIME DATA(dst).

    timestamp2 = timestamp.
    fraction   = | { timestamp2+15(7) } |.
    CONDENSE fraction NO-GAPS.

    DATA(created_on) = |{ dat(4) }-{ dat+4(2) }-{ dat+6(2) }T{ tim(2) }:{ tim+2(2) }:{ tim+4(2) }.{ fraction }Z|.
    CONDENSE created_on NO-GAPS.

**********************************************************************
**SOAP API Call

    CASE sy-sysid.
      WHEN lv_dev.
        lo_url = 'https://my417176.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
      WHEN lv_qas.
        lo_url = 'https://my418964.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
      WHEN lv_prd.
        lo_url = 'https://my419924.s4hana.cloud.sap/sap/bc/srt/scs_ext/sap/journalentrycreaterequestconfi'.
    ENDCASE.


    TRY.
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.


    DATA(lo_request) = lo_http_client->get_http_request( ).

    lo_request->set_header_fields(  VALUE #(
               (  name = 'Content-Type'  value = 'text/xml' ) )
                ).

    SELECT SINGLE *
    FROM zi_cs_id
    WHERE systemid = @sy-mandt
    INTO @DATA(wa_idpass).



    lo_request->set_authorization_basic(
      EXPORTING
        i_username = wa_idpass-username
        i_password = wa_idpass-password
    ).


    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_fi_jvposting  SOURCE header     = req_table
                                                 createdon  = created_on
                                         RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>decode_utf8( encoded = lv_output_xml ).




    lo_request->append_text(
          EXPORTING
            data   = ls_data_xml
        ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.


    DATA(status) = lv_response->get_status( ).
    DATA(lv_json_response) = lv_response->get_text( ).

    SPLIT lv_json_response AT '<JournalEntryCreateConfirmation>' INTO DATA(data1) DATA(data2).

    SPLIT data2 AT '</MessageHeader>' INTO DATA(data3) DATA(data4).

    SPLIT data4 AT '<Log>' INTO DATA(data5) DATA(data6).

    CONCATENATE '<?xml version="1.0" encoding="utf-8"?>' data5 INTO data5.


**********************************************************************
**Response in XML Schema

    TYPES:BEGIN OF ty_journalentry,
            accountingdocument TYPE  i_journalentry-accountingdocument,
            companycode        TYPE  i_journalentry-companycode,
            fiscalyear         TYPE  i_journalentry-fiscalyear,
          END OF ty_journalentry.

    DATA:wajournalentrycreateconf TYPE ty_journalentry.

    TRY.
        CALL TRANSFORMATION ztr_fi_jvposting_return
        SOURCE XML data5
        RESULT     journalentrycreateconfirmation = wajournalentrycreateconf.
      CATCH cx_st_error INTO DATA(error).               "#EC NO_HANDLER
    ENDTRY.



    IF wajournalentrycreateconf-accountingdocument <> '0000000000'.

      TRY.
          response->set_status(
            EXPORTING
              i_code   = status-code
              i_reason = status-reason
          ).
        CATCH cx_web_message_error.                     "#EC NO_HANDLER
      ENDTRY.

      DATA string TYPE string.
      /ui2/cl_json=>serialize( EXPORTING data = wajournalentrycreateconf
                                    pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                    RECEIVING
                                     r_json           =  string ).

      response->set_text( string ).
    ELSE.

      TRY.
          response->set_status(
            EXPORTING
              i_code   = 500
          ).
        CATCH cx_web_message_error.                     "#EC NO_HANDLER

      ENDTRY.


      SPLIT data4 AT '</JournalEntryCreateConfirmation>' INTO DATA(error1) DATA(error2).

      SPLIT error2 AT '</JournalEntryCreateConfirmation>' INTO DATA(error3) DATA(error4).

      TYPES:BEGIN OF ty_journalentryerror,
              typeid       TYPE  string,
              severitycode TYPE  string,
              note         TYPE  string,
            END OF ty_journalentryerror.

      DATA:iterror TYPE TABLE OF ty_journalentryerror.


      REPLACE ALL OCCURRENCES OF PCRE '<WebURI>.*</WebURI>' IN error3 WITH '' IGNORING CASE.


      TRY.
          CALL TRANSFORMATION ztr_fi_jvposting_error
          SOURCE XML error3
          RESULT     log = iterror.
        CATCH cx_st_error INTO error.                   "#EC NO_HANDLER
      ENDTRY.

      /ui2/cl_json=>serialize( EXPORTING data = iterror
                                          pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                          RECEIVING
                                           r_json           =  string ).

      response->set_text( string ).

    ENDIF.


  ENDMETHOD.
ENDCLASS.

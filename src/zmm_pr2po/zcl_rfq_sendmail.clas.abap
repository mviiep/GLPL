CLASS zcl_rfq_sendmail DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_SENDMAIL IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.
**********************************************************************
**Data Definition
    DATA:
      lv_request_uri    TYPE string,
      lv_request_method TYPE string,
      lv_content_type   TYPE string,
      lv_req_body       TYPE string,
      wa                TYPE zi_rfq_suppliers.

    DATA: lr_rtti_struc TYPE REF TO cl_abap_structdescr.
    DATA: lt_comp TYPE cl_abap_structdescr=>component_table.
    DATA : v_string TYPE string.
    DATA: responsetext TYPE string.
**********************************************************************

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
                                CHANGING data = wa ).


    SELECT SINGLE supmailtab~requestforquotation,
                  supmailtab~rec_counter,
                  supmailtab~supplier,
                  supmailtab~suppliername,supmailtab~mail1,supmailtab~mail2,
                  supmailtab~mail3,supmailtab~cc1,supmailtab~cc2,supmailtab~cc3,supmailtab~cc4,supmailtab~cc5,
                  supmailtab~mail_sentflag,supmailtab~reminder_flg1,supmailtab~reminder_flg2
        FROM zirfq_suppmail AS supmailtab
        LEFT OUTER JOIN i_supplier AS _supplier ON supmailtab~supplier = _supplier~supplier
              WHERE supmailtab~requestforquotation = @wa-requestforquotation
                AND supmailtab~rec_counter         = @wa-rec_counter
               INTO @DATA(wa_rfqsuppliers).

    CLEAR wa_rfqsuppliers-mail_sentflag.
    IF wa_rfqsuppliers-mail_sentflag <> 'X'.

      SELECT SINGLE rfqdesc~requestforquotationname,rfqdesc~quotationlatestsubmissiondate,rfqdesc~creationdate
      FROM i_requestforquotation_api01 AS rfqdesc
      WHERE rfqdesc~requestforquotation = @wa-requestforquotation
      INTO @DATA(wa_requestforquotation_api).

      SELECT SINGLE purchaserequisition
      FROM i_rfqitem_api01
      WHERE requestforquotation = @wa-requestforquotation
      INTO @DATA(lv_purchaserequisition).

      DATA lv_supplier(10) TYPE c.
      lv_supplier = |{ wa-supplier ALPHA = IN }|.

      SELECT SINGLE _emailaddress~emailaddress
      FROM i_supplier
      LEFT OUTER JOIN i_addressemailaddress_2 WITH PRIVILEGED ACCESS AS _emailaddress ON _emailaddress~addressid = i_supplier~addressid
      WHERE supplier = @lv_supplier
      INTO @DATA(lv_supplieraddress).

      IF lv_request_method = 'POST'.

        TRY.
            DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
            DATA(ld_mail_content) = ``.

            DATA : mail1 TYPE cl_bcs_mail_message=>ty_address,
                   mail2 TYPE cl_bcs_mail_message=>ty_address,
                   mail3 TYPE cl_bcs_mail_message=>ty_address,
                   mail4 TYPE cl_bcs_mail_message=>ty_address,
                   cc1   TYPE cl_bcs_mail_message=>ty_address,
                   cc2   TYPE cl_bcs_mail_message=>ty_address,
                   cc3   TYPE cl_bcs_mail_message=>ty_address,
                   cc4   TYPE cl_bcs_mail_message=>ty_address,
                   cc5   TYPE cl_bcs_mail_message=>ty_address.


**Sender
            lo_mail->set_sender( iv_address = 'gl.purchase@godrejliving.co.in' ).


**Receiver


            IF wa-mail1 IS NOT INITIAL.

              IF matches( val   = wa-mail1
                          regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                ##REGEX_POSIX.

                mail1 = wa-mail1.
                lo_mail->add_recipient( iv_address = mail1 iv_copy = cl_bcs_mail_message=>to ). "bill to party mail
              ENDIF.

            ENDIF.

            IF wa-mail2 IS NOT INITIAL.

              IF matches( val   = wa-mail2
                          regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                ##REGEX_POSIX.

                mail2 = wa-mail2.
                lo_mail->add_recipient( iv_address = mail2 iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
              ENDIF.
            ENDIF.

            IF wa-mail3 IS NOT INITIAL.

              IF matches( val   = wa-mail3
                          regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                  ##REGEX_POSIX.

                mail3 = wa-mail3.
                lo_mail->add_recipient( iv_address = mail3 iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
              ENDIF.

            ENDIF.


**CC Person

            IF wa-cc1 IS NOT INITIAL.

              IF matches( val   = wa-cc1
                            regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                    ##REGEX_POSIX.

                cc1 = wa-cc1.
                lo_mail->add_recipient( iv_address = cc1 iv_copy = cl_bcs_mail_message=>cc ).
              ENDIF.

            ENDIF.

            IF wa-cc2 IS NOT INITIAL.

              IF matches( val   = wa-cc2
                              regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                      ##REGEX_POSIX.

                cc2 = wa-cc2.
                lo_mail->add_recipient( iv_address = cc2 iv_copy = cl_bcs_mail_message=>cc ).
              ENDIF.
            ENDIF.

            IF wa-cc3 IS NOT INITIAL.

              IF matches( val   = wa-cc3
                              regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                      ##REGEX_POSIX.
                cc3 = wa-cc3.
                lo_mail->add_recipient( iv_address = cc3 iv_copy = cl_bcs_mail_message=>cc ).
              ENDIF.

            ENDIF.

            IF wa-cc4 IS NOT INITIAL.

              IF matches( val   = wa-cc4
                              regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                      ##REGEX_POSIX.
                cc4 = wa-cc4.
                lo_mail->add_recipient( iv_address = cc4 iv_copy = cl_bcs_mail_message=>cc ).
              ENDIF.

            ENDIF.

            IF wa-cc5 IS NOT INITIAL.

              IF matches( val   = wa-cc5
                              regex = '^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-a-zA-Z0-9]*\.)+(com|org|co\.in))$' )
                                      ##REGEX_POSIX.
                cc5 = wa-cc5.
                lo_mail->add_recipient( iv_address = cc5 iv_copy = cl_bcs_mail_message=>cc ).
              ENDIF.

            ENDIF.

**Attachment


            DATA(class) = NEW zcl_rfq_custom( ).
            DATA(r_form) = class->rfq(
                             p_rfq         = wa-requestforquotation
                             p_supplier    = lv_supplier
                             p_rec_counter = wa-rec_counter
                           ).

            DATA(pdfxstring) = cl_web_http_utility=>decode_x_base64( encoded = r_form ).

            lo_mail->add_attachment( cl_bcs_mail_binarypart=>create_instance(
                                       iv_content      = pdfxstring
                                       iv_content_type = 'text/plain'
                                       iv_filename     = 'RequestforQuotationForm.pdf'
                                     ) ).



**Excel Attachment

            SELECT DISTINCT item~requestforquotation, item~requestforquotationitem,
            CASE
            WHEN supplier~supplier IS NULL
            THEN unregsupplier~supplier
            ELSE supplier~supplier
            END AS supplier,
            CASE
            WHEN supplier~suppliername IS NULL
            THEN unregsupplier~suppliername
            ELSE supplier~suppliername
            END AS suppliername,
            item~material, item~materialname, item~quantity,
            item~unit, item~targetrate, item~quotedrate, item~currency, item~itemremark,item~headerremark
            FROM zi_rfq_supplieritems_excel AS item

            LEFT OUTER JOIN zi_rfq_suppliername_excel AS supplier      ON  supplier~requestforquotation      =  item~requestforquotation
                                                                      AND  supplier~supplier                 =  @wa-supplier
            LEFT OUTER JOIN  zirfq_suppmail           AS unregsupplier ON  unregsupplier~requestforquotation =  item~requestforquotation
                                                                      AND  unregsupplier~supplier            =  @wa-supplier
                                                                      AND  unregsupplier~rec_counter         =  @wa-rec_counter
            WHERE item~requestforquotation = @wa-requestforquotation
            ORDER BY item~requestforquotation DESCENDING, item~requestforquotationitem DESCENDING
            INTO TABLE @DATA(it_supplieritems).


            CONCATENATE 'RFQNumber' 'RFQLineItem' 'SupplierCode' 'SupplierName' 'Material'
            'Description' 'Qty' 'Unit' 'TargetRate' 'QuotedRate' 'Currency' 'ItemRemarks' 'HeaderRemarks' 'VendorRemarks' headername INTO DATA(headername) SEPARATED BY ','.
            SHIFT headername RIGHT DELETING TRAILING ','.
            SHIFT headername LEFT DELETING LEADING space.

* For UOM conversion - Begin
    data(lt_uomtemp) = it_supplieritems.
     sort lt_uomtemp by unit.
     delete ADJACENT DUPLICATES FROM lt_uomtemp COMPARING unit.
     if lt_uomtemp is not INITIAL.
        select UnitOfMeasure, UnitOfMeasure_E from I_UNITOFMEASURETEXT
                    FOR ALL ENTRIES IN @lt_uomtemp
                    where Language = @sy-langu
                      and UnitOfMeasure = @lt_uomtemp-unit
                      into table @data(lt_uom).
     endif.
* UOM Conversion - End
            LOOP AT it_supplieritems INTO DATA(wa_supplieritems).
* Conversion exit for UOM
                wa_supplieritems-unit = value #( lt_uom[ UnitOfMeasure = wa_supplieritems-unit ]-UnitOfMeasure_E OPTIONAL ).

              CONCATENATE wa_supplieritems-requestforquotation wa_supplieritems-requestforquotationitem wa_supplieritems-supplier
              wa_supplieritems-suppliername wa_supplieritems-material wa_supplieritems-materialname wa_supplieritems-quantity
              wa_supplieritems-unit wa_supplieritems-targetrate wa_supplieritems-quotedrate wa_supplieritems-currency wa_supplieritems-itemremark wa_supplieritems-headerremark
              INTO v_string SEPARATED BY ','.
              SHIFT v_string RIGHT DELETING TRAILING ','.
              CONCATENATE v_string withspace INTO DATA(withspace) SEPARATED BY cl_abap_char_utilities=>cr_lf.
            ENDLOOP.

            CONCATENATE headername withspace INTO withspace SEPARATED BY cl_abap_char_utilities=>cr_lf.

            lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance( iv_content      =  withspace
                                                                            iv_content_type = 'text/plain'
                                                                            iv_filename     = 'RequestforQuotationExcel.csv'
                                                                          ) ).


**********************************************************************





**********************************************************************

**Subject of Email
            lo_mail->set_subject( | RFQ: { wa-requestforquotation } [{ lv_purchaserequisition } - {  wa_requestforquotation_api-requestforquotationname }]. | ).


**Body of Email
            DATA:lv_content TYPE string.

            lv_content = | <p>Dear Partner,</p><p>We hope this message finds you well.</p><p>Godrej Living Pvt Ltd has invited you to place a bid on the following request for quotation: <strong>{ wa-requestforquotation } | &&
  |</strong> for the supply of goods/services a| &&
|s detailed in the attached Excel format.</p><p>To ensure consistency and facilitate a smooth evaluation process, we kindly request that you adhere to the provided Excel format when submitting your quotation. Please avoid making any changes to the s| &&
|tructure or format of the template/document.</p><p>You can find further information on this RFQ, including details related to the site address, contact person, and specific remarks, in the PDF attachment.</p><p>If you have questions regarding this | &&
|RFQ, please send an e-mail to <a href="mailto:gl.purchase@godrejliving.co.in">gl.purchase@godrejliving.co.in</a>.</p><p>We look forward to working with you.</p><p>Sincerely,<br>Godrej Living Pvt Ltd</p>|.


            lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                    iv_content      = lv_content
                    iv_content_type = 'text/html'
                     ) ).

**Send Mail
            lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
          CATCH cx_bcs_mail INTO DATA(lx_mail).         "#EC NO_HANDLER
            lx_mail->get_text(
              RECEIVING
                result =  DATA(email_error)
            ).

            response->set_status( EXPORTING i_code = 400 ).

            TRY.
                REPLACE ALL OCCURRENCES OF 'No recipients' IN email_error WITH 'Incorrect recipients'.
                response->set_text( | RFQ: { wa-requestforquotation } Supplier: { wa-supplier } Failure - { email_error } | ).
              CATCH cx_web_message_error.               "#EC NO_HANDLER
            ENDTRY.

        ENDTRY.

      ENDIF.

      DATA(wa_response) = VALUE #( lt_status[ 1 ] OPTIONAL ).

      IF wa_response-status EQ 'S'.

        wa_rfqsuppliers-mail_sentflag = 'X'.

        SELECT SINGLE *
        FROM zdb_rfqdate
        WHERE requestforquotation = @wa-requestforquotation
        INTO @DATA(wa_rfqdate).

        IF wa_rfqdate-requestforquotation IS INITIAL.
          wa_rfqdate-requestforquotation = wa-requestforquotation.
          wa_rfqdate-originaldate        = wa_requestforquotation_api-quotationlatestsubmissiondate.
          wa_rfqdate-mailsenddate        = cl_abap_context_info=>get_system_date( ).
          MODIFY zdb_rfqdate FROM @wa_rfqdate.
        ENDIF.

        UPDATE zirfq_suppmail SET mail_sentflag = @wa_rfqsuppliers-mail_sentflag
        WHERE requestforquotation = @wa_rfqsuppliers-requestforquotation
          AND rec_counter   = @wa_rfqsuppliers-rec_counter
          AND supplier = @wa_rfqsuppliers-supplier.

        TRY.
            response->set_text( 'Success' ).
          CATCH cx_web_message_error.                   "#EC NO_HANDLER
        ENDTRY.

      ELSEIF wa_response-status EQ 'F'.

        response->set_status( EXPORTING i_code = 400 ).
        TRY.
            response->set_text(  |RFQ: { wa-requestforquotation } Supplier: { wa-supplier } Failure - { email_error } | ).
          CATCH cx_web_message_error.                   "#EC NO_HANDLER
        ENDTRY.

      ENDIF.


    ELSEIF wa_rfqsuppliers-mail_sentflag EQ 'X'.

      response->set_status( EXPORTING i_code = 400 ).
      TRY.
          response->set_text( 'Email Already Send to Supplier' ).
        CATCH cx_web_message_error.                     "#EC NO_HANDLER
      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

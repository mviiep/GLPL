CLASS zcl_rfq_reminder1 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_REMINDER1 IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

**********************************************************************
** Reminder 1

    DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).

    SELECT DISTINCT supmailtab~requestforquotation,supmailtab~rec_counter,supmailtab~supplier,
    supmailtab~suppliername,supmailtab~mail1,supmailtab~mail2,
    supmailtab~mail3,supmailtab~cc1,supmailtab~cc2,supmailtab~cc3,supmailtab~cc4,supmailtab~cc5,
    supmailtab~mail_sentflag,supmailtab~reminder_flg1,supmailtab~reminder_flg2,rfqdate~originaldate,
    rfqdesc~requestforquotationname,rfqdesc~quotationlatestsubmissiondate,rfqdesc~creationdate,rfqdate~mailsenddate
    FROM zirfq_suppmail AS supmailtab
    LEFT OUTER JOIN i_requestforquotation_api01 AS rfqdesc ON rfqdesc~requestforquotation EQ supmailtab~requestforquotation
    LEFT OUTER JOIN zdb_rfqdate                 AS rfqdate ON supmailtab~requestforquotation EQ rfqdate~requestforquotation
    WHERE reminder_flg1 <> 'X'
    AND mail_sentflag EQ 'X'
    AND supmailtab~requestforquotation IS NOT INITIAL
    AND rfqdate~mailsenddate <> @lv_current_date
    INTO TABLE @DATA(it_rfqsuppliers_r1).


    LOOP AT it_rfqsuppliers_r1 INTO DATA(wa_rfqsuppliers_r1).

      DATA(date) =          |{ wa_rfqsuppliers_r1-creationdate+6(2) }/{ wa_rfqsuppliers_r1-creationdate+4(2) }/{ wa_rfqsuppliers_r1-creationdate(4) }|.
      DATA(mailsenddate) =  |{ wa_rfqsuppliers_r1-mailsenddate+6(2) }/{ wa_rfqsuppliers_r1-mailsenddate+4(2) }/{ wa_rfqsuppliers_r1-mailsenddate(4) }|.
      DATA(originaldate) =  |{ wa_rfqsuppliers_r1-originaldate+6(2) }/{ wa_rfqsuppliers_r1-originaldate+4(2) }/{ wa_rfqsuppliers_r1-originaldate(4) }|.
      DATA(newdate) =       |{ wa_rfqsuppliers_r1-quotationlatestsubmissiondate+6(2) }/{ wa_rfqsuppliers_r1-quotationlatestsubmissiondate+4(2) }/{ wa_rfqsuppliers_r1-quotationlatestsubmissiondate(4) }|.

      SELECT SINGLE purchaserequisition
      FROM i_rfqitem_api01
      WHERE requestforquotation = @wa_rfqsuppliers_r1-requestforquotation
      INTO @DATA(lv_purchaserequisition).

      TRY.
          DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
          DATA(ld_mail_content) = ``.

          DATA : mail1 TYPE cl_bcs_mail_message=>ty_address,
                 mail2 TYPE cl_bcs_mail_message=>ty_address,
                 mail3 TYPE cl_bcs_mail_message=>ty_address,
                 cc1   TYPE cl_bcs_mail_message=>ty_address,
                 cc2   TYPE cl_bcs_mail_message=>ty_address,
                 cc3   TYPE cl_bcs_mail_message=>ty_address,
                 cc4   TYPE cl_bcs_mail_message=>ty_address,
                 cc5   TYPE cl_bcs_mail_message=>ty_address.


**Sender
          lo_mail->set_sender( iv_address = 'test@castaliaz.co.in' ).


**Receiver
          IF wa_rfqsuppliers_r1-mail1 IS NOT INITIAL.
            mail1 = wa_rfqsuppliers_r1-mail1.
            lo_mail->add_recipient( iv_address = mail1 iv_copy = cl_bcs_mail_message=>to ). "bill to party mail
          ENDIF.

          IF wa_rfqsuppliers_r1-mail2 IS NOT INITIAL.
            mail2 = wa_rfqsuppliers_r1-mail2.
            lo_mail->add_recipient( iv_address = mail2 iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
          ENDIF.

          IF wa_rfqsuppliers_r1-mail3 IS NOT INITIAL.
            mail3 = wa_rfqsuppliers_r1-mail3.
            lo_mail->add_recipient( iv_address = mail3 iv_copy = cl_bcs_mail_message=>to ). "Additional Receiver
          ENDIF.


**CC Person
          IF wa_rfqsuppliers_r1-cc1 IS NOT INITIAL.
            cc1 = wa_rfqsuppliers_r1-cc1.
            lo_mail->add_recipient( iv_address = cc1 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.

          IF wa_rfqsuppliers_r1-cc2 IS NOT INITIAL.
            cc2 = wa_rfqsuppliers_r1-cc2.
            lo_mail->add_recipient( iv_address = cc2 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.

          IF wa_rfqsuppliers_r1-cc3 IS NOT INITIAL.
            cc3 = wa_rfqsuppliers_r1-cc3.
            lo_mail->add_recipient( iv_address = cc3 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.

          IF wa_rfqsuppliers_r1-cc4 IS NOT INITIAL.
            cc4 = wa_rfqsuppliers_r1-cc4.
            lo_mail->add_recipient( iv_address = cc4 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.

          IF wa_rfqsuppliers_r1-cc5 IS NOT INITIAL.
            cc5 = wa_rfqsuppliers_r1-cc5.
            lo_mail->add_recipient( iv_address = cc5 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.


**Subject of Email
          lo_mail->set_subject( | Reminder 1 - RFQ: { wa_rfqsuppliers_r1-requestforquotation } [{ lv_purchaserequisition } - {  wa_rfqsuppliers_r1-requestforquotationname }]. | ).


**Body of Email
          DATA:lv_content TYPE string.

          lv_content = | <p>Dear Partner,</p><p>I hope this message finds you well.</p> <p>We would like to kindly remind you that we are awaiting your quotation for the supply of goods/services as per our earlier communication.| &&
          | The details of the RFQ were shared on <strong>{ date }</strong>,| &&
          | and we had requested your submission by <strong>{ originaldate }</strong>.</p><p>If there are any issues or clarifications required regarding the RFQ, please do not hesitate to reach out to us. | &&
          | We would be happy to assist to ensure the timely submission of your quotation.</p>| &&
          |<p>We kindly request you to share your quotation by <strong>{ newdate }</strong>.</p><p>Thank you for your prompt attention to this matter, and we look forward to receiving your response.</p>| &&
          |<p>Sincerely,</br>Godrej Living Pvt Ltd.</p> |.


          lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                  iv_content      = lv_content
                  iv_content_type = 'text/html'
                   ) ).

**Send Mail
          lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
        CATCH cx_bcs_mail INTO DATA(lx_mail).           "#EC NO_HANDLER
          "handle exception

      ENDTRY.


      DATA(wa_rfqsuppliers_r1_response) = VALUE #( lt_status[ 1 ] OPTIONAL ).

      IF wa_rfqsuppliers_r1_response-status EQ 'S'.
        DATA: responsetext TYPE string.
        responsetext = 'Success'.

        wa_rfqsuppliers_r1-reminder_flg1 = 'X'.

**Update the Data with Reminder 1 Field as X
        UPDATE zirfq_suppmail SET reminder_flg1 = @wa_rfqsuppliers_r1-reminder_flg1
        WHERE requestforquotation = @wa_rfqsuppliers_r1-requestforquotation
        AND supplier = @wa_rfqsuppliers_r1-supplier.

      ENDIF.

    ENDLOOP.

**********************************************************************

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

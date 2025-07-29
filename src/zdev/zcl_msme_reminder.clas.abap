CLASS zcl_msme_reminder DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA:counter(3) TYPE c,
         amt        TYPE string,
         it_string  TYPE STANDARD TABLE OF string.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MSME_REMINDER IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.


    TRY.
        DATA(lo_mail) = cl_bcs_mail_message=>create_instance( ).
        DATA(ld_mail_content) = ``.

        DATA : mail1 TYPE cl_bcs_mail_message=>ty_address,
               mail2 TYPE cl_bcs_mail_message=>ty_address,
               mail3 TYPE cl_bcs_mail_message=>ty_address,
               cc1   TYPE cl_bcs_mail_message=>ty_address,
               cc2   TYPE cl_bcs_mail_message=>ty_address,
               bcc1  TYPE cl_bcs_mail_message=>ty_address,
               bcc2  TYPE cl_bcs_mail_message=>ty_address.


**Sender

        lo_mail->set_sender( iv_address = 'gl.purchase@godrejliving.co.in' ).


**Receiver


        mail1 = 'prachi.bhabal@godrejliving.co.in'.
        lo_mail->add_recipient( iv_address = mail1 iv_copy = cl_bcs_mail_message=>to ).


**CC Person


        cc1 = 'divya.kulkarni@godrejliving.co.in'.
        lo_mail->add_recipient( iv_address = cc1 iv_copy = cl_bcs_mail_message=>cc ).


** BCC Person

*        bcc1 = 'nikhil.gonsalves@castaliaz.co.in'.
*        lo_mail->add_recipient( iv_address = bcc1 iv_copy = cl_bcs_mail_message=>bcc ).
*
*        bcc2 = 'vidhi.pednekar@castaliaz.co.in'.
*        lo_mail->add_recipient( iv_address = bcc2 iv_copy = cl_bcs_mail_message=>bcc ).


**Excel Attachment

        DATA(lv_current_date) = cl_abap_context_info=>get_system_date( ).

        SELECT journalentryitem~supplier,
               _supplier~suppliername,
               _supplier~businesspartnerpannumber,
               journalentryitem~documentdate,
               journalentryheader~documentreferenceid,
               amountincompanycodecurrency,
               journalentryitem~transactioncurrency,
               journalentryitem~clearingdate,
               journalentryitem~accountingdocument,
               CASE
               WHEN journalentryitem~documentdate = '00000000' THEN 0
               ELSE days_between(  journalentryitem~documentdate, @lv_current_date )  + 1 END AS diff_days,
               _businesspartnertaxnumber~bptaxtype
        FROM i_journalentryitem AS journalentryitem
        LEFT OUTER JOIN i_supplier                 AS _supplier                 ON _supplier~supplier                        = journalentryitem~supplier
        LEFT OUTER JOIN i_businesspartnertaxnumber AS _businesspartnertaxnumber ON _businesspartnertaxnumber~businesspartner = journalentryitem~supplier
        LEFT OUTER JOIN i_journalentry             AS journalentryheader        ON journalentryheader~accountingdocument     = journalentryitem~accountingdocument
                                                                               AND journalentryheader~companycode            = journalentryitem~companycode
                                                                               AND journalentryheader~fiscalyear             = journalentryitem~fiscalyear
        WHERE  _businesspartnertaxnumber~bptaxtype = 'IN5'
        AND journalentryitem~supplier <> ' '
        AND journalentryitem~financialaccounttype = 'K'
        AND journalentryitem~ledger = '0L'
        AND journalentryitem~clearingdate = '00000000'
        INTO TABLE @DATA(lt_journal).


        DELETE lt_journal WHERE diff_days <= 40.


        CONCATENATE 'S.No.' 'MSME Supplier BP Number' 'Name of MSE Supplier' 'PAN of the Supplier' 'Document Date' 'DocumentReferenceID'
        'Currency' 'Amount for Document Date + 40 Days' headername INTO DATA(headername) SEPARATED BY ','.
        SHIFT headername RIGHT DELETING TRAILING ','.


        LOOP AT lt_journal INTO DATA(wa_journal).
          counter = sy-tabix.
          wa_journal-amountincompanycodecurrency = wa_journal-amountincompanycodecurrency * -1.
          amt = wa_journal-amountincompanycodecurrency.
          CONDENSE amt NO-GAPS.
          CONCATENATE counter wa_journal-supplier wa_journal-suppliername
          wa_journal-businesspartnerpannumber wa_journal-documentdate wa_journal-documentreferenceid wa_journal-transactioncurrency
          amt
          INTO DATA(v_string) SEPARATED BY ','.
          SHIFT v_string RIGHT DELETING TRAILING ','.
          CONCATENATE v_string withspace INTO DATA(withspace) SEPARATED BY cl_abap_char_utilities=>cr_lf.
          APPEND v_string TO it_string.
        ENDLOOP.

        CONCATENATE LINES OF it_string INTO DATA(wa_string) SEPARATED BY cl_abap_char_utilities=>cr_lf.

        CONCATENATE headername wa_string INTO wa_string SEPARATED BY cl_abap_char_utilities=>cr_lf.

        lo_mail->add_attachment( cl_bcs_mail_textpart=>create_instance( iv_content      =  wa_string
                                                                         iv_content_type = 'text/plain'
                                                                         iv_filename     = 'MSME_EXCEL.csv'
                                                                       ) ).

**Subject of Email

        lo_mail->set_subject( |Reminder: Pending MSME Vendor Invoices Due for Payment.| ).


**Body of Email

        DATA:lv_content TYPE string.

        lv_content = |<p>Dear User,</p><p>I hope this message finds you well.</p><p>Please find attached the list of MSME Vendor invoices that are approaching their due dates. We kindly request that you process the payments | &&
                |at the earliest to avoid any penalties for non-payment to MSME vendors.</p><p>Thank you for your prompt attention to this matter.</p><p>Best Regards,<br>Accounts Payable Department,<br>| &&
                |Godrej Living Private Limited.</p>|.



        lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                iv_content      = lv_content
                iv_content_type = 'text/html'
                 ) ).

**Send Mail

        lo_mail->send( IMPORTING et_status = DATA(lt_status) ).
      CATCH cx_bcs_mail INTO DATA(lx_mail).             "#EC NO_HANDLER
        "handle exception

    ENDTRY.

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

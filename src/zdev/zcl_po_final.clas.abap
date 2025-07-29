CLASS zcl_po_final DEFINITION
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



CLASS ZCL_PO_FINAL IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    SELECT DISTINCT *  FROM i_workflowstatusoverview
    WHERE sapobjectnoderepresentation = 'PurchaseOrder'
    AND workflowexternalstatus = 'COMPLETED' INTO TABLE @DATA(it_po).

    SELECT DISTINCT * FROM i_workflowstatusoverview
    WHERE sapobjectnoderepresentation = 'PurchaseOrder'
    AND workflowexternalstatus = 'STARTED' INTO TABLE @DATA(it_postart).


    LOOP AT it_postart INTO DATA(wa_postart) .
      DELETE it_po WHERE sapbusinessobjectnodekey1 = wa_postart-sapbusinessobjectnodekey1.
    ENDLOOP.


    SELECT a~purchaseorder, a~createdbyuser, c~email_id, c~email_id2, c~email_id3, email_cc1, email_cc2, email_cc3,
        email_cc4, email_cc5
        FROM i_purchaseorderapi01   AS a
        INNER JOIN @it_po           AS b ON a~purchaseorder = b~sapbusinessobjectnodekey1
        INNER JOIN zi_po_createuser AS c ON a~createdbyuser = c~cb_user
        INNER JOIN zpo_mail_status  AS d ON a~purchaseorder = d~pocode
                                        AND d~finalmail     IS INITIAL
        INTO TABLE @DATA(it_pouser).

    DELETE ADJACENT DUPLICATES FROM it_pouser COMPARING purchaseorder createdbyuser.

    LOOP AT it_pouser INTO DATA(wa_pouser).

      SELECT SINGLE * FROM zpo_mail_status WHERE pocode = @wa_pouser-purchaseorder INTO @DATA(po_mail).

      IF po_mail IS NOT INITIAL.

        SELECT SINGLE SUM( a~grossamount ) AS totamnt , a~purchaseorder, b~supplier, c~performanceperiodstartdate, c~performanceperiodenddate, d~suppliername
        FROM i_purchaseorderitemapi01                AS a
        LEFT OUTER JOIN i_purchaseorderapi01         AS b ON a~purchaseorder = b~purchaseorder
        LEFT OUTER JOIN i_purordschedulelineapi01    AS c ON a~purchaseorder = c~purchaseorder
        LEFT OUTER JOIN i_supplier                   AS d ON b~supplier      = d~supplier
        WHERE a~purchaseorder = @wa_pouser-purchaseorder
        GROUP BY a~purchaseorder, b~supplier, c~performanceperiodstartdate, c~performanceperiodenddate, d~suppliername
        INTO @DATA(wa_tab).

        DATA(lv_frmdt) = | { wa_tab-performanceperiodstartdate+6(2) }-{ wa_tab-performanceperiodstartdate+4(2) }-{ wa_tab-performanceperiodstartdate+0(4) } to |.

        CONCATENATE wa_tab-performanceperiodenddate+6(2) '-' wa_tab-performanceperiodenddate+4(2) '-' wa_tab-performanceperiodenddate+0(4) INTO DATA(lv_todt).

        IF po_mail-pocode IS NOT INITIAL AND po_mail-finalmail IS INITIAL.
          TRY.
              DATA(lo_mail) = cl_bcs_mail_message=>create_instance(  ).
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
              lo_mail->set_sender( iv_address = 'gl.purchase@godrejliving.co.in' ).

              IF wa_pouser-email_id IS NOT INITIAL.
                mail1 = wa_pouser-email_id.
                lo_mail->add_recipient( iv_address = mail1 iv_copy = cl_bcs_mail_message=>to ). " mail to 1
              ENDIF.
              IF wa_pouser-email_id2 IS NOT INITIAL.
                mail2 = wa_pouser-email_id2.
                lo_mail->add_recipient( iv_address = mail2 iv_copy = cl_bcs_mail_message=>to ). " mail to 2
              ENDIF.
              IF wa_pouser-email_id3 IS NOT INITIAL.
                mail3 = wa_pouser-email_id3.
                lo_mail->add_recipient( iv_address = mail3 iv_copy = cl_bcs_mail_message=>to ). " mail to 1
              ENDIF.
              IF wa_pouser-email_cc1 IS NOT INITIAL.
                cc1 = wa_pouser-email_cc1.
                lo_mail->add_recipient( iv_address = cc1 iv_copy = cl_bcs_mail_message=>cc ). " mail to 1
              ENDIF.
              IF wa_pouser-email_cc2 IS NOT INITIAL.
                cc2 = wa_pouser-email_cc2.
                lo_mail->add_recipient( iv_address = cc2 iv_copy = cl_bcs_mail_message=>cc ). " mail to 1
              ENDIF.
              IF wa_pouser-email_cc3 IS NOT INITIAL.
                cc3 = wa_pouser-email_cc3.
                lo_mail->add_recipient( iv_address = cc3 iv_copy = cl_bcs_mail_message=>cc ). " mail to 1
              ENDIF.
              IF wa_pouser-email_cc4 IS NOT INITIAL.
                cc4 = wa_pouser-email_cc4.
                lo_mail->add_recipient( iv_address = cc4 iv_copy = cl_bcs_mail_message=>cc ). " mail to 1
              ENDIF.
              IF wa_pouser-email_cc5 IS NOT INITIAL.
                cc5 = wa_pouser-email_cc5.
                lo_mail->add_recipient( iv_address = cc5 iv_copy = cl_bcs_mail_message=>cc ). " mail to 1
              ENDIF.

              lo_mail->set_subject( |Attention required: WO is Approved - { wa_pouser-purchaseorder }| ).

              DATA:lv_content TYPE string.

              lv_content = | <p>Dear Sir,</p><p>Based on the below information, below WO is approved- </p></br> | &&
            | <table style = "border : 1px solid black; border-collapse: collapse "> <thead><tr><th style="border: 1px solid black; border-collapse: collapse;" >Vendor Name</th> | &&
            | <th style="border: 1px solid black; border-collapse: collapse;" > WO Period</th>  | &&
            | <th style="border: 1px solid black; border-collapse: collapse;" > WO Amount</th></tr> </thead>| &&
            |<tr><td style="border: 1px solid black; border-collapse: collapse;" > { wa_tab-suppliername }</td>| &&
            |<td style="border: 1px solid black; border-collapse: collapse;" > { lv_frmdt }{ lv_todt } </td>| &&
            |<td style="border: 1px solid black; border-collapse: collapse;" > { wa_tab-totamnt } </td></tr> </table>| &&
            | Please note below: </p>| &&
         |<p>1.         We have a valid LOI from the customer.</p> | &&
         |<p>2.         Rates and terms mentioned in the WO are verified with rates mentioned in cost sheet and terms agreed by our client. </p> | &&
         |<p>3.         The rates in the scan copy of the quotation / pro-forma invoice have been checked by Procurement Team & enclosed herewith for your reference. </p>| &&
         |<p>4.         Vendor payment will be released only after receipt of payment from the client. </p>| &&
         |<p>Sincerely,</p>| &&
         |<p>Godrej Living Pvt Ltd</p>|.
              lo_mail->set_main( cl_bcs_mail_textpart=>create_instance(
                    iv_content      = lv_content
                    iv_content_type = 'text/html'
                     ) ).

              lo_mail->send(
                IMPORTING
                  et_status              = DATA(lt_status) ).


            CATCH cx_bcs_mail  INTO DATA(lv_mail).      "#EC NO_HANDLER
          ENDTRY.


          READ TABLE lt_status WITH KEY status = 'F' TRANSPORTING NO FIELDS.

          IF sy-subrc NE 0.
            po_mail-finalmail = 'X'.
            MODIFY zpo_mail_status FROM @po_mail.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDLOOP.

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

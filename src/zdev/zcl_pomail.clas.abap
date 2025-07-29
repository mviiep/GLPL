CLASS zcl_pomail DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
*   INTERFACES if_oo_adt_classrun.
    TYPES: BEGIN OF ty_po,
             po(10),
           END OF ty_po.
    CLASS-DATA: it_po         TYPE TABLE OF ty_po,
                wa_po         TYPE i_purchaseorderapi01-purchaseorder,
                lv_code       TYPE zstrcode,
                wa_pomail     TYPE zdb_po_mail,
                wa_pomailstat TYPE zpo_mail_status.

    CLASS-METHODS: sendmail IMPORTING wa_po          LIKE wa_po
                                      lv_code        TYPE zstrcode
                            RETURNING VALUE(r_value) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS ZCL_POMAIL IMPLEMENTATION.


  METHOD sendmail.

*    SELECT SINGLE * FROM zi_str_mail WHERE strcode = @lv_code INTO @DATA(la_strmail).
*    SELECT SINGLE purchasingprocessingstatus
*        FROM i_purchaseorderapi01
*        WHERE purchaseorder = @wa_po
*        INTO  @DATA(ls_status).
    SELECT  SINGLE * FROM zpo_mail_status WHERE pocode = @wa_po INTO @DATA(wa_pomailstat).
    SELECT SINGLE * FROM i_purchaseorderapi01 WHERE purchaseorder = @wa_po INTO @DATA(wa_podate).
    IF wa_pomailstat IS INITIAL.
      wa_pomailstat-pocode = wa_podate-purchaseorder.
      wa_pomailstat-lastchange = wa_podate-lastchangedatetime.
      MODIFY zpo_mail_status  FROM @wa_pomailstat.
      CLEAR wa_pomailstat.
      SELECT  SINGLE * FROM zpo_mail_status WHERE pocode = @wa_po INTO @wa_pomailstat.
    ELSEIF wa_pomailstat-lastchange <> wa_podate-lastchangedatetime.
      SELECT  *
       FROM zdb_po_mail
       WHERE pocode = @wa_po
       INTO TABLE @DATA(it_pomail).
      LOOP AT it_pomail INTO wa_pomail.
        wa_pomail-pocode = wa_po.
        wa_pomail-strcode = wa_pomail-strcode.
        wa_pomail-sendmail = ''.
        MODIFY zdb_po_mail FROM @wa_pomail.
        CLEAR wa_pomail.
      ENDLOOP.


      wa_pomailstat-pocode = wa_po.
      wa_pomailstat-sendmaila1 = ''.
      wa_pomailstat-sendmaila2 = ''.
      wa_pomailstat-sendmaila3 = ''.
      wa_pomailstat-sendmaila4 = ''.
      wa_pomailstat-sendmaila5 = ''.
      wa_pomailstat-sendmaila6 = ''.
      wa_pomailstat-sendmaila7 = ''.
      wa_pomailstat-sendmaila8 = ''.
      wa_pomailstat-sendmaila9 = ''.
      wa_pomailstat-sendmaila10 = ''.
      wa_pomailstat-sendmaila11 = ''.
      wa_pomailstat-sendmaila12 = ''.
      wa_pomailstat-sendmaila13 = ''.
      wa_pomailstat-finalmail = ''.
      MODIFY zpo_mail_status FROM @wa_pomailstat.
      "need to clear all the approval mail mark updates. write code
    ENDIF.
*    SELECT SINGLE * FROM i_purchaseorderapi01 WHERE purchaseorder = @wa_po INTO @wa_podate.
    SELECT SINGLE SUM( grossamount ) AS totamt, purchaseorder FROM i_purchaseorderitemapi01 WHERE purchaseorder = @wa_po GROUP BY purchaseorder INTO @DATA(wa_poitem).
    SELECT SINGLE workflowinternalid, workflowexternalstatus
      FROM i_workflowstatusoverview
      WHERE sapbusinessobjectnodekey1 = @wa_po
      INTO @DATA(wa_workflowinternalid).
    IF wa_workflowinternalid IS NOT INITIAL.
      SELECT SINGLE workflowtaskinternalid, workflowtaskrecipient
        FROM i_workflowrecipients_v2
        WHERE workflowinternalid = @wa_workflowinternalid-workflowinternalid
        INTO @DATA(wa_approver).
      SELECT workflowtaskinternalid, workflowinternalid, workflowtaskexternalstatus
          FROM i_workflowstatusdetails
          WHERE workflowinternalid = @wa_workflowinternalid-workflowinternalid
          INTO TABLE @DATA(it_workflowstatus).
      IF it_workflowstatus IS NOT INITIAL.
        SELECT COUNT( * )
            FROM @it_workflowstatus AS it_workflw
            INTO @DATA(lv_count).
      ENDIF.
    ENDIF.
    DATA: lv_str(10) TYPE c,
          l_stmp     TYPE timestampl,
          lv_diff    TYPE p DECIMALS 0.
    DATA(wa_workflowstatusdetails) = VALUE #( it_workflowstatus[ 1 ] OPTIONAL ).
*    IF wa_approver IS NOT INITIAL.
    GET TIME STAMP FIELD l_stmp.
    TRY.
        lv_diff = cl_abap_tstmp=>subtract(
                 tstmp1 = l_stmp
                 tstmp2 = wa_pomailstat-lastapprove ).
      CATCH cx_parameter_invalid INTO DATA(lx_tstmp_error).
    ENDTRY.
    IF wa_poitem-totamt < '1000000'.
      IF ( lv_diff > 120 OR lv_diff = 0 ) AND (  wa_pomailstat-sendmaila1 IS INITIAL OR wa_pomailstat-lastchange <> wa_podate-lastchangedatetime ).
        lv_str = 'A1'.
        wa_pomailstat-lastchange = wa_podate-lastchangedatetime.
        wa_pomailstat-pocode = wa_podate-purchaseorder.
        wa_pomailstat-lastapprove = l_stmp.
        MODIFY zpo_mail_status  FROM @wa_pomailstat.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila1 = 'X' AND wa_pomailstat-sendmaila2 IS INITIAL.
        lv_str = 'A2'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila1 = 'X' AND wa_pomailstat-sendmaila2 = 'X'.
        lv_str = 'FI'.
      ENDIF.
    ELSEIF wa_poitem-totamt BETWEEN '1000001' AND '3000000' .
      IF ( lv_diff > 120 OR lv_diff = 0 ) AND (  wa_pomailstat-sendmaila3 IS INITIAL OR wa_pomailstat-lastchange <> wa_podate-lastchangedatetime ).
        lv_str = 'A3'.
        wa_pomailstat-lastchange = wa_podate-lastchangedatetime.
        wa_pomailstat-pocode = wa_podate-purchaseorder.
        wa_pomailstat-lastapprove = l_stmp.
        MODIFY zpo_mail_status  FROM @wa_pomailstat.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila3 = 'X' AND wa_pomailstat-sendmaila4 IS INITIAL.
        lv_str = 'A4'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila3 = 'X' AND wa_pomailstat-sendmaila4 = 'X' AND wa_pomailstat-sendmaila5 IS INITIAL.
        lv_str = 'A5'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila3 = 'X' AND wa_pomailstat-sendmaila4 = 'X' AND wa_pomailstat-sendmaila5 = 'X'.
        lv_str = 'FI'.
      ENDIF.
    ELSEIF wa_poitem-totamt BETWEEN '3000001' AND '5000000' .
      IF ( lv_diff > 120 OR lv_diff = 0 ) AND (  wa_pomailstat-sendmaila6 IS INITIAL OR wa_pomailstat-lastchange <> wa_podate-lastchangedatetime ).
        lv_str = 'A6'.
        wa_pomailstat-lastchange = wa_podate-lastchangedatetime.
        wa_pomailstat-pocode = wa_podate-purchaseorder.
        wa_pomailstat-lastapprove = l_stmp.
        MODIFY zpo_mail_status  FROM @wa_pomailstat.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila6 = 'X' AND wa_pomailstat-sendmaila7 IS INITIAL.
        lv_str = 'A7'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila6 = 'X' AND wa_pomailstat-sendmaila7 = 'X' AND wa_pomailstat-sendmaila8 IS INITIAL.
        lv_str = 'A8'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila6 = 'X' AND wa_pomailstat-sendmaila7 = 'X' AND wa_pomailstat-sendmaila8 = 'X' AND wa_pomailstat-sendmaila9 IS INITIAL.
        lv_str = 'A9'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila6 = 'X' AND wa_pomailstat-sendmaila7 = 'X' AND wa_pomailstat-sendmaila8 = 'X' AND wa_pomailstat-sendmaila9 IS INITIAL.
        lv_str = 'FI'.
      ENDIF.
    ELSEIF wa_poitem-totamt > '5000001' .
      IF ( lv_diff > 120 OR lv_diff = 0 ) AND (  wa_pomailstat-sendmaila10 IS INITIAL OR wa_pomailstat-lastchange <> wa_podate-lastchangedatetime ).
        lv_str = 'A10'.
        wa_pomailstat-lastchange = wa_podate-lastchangedatetime.
        wa_pomailstat-pocode = wa_podate-purchaseorder.
        wa_pomailstat-lastapprove = l_stmp.
        MODIFY zpo_mail_status  FROM @wa_pomailstat.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila10 = 'X' AND wa_pomailstat-sendmaila11 IS INITIAL.
        lv_str = 'A11'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila10 = 'X' AND wa_pomailstat-sendmaila11 = 'X' AND wa_pomailstat-sendmaila12 IS INITIAL.
        lv_str = 'A12'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila10 = 'X' AND wa_pomailstat-sendmaila11 = 'X' AND wa_pomailstat-sendmaila12 = 'X' AND wa_pomailstat-sendmaila13 IS INITIAL.
        lv_str = 'A13'.
      ELSEIF lv_diff > 120 AND wa_pomailstat-sendmaila10 = 'X' AND wa_pomailstat-sendmaila11 = 'X' AND wa_pomailstat-sendmaila12 = 'X' AND wa_pomailstat-sendmaila13 IS INITIAL.
        lv_str = 'FI'.
      ENDIF.
    ENDIF.

    SELECT SINGLE *
       FROM zdb_po_mail
       WHERE pocode = @wa_po
         AND strcode = @lv_str
       INTO @wa_pomail.
**    IF wa_workflowinternalid-workflowexternalstatus = 'COMPLETED'.
**      SELECT SINGLE createdbyuser
**          FROM i_purchaseorderapi01
**          WHERE purchaseorder = @wa_po
**          INTO @DATA(lv_user).
**      SELECT SINGLE businesspartner, addressid FROM i_bpprotectedaddress INTO @DATA(it_bp).
**    ELSE.
    IF wa_po IS NOT INITIAL AND wa_pomail-sendmail IS INITIAL.

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



          SELECT SINGLE * FROM zi_str_mail WHERE strcode = @lv_str INTO @DATA(wa_strmail).
          SELECT SINGLE purchasingprocessingstatus
              FROM i_purchaseorderapi01
              WHERE purchaseorder = @wa_po
              INTO @DATA(status).

          SELECT SINGLE SUM( a~grossamount ) AS totamnt , a~purchaseorder, b~supplier, c~performanceperiodstartdate, c~performanceperiodenddate, d~suppliername
              FROM i_purchaseorderitemapi01 AS a
              LEFT OUTER JOIN i_purchaseorderapi01 AS b ON a~purchaseorder = b~purchaseorder
              LEFT OUTER JOIN i_purordschedulelineapi01 AS c ON a~purchaseorder = c~purchaseorder
              LEFT OUTER JOIN i_supplier AS d ON b~supplier = d~supplier
              WHERE a~purchaseorder = @wa_po
              GROUP BY a~purchaseorder, b~supplier, c~performanceperiodstartdate, c~performanceperiodenddate, d~suppliername
              INTO @DATA(wa_tab).

*          wa_strmail-famailto = 'mayur.bhor@castaliaz.co.in'.
          IF wa_strmail-famailto IS NOT INITIAL.
            mail1 = wa_strmail-famailto.
            lo_mail->add_recipient( iv_address = mail1 iv_copy = cl_bcs_mail_message=>to ). " mail to 1
          ENDIF.
*          wa_strmail-famailto2 = 'vishal.pardeshi@castaliaz.co.in'.

          IF wa_strmail-famailto2 IS NOT INITIAL.
            mail2 = wa_strmail-famailto2.
            lo_mail->add_recipient( iv_address = mail2 iv_copy = cl_bcs_mail_message=>to ). " mail to 2
          ENDIF.
          IF wa_strmail-famailto3 IS NOT INITIAL.
            mail3 = wa_strmail-famailto3.
            lo_mail->add_recipient( iv_address = mail3 iv_copy = cl_bcs_mail_message=>to ). " mail to 3
          ENDIF.
*
*        "CC mail
*
          IF wa_strmail-famailcc IS NOT INITIAL.
            cc1 = wa_strmail-famailcc.
            lo_mail->add_recipient( iv_address = cc1 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.
*
          IF wa_strmail-famailcc2 IS NOT INITIAL.
            cc2 = wa_strmail-famailcc2.
            lo_mail->add_recipient( iv_address = cc2 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.
*
          IF wa_strmail-famailcc3 IS NOT INITIAL.
            cc3 = wa_strmail-famailcc3.
            lo_mail->add_recipient( iv_address = cc3 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.
*
          IF wa_strmail-famailcc4 IS NOT INITIAL.
            cc4 = wa_strmail-famailcc4.
            lo_mail->add_recipient( iv_address = cc4 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.
*
          IF wa_strmail-famailcc5 IS NOT INITIAL.
            cc5 = wa_strmail-famailcc5.
            lo_mail->add_recipient( iv_address = cc5 iv_copy = cl_bcs_mail_message=>cc ).
          ENDIF.

          DATA(lv_frmdt) = | { wa_tab-performanceperiodstartdate+6(2) }-{ wa_tab-performanceperiodstartdate+4(2) }-{ wa_tab-performanceperiodstartdate+0(4) } to |.
*            CONCATENATE wa_tab-performanceperiodstartdate+6(2) '-' wa_tab-performanceperiodstartdate+4(2) '-' wa_tab-performanceperiodstartdate+0(4) ' ' 'to' ' ' INTO DATA(lv_frmdt).
          CONCATENATE wa_tab-performanceperiodenddate+6(2) '-' wa_tab-performanceperiodenddate+4(2) '-' wa_tab-performanceperiodenddate+0(4) INTO DATA(lv_todt).
**Subject of Email
          lo_mail->set_subject( |Attention required: WO available for approval - { wa_tab-purchaseorder }| ).
*            lo_mail->set_subject( | RFQ: { wa-requestforquotation } [{ requestforquotationname }]. | ).
          DATA:lv_content TYPE string,
               lv_border  TYPE string VALUE 'border : 1px solid black;'.
          lv_content = | <p>Dear Sir,</p><p>Based on the below information, below WO available for your approval- </p></br> | &&
        ""<p>Godrej Living Pvt Ltd has invited you to place a bid on the following request for quotation: | && "{ wa-requestforquotation } | &&
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

          DATA : ls_strmail TYPE TABLE OF ztab_str_mail.

          APPEND : wa_strmail TO ls_strmail.
          LOOP AT ls_strmail ASSIGNING FIELD-SYMBOL(<fs_sendmail>).
            <fs_sendmail>-sendmail = 'Yes'.
          ENDLOOP.
          wa_pomail-sendmail    = 'Yes'.
          wa_pomail-pocode      = wa_po.
          wa_pomail-strcode     = lv_str.
*           UPDATE ztab_str_mail set sendmail = 'Yes' where strcode = @wa_strmail-Strcode.
          MODIFY zdb_po_mail FROM @wa_pomail .

          wa_pomailstat-pocode = wa_po.
          CASE lv_str.
            WHEN 'A1'.
              wa_pomailstat-sendmaila1 = 'X'.
            WHEN 'A2'.
              wa_pomailstat-sendmaila2 = 'X'.
            WHEN 'A3'.
              wa_pomailstat-sendmaila3 = 'X'.
            WHEN 'A4'.
              wa_pomailstat-sendmaila4 = 'X'.
            WHEN 'A5'.
              wa_pomailstat-sendmaila5 = 'X'.
            WHEN 'A6'.
              wa_pomailstat-sendmaila6 = 'X'.
            WHEN 'A7'.
              wa_pomailstat-sendmaila7 = 'X'.
            WHEN 'A8'.
              wa_pomailstat-sendmaila8 = 'X'.
            WHEN 'A9'.
              wa_pomailstat-sendmaila9 = 'X'.
            WHEN 'A10'.
              wa_pomailstat-sendmaila10 = 'X'.
            WHEN 'A11'.
              wa_pomailstat-sendmaila11 = 'X'.
            WHEN 'A12'.
              wa_pomailstat-sendmaila12 = 'X'.
            WHEN 'A13'.
              wa_pomailstat-sendmaila13 = 'X'.
            WHEN 'FI'.
              wa_pomailstat-sendmaila13 = 'X'.

          ENDCASE.

          MODIFY zpo_mail_status FROM @wa_pomailstat.
        CATCH cx_bcs_mail  INTO DATA(lv_mail).          "#EC NO_HANDLER
      ENDTRY.
    ENDIF.
**    ENDIF.
  ENDMETHOD.
ENDCLASS.

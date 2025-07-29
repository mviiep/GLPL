*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS loc DEFINITION.

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_buffer.
             INCLUDE TYPE   ZI_RFQ_Supsummary AS data.
    TYPES:   flag TYPE c LENGTH 1,
           END OF ty_buffer.

   types: begin of ty_supplier,
            rfqno           type ebeln,
            suppliercode    type lifnr,
            apprflag        type c LENGTH 1,
           end   of ty_supplier,
           tty_supplier type STANDARD TABLE OF ty_supplier.
   types: begin of ty_msgs,
            msgtyp  type sy-msgty,
            msgtxt  type sy-msgv1,
         end   of ty_msgs,
         tty_msgs   type STANDARD TABLE OF ty_msgs.

    TYPES tdata TYPE TABLE OF ty_buffer.
    CLASS-DATA mt_data TYPE tdata.

    CLASS-DATA:thead            TYPE TABLE OF ZI_RFQ_Supsummary,
               tdel             type table of ZI_RFQ_Supsummary,
               gt_supplier      type tty_supplier,              "To create quotations
               gt_rfqpublish    type STANDARD TABLE OF ztb_rfqsuplrritm,
               gv_upd_flag      type c,
               it_msglogs        type standard table of ztb_rfq_logs,
               gv_opmode        type c.
ENDCLASS.

CLASS lhc_zi_rfq_supsummary DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZI_RFQ_Supsummary RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE ZI_RFQ_Supsummary.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ZI_RFQ_Supsummary.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE ZI_RFQ_Supsummary.

    METHODS read FOR READ
      IMPORTING keys FOR READ ZI_RFQ_Supsummary RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ZI_RFQ_Supsummary.

ENDCLASS.

CLASS lhc_zi_rfq_supsummary IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen        LIKE LINE OF mapped-ZI_RFQ_Supsummary,
          tgdt          LIKE LINE OF loc=>mt_data,
          wa_mail       TYPE zi_rfq_suppliers,
          it_suppliers  type loc=>tty_supplier,
          wa_suppliers  type loc=>ty_supplier.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zi_rfq_supsummary.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.

"RFQ Publish
    DATA: lt_itab       type STANDARD TABLE OF ZI_RFQ_Supsummary,
          lv_csrftoken  type string,
          lv_errflag    type c LENGTH 1,
          lv_updflag    type c LENGTH 1,
          lt_cookies    type IF_WEB_HTTP_REQUEST=>COOKIES.
   data: wa_record like line of reported-zi_rfq_supsummary.
   data: lv_msgtyp      type IF_ABAP_BEHV_MESSAGE=>T_SEVERITY,
         lwa_msg        type zcl_rfq_utility=>ty_msgs.

    MOVE-CORRESPONDING loc=>thead TO lt_itab.

      data(lv_rfq)    = VALUE #( lt_itab[ 1 ]-RequestForQuotation OPTIONAL ).
      if lv_rfq is not INITIAL.
          select * from ztb_rfqsuplrritm
                    WHERE rfq_number     = @lv_rfq
                    into table @data(lt_rfqtab).

           sort lt_rfqtab by rfq_number rec_counter.
           delete ADJACENT DUPLICATES FROM lt_rfqtab COMPARING rfq_number rec_counter.

" To skip creating supplier quotations for those unregistered vendors (where supplier code doesn't exist)
           delete lt_rfqtab where supplier_code1 = '0000000000'.
           delete lt_rfqtab where supplier_code1 is INITIAL.

           data(wa_rfqtab) = VALUE #( lt_rfqtab[ apprl_flag = 'X' ] OPTIONAL ).

      else.
        RETURN.
      endif.

      if wa_rfqtab is INITIAL.
        return.
      endif.
*&----------------------------------------------------------&*
* To add new supplier in case not added at RFQ creation time - starts
* it will add if RFQ is not published yet
*&----------------------------------------------------------&*
    data: it_bidder_temp type zcl_rfq_utility=>tty_bidder.
    select single RFQLifecycleStatus
            from I_Requestforquotation_Api01
                where RequestForQuotation = @lv_rfq
                INTO @data(lv_rfqstat).
    if lv_rfqstat = '01'.       "Add bidder if RFQ is not published, else skip adding new bidder
            select * from I_RfqBidder_Api01
                      where RequestForQuotation = @lv_rfq
                      ORDER BY RequestForQuotation, Supplier
                      into table @data(it_bidder).

         data(lt_rfqtab_temp) = lt_rfqtab.
         sort lt_rfqtab_temp by rfq_number supplier_code1.
         loop at it_bidder into data(wa_bidder).
            delete lt_rfqtab_temp where rfq_number = wa_bidder-RequestForQuotation
                                    and supplier_code1 = wa_bidder-Supplier.
         endloop.
         sort it_bidder by RequestForQuotation PartnerCounter.

         data(lv_cntr) = VALUE #( it_bidder[ lines( it_bidder ) ]-PartnerCounter OPTIONAL ).
         loop at lt_rfqtab_temp into data(wa_temp).
            lv_cntr = lv_cntr + 1.
            wa_bidder-RequestForQuotation   = wa_temp-rfq_number.
            wa_bidder-PartnerCounter        = lv_cntr.
            wa_bidder-PartnerFunction       = 'BI'.
            WA_BIDDER-Supplier              = wa_temp-supplier_code1.

            data(lv_subrc) = zcl_rfq_utility=>add_bidder_torfq( exporting is_bidder = WA_BIDDER ).
*            append wa_bidder to it_bidder_temp.
            clear: wa_bidder.
         endloop.


        if lv_subrc = 0.
" success msg
            clear: lv_errflag .
         else.
" error msg

           lv_errflag  = 'X'.
        endif.

     endif.
*&----------------------------------------------------------&*
* To add new supplier in case not added at RFQ creation time - Ends
*&----------------------------------------------------------&*

    if lv_errflag is initial.
*&----------------------------------------------------------&*
* "Publish RFQ - Starts
*&----------------------------------------------------------&*
        clear: lv_csrftoken, lt_cookies.
        case lv_rfqstat.
        when '01'.
            lv_subrc = zcl_rfq_utility=>rfq_publish( EXPORTING iv_rfqno = lv_rfq
                                                     IMPORTING ep_csrftoken = lv_csrftoken
                                                               et_cookies  = lt_cookies ).
        when '02'.
            lwa_msg-msgtyp  = if_abap_behv_message=>severity-error.
            lwa_msg-msgtxt  = |RFQ { lv_rfq } was already published |.
            append lwa_msg to zcl_rfq_utility=>gt_msgs.
            clear: lwa_msg.
            lv_subrc = 0.       "Proceed with creating supplier quotations
        when '03'.
            lwa_msg-msgtyp  = if_abap_behv_message=>severity-error.
            lwa_msg-msgtxt  = |RFQ { lv_rfq } was already cancelled |.
            append lwa_msg to zcl_rfq_utility=>gt_msgs.
            clear: lwa_msg.
            lv_subrc = 4.       "Do not process further as it is cancelled
        when OTHERS.
            lv_subrc = 4.       "Do not process further as unknown status
        endcase.
*&----------------------------------------------------------&*
* "Publish RFQ - Ends
*&----------------------------------------------------------&*

"" if RFQ is published then create supplier quotations.
         if lv_subrc = 0.
         wait up to 4 seconds.
*&----------------------------------------------------------&*
* "Create supplier quotations - starts
*&----------------------------------------------------------&
* Check if supplier quotations already created for suppler/RFQ
       if lt_rfqtab is not initial.
          select from I_SupplierQuotation_Api01 as a
          FIELDS
          a~SupplierQuotation,
          a~RequestForQuotation,
          a~Supplier
          FOR ALL ENTRIES IN @lt_rfqtab
            where a~RequestForQuotation = @lt_rfqtab-rfq_number
              and a~Supplier            = @lt_rfqtab-supplier_code1
          into table @data(it_supquot).

          sort it_supquot by RequestForQuotation Supplier.
          sort lt_rfqtab by rfq_number supplier_code1.
          loop at it_supquot INTO data(lwa_supquot).
*            wa_rfqtab = value #( lt_rfqtab[ 1 ] OPTIONAL ).
            delete lt_rfqtab where rfq_number     = lwa_supquot-RequestForQuotation
                               and supplier_code1 = lwa_supquot-Supplier.
          ENDLOOP.
        endif.
* Return error msg in case supplier quotation already created
          if lines( lt_rfqtab ) <= 0.
            lwa_msg-msgtyp  = if_abap_behv_message=>severity-error.
            lwa_msg-msgtxt  = |Supplier quotations already created for RFQ{ lv_rfq }|.
            append lwa_msg to zcl_rfq_utility=>gt_msgs.
            clear: lwa_msg.
            lv_subrc = 4.       "Do not process further
            data(lv_superrflag) = 'X'.
            clear: lt_rfqtab.
          endif.

          sort lt_rfqtab by rfq_number rec_counter.
          if lv_superrflag is INITIAL.
              loop at lt_rfqtab INTO data(wa_supplier).

                if ( wa_supplier-supplier_code1 <> '0000000000' ) and wa_supplier-supplier_code1 is not INITIAL.
                data(lv_quotno) = zcl_rfq_utility=>create_supplierquotation( exporting ip_rfqno         = wa_supplier-rfq_number
                                                                                       ip_suppliercode  = wa_supplier-supplier_code1
                                                                                       ip_apprl_flag    = wa_supplier-apprl_flag
                                                                                        ).
                    if lv_quotno is INITIAL.
                        exit.
                    endif.
                endif.
              ENDLOOP.
          ENDIF.
*&----------------------------------------------------------&*
* "Create supplier quotations - ends
*&----------------------------------------------------------&
* Commented below code to mark RFQ as complete as it will through error due to
* the supplier quotation sent approval hence that supplier quotation can't be marked as complete
*             if lv_quotno is not initial.
*               lv_subrc = zcl_rfq_utility=>RFQ_Complete( EXPORTING ip_rfqno = lv_rfq ).
*             endif.

         endif.

     clear: loc=>gt_rfqpublish, loc=>gt_supplier, loc=>gv_upd_flag, loc=>tdel, loc=>thead.
    endif.

    data: wa_rfqlogs   type ztb_rfq_logs,
          it_rfqlogs        type standard table of ztb_rfq_logs,
          lv_rcntr          type n LENGTH 4.

   select count( * )
        from ztb_rfq_logs where requestforquotation = @lv_rfq
        into @data(lv_rcount).

        lv_rcntr = lv_rcount.

   loop at zcl_rfq_utility=>gt_msgs into lwa_msg.

*  wa_record-%msg = lwa_msg-msgtxt.
     lv_msgtyp = cond #( when lwa_msg-msgtyp = 'E' then if_abap_behv_message=>severity-error
                         when lwa_msg-msgtyp = 'S' then if_abap_behv_message=>severity-success ).
      data(wa_msg)  =     me->new_message( EXPORTING
                           id     = 'ZMSG_PR_UPDATE'
                           number = 010
                           severity = lv_msgtyp
                           v1       = lwa_msg-msgtxt
                           v2       = lwa_msg-msgv2 ).
        wa_record-%msg = wa_msg.
        wa_record-%tky-%key-RequestForQuotation =    lv_rfq.

        append wa_record to reported-zi_rfq_supsummary.

* For logs
        lv_rcntr = lv_rcntr + 1.
        wa_rfqlogs-requestforquotation  = lv_rfq.
        wa_rfqlogs-recordcounter = lv_rcntr.
        wa_rfqlogs-msgtyp        = lwa_msg-msgtyp.
        wa_rfqlogs-msgtext       = lwa_msg-msgtxt.
        append wa_rfqlogs to it_rfqlogs.
        clear: wa_rfqlogs.
    ENDLOOP.
    if it_rfqlogs is not INITIAL and lv_superrflag is INITIAL.
*        modify ztb_rfq_logs from table @it_rfqlogs.
        move-CORRESPONDING it_rfqlogs to loc=>it_msglogs.
        loc=>gv_opmode  = 'C'.              "Create Mode
    endif.
  ENDMETHOD.

  METHOD update.

**********************************************************************
** Data Definition
**********************************************************************

    DATA: mapgen  LIKE LINE OF mapped-zi_rfq_supsummary,
          tgdt    LIKE LINE OF loc=>mt_data.

**********************************************************************
    LOOP AT entities INTO DATA(wa).

      MOVE-CORRESPONDING wa TO mapgen.
      MOVE-CORRESPONDING wa TO tgdt.


      APPEND mapgen TO mapped-zi_rfq_supsummary.
      APPEND tgdt TO loc=>thead.

    ENDLOOP.
    loc=>gv_opmode  = 'U'.          "Update mode
  ENDMETHOD.

  METHOD delete.
  data: lwa_line type ZI_RFQ_Supsummary.
    loop at keys INTO data(lwa_key).
    lwa_line-requestforquotation = lwa_key-RequestForQuotation.
"    lwa_line-rfq_item      = lwa_key-rfq_item.
    append lwa_line to loc=>tdel.
    clear: lwa_line.
    ENDLOOP.
    loc=>gv_opmode  = 'D'.      "Delete mode
  ENDMETHOD.

*end of delete method

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

"**************************************************************************"
" SAVER Class definition and implementation
"**************************************************************************"
CLASS lsc_zi_rfq_supsummary DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_rfq_supsummary IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

"***************************************************************"
" SAVE Method
"***************************************************************"
  METHOD save.
    types: begin of ty_supplier,
            rfqno           type ebeln,
            suppliercode    type lifnr,
            apprflag        type c LENGTH 1,
           end   of ty_supplier,
           tty_supplier type STANDARD TABLE OF ty_supplier.

    DATA : lt_itab      type STANDARD TABLE OF ZI_RFQ_Supsummary,
           lt_data      TYPE STANDARD TABLE OF ztb_rfqsuplrritm,
           wa_data      type ztb_rfqsuplrritm,
           it_supplier  type loc=>tty_supplier,
           wa_supplier  type loc=>ty_supplier,
           upd_flag     type c,
           lv_errflag   type c LENGTH 1,
           lv_csrftoken type string.

"If Delete is requested

    if loc=>tdel is not INITIAL and loc=>gv_opmode  = 'D'.  "Deletion mode
        loop at loc=>tdel INTO data(lwa_del).
            delete from ztb_rfqsuplrritm where rfq_number = @lwa_del-RequestForQuotation.

        endloop.
        clear: loc=>tdel.
        return.
    endif.

* Check logs
    if loc=>it_msglogs is not INITIAL and loc=>gv_opmode  = 'C'.    "Creation mode to call api's
        modify ztb_rfq_logs from table @loc=>it_msglogs.
        clear: loc=>it_msglogs.
    endif.

* In Case of approval flag
    MOVE-CORRESPONDING loc=>thead TO lt_itab.

    loop at lt_itab INTO data(lwa_itab).
        wa_Data-rfq_number  = lwa_itab-RequestForQuotation.
"        wa_data-rfq_item    = lwa_itab-rfq_item.

        if lwa_itab-aprl_flg1 is not INITIAL.
            wa_data-supplier_code1 = lwa_itab-supplier_code1.
        endif.
       if lwa_itab-aprl_flg2 is not INITIAL.
            wa_data-supplier_code1 = lwa_itab-supplier_code2.
        endif.
        if lwa_itab-aprl_flg3 is not INITIAL.
            wa_data-supplier_code1 = lwa_itab-supplier_code3.
        endif.
       if lwa_itab-aprl_flg4 is not INITIAL.
            wa_data-supplier_code1 = lwa_itab-supplier_code4.
        endif.
        if lwa_itab-aprl_flg5 is not INITIAL.
            wa_data-supplier_code1 = lwa_itab-supplier_code5.
        endif.

        if wa_data-supplier_code1 is not INITIAL.
            wa_data-apprl_flag = 'X'.
            append wa_data to lt_data.
        endif.

" Build internal table with all supplier codes to create quotation
        wa_supplier-rfqno           = lwa_itab-RequestForQuotation.
        if lwa_itab-supplier_code1 <> '0000000000' and lwa_itab-supplier_code1 is not INITIAL.
            wa_supplier-suppliercode    = lwa_itab-supplier_code1.
            wa_supplier-apprflag        = COND #( when lwa_itab-aprl_flg1 is not initial then 'X' else '' ).
            append wa_supplier to it_supplier.
        endif.
       if lwa_itab-supplier_code2 <> '0000000000' and lwa_itab-supplier_code2 is not INITIAL.
            wa_supplier-suppliercode    = lwa_itab-supplier_code2.
            wa_supplier-apprflag        = COND #( when lwa_itab-aprl_flg2 is not initial then 'X' else '' ).
            append wa_supplier to it_supplier.
        endif.
        if lwa_itab-supplier_code3 <> '0000000000' and lwa_itab-supplier_code3 is not INITIAL.
            wa_supplier-suppliercode    = lwa_itab-supplier_code3.
            wa_supplier-apprflag        = COND #( when lwa_itab-aprl_flg3 is not initial then 'X' else '' ).
            append wa_supplier to it_supplier.
        endif.
       if lwa_itab-supplier_code4 <> '0000000000' and lwa_itab-supplier_code4 is not INITIAL.
            wa_supplier-suppliercode    = lwa_itab-supplier_code4.
            wa_supplier-apprflag        = COND #( when lwa_itab-aprl_flg4 is not initial then 'X' else '' ).
            append wa_supplier to it_supplier.
        endif.
       if lwa_itab-supplier_code5 <> '0000000000' and lwa_itab-supplier_code5 is not INITIAL.
            wa_supplier-suppliercode    = lwa_itab-supplier_code5.
            wa_supplier-apprflag        = COND #( when lwa_itab-aprl_flg5 is not initial then 'X' else '' ).
            append wa_supplier to it_supplier.
        endif.

        clear: wa_data, wa_supplier.
    ENDLOOP.

"
    sort it_supplier by rfqno suppliercode.
    delete ADJACENT DUPLICATES FROM it_supplier COMPARING rfqno suppliercode.
*
** Keep it in local header
*    if it_supplier is not INITIAL.
*        MOVE-CORRESPONDING it_supplier to loc=>gt_supplier.
*    endif.

    sort lt_data by rfq_number supplier_code1.
    delete ADJACENT DUPLICATES FROM lt_data COMPARING rfq_number supplier_code1.
    if lt_data is NOT INITIAL.
        MOVE-CORRESPONDING lt_data to loc=>gt_rfqpublish.
    endif.

*    data(lv_rfqno) = VALUE #(  lt_itab[ 1 ]-RequestForQuotation OPTIONAL ).
     data(lv_rfqno) = lwa_itab-RequestForQuotation.


* Get data from ZIRFQ_SUPPMAIL to update newly added supplier code - Starts
      sort lt_itab by RequestForQuotation.
      select * from zirfq_suppmail
                    where requestforquotation = @lv_rfqno
                    into table @data(lt_suppmail).
*
    if lwa_itab-comp_comments is not INITIAL.
        lt_suppmail = value #( let lt_suppmail_temp = lt_suppmail in for <f5> in lt_suppmail_temp ( value #( base <f5> comp_comments = lwa_itab-comp_comments  ) ) ).
        modify zirfq_suppmail from table @lt_suppmail.
    endif.

*      delete lt_suppmail where supplier <> '0000000000'.
      delete lt_suppmail where unreg_flag <> 'X'.

      LOOP  AT LT_SUPPMAIL ASSIGNING FIELD-SYMBOL(<f2>).
       data(lv_name) = to_upper( <f2>-suppliername ).
       data(wa_itab) = VALUE #( lt_itab[ RequestForQuotation = <f2>-requestforquotation ] OPTIONAL ).
*&------------------------------------------------------------------------&*
* Check new supplier code entered for unregistered vendors
*&------------------------------------------------------------------------&*
*      if  <f2>-supplier = '0000000000' .
      if  <f2>-unreg_flag = 'X' .
           if lv_name = to_upper( wa_itab-suppliername1 ) and wa_itab-supplier_code1 is not initial.
                <f2>-supplier = wa_itab-supplier_code1.
           endif.
           if lv_name = to_upper( wa_itab-suppliername2 ) and wa_itab-supplier_code2 is not initial.
                <f2>-supplier = wa_itab-supplier_code2.
           endif.
           if lv_name = to_upper( wa_itab-suppliername3 ) and wa_itab-supplier_code3 is not initial.
                <f2>-supplier = wa_itab-supplier_code3.
           endif.
           if lv_name = to_upper( wa_itab-suppliername4 ) and wa_itab-supplier_code4 is not initial.
                <f2>-supplier = wa_itab-supplier_code4.
           endif.
           if lv_name = to_upper( wa_itab-suppliername5 ) and wa_itab-supplier_code5 is not initial.
                <f2>-supplier = wa_itab-supplier_code5.
           endif.
       endif.
       clear: wa_itab, lv_name.
      Endloop.

      delete lt_suppmail where supplier = '0000000000'.
      if lt_suppmail is not INITIAL.
        UNASSIGN <f2>.
        modify zirfq_suppmail from table @lt_suppmail.
        sort lt_suppmail by requestforquotation rec_counter.
        select * from ztb_rfqsuplrritm
                     FOR ALL ENTRIES IN @lt_suppmail
                     WHERE rfq_number   = @lt_suppmail-requestforquotation
                       and rec_counter  = @lt_suppmail-rec_counter
                     INTO table @data(lt_itmdata).

        loop at lt_itmdata ASSIGNING FIELD-SYMBOL(<f3>).
*            if <f3>-supplier_code1 = '0000000000' or <f3>-supplier_code1 is INITIAL.
               <f3>-supplier_code1 = value #( lt_suppmail[ requestforquotation = <f3>-rfq_number
                                                           rec_counter         = <f3>-rec_counter ]-supplier  optional ).
*            endif.
        endloop.
        if lv_errflag is not INITIAL.
            return.
        endif.
        modify ztb_rfqsuplrritm from table @lt_itmdata.
      endif.
*&------------------------------------------------------------------------&*
* Get data from ZIRFQ_SUPPMAIL to update newly added supplier code - Ends
*&------------------------------------------------------------------------&*
    if lt_data is not INITIAL.
        select * from ztb_rfqsuplrritm
                     FOR ALL ENTRIES IN @lt_data
                        WHERE rfq_number   = @lt_data-rfq_number
                          and supplier_code1 = @lt_data-supplier_code1
                        into table @data(lt_rfqtab).
        sort lt_rfqtab by rfq_number rfq_item supplier_code1.
        LOOP AT lt_rfqtab ASSIGNING FIELD-SYMBOL(<f1>).
            <f1>-apprl_flag = 'X'.
            UPDATE  ztb_rfqsuplrritm set apprl_flag = @<f1>-apprl_flag
                                        WHERE rfq_number = @<f1>-rfq_number
                                          AND rfq_item   = @<f1>-rfq_item
                                          and supplier_code1 = @<f1>-supplier_code1.
"            upd_flag = 'X'.
            loc=>gv_upd_flag   = 'X'.

        ENDLOOP.
"        modify ztb_rfqsuplrritm from table @lt_rfqtab.

    endif.

  ENDMETHOD.

  METHOD cleanup.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

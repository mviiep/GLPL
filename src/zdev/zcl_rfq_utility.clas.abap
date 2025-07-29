CLASS zcl_rfq_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  types: begin of ty_msgs,
            msgtyp  type sy-msgty,
            msgtxt  type sy-msgv1,
            msgv2   type sy-msgv2,
         end   of ty_msgs,
         tty_msgs   type STANDARD TABLE OF ty_msgs,
         tty_bidder type standard table of I_RfqBidder_Api01.

    class-data: gt_msgs type tty_msgs.
    CONSTANTS: gc_e type C LENGTH 1 VALUE 'E',
               gc_s TYPE C LENGTH 1 VALUE 'S'.

    class-METHODS: get_srvurl   importing iv_service type string
                                RETURNING VALUE(ep_url) type string,

                   add_bidder_torfq IMPORTING
*                                                it_bidder   type  tty_bidder
                                                is_bidder    type I_RfqBidder_Api01
                                    RETURNING VALUE(ep_subrc) type sy-subrc,

                   rfq_publish IMPORTING iv_rfqno       type ebeln
                               EXPORTING ep_csrftoken   type string
                                         et_cookies     type IF_WEB_HTTP_REQUEST=>COOKIES
                               RETURNING VALUE(ep_subrc) type sy-subrc,

                   create_supplierquotation IMPORTING ip_rfqno          type ebeln
                                                      ip_suppliercode   type lifnr
                                                      ip_apprl_flag     type C
*                                                      ip_csrftoken      type string OPTIONAL
                                                      ipt_cookies       type IF_WEB_HTTP_REQUEST=>COOKIES OPTIONAL
                               RETURNING VALUE(ep_quotno)   type ebeln,

                   RFQ_Complete IMPORTING ip_rfqno  type ebeln
*                                          ip_csrftoken      type string OPTIONAL
*                                          ipt_cookies       type IF_WEB_HTTP_REQUEST=>COOKIES OPTIONAL
                                RETURNING VALUE(ep_subrc)   type sy-subrc.
  PROTECTED SECTION.
  PRIVATE SECTION.
    class-METHODS: supplierquot_itemprice_update IMPORTING ip_url             type string
                                                     ip_supquotno       type ebeln  "Supplier quotation no
                                                     ip_rfqno           type ebeln  "RFQ Number
                                                     ip_supplier        type lifnr
                                           returning value(ep_subrc)    type sy-subrc.
ENDCLASS.



CLASS ZCL_RFQ_UTILITY IMPLEMENTATION.


    METHOD add_bidder_torfq.
*&-----------------------------------------------------------------&*
" add new bidder to RFQ - Starts
*&-----------------------------------------------------------------&*
 "RequestForQuotation": "string",
   "PartnerCounter": "string",
   "PartnerFunction": "string",
   "Supplier": "string"
        types: begin of ty_rfq,
                _Request_For_Quotation type string,
                _Partner_Counter       type string,
                _Partner_Function      type string,
                _Supplier              type string,
               end   of ty_rfq,
               tty_rfq type standard table of ty_rfq.
        DATA:
            lv_access_token     TYPE string,
            lo_http_token       TYPE REF TO if_web_http_client,
            lo_http_client_bid  type ref to if_web_http_client,
            lv_csrftoken    type string,
            lwa_rfq         type ty_rfq,
            it_rfq          type tty_rfq,
            wa_msg          type ty_msgs.

       data(lo_url) = get_srvurl( exporting iv_service = 'API_RFQ_PROCESS_SRV' ).
* Read credentials
          SELECT SINGLE *
            FROM zi_cs_id
                WHERE systemid = @sy-mandt
                INTO @DATA(wa_idpass).

        TRY.
            lo_http_token = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).

        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

" To fetch x-csrf-token
           DATA(lo_request) = lo_http_token->get_http_request( ).
            lo_request->set_header_fields(  VALUE #( ( name = 'Content-Type'  value = 'application/json' )
                                                     ( name = 'x-csrf-token'  value = 'Fetch' )
                                                    )  ).
           lo_request->set_authorization_basic(
                              EXPORTING
                                i_username = wa_idpass-username
                                i_password = wa_idpass-password ).
        TRY.

            DATA(lo_response) = lo_http_token->execute( i_method  = if_web_http_client=>get ).

        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

        ENDTRY.

        DATA(lv_status) = lo_response->get_status( ).
        DATA(lv_json_response) = lo_response->get_text( ).

        lv_csrftoken = lo_response->get_header_field( exporting i_name = 'x-csrf-token' ).
        lo_response->get_cookies(
              RECEIVING
                r_value = DATA(it_cookies)
            ).

        TRY.
*            lo_http_client->close(  ).
            if lv_status-code <> 200.
                return.     "exit in case error in receiving csrf token
            endif.
* Adding new bidder
        CONCATENATE lo_url 'A_RequestForQuotationBidder' into data(lv_urlnew).

        lo_http_client_bid = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

        data(lo_request_bid) = lo_http_client_bid->get_http_request( ).

        lo_request_bid->set_header_fields(  VALUE #( (  name = 'Content-Type'  value = 'application/json' )
                                                     (  name = 'x-csrf-token'  value = lv_csrftoken )
                                                   )   ).

          loop at it_cookies into data(ls_cookie).
            lo_request_bid->set_cookie( EXPORTING
                                          i_name    = ls_cookie-name
                                          i_value   = ls_cookie-value
                                          i_path    = ls_cookie-path
                                          i_secure  = ls_cookie-secure ).
          endloop.

              lwa_rfq-_request_for_quotation = is_bidder-RequestForQuotation.
              lwa_rfq-_partner_counter       = is_bidder-PartnerCounter.
              lwa_rfq-_partner_function      = is_bidder-PartnerFunction.
              lwa_rfq-_supplier              = is_bidder-Supplier.

          data(lv_json) =  /ui2/cl_json=>serialize( exporting data = lwa_rfq
                                                              pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
          lo_request_bid->set_text( EXPORTING  i_text = lv_json ).

           data(lo_response_bid) = lo_http_client_bid->execute( i_method  = if_web_http_client=>post ).

            data(lv_resptext)    = lo_response_bid->get_text(  ).
            data(lv_status_bid) = lo_response_bid->get_status(  ).
           if lv_status_bid-code = 200 or
              lv_status_bid-code = 201.
                ep_subrc = 0.
                wa_msg-msgtyp   = gc_s.
                wa_msg-msgtxt   = | Bidder { is_bidder-Supplier } has been added|.
                append wa_msg to gt_msgs.
           else.
                ep_subrc = 4.
                wa_msg-msgtyp   = gc_e.
                wa_msg-msgtxt   = |Error adding bidder { is_bidder-supplier } |.
                append wa_msg to gt_msgs.
           endif.
           lo_http_client_bid->close(  ).
           lo_http_token->close(  ).
       CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

        ENDTRY.
*&-----------------------------------------------------------------&*
" add new bidder to RFQ - Ends
*&-----------------------------------------------------------------&*
    ENDMETHOD.


    METHOD create_supplierquotation.
"************************************************
" METHOD create_supplierquotation -starts
"************************************************
     types: begin of ty_application,
                component_id    type string,
                service_namespace type string,
                service_id      type string,
                service_version type string,
            end   of ty_application,

            begin of ty_Error_Resolution,
                SAP_Transaction type string,
                SAP_Note        type string,
            end   of ty_Error_Resolution,

            begin of ty_errordetail,
                ContentID       type string,
                code            type string,
                message         type string,
                longtext_url    type string,
                propertyref     type string,
                severity        type string,
                target          type string,
                transition      type string,
            end   of ty_errordetail,

            begin of ty_errordetails,
                errordetail type ty_errordetail,
            end   of ty_errordetails,
            tty_errordetails TYPE standard table of ty_errordetails,

            begin of ty_innererror,
                application type ty_application,
                transactionid   type string,
                timestamp   type string,
                Error_Resolution    type ty_Error_Resolution,
*                errordetails        type standard table of ty_errordetails,
            end   of ty_innererror,

            begin of ty_error,
                code type string,
                message type string,
                innererror type string,
*                innererror  type ty_innererror,
            end   of ty_error.
       DATA:
            lv_access_token TYPE string,
            lo_http_token  TYPE REF TO if_web_http_client,
            lo_http_supquot  TYPE REF TO if_web_http_client,
            lv_csrf_token   type string,
            lv_flag         type c,
            wa_msg          type ty_msgs,
            wa_error        type ty_error.

        if ip_rfqno is INITIAL.
            return.
        endif.

"https://my417176.s4hana.cloud.sap/sap/opu/odata/sap/API_QTN_PROCESS_SRV/CreateFromRFQ?QuotationSubmissionDate=datetime'2024-12-27T00:00:00'&Supplier='10000'&RequestForQuotation='7000000035'
    data(lv_url) = get_srvurl( exporting iv_service = 'API_QTN_PROCESS_SRV' ).

" Get csrf token
     TRY.
        lo_http_token = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      catch cx_web_message_error. "#EC NO_HANDLER

    ENDTRY.

* Read credentials
          SELECT SINGLE *
            FROM zi_cs_id
                WHERE systemid = @sy-mandt
                INTO @DATA(wa_idpass).

" To fetch x-csrf-token
       DATA(lo_request) = lo_http_token->get_http_request( ).

        lo_request->set_header_fields(  VALUE #(
                                                   (  name = 'Content-Type'  value = 'application/json' )
                                                   (  name = 'x-csrf-token'  value = 'Fetch' )
                                              )   ).

       lo_request->set_authorization_basic(
                          EXPORTING
                            i_username = wa_idpass-username
                            i_password = wa_idpass-password
                        ).
     TRY.
        DATA(lo_response) = lo_http_token->execute( i_method  = if_web_http_client=>get ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

      data(lv_msg) = lo_Response->get_text(  ).

    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

        lv_csrf_token = lo_response->get_header_field( exporting i_name = 'x-csrf-token' ).
        lo_response->get_cookies(
              RECEIVING
                r_value = DATA(it_cookies)
            ).

        if lv_status-code <> 200.
            return.     "exit in case error in receiving csrf token
        endif.

" To create supplier quotation
     TRY.
"        lo_http_client->close(  ).
"CreateFromRFQ?QuotationSubmissionDate=datetime'2024-12-27T00:00:00'&Supplier='10000'&RequestForQuotation='7000000035'
        data:
              lv_system_date TYPE d,
              lv_lifnr    type lifnr.

" Convert SY-DATUM to the desired format YYYY-MM-DD
            lv_system_date = cl_abap_context_info=>get_system_date( ).
            data(lv_date) = |{ lv_system_date(4) }-{ lv_system_date+4(2) }-{ lv_system_date+6(2) }|.

" Append time portion and wrap in single quotes for OData datetime
            data(lv_date_time) = |datetime'{ lv_date }T00:00:00'|.

        CONCATENATE lv_url 'CreateFromRFQ?QuotationSubmissionDate='
                             lv_date_time  '&Supplier='  '''' ip_suppliercode ''''
                            '&RequestForQuotation='  '''' ip_rfqno ''''  into data(lv_urlnew).

        lo_http_supquot = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

        lo_request = lo_http_supquot->get_http_request( ).
        lo_request->set_header_fields(  VALUE #( (  name = 'Content-Type'  value = 'application/json' )
                                                 (  name = 'x-csrf-token'  value = lv_csrf_token )
                                                )
                                     ).
         loop at it_cookies into data(ls_cookie).
            lo_request->set_cookie( EXPORTING
                                          i_name    = ls_cookie-name
                                          i_value   = ls_cookie-value
                                          i_path    = ls_cookie-path
                                          i_secure  = ls_cookie-secure ).
          endloop.

           lo_response = lo_http_supquot->execute( i_method  = if_web_http_client=>post ).
           lv_json_response = lo_response->get_text(  ).
           lv_status        = lo_response->get_status(  ).

    data: lv_data1  type string,
          lv_data2  type string.

"A_SupplierQuotation_2
    if lv_status-code   = 200.
        split lv_json_response at '<d:SupplierQuotation>' into lv_data1 lv_data2.
        if lv_data2 is not INITIAL.
           split lv_data2 at '</d:SupplierQuotation>' into lv_data1 lv_data2.
        else.
            clear: lv_data1.
        endif.
         ep_quotno = lv_data1.

       if lo_response->get_status(  )-code = 200 or
          lo_response->get_status(  )-code = 201 or
          ep_quotno is not INITIAL.

        lv_flag = 'X'.
        wa_msg-msgtyp   = gc_s.
        wa_msg-msgtxt   = |Supplier Quot { ep_quotno } has been created |.
        append wa_msg to zcl_rfq_utility=>gt_msgs.
       else.
        clear: ep_quotno, LV_FLAG.
        split lv_json_response at '<message xml:lang="en">' into lv_data1 lv_data2.
        if lv_data2 is not INITIAL.
            split lv_data2 at '</message>' into lv_data1 lv_data2.
        endif.
        wa_msg-msgtyp   = gc_e.
        data(lv_len)    = strlen( lv_data1 ).
        if lv_len > 50.
            lv_len = lv_len - 50.
            if lv_len > 50. lv_len = 50. endif.
            wa_msg-msgtxt = lv_data1+0(50).
            wa_msg-msgv2  = lv_data1+51(lv_len).
        else.
            wa_msg-msgtxt   = lv_data1.
        endif.
*        wa_error = lv_json_response.
        append wa_msg to zcl_rfq_utility=>gt_msgs.
       endif.
    else.
        split lv_json_response at '<message xml:lang="en">' into lv_data1 lv_data2.
        if lv_data2 is not INITIAL.
            split lv_data2 at '</message>' into lv_data1 lv_data2.
        endif.
        wa_msg-msgtyp   = gc_e.
        lv_len    = strlen( lv_data1 ).
        if lv_len > 50.
            lv_len = lv_len - 50.
            if lv_len > 50. lv_len = 50. endif.
            wa_msg-msgtxt = lv_data1+0(50).
            wa_msg-msgv2  = lv_data1+50(lv_len).
        else.
            wa_msg-msgtxt   = lv_data1.
        endif.
*        wa_error = lv_json_response.
        append wa_msg to zcl_rfq_utility=>gt_msgs.

    endif.

* Supplier quotation status update to Submit
       IF LV_FLAG IS NOT INITIAL.
            CLEAR: LV_FLAG.
            lo_http_supquot->close(  ).

* Supplier quotation change item price from custom table.
         data(lv_retncode) =  supplierquot_itemprice_update( EXPORTING
                                                          ip_url = lv_url
                                                          ip_supquotno = ep_quotno
                                                          ip_rfqno = ip_rfqno
                                                          ip_supplier = ip_suppliercode ).
*                                                          ip_csrftoken = lv_csrf_token
*                                                          ipt_cookies = it_cookies   ).
         if lv_retncode <> 0.
            return.         "do not process in case of item price not updated
         endif.

            CONCATENATE lv_url 'Submit?SupplierQuotation=' '''' ep_quotno '''' into lv_urlnew.

           lo_http_supquot = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

            lo_request = lo_http_supquot->get_http_request( ).
            lo_request->set_header_fields(  VALUE #(
                                                     (  name = 'Content-Type'  value = 'application/json' )
                                                     (  name = 'x-csrf-token'  value = lv_csrf_token )
                                                    )
                                         ).
          loop at it_cookies into ls_cookie.
            lo_request->set_cookie( EXPORTING
                                          i_name    = ls_cookie-name
                                          i_value   = ls_cookie-value
                                          i_path    = ls_cookie-path
                                          i_secure  = ls_cookie-secure ).
          endloop.
            lo_response = lo_http_supquot->execute( i_method  = if_web_http_client=>post ).
           data(lv_resptext)    = lo_response->get_text(  ).
            if lo_response->get_status(  )-code = 200.
                wa_msg-msgtyp   = gc_s.
                wa_msg-msgtxt   = |Supplier Quot { ep_quotno } Submitted|.
                append wa_msg to zcl_rfq_utility=>gt_msgs.

"Complete in case non-approved vendors
              CLEAR: LV_FLAG.
              case ip_apprl_flag.
                when 'X'.       "Submit for approval in case approved vendor
                    CONCATENATE lv_url 'SubmitForApproval?SupplierQuotation=' '''' ep_quotno '''' into lv_urlnew.
                when OTHERS.    "Complete quotation in case of unapproved vendors
                    CONCATENATE lv_url 'Complete?SupplierQuotation=' '''' ep_quotno '''' into lv_urlnew.
                return. " DO NOT PROCESS FURTHER AS Requested; user wants to sent other quotation for approval in case of previous rejection
              ENDCASE.
               lo_http_supquot = cl_web_http_client_manager=>create_by_http_destination(
                                        i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

                lo_request = lo_http_supquot->get_http_request( ).
                lo_request->set_header_fields(  VALUE #( (  name = 'Content-Type'  value = 'application/json' )
                                                         (  name = 'x-csrf-token'  value = lv_csrf_token )
                                                        )
                                             ).
              loop at it_cookies into ls_cookie.
                lo_request->set_cookie( EXPORTING
                                              i_name    = ls_cookie-name
                                              i_value   = ls_cookie-value
                                              i_path    = ls_cookie-path
                                              i_secure  = ls_cookie-secure ).
              endloop.
              lo_response = lo_http_supquot->execute( i_method  = if_web_http_client=>post ).
              lv_status = lo_response->get_status(  ).
              lv_resptext    = lo_response->get_text(  ).
              if lv_status-code = 200.
                wa_msg-msgtyp   = gc_s.
                if ip_apprl_flag is not INITIAL.
                    wa_msg-msgtxt   = |Supplier Quot { ep_quotno } sent for Approval|.
                else.
                    wa_msg-msgtxt   = |Supplier Quot { ep_quotno } status Completed|.
                endif.
                append wa_msg to zcl_rfq_utility=>gt_msgs.


              endif.
            endif.
        ENDIF.
        lo_http_token->close(  ).
        lo_http_supquot->close(  ).
    CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

    ENDTRY.

    ENDMETHOD.  "create_supplierquotation ends


    Method get_srvurl.
"************************************************
*" get_srvurl , Service URL method
"************************************************
        data: lv_url type string,
              lv_dev(3)       TYPE c VALUE 'N7O',
              lv_qas(3)       TYPE c VALUE 'M2S',
              lv_prd(3)       TYPE c VALUE 'KSZ'.
    " RFQ: API_RFQ_PROCESS_SRV
           case sy-sysid.
           when lv_dev.
                CONCATENATE 'https://my417176.s4hana.cloud.sap/sap/opu/odata/sap/' iv_service '/' INTO ep_url.
           when lv_qas.
                CONCATENATE 'https://my418964.s4hana.cloud.sap/sap/opu/odata/sap/' iv_service '/' INTO ep_url.
           when lv_prd.
*           https://my419924.s4hana.cloud.sap/ui
                CONCATENATE 'https://my419924.s4hana.cloud.sap/sap/opu/odata/sap/' iv_service '/' INTO ep_url.
           ENDCASE.

    ENDMETHOD.      "End get_srvurl method


    METHOD RFQ_Complete.
*&-----------------------------------------------------------------&*
* RFQ Complete
*&-----------------------------------------------------------------&*
      DATA:
            lv_access_token TYPE string,
            lo_http_token   TYPE REF TO if_web_http_client,
            lo_http_rfq     TYPE REF TO if_web_http_client,
            lv_flag         type c,
            lv_urlnew       type string,
            wa_msg          type ty_msgs,
            lv_csrftoken   type string.

         data(lv_url) = get_srvurl( exporting iv_service = 'API_RFQ_PROCESS_SRV' ).
*     Read credentials
              SELECT SINGLE *
                FROM zi_cs_id
                    WHERE systemid = @sy-mandt
                    INTO @DATA(wa_idpass).

    " Get csrf token
         TRY.
            lo_http_token = cl_web_http_client_manager=>create_by_http_destination(
                                    i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          catch cx_web_message_error. "#EC NO_HANDLER

        ENDTRY.

    " To fetch x-csrf-token
           DATA(lo_request) = lo_http_token->get_http_request( ).
            lo_request->set_header_fields(  VALUE #( (  name = 'Content-Type'  value = 'application/json' )
                                                     (  name = 'x-csrf-token'  value = 'Fetch' )
                                                 )   ).
           lo_request->set_authorization_basic(
                              EXPORTING
                                i_username = wa_idpass-username
                                i_password = wa_idpass-password  ).
         TRY.
          DATA(lo_response) = lo_http_token->execute( i_method  = if_web_http_client=>get ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

*          data(lv_resptext) = lo_Response->get_text(  ).

        ENDTRY.

        DATA(lv_status) = lo_response->get_status( ).
        DATA(lv_json_response) = lo_response->get_text( ).

            lv_csrftoken = lo_response->get_header_field( exporting i_name = 'x-csrf-token' ).
            lo_response->get_cookies(
                  RECEIVING
                    r_value = DATA(it_cookies)
                ).

            if lv_status-code <> 200.
                return.     "exit in case error in receiving csrf token
            endif.

* Mark RFQ status as complete
            CONCATENATE lv_url 'Complete?RequestForQuotation=' '''' ip_rfqno '''' into lv_urlnew.
        try.
            lo_http_rfq = cl_web_http_client_manager=>create_by_http_destination(
                                        i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

            data(lo_request_rfq) = lo_http_rfq->get_http_request( ).
            lo_request_rfq->set_header_fields(  VALUE #( ( name = 'Content-Type'  value = 'application/json' )
                                                         ( name = 'x-csrf-token'  value = lv_csrftoken )
                                                       )  ).
              loop at it_cookies into data(ls_cookie).
                lo_request_rfq->set_cookie( EXPORTING
                                              i_name    = ls_cookie-name
                                              i_value   = ls_cookie-value
                                              i_path    = ls_cookie-path
                                              i_secure  = ls_cookie-secure ).
              endloop.

              data(lo_response_rfq) = lo_http_rfq->execute( i_method  = if_web_http_client=>post ).
              lv_status = lo_response_rfq->get_status(  ).
              data(lo_resp_text) = lo_response_rfq->get_text(  ).

              if lv_status-code = 204.
                ep_subrc    = 0.
                wa_msg-msgtyp   = gc_s.
                wa_msg-msgtxt   = |RFQ { ip_rfqno } Marked Complete|.
                append wa_msg to zcl_rfq_utility=>gt_msgs.
              else.
                ep_subrc = 4.
                wa_msg-msgtyp   = gc_e.
                wa_msg-msgtxt   = |Errors in RFQ { ip_rfqno } to mark Complete|.
                append wa_msg to zcl_rfq_utility=>gt_msgs.
              endif.

            lo_http_rfq->close(  ).
            lo_http_token->close(  ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

        ENDTRY.
    ENDMETHOD.


    METHOD rfq_publish.
"************************************************
" rfq_publish Method
"************************************************
        types: begin of ty_rfq,
                _Request_For_Quotation type ebeln,
               end   of ty_rfq.
        DATA:
"            lv_url           TYPE string, "https://my417176.s4hana.cloud.sap/sap/opu/odata/sap/API_RFQ_PROCESS_SRV/
            lv_access_token     TYPE string,
            lo_http_token       TYPE REF TO if_web_http_client,
            lo_http_client_rfq  type ref to if_web_http_client,
            lv_dev(3)       TYPE c VALUE 'N7O',
            lv_qas(3)       TYPE c VALUE 'M2S',
            lv_prd(3)       TYPE c VALUE 'KSZ',
            lv_csrf_token   type string,
            lv_wa           type ty_rfq,
            wa_msg          type ty_msgs.

       data(lo_url) = get_srvurl( exporting iv_service = 'API_RFQ_PROCESS_SRV' ).
* Read credentials
          SELECT SINGLE *
            FROM zi_cs_id
                WHERE systemid = @sy-mandt
                INTO @DATA(wa_idpass).

"        lo_url = 'API_RFQ_PROCESS_SRV'
     TRY.
"        CONCATENATE lo_url 'SubmitForApproval?RequestForQuotation=' '''' iv_rfqno '''' into lo_url.
        lo_http_token = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).

      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
    ENDTRY.

" To fetch x-csrf-token
       DATA(lo_request) = lo_http_token->get_http_request( ).
        lo_request->set_header_fields(  VALUE #(
                                                 ( name = 'Content-Type'  value = 'application/json' )
                                                 ( name = 'x-csrf-token'  value = 'Fetch' )
                                                 ( name = 'Accept' Value = '*/*' )
*                                                 ( name = 'Cache-Control'              value = 'no-cache' )
                                                )
                                     ).

       lo_request->set_authorization_basic(
                          EXPORTING
                            i_username = wa_idpass-username
                            i_password = wa_idpass-password
                        ).

     TRY.
"        data(lv_url_suffix) = |/sap/opu/odata/sap/API_RFQ_PROCESS_SRV/SubmitForApproval?RequestForQuotation='{ iv_rfqno }'|.

        DATA(lo_response) = lo_http_token->execute(
                            i_method  = if_web_http_client=>get ).
"                            i_method  = if_web_http_client=>post ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
"       data(lv_msg) = lo_Response->get_text(  ).
    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

     lv_csrf_token = lo_response->get_header_field( exporting i_name = 'x-csrf-token' ).
    lo_response->get_cookies(
          RECEIVING
            r_value = DATA(it_cookies)
        ).

     ep_csrftoken = lv_csrf_token.

    TRY.
*        lo_http_client->close(  ).
        if lv_status-code <> 200.
"            severity = if_abap_behv_message=>severity-success.
            return.     "exit in case error in receiving csrf token
        endif.

*" To publish RFQ
     CONCATENATE lo_url 'SubmitForApproval?RequestForQuotation=' '''' iv_rfqno '''' into lo_url.

        lo_http_client_rfq = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).

        data(lo_request_rfq) = lo_http_client_rfq->get_http_request( ).

        lo_request_rfq->set_header_fields(  VALUE #(
                                                 (  name = 'Content-Type'  value = 'application/json' )
                                                 (  name = 'x-csrf-token'  value = lv_csrf_token )
                                              )   ).
*            lo_request_rfq->set_authorization_basic(
*              EXPORTING
*                i_username = wa_idpass-username
*                i_password =  wa_idpass-password
*            ).

          loop at it_cookies into data(ls_cookie).
            lo_request_rfq->set_cookie( EXPORTING
                                          i_name    = ls_cookie-name
                                          i_value   = ls_cookie-value
                                          i_path    = ls_cookie-path
                                          i_secure  = ls_cookie-secure ).
          endloop.
          et_cookies = it_cookies.

          lv_wa-_request_for_quotation = iv_rfqno.
*          data(lv_json) =  /ui2/cl_json=>serialize( exporting data = lv_wa
*                                                              pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
*          lo_request->set_text( EXPORTING
*                                    i_text = lv_json ).

           data(lo_response_rfq) = lo_http_client_rfq->execute( i_method  = if_web_http_client=>post ).
           data(lv_resptext)    = lo_response_rfq->get_text(  ).
            data(lv_status_rfq) = lo_response_rfq->get_status(  ).
           if lv_status_rfq-code = 200.
            ep_subrc = 0.
            wa_msg-msgtyp   = gc_s.
            wa_msg-msgtxt   = |RFQ{ iv_rfqno } has been published|.
            append wa_msg to gt_msgs.
           else.
            ep_subrc = 4.
            wa_msg-msgtyp   = gc_e.
            wa_msg-msgtxt   = |Error Publishing RFQ{ iv_rfqno } |.
            append wa_msg to gt_msgs.
           endif.
           lo_http_client_rfq->close(  ).
           CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

    ENDTRY.
    ENDMETHOD.   " Publish RFQ method ends


    METHOD supplierquot_itemprice_update.           "Method starts
* IMPORTING   ip_url             type string
*             ip_supquotno       type ebeln
*             ip_rfqno           type ebeln  "RFQ Number
*             ip_supplier        type lifnr
*   returning value(ep_subrc)    type sy-subrc.
       types: begin of ty_suprate,
*                _Request_For_Quotation type ebeln,
                _Net_Price_Amount      type string,
               end   of ty_suprate.

* This method is to update Net Order Price at item level of supplier quotation from custom table

       DATA:
            lv_access_token TYPE string,
            lo_http_token  TYPE REF TO if_web_http_client,
            lo_http_supquot  TYPE REF TO if_web_http_client,
            lv_flag         type c,
            lv_urlnew       type string,
            wa_msg          type ty_msgs,
            wa_suprate      type ty_suprate.

* Get access token
    data(lv_url) = get_srvurl( exporting iv_service = 'API_QTN_PROCESS_SRV' ).

" Get csrf token
     TRY.
        lo_http_token = cl_web_http_client_manager=>create_by_http_destination(
                                i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      catch cx_web_message_error. "#EC NO_HANDLER

    ENDTRY.

* Read credentials
          SELECT SINGLE *
            FROM zi_cs_id
                WHERE systemid = @sy-mandt
                INTO @DATA(wa_idpass).

" To fetch x-csrf-token
       DATA(lo_request) = lo_http_token->get_http_request( ).

        lo_request->set_header_fields(  VALUE #(
                                                   (  name = 'Content-Type'  value = 'application/json' )
                                                   (  name = 'x-csrf-token'  value = 'Fetch' )
                                              )   ).

       lo_request->set_authorization_basic(
                          EXPORTING
                            i_username = wa_idpass-username
                            i_password = wa_idpass-password
                        ).
     TRY.
        DATA(lo_response) = lo_http_token->execute( i_method  = if_web_http_client=>get ).
      CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

      data(lv_msg) = lo_Response->get_text(  ).

    ENDTRY.

    DATA(lv_status) = lo_response->get_status( ).
    DATA(lv_json_response) = lo_response->get_text( ).

        data(lv_csrftoken) = lo_response->get_header_field( exporting i_name = 'x-csrf-token' ).
        lo_response->get_cookies(
              RECEIVING
                r_value = DATA(it_cookies)
            ).

        if lv_status-code <> 200.
            return.     "exit in case error in receiving csrf token
        endif.

         select from I_SupplierQuotationItem_Api01 as a
         fields
         a~SupplierQuotation,
         a~SupplierQuotationItem,
         a~\_SupplierQuotation-Supplier,
         a~RequestForQuotation,
         a~RequestForQuotationItem
         WHERE a~SupplierQuotation  = @ip_supquotno
           and a~\_SupplierQuotation-Supplier = @ip_supplier
         into table @data(it_supquotitm).

        sort it_supquotitm by SupplierQuotation SupplierQuotationItem.

* Read price from custom table
        select from ztb_rfqsuplrritm as a
         FIELDS
         a~rfq_number,
         a~rfq_item,
         a~supplier_code1,
         a~item_rate1
         where a~rfq_number = @ip_rfqno
           and a~supplier_code1 = @ip_supplier
         INTO TABLE @data(it_ztbsupitm).

         sort it_ztbsupitm by rfq_number rfq_item.

*A_SupplierQuotationItem(SupplierQuotation='8000000017',SupplierQuotationItem='10')
        try.
            loop at it_supquotitm into data(wa_supquotitm).
                clear: lv_urlnew.
                CONCATENATE lv_url 'A_SupplierQuotationItem(SupplierQuotation=' '''' ip_supquotno ''''
                                   ',SupplierQuotationItem=' '''' wa_supquotitm-SupplierQuotationItem '''' ')' into lv_urlnew.

               lo_http_supquot = cl_web_http_client_manager=>create_by_http_destination(
                                        i_destination = cl_http_destination_provider=>create_by_url( lv_urlnew ) ).

                lo_request = lo_http_supquot->get_http_request( ).
                lo_request->set_header_fields(  VALUE #(
                                                         (  name = 'Content-Type'  value = 'application/json' )
                                                         (  name = 'x-csrf-token'  value = lv_csrftoken )
                                                        )  ).
              loop at it_cookies into data(ls_cookie).
                lo_request->set_cookie( EXPORTING
                                              i_name    = ls_cookie-name
                                              i_value   = ls_cookie-value
                                              i_path    = ls_cookie-path
                                              i_secure  = ls_cookie-secure ).
              endloop.

               wa_suprate-_net_price_amount = VALUE #( it_ztbsupitm[ rfq_number = wa_supquotitm-RequestForQuotation
                                                                     rfq_item   = wa_supquotitm-RequestForQuotationItem
                                                                     supplier_code1 = wa_supquotitm-supplier ]-item_rate1 OPTIONAL ).
* To remove space just in case
              wa_suprate-_net_price_amount = condense( wa_suprate-_net_price_amount ).

          data(lv_json) =  /ui2/cl_json=>serialize( exporting data = wa_suprate
                                                              pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
          lo_request->set_text( EXPORTING
                                    i_text = lv_json ).

              lo_response = lo_http_supquot->execute( i_method  = if_web_http_client=>patch ).
              lv_status = lo_response->get_status(  ).
              data(lv_resptext) = lo_response->get_text(  ).

              if lv_status-code = 204.
                ep_subrc    = 0.
                wa_msg-msgtyp   = gc_s.
                wa_msg-msgtxt   = |Item price updated for { wa_supquotitm-SupplierQuotation }/{ wa_supquotitm-SupplierQuotationItem }|.
                append wa_msg to zcl_rfq_utility=>gt_msgs.
              else.
                ep_subrc = 4.
                wa_msg-msgtyp   = gc_e.
                wa_msg-msgtxt   = |Error updating price for { wa_supquotitm-SupplierQuotation }/{ wa_supquotitm-SupplierQuotationItem }|.
                append wa_msg to zcl_rfq_utility=>gt_msgs.
              endif.

            lo_http_supquot->close(  ).
            endloop.
            lo_http_token->close(  ).

            clear: lo_request, lo_response.

        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER

        ENDTRY.
    ENDMETHOD.                              " supplierquot_itemprice_update ends
ENDCLASS.

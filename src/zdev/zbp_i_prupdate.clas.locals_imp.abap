CLASS lhc_zi_prupdate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_prupdate RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_prupdate RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_prupdate.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_prupdate.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_prupdate.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_prupdate RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_prupdate.

    METHODS update_pr FOR MODIFY
      IMPORTING keys FOR ACTION zi_prupdate~update_pr RESULT result.

ENDCLASS.

CLASS lhc_zi_prupdate IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD update_pr.
    " Define the nested structures
    TYPES: BEGIN OF ty_purchase_requisition_item,
             _purchasing___group___code  TYPE string,
             _unit                       TYPE string,
             _p_r___line___item1         TYPE string,
             _valuation___price          TYPE string,
             _r_f_q___number             TYPE string,
             _r_f_q__status              TYPE string,
             _delivery___date            TYPE string,
             "rfq_no line item
             _line_item_text_information TYPE string, "need to change in json
             _validity___start___date    TYPE string,
             _quantity                   TYPE string,  " Quantity field
             _validity___end___date      TYPE string,
             _asset___code               TYPE string,
             _item___currency            TYPE string,
             _item___status              TYPE string,
             _material___code            TYPE string,
             _material___group___code    TYPE string,
             _cost_center_site_wise_ho   TYPE string, "need to change in json
             _requisitioner              TYPE string,
             _purchase_order_number      TYPE string,
             _purchase_order_line_item   TYPE string, "need to change in json
             _unique_i_d                 TYPE string,
             _proposeditemid             TYPE string, "need to change in json
           END OF ty_purchase_requisition_item.

    TYPES: BEGIN OF ty_data,
             _purchase___requisition___item TYPE STANDARD TABLE OF ty_purchase_requisition_item WITH EMPTY KEY,
           END OF ty_data.

    TYPES: BEGIN OF ty_json_root,
             data TYPE STANDARD TABLE OF ty_data WITH EMPTY KEY,
           END OF ty_json_root.
    TYPES: BEGIN OF ty_table,
             purchaserequisition     TYPE c LENGTH 10,
             purchaserequisitionitem TYPE c LENGTH 4,
             message                 TYPE c LENGTH 100,
             flag                    TYPE c LENGTH 10,
           END OF ty_table.
    " Declare the work area
    DATA: lv_json_data TYPE ty_json_root,
          it_pritem    TYPE TABLE OF ty_purchase_requisition_item,
          wa_pritem    TYPE ty_purchase_requisition_item,
          it_data      TYPE TABLE OF ty_data,
          wa_data      TYPE ty_data,
          lv_po        TYPE string,
          lv_json      TYPE string,
          po_qty       TYPE string,
          wa_table     TYPE zpr_zohostatus,
          lv_zoho      TYPE string.

    READ TABLE keys INTO DATA(wa_key) INDEX 1.
    SELECT *
        FROM zi_prupdate
        WHERE purchaserequisition = @wa_key-purchaserequisition
*        and PurchaseOrderItem = @wa_key-PurchaseRequisitionItem
        INTO TABLE @DATA(it_pr).
    DELETE ADJACENT DUPLICATES FROM it_pr COMPARING purchaserequisition purchaserequisitionitem. "#EC CI_SORTED
    LOOP AT it_pr INTO DATA(wa_pr).
      lv_zoho = wa_pr-yy1_przohoid_pri.
      wa_pritem-_purchasing___group___code  = wa_pr-purchasinggroup.
      wa_pritem-_p_r___line___item1         = wa_pr-purchaserequisitionitem.
      wa_pritem-_valuation___price          = wa_pr-itemnetamount.
      wa_pritem-_r_f_q__status              = wa_pr-requestforquotation.
      wa_pritem-_unique_i_d                 = wa_pr-yy1_przohourl_pri.
      wa_pritem-_proposeditemid             = wa_pr-yy1_zohouniqueprid_pri.
      wa_pritem-_delivery___date              = wa_pr-deliverydate.
      IF wa_pr-producttype = 'ZSER'.
        wa_pritem-_delivery___date              = ''.
      ELSE.
        wa_pritem-_delivery___date            = |{ wa_pritem-_delivery___date+0(4) }-{ wa_pritem-_delivery___date+4(2) }-{ wa_pritem-_delivery___date+6(2) }|.
      ENDIF.
      wa_pritem-_line_item_text_information = wa_pr-purchaserequisitionitemtext.
      wa_pritem-_validity___start___date      = wa_pr-performanceperiodstartdate.
        wa_pritem-_validity___end___date        = wa_pr-performanceperiodenddate.

        IF wa_pr-producttype = 'ZCSM' OR wa_pr-producttype = 'ZCON'.
          wa_pritem-_validity___start___date      = ''.
          wa_pritem-_validity___end___date        = ''.
        ELSE.
          wa_pritem-_validity___start___date      = |{ wa_pritem-_validity___start___date+0(4) }-{ wa_pritem-_validity___start___date+4(2) }-{ wa_pritem-_validity___start___date+6(2) }|.
          wa_pritem-_validity___end___date        = |{ wa_pritem-_validity___end___date+0(4) }-{ wa_pritem-_validity___end___date+4(2) }-{ wa_pritem-_validity___end___date+6(2) }|.
        ENDIF.

      wa_pritem-_quantity                   = wa_pr-requestedquantity.
      wa_pritem-_unit                       = wa_pr-baseunit.
      wa_pritem-_asset___code               = wa_pr-masterfixedasset.
      SHIFT wa_pritem-_asset___code LEFT DELETING LEADING '0'.
      wa_pritem-_item___currency            = wa_pr-purreqnitemcurrency.
      CASE wa_pr-isdeleted.
        WHEN 'X'.
          wa_pritem-_item___status = 'InActive'.
        WHEN ''.
          wa_pritem-_item___status = 'Active'.
      ENDCASE.
      wa_pritem-_material___code            = wa_pr-material.
      SHIFT wa_pritem-_material___code LEFT DELETING LEADING '0'.
      wa_pritem-_material___group___code    = wa_pr-materialgroup.
      wa_pritem-_cost_center_site_wise_ho   = wa_pr-costcenter.
      SHIFT wa_pritem-_cost_center_site_wise_ho LEFT DELETING LEADING '0'.
      wa_pritem-_requisitioner              = wa_pr-requisitionername.
      SELECT purchaseorder, purchaseorderitem,   orderquantity, purchaserequisition, purchaserequisitionitem
        FROM i_purchaseorderitemapi01
        WHERE purchaserequisition = @wa_pr-purchaserequisition
          AND purchaserequisitionitem = @wa_pr-purchaserequisitionitem
          INTO TABLE @DATA(it_po).
      LOOP AT it_po INTO DATA(wa_po) WHERE purchaserequisition = wa_pr-purchaserequisition AND purchaserequisitionitem = wa_pr-purchaserequisitionitem.
        SELECT SINGLE purchaseorder, purchaseorderdate, supplier
            FROM i_purchaseorderapi01
            WHERE purchaseorder = @wa_po-purchaseorder
            INTO @DATA(wa_pohead).
        REPLACE '-' IN wa_pohead-purchaseorderdate WITH '/'.
        po_qty = wa_po-orderquantity.

        CONCATENATE wa_po-purchaseorder wa_pohead-purchaseorderdate wa_po-purchaseorderitem po_qty wa_pohead-supplier INTO lv_po SEPARATED BY '-'.
        CONCATENATE lv_po withspace INTO DATA(withspace) SEPARATED BY cl_abap_char_utilities=>cr_lf.
        CLEAR: wa_pohead, po_qty.
      ENDLOOP.
      wa_pritem-_purchase_order_line_item   = withspace.
      APPEND wa_pritem TO wa_data-_purchase___requisition___item.
      CLEAR: withspace, lv_po.
    ENDLOOP.
    APPEND wa_data TO lv_json_data-data.

    lv_json = /ui2/cl_json=>serialize( data = lv_json_data
                                       compress = abap_false
                                       pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

    REPLACE  ALL OCCURRENCES OF 'LineItemTextInformation'  IN lv_json WITH 'Line_Item_Text_Information'.
    REPLACE ALL OCCURRENCES OF  'CostCenterSiteWiseHo'     IN lv_json WITH 'Cost_Center_Site_wise_HO'.
    REPLACE ALL OCCURRENCES OF  'PurchaseOrderLineItem'    IN lv_json WITH 'Purchase_Order_Line_Item'.
    REPLACE ALL OCCURRENCES OF  'Proposeditemid'           IN lv_json WITH 'Proposed_Cost_sheet_line_item_ID'.



**********************************************************************
** Data Definition
**********************************************************************

    DATA : lv_tenent  TYPE c LENGTH 8,
           lv_dev(3)  TYPE c VALUE 'N7O',
           lv_qas(3)  TYPE c VALUE 'M2S',
           lv_prd(3)  TYPE c VALUE 'MLN',
           lo_url     TYPE string,
           lv_sub_key TYPE string.

    DATA(lv_token) = zcl_zoho_asset_token=>tokenmethod( ).


    CASE sy-sysid.
      WHEN lv_dev.
        lo_url = |https://glpl-nonprod-apim-02.azure-api.net/zohoPR/report/All_Purchase_Requisitions/{ lv_zoho }|.
        lv_sub_key = '802944882ff341c4a540281f5fef0edb'.
      WHEN lv_qas.
        lo_url = |https://glpl-nonprod-apim-02.azure-api.net/zohoPR/report/All_Purchase_Requisitions/{ lv_zoho }|.
        lv_sub_key = '802944882ff341c4a540281f5fef0edb'.
      WHEN lv_prd.
        lo_url = |https://glpl-prod-apim-02.azure-api.net/zohoPR/report/All_Purchase_Requisitions/{ lv_zoho }|.
        lv_sub_key = '90dee5bd8a9d415c924fa4dc008d91ee'.
    ENDCASE.

    CONDENSE lo_url.

    TRY.
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
        i_destination = cl_http_destination_provider=>create_by_url( lo_url ) ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.
    DATA(lo_request) = lo_http_client->get_http_request( ).

    DATA: wa_fields TYPE if_web_http_request=>name_value_pair,
          i_fields  TYPE if_web_http_request=>name_value_pairs.

    wa_fields-name = 'Accept'.
    wa_fields-value = '*'.
    APPEND wa_fields TO i_fields.

    IF sy-sysid <> lv_prd.
      wa_fields-name = 'environment'.
      wa_fields-value = 'development'.
      APPEND wa_fields TO i_fields.
    ENDIF.

    wa_fields-name = 'Authorization'.
    wa_fields-value = lv_token.
    APPEND wa_fields TO i_fields.

    wa_fields-name = 'Ocp-Apim-Subscription-Key'.
    wa_fields-value = lv_sub_key.
    APPEND wa_fields TO i_fields.

    lo_request->set_header_fields( i_fields ).

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
    FIND FIRST OCCURRENCE OF '"message":"Data Updated Successfully"' IN lv_json_response.
    IF sy-subrc EQ 0.
      DATA(wa_msg) = me->new_message(
                            id       = 'ZMSG_PR_UPDATE'
                            number   = 001
                            severity = if_abap_behv_message=>severity-success
                            v1       = '.'
                          ).

      DATA wa_record LIKE LINE OF reported-zi_prupdate.
      wa_record-%msg = wa_msg.
*      wa_record-%tky-%key-customer = wa_zoho-customer.
      APPEND wa_record TO reported-zi_prupdate.
      wa_table-flag = 'X'.
      wa_table-message = 'Data Updated Successfully'.
      wa_table-purchaserequisition = wa_key-purchaserequisition.
      wa_table-prlastchangedatetime = wa_pr-lastchangedatetime.
*      wa_table-purchaserequisitionitem = wa_key-purchaserequisitionitem.
      SELECT SINGLE * FROM zpr_zohostatus WHERE purchaserequisition = @wa_key-purchaserequisition INTO @DATA(wa_prstatus).
      IF wa_prstatus-purchaserequisition IS INITIAL.
        MODIFY zpr_zohostatus FROM @wa_table.
      ELSE.
        UPDATE zpr_zohostatus SET message = 'Data Not Updated Successfully' WHERE purchaserequisition = @wa_key-purchaserequisition.
      ENDIF.
    ELSE.

      wa_msg = me->new_message(
                            id       = 'ZMSG_PR_UPDATE'
                            number   = 002
                            severity = if_abap_behv_message=>severity-success
                            v1       = '.'
                          ).

*      DATA wa_record LIKE LINE OF reported-zi_prupdate.
      wa_record-%msg = wa_msg.
      wa_table-flag = ''.
      wa_table-message = 'Data not Updated Due to Error'.
      wa_table-purchaserequisition = wa_key-purchaserequisition.
*      wa_table-purchaserequisitionitem = wa_key-purchaserequisitionitem.
*      MODIFY zpr_zohostatus FROM @wa_table.
      SELECT SINGLE * FROM zpr_zohostatus WHERE purchaserequisition = @wa_key-purchaserequisition INTO @wa_prstatus.
      IF wa_prstatus-purchaserequisition IS INITIAL.
        MODIFY zpr_zohostatus FROM @wa_table.
      ELSE.
        UPDATE zpr_zohostatus SET message = 'Data Updated Successfully', prlastchangedatetime = @wa_pr-lastchangedatetime WHERE purchaserequisition = @wa_key-purchaserequisition.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_prupdate DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_prupdate IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

    CLASS zcl_bd_mmpur_final_check_po DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_mmpur_final_check_po .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BD_MMPUR_FINAL_CHECK_PO IMPLEMENTATION.


  METHOD if_ex_mmpur_final_check_po~check.
    TYPES:
      BEGIN OF b_mmpur_s_messages,
        messageid        TYPE if_ex_mmpur_final_check_po=>syst_msgid,
        messagetype      TYPE if_ex_mmpur_final_check_po=>syst_msgty,
        messagenumber    TYPE if_ex_mmpur_final_check_po=>syst_msgno,
        messagevariable1 TYPE if_ex_mmpur_final_check_po=>syst_msgv,
        messagevariable2 TYPE if_ex_mmpur_final_check_po=>syst_msgv,
        messagevariable3 TYPE if_ex_mmpur_final_check_po=>syst_msgv,
        messagevariable4 TYPE if_ex_mmpur_final_check_po=>syst_msgv,
      END OF b_mmpur_s_messages .
    DATA: wa_msg TYPE b_mmpur_s_messages.


    LOOP AT purchaseorderitems INTO DATA(wa_po_item).

      SELECT SINGLE   material, purchaseorderitemtext
     FROM i_purchaseorderitemapi01 WITH PRIVILEGED ACCESS
     WHERE material = @wa_po_item-material
     INTO @DATA(i_text).

      DATA(acc) = wa_po_item-accountassignmentcategory.

      CASE purchaseorder-purchaseordertype.
        WHEN 'ZAST'.
          IF acc NE 'A'.
            READ TABLE messages INTO DATA(wa_mes) INDEX 1.
            wa_mes-messageid = 002.
            wa_mes-messagetype = 'E'.
            wa_mes-messagenumber = 1 + 1.
            wa_mes-messagevariable1 = 'Accounting assignment category is incorrect.'.
            APPEND wa_mes TO messages.
          ENDIF.
        WHEN 'ZUSER' OR 'ZMAT'.
          IF acc NE 'K'.
            READ TABLE messages INTO DATA(wa_mess) INDEX 1.
            wa_mess-messageid = 002.
            wa_mess-messagetype = 'E'.
            wa_mess-messagenumber = 1 + 1.
            wa_mess-messagevariable1 = 'Accounting assignment category is incorrect.'.
            APPEND wa_mess TO messages.
          ENDIF.
      ENDCASE.

*      IF purchaseorder-purchaseordertype NE 'ZAST'.
*   OR PURCHASEORDER-purchaseordertype NE 'ZUSER'
*   OR PURCHASEORDER-purchaseordertype NE 'ZMAT'.
*        IF i_text-purchaseorderitemtext IS NOT INITIAL.
*          IF wa_po_item-purchaseorderitemtext NE i_text-purchaseorderitemtext.
*            READ TABLE messages INTO DATA(wa_messs) INDEX 1.
*            wa_messs-messageid = 002.
*            wa_messs-messagetype = 'E'.
*            wa_mess-messagenumber = 1 + 1.
*            wa_messs-messagevariable1 = 'Material Description Cannot be Changed.'.
*            APPEND wa_messs TO messages.
*          ENDIF.
*        ENDIF.




  IF Wa_po_item-taxcode is INITIAL.
     read table messages into data(wa_messs1) index 1.
   wa_messs1-messageid = 001.
    wa_messs1-messagetype = 'E'.
     wa_messs1-messagenumber = 1 + 1.
      wa_messs1-messagevariable1 = 'Tax Code is Mandatory'.
      APPEND wa_messs1 to messages.
  ENDIF.


    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS zcl_mm_pur_s4_qtn_modify_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mm_pur_s4_qtn_modify_item .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_PUR_S4_QTN_MODIFY_ITEM IMPLEMENTATION.


  METHOD if_mm_pur_s4_qtn_modify_item~modify_item.
*   importing
*      !SUPPLIERQUOTATIONITEMKEY type MMPUR_S_QTN_ITM_KEY optional
*    changing
*      !SUPPLIERQUOTATIONITEM type MMPUR_S_QTN_ITM_MODIFY optional
*    raising
*      CX_BLE_RUNTIME_ERROR .

    if supplierquotationitemkey is not INITIAL.
    endif.

    if supplierquotationitem is not INITIAL.
    endif.
  ENDMETHOD.
ENDCLASS.

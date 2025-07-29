INTERFACE zinf_mm_pur_rfq_modify_item
  PUBLIC .


  INTERFACES if_badi_interface .

*  TYPES:
*    BEGIN OF tx_contract,
*      modify_item TYPE if_abap_tx_functional=>ty,
*    END OF tx_contract.

  METHODS modify_item
    IMPORTING
      !requestforquotationitemkey TYPE mmpur_s_rfq_itm_key OPTIONAL
    CHANGING
      !requestforquotationitem    TYPE mmpur_s_rfq_itm_modify OPTIONAL
    RAISING
      cx_ble_runtime_error .

ENDINTERFACE.

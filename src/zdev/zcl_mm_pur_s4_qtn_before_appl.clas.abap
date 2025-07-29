CLASS zcl_mm_pur_s4_qtn_before_appl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mmpur_qtn_before_appl_badi .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_PUR_S4_QTN_BEFORE_APPL IMPLEMENTATION.


  METHOD if_mmpur_qtn_before_appl_badi~map_qtn_before_appl_interface.
*    IMPORTING
*      !inboundmessage  TYPE mmpur_s_suppl_qtn_s4_req_msg
*    CHANGING
*      !skipprocessing  TYPE abap_bool
*      !quoteparameters TYPE mmpur_s_cwr_qtn_from_rfq_param
*      !rfqparameters   TYPE tty_reqforquotation
*      !errormessages   TYPE tty_bapiret2
*    RAISING
*      cx_ble_runtime_error .

    if quoteparameters is not INITIAL.
    endif.
    if rfqparameters is not INITIAL.
    endif.
  ENDMETHOD.
ENDCLASS.

CLASS zcl_mmpur_po_workflow_restart DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mmpur_po_workflow_restart .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MMPUR_PO_WORKFLOW_RESTART IMPLEMENTATION.


  METHOD if_mmpur_po_workflow_restart~check_po_workflow_restart.

    READ TABLE purchaseorderitem INTO DATA(ls_item) INDEX 1.
    READ TABLE purchaseorderitem_db INTO DATA(ls_item_db) INDEX 1.

    DATA: wa_zpo_mail TYPE zpo_mail_status.

    CASE  workflowrestarttype.
      WHEN 'C'.

        IF ls_item-netamount LT ls_item_db-netamount.
          workflowrestarttype = 'N'.
          RETURN.
        ENDIF.



    ENDCASE.


  ENDMETHOD.
ENDCLASS.

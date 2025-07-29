CLASS lhc_zsales1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zsales1 RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zsales1.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zsales1.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zsales1.

    METHODS read FOR READ
      IMPORTING keys FOR READ zsales1 RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zsales1.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ zsales1\_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE zsales1\_item.

ENDCLASS.

CLASS lhc_zsales1 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  data(a) = '2'.


  ENDMETHOD.

  METHOD update.
data(w) = '2'.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_item.
  ENDMETHOD.

  METHOD cba_item.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zsalesiteemm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zsalesiteemm.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zsalesiteemm.

    METHODS read FOR READ
      IMPORTING keys FOR READ zsalesiteemm RESULT result.

    METHODS rba_parent FOR READ
      IMPORTING keys_rba FOR READ zsalesiteemm\_parent FULL result_requested RESULT result LINK association_links.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zsalesiteemm.

ENDCLASS.

CLASS lhc_zsalesiteemm IMPLEMENTATION.

  METHOD update.
  data(w) = '2'.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_parent.
  ENDMETHOD.

  METHOD create.
  data(w) = '2'.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zsales1 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zsales1 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  data(e) = 'e'.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

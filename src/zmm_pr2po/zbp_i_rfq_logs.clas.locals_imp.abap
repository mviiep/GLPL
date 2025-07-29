*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lhc_zi_rfq_logs DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_rfq_logs RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_rfq_logs.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_rfq_logs.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_rfq_logs.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_rfq_logs RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_rfq_logs.

ENDCLASS.

CLASS lhc_zi_rfq_logs IMPLEMENTATION.
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
endclass.

CLASS lsc_zi_rfq_logs DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_rfq_logs IMPLEMENTATION.

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

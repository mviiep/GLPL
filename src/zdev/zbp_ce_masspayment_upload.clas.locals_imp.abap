CLASS lhc_zce_masspayment_upload DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zce_masspayment_upload RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zce_masspayment_upload.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zce_masspayment_upload.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zce_masspayment_upload.

    METHODS read FOR READ
      IMPORTING keys FOR READ zce_masspayment_upload RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zce_masspayment_upload.

ENDCLASS.

CLASS lhc_zce_masspayment_upload IMPLEMENTATION.

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

ENDCLASS.

CLASS lsc_zce_masspayment_upload DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zce_masspayment_upload IMPLEMENTATION.

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

CLASS lhc_zmbo_test DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmbo_test RESULT result.
    METHODS jvpost FOR MODIFY
      IMPORTING keys FOR ACTION zmbo_test~jvpost RESULT result.
    METHODS jvpost1 FOR MODIFY
      IMPORTING keys FOR ACTION zmbo_test~jvpost1 RESULT result.

ENDCLASS.

CLASS lhc_zmbo_test IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD jvpost.

  data(a) = '2'.

 zcl_mbo=>get_instance(  )->jvpost(
   EXPORTING
     keys     =  keys
   CHANGING
     result   = result
     mapped   = mapped
     failed   = failed
     reported = reported
 ).

 "zdata2=>get_instance(  )

  ENDMETHOD.

  METHOD jvpost1.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zmbo_test DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zmbo_test IMPLEMENTATION.

  METHOD save_modified.




  ENDMETHOD.

  METHOD cleanup_finalize.

  ENDMETHOD.

ENDCLASS.

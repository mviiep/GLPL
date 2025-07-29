CLASS lhc_zce_coll DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zce_coll RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zce_coll.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zce_coll.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zce_coll.

    METHODS read FOR READ
      IMPORTING keys FOR READ zce_coll RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zce_coll.

    METHODS updatesstatus FOR MODIFY
      IMPORTING keys FOR ACTION zce_coll~updatesstatus RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zce_coll RESULT result.

ENDCLASS.

CLASS lhc_zce_coll IMPLEMENTATION.

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

  METHOD updatesstatus.

  data(it_keys) = keys.

  data(status) = keys[ 1 ]-%param-status.

  result = value #( (  PurchaseOrder = keys[ 1 ]-PurchaseOrder
                       PurchaseOrderitem = keys[ 1 ]-PurchaseOrderitem
                       %param-weekstatus =   status            ) ).

 reported-zce_coll = VALUE #( ( PurchaseOrder = keys[ 1 ]-PurchaseOrder
                       PurchaseOrderitem = keys[ 1 ]-PurchaseOrderitem
                       %msg = new_message(
                                id       = 'SY'
                                number   =  '002'
                                severity =  if_abap_behv_message=>severity-success
                                v1       =  'Done'
*                                v2       =
*                                v3       =
*                                v4       =
                              )
                              %state_area = 'hjk'
                              ) ).


  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zce_coll DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zce_coll IMPLEMENTATION.

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

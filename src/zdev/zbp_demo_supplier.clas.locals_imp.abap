CLASS lhc_zdemo_supplier DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zdemo_supplier RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zdemo_supplier RESULT result.

    METHODS createvendor FOR MODIFY
      IMPORTING keys FOR ACTION zdemo_supplier~createvendor RESULT result.

    METHODS updatevendor FOR MODIFY
      IMPORTING keys FOR ACTION zdemo_supplier~updatevendor RESULT result.

ENDCLASS.

CLASS lhc_zdemo_supplier IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD createvendor.
  ENDMETHOD.

  METHOD updatevendor.
  ENDMETHOD.

ENDCLASS.

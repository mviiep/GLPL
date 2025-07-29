CLASS zdata2 DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .


  PUBLIC SECTION.
    "INTERFACES if_abap_behv_message.
    TYPES: tt_keys     TYPE TABLE FOR ACTION IMPORT zcolcus~pst,
           tt_result   TYPE TABLE FOR ACTION RESULT zcolcus~pst,
           tt_mapped   TYPE RESPONSE FOR MAPPED EARLY zcolcus,
           tt_failed   TYPE RESPONSE FOR FAILED EARLY zcolcus,
           tt_reported TYPE RESPONSE FOR REPORTED EARLY zcolcus.


    METHODS:  pst
      IMPORTING keys     TYPE tt_keys
      CHANGING  result   TYPE   tt_result
                mapped   TYPE tt_mapped
                failed   TYPE tt_failed
                reported TYPE tt_reported.





    CLASS-METHODS: get_instance RETURNING VALUE(mo_value) TYPE REF TO zdata1.
    CLASS-DATA: ro_value TYPE REF TO zdata1.

  PROTECTED SECTION.


  PRIVATE SECTION.
ENDCLASS.



CLASS ZDATA2 IMPLEMENTATION.


  METHOD get_instance.
    mo_value = ro_value = COND #( WHEN mo_value IS BOUND
                                    THEN mo_value
                                    ELSE NEW #(  ) ).

  ENDMETHOD.


  METHOD pst.

  ENDMETHOD.
ENDCLASS.

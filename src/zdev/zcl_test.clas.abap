CLASS zcl_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.



    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT SINGLE *
    FROM zmm_supplier
    WHERE supplier = '0000010441'
    INTO @DATA(zirfq_suppmailtab).

    zirfq_suppmailtab-supplier = '0000010441'.
    zirfq_suppmailtab-res_supplier = '726575000002596573'.

    MODIFY zmm_supplier FROM @zirfq_suppmailtab.
  ENDMETHOD.
ENDCLASS.

CLASS zcl_test_fr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_faa_dc_upa_badi .
    INTERFACES if_badi_interface .
    INTERFACES if_faa_dc_upa_badi_customer .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST_FR IMPLEMENTATION.


  METHOD if_faa_dc_upa_badi~activate_max_segmentation.
  ENDMETHOD.


  METHOD if_faa_dc_upa_badi~set_changeover_year.
  ENDMETHOD.


  METHOD if_faa_dc_upa_badi~set_max_base_value.
  ENDMETHOD.


  METHOD if_faa_dc_upa_badi~set_max_depreciation_amount.
  ENDMETHOD.


  METHOD if_faa_dc_upa_badi~set_min_netbook_value.
  ENDMETHOD.


  METHOD if_faa_dc_upa_badi~set_rounding.
  ENDMETHOD.
ENDCLASS.

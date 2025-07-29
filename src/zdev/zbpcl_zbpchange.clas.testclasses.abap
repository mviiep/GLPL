CLASS LTC_CONSUMER DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    DATA:
      MO_CUT TYPE REF TO ZBPCL_ZBPCHANGE.

    METHODS:
      SETUP,
      HANDLE_BUSINESSPARTNER_CH_C4F9 FOR TESTING
        RAISING
          CX_STATIC_CHECK,
      HANDLE_BUSINESSPARTNER_CR_DEB4 FOR TESTING
        RAISING
          CX_STATIC_CHECK.
ENDCLASS.

CLASS LTC_CONSUMER IMPLEMENTATION.
  METHOD SETUP.
  mo_cut = NEW #( ).
  ENDMETHOD.
  METHOD HANDLE_BUSINESSPARTNER_CH_C4F9.
*    DATA: lo_event_dbl TYPE REF TO ZBPIF_BUSINESSPARTNER_CHA_57D7.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZBPIF_BUSINESSPARTNER_CHA_57D7' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZBPIF_BUSINESSPARTNER_CHA_57D7=>ty_s_businesspartner_chan_61AA( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_businesspartner_ch_C4F9 is called
*    mo_cut->ZBPIF_ZBPCHANGE_HANDLER~handle_businesspartner_ch_C4F9( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
  METHOD HANDLE_BUSINESSPARTNER_CR_DEB4.
*    DATA: lo_event_dbl TYPE REF TO ZBPIF_BUSINESSPARTNER_CRE_A9A2.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZBPIF_BUSINESSPARTNER_CRE_A9A2' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZBPIF_BUSINESSPARTNER_CRE_A9A2=>ty_s_businesspartner_crea_747D( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_businesspartner_cr_DEB4 is called
*    mo_cut->ZBPIF_ZBPCHANGE_HANDLER~handle_businesspartner_cr_DEB4( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
ENDCLASS.

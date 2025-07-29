CLASS LTC_CONSUMER DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
  PRIVATE SECTION.
    DATA:
      MO_CUT TYPE REF TO ZDEVCL_SALESCONTRACTEVENTS.

    METHODS:
      SETUP,
      HANDLE_SALESCONTRACT_CHAN_62F6 FOR TESTING
        RAISING
          CX_STATIC_CHECK,
      HANDLE_SALESCONTRACT_CREA_5C3C FOR TESTING
        RAISING
          CX_STATIC_CHECK,
      HANDLE_SALESCONTRACT_DELE_99DD FOR TESTING
        RAISING
          CX_STATIC_CHECK,
      HANDLE_SALESCONTRACT_ITEM_7A98 FOR TESTING
        RAISING
          CX_STATIC_CHECK,
      HANDLE_SALESCONTRACT_ITEM_43FD FOR TESTING
        RAISING
          CX_STATIC_CHECK,
      HANDLE_SALESCONTRACT_ITEM_27A1 FOR TESTING
        RAISING
          CX_STATIC_CHECK.
ENDCLASS.

CLASS LTC_CONSUMER IMPLEMENTATION.
  METHOD SETUP.
  mo_cut = NEW #( ).
  ENDMETHOD.
  METHOD HANDLE_SALESCONTRACT_CHAN_62F6.
*    DATA: lo_event_dbl TYPE REF TO ZDEVIF_SALESCONTRACT_CHAN_62F6.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZDEVIF_SALESCONTRACT_CHAN_62F6' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZDEVIF_SALESCONTRACT_CHAN_62F6=>ty_s_salescontract_changed_v1( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salescontract_chan_62F6 is called
*    mo_cut->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_chan_62F6( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
  METHOD HANDLE_SALESCONTRACT_CREA_5C3C.
*    DATA: lo_event_dbl TYPE REF TO ZDEVIF_SALESCONTRACT_CREA_5C3C.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZDEVIF_SALESCONTRACT_CREA_5C3C' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZDEVIF_SALESCONTRACT_CREA_5C3C=>ty_s_salescontract_created_v1( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salescontract_crea_5C3C is called
*    mo_cut->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_crea_5C3C( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
  METHOD HANDLE_SALESCONTRACT_DELE_99DD.
*    DATA: lo_event_dbl TYPE REF TO ZDEVIF_SALESCONTRACT_DELE_99DD.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZDEVIF_SALESCONTRACT_DELE_99DD' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZDEVIF_SALESCONTRACT_DELE_99DD=>ty_s_salescontract_deleted_v1( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salescontract_dele_99DD is called
*    mo_cut->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_dele_99DD( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
  METHOD HANDLE_SALESCONTRACT_ITEM_7A98.
*    DATA: lo_event_dbl TYPE REF TO ZDEVIF_SALESCONTRACT_ITEM_7A98.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZDEVIF_SALESCONTRACT_ITEM_7A98' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZDEVIF_SALESCONTRACT_ITEM_7A98=>ty_s_salescontract_itemch_483A( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salescontract_item_7A98 is called
*    mo_cut->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_item_7A98( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
  METHOD HANDLE_SALESCONTRACT_ITEM_43FD.
*    DATA: lo_event_dbl TYPE REF TO ZDEVIF_SALESCONTRACT_ITEM_43FD.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZDEVIF_SALESCONTRACT_ITEM_43FD' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZDEVIF_SALESCONTRACT_ITEM_43FD=>ty_s_salescontract_itemcr_EE17( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salescontract_item_43FD is called
*    mo_cut->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_item_43FD( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
  METHOD HANDLE_SALESCONTRACT_ITEM_27A1.
*    DATA: lo_event_dbl TYPE REF TO ZDEVIF_SALESCONTRACT_ITEM_27A1.
*
*    " Given is an event double
*    lo_event_dbl ?= cl_abap_testdouble=>create( 'ZDEVIF_SALESCONTRACT_ITEM_27A1' ).
*
*    " which is prepared for the get_business_data call
*    cl_abap_testdouble=>configure_call( lo_event_dbl
*                     )->returning( VALUE ZDEVIF_SALESCONTRACT_ITEM_27A1=>ty_s_salescontract_itemde_240C( )
*                     )->and_expect( )->is_called_once( ).
*    lo_event_dbl->get_business_data( ).
*
*    " When handle_salescontract_item_27A1 is called
*    mo_cut->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_item_27A1( lo_event_dbl ).
*
*    " Then the event double has been called
*    cl_abap_testdouble=>verify_expectations( lo_event_dbl ).
  ENDMETHOD.
ENDCLASS.

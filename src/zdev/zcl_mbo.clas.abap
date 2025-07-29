CLASS zcl_mbo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_keys     TYPE TABLE FOR ACTION IMPORT zmbo_test~jvpost,
           tt_result   TYPE TABLE FOR ACTION RESULT zmbo_test~jvpost,
           tt_mapped   TYPE  RESPONSE FOR MAPPED EARLY zmbo_test,
           tt_failed   TYPE RESPONSE FOR FAILED EARLY zmbo_test,
           tt_reported TYPE RESPONSE FOR REPORTED EARLY zmbo_test.


    METHODS:  jvpost
      IMPORTING keys     TYPE  tt_keys
      CHANGING  result   TYPE  tt_result
                mapped   TYPE tt_mapped
                failed   TYPE  tt_failed
                reported TYPE tt_reported.




    CLASS-METHODS: get_instance RETURNING VALUE(mo_value) TYPE REF TO zcl_mbo.

    CLASS-DATA: ro_value TYPE REF TO zcl_mbo.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MBO IMPLEMENTATION.


  METHOD get_instance.
    mo_value = ro_value = COND #( WHEN mo_value IS BOUND
                                    THEN mo_value
                                    ELSE NEW #(  ) ).
  ENDMETHOD.


  METHOD jvpost.
       DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          it_post    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

   lt_je_deep = VALUE #( ( %cid = lv_cid
                             %param = VALUE #(  businesstransactiontype = 'AZBU'
                                                accountingdocumenttype = 'KZ'
                                              "  documentreferenceid = lv_accountno

                                                companycode = '1000' " Success
                                                createdbyuser = 'CB9980000010'
                                                documentdate  = sy-datlo              "'2025-03-04'
                                                postingdate =   sy-datlo                     " '2025-03-04'
                                                %control = VALUE #( businesstransactiontype = if_abap_behv=>mk-on
                                                                     accountingdocumenttype = if_abap_behv=>mk-on
                                                                     documentreferenceid = if_abap_behv=>mk-on
                                                                     companycode = if_abap_behv=>mk-on
                                                                     createdbyuser = if_abap_behv=>mk-on
                                                                      documentdate  = if_abap_behv=>mk-on
                                                                      postingdate =  if_abap_behv=>mk-on
                                                                     _glitems = if_abap_behv=>mk-on )
                                                _glitems = VALUE #( (   glaccountlineitem = |001| companycode = '1000'  glaccount = '0021001012' profitcenter = '0000100000' documentitemtext = 'G/L Line Item Text' housebank = 'HDFC1' housebankaccount =
'03512'
                                                                        _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-1000.55' currency = 'INR'
                                                                                                    %control = VALUE #( currencyrole = if_abap_behv=>mk-on journalentryitemamount = if_abap_behv=>mk-on currency = if_abap_behv=>mk-on )
                                                                                                 ) )
                                                                        %control = VALUE #( glaccountlineitem = if_abap_behv=>mk-on companycode = if_abap_behv=>mk-on  glaccount = if_abap_behv=>mk-on profitcenter = if_abap_behv=>mk-on documentitemtext =
if_abap_behv=>mk-on  housebank = if_abap_behv=>mk-on housebankaccount = if_abap_behv=>mk-on )
                                                                             ) )

                                                _apitems = VALUE #( ( glaccountlineitem = '000002' supplier = '0000010001'   documentitemtext = 'Vendor Line Item Text' businessplace = 'MH27' specialglcode =  'A'
                                                                       _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '1000.55' currency = 'INR'
                                                                                                    %control = VALUE #( currencyrole = if_abap_behv=>mk-on journalentryitemamount = if_abap_behv=>mk-on currency = if_abap_behv=>mk-on )
                                                                                                 ) )
                                                                      %control = VALUE #( glaccountlineitem = if_abap_behv=>mk-on supplier = if_abap_behv=>mk-on   documentitemtext = if_abap_behv=>mk-on businessplace =
if_abap_behv=>mk-on specialglcode =  if_abap_behv=>mk-on   )
                                                                   ) )
                                                )    ) ).

    MODIFY ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE post FROM lt_je_deep
           FAILED DATA(ls_failed_deep)
           REPORTED DATA(ls_reported_deep)
         MAPPED DATA(ls_mapped_deep).

   " it_post =  lt_je_deep.




*    MODIFY ENTITIES OF i_journalentrytp
*         ENTITY journalentry
*         EXECUTE post FROM lt_je_deep
*           FAILED DATA(ls_failed_deep)
*           REPORTED DATA(ls_reported_deep)
**           MAPPED DATA(ls_mapped_deep).

    IF ls_failed_deep IS NOT INITIAL.


      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
        ...
      ENDLOOP.

    ENDIF.
    reported-zmbo_test = VALUE #( FOR ls_je IN ls_reported_deep-journalentry
                                       ( CORRESPONDING #( ls_je  ) )     ).

*   mapped-zcolcus = value #( for ls1_mapped in ls_mapped_deep-journalentry
*                              ( CORRESPONDING #( ls1_mapped ) ).
*

    mapped-zmbo_test = CORRESPONDING #( ls_mapped_deep-journalentry  ).

  ENDMETHOD.
ENDCLASS.

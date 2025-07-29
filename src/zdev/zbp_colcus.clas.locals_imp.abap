CLASS local DEFINITION.
  PUBLIC SECTION.

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          it_post    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.

ENDCLASS.



CLASS lhc_zcolcus DEFINITION INHERITING FROM cl_abap_behavior_handler.


  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcolcus RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zcolcus.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcolcus.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcolcus.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcolcus RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcolcus.

    METHODS pst FOR MODIFY
      IMPORTING keys FOR ACTION zcolcus~pst RESULT result.
    METHODS popup FOR MODIFY
      IMPORTING keys FOR ACTION zcolcus~popup RESULT result.
    METHODS postdata FOR MODIFY
      IMPORTING keys FOR ACTION zcolcus~postdata RESULT result.
    METHODS exp FOR MODIFY
      IMPORTING keys FOR ACTION zcolcus~exp RESULT result.
    METHODS calculate_sum FOR READ
      IMPORTING keys FOR FUNCTION zcolcus~calculate_sum RESULT result.
    METHODS calculate_sum1 FOR MODIFY
      IMPORTING keys FOR ACTION zcolcus~calculate_sum1 RESULT result.



ENDCLASS.

CLASS lhc_zcolcus IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.


    DATA(lv_cust) = entities.
    DATA(a) = '2'.

*data(lv_msg) = 'Jagdamba'.
**
*    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_symbol>).
**    reported-zcolcus = value #( (
**                                  %cid = <ls_symbol>-%cid
**                                   %key = <ls_symbol>-%key
**                                   lv_json = <ls_symbol>-lv_json
**                                   lv_message = 'Jagdambe'
**                                   %element-lv_json = if_abap_behv=>mk-on
**                                    %element-lv_message = if_abap_behv=>mk-on
**
**
**                                                     ) ).
*
*
*      reported-zcolcus = VALUE #( (
*        %cid = <ls_symbol>-%cid
*        %key = <ls_symbol>-%key
*        lv_json = <ls_symbol>-lv_json
*        lv_message = lv_msg
*        %element-lv_json = if_abap_behv=>mk-on
*        %element-lv_message = if_abap_behv=>mk-on
*      ) )
*.
*        ENDLOOP.

    DATA: lt_zcolcus type table for reported early zcolcus.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_symbol>).

      DATA(lv_msg) = 'Jagdamba'. " or dynamically generated

      APPEND VALUE #(
        %cid                = <ls_symbol>-%cid
        %key                = <ls_symbol>-%key
        lv_json             = <ls_symbol>-lv_json
        lv_message          = lv_msg
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-success
                 text     = 'SUNNA'
               )
        %element-lv_json    = if_abap_behv=>mk-on
        %element-lv_message = if_abap_behv=>mk-on
      ) TO lt_zcolcus.
 mapped-zcolcus = value #( ( %cid = <ls_symbol>-%cid
                              %key = <ls_symbol>-%key
                              lv_json = <ls_symbol>-lv_json
                              lv_message = lv_msg

                                 ) ).



    ENDLOOP.

    reported-zcolcus = lt_zcolcus.




  ENDMETHOD.

  METHOD update.
    DATA(a) = '2'.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD pst.


    DATA: lv_text  TYPE string,
          lv_text1 TYPE string.
    DATA(a) = '2'.



*
*    result = VALUE #( FOR ls_keys IN keys
*                         ( " %cid_ref = ls_keys-%cid_ref
*                             cust_id = ls_keys-cust_id
*                             %param-cust_id = ls_keys-cust_id
*                             %param-weekstatus = 'Thurs'  )                     ).
*
*
*    failed-zcolcus = VALUE #( FOR ls_keys IN keys
*                          ( " %cid_ref = ls_keys-%cid_ref
*                              cust_id = ls_keys-cust_id
*
*
*                                        )      ).
*
*    reported-zcolcus =   VALUE #( FOR ls_keys IN keys
*                          ( " %cid_ref = ls_keys-%cid_ref
*                               %pky = ls_keys-%pky
*                               %key = ls_keys-%key
*                               %cid = ls_keys-%cid_ref
*                              cust_id = ls_keys-cust_id
*                            "  CORRESPONDING #( ls_keys )
*
*
*                                        )      ).
*    mapped-zcolcus =    VALUE #( FOR ls_keys IN keys
*                         ( " %cid_ref = ls_keys-%cid_ref
*                              %pky = ls_keys-%pky
*                              %key = ls_keys-%key
*                              %cid = ls_keys-%cid_ref
*                             cust_id = ls_keys-cust_id ) ).
*    "  CORRESPONDING #( ls_keys )
*
*
*    LOOP AT failed-zcolcus ASSIGNING FIELD-SYMBOL(<ls_fail>).
*      lv_text = <ls_fail>-%fail-cause.      "if_message~get_text( ).
*    ENDLOOP.
*
**    loop at reported-zcolcus ASSIGNING FIELD-SYMBOL(<ls_report>).
**  lv_text1 = <ls_report>-%msg->if_message~get_text( )."if_message~get_text( ).
**  endloop.
*    DATA(msg) = |{ lv_text } and { lv_text1 }|.
*    IF failed-zcolcus IS NOT INITIAL.
*      reported-zcolcus =   VALUE #( FOR ls_keys IN keys
*                            ( " %cid_ref = ls_keys-%cid_ref
*                                cust_id = ls_keys-cust_id
*                                %msg = new_message_with_text(
*                                         severity = if_abap_behv_message=>severity-error
*                                         text     = msg
*                                       )
*                                          )    ).
*    ENDIF.


  ENDMETHOD.

  METHOD popup.

*  result = VALUE #( for ls_key in keys
*                    (  %cid_ref = ls_key-%cid_ref
*                      %tky = ls_key-%tky
*                      cust_id = ls_key-cust_id
*                      %param-dept = 'Json Description'   ) ).
*
* mapped-zcolcus = value #( for ls_mapped in keys
*                           ( %tky = ls_mapped-%tky
*                           cust_id = ls_mapped-cust_id
*                             ) ).

  ENDMETHOD.



  METHOD postdata.

  ENDMETHOD.

  METHOD exp.
    DATA(a) = '2'.


  ENDMETHOD.

*  METHOD exp1.
*  data(e) = '2'.
*  ENDMETHOD.

  METHOD calculate_sum.

    result[ 1 ]-%param-sum1  = keys[ 1 ]-%param-number1 + keys[ 1 ]-%param-number2.
    result[ 1 ]-%param-message = |The sum of { keys[ 1 ]-%param-number1 } and { keys[ 1 ]-%param-number1 } is { result[ 1 ]-%param-sum1 }.|.





  ENDMETHOD.



  METHOD calculate_sum1.
    DATA(q) = '2'.
*  result[ 1 ]-%param-sum1  = keys[ 1 ]-%param-number1 + keys[ 1 ]-%param-number2.
*  result[ 1 ]-%param-message = |The sum of { keys[ 1 ]-%param-number1 } and { keys[ 1 ]-%param-number1 } is { result[ 1 ]-%param-sum1 }.|.

* loop at keys ASSIGNING FIELD-SYMBOL(<ls_key>).
*    result[ 1 ]-%cid = <ls_key>-%cid.
*   result[ 1 ]-%param-message = 'Har har Mahadev'.
*   result[ 1 ]-%param-sum1 = '11'.
*endloop.

    result = VALUE #( FOR ls_key1 IN keys
                    ( %cid = ls_key1-%cid
                      %param-message = 'Har'
                      %param-sum1 = '11' ) ).



*     mapped-zcolcus = VALUE #( FOR ls_key1 IN keys
*                    ( %cid = ls_key1-%cid
*                      %param- = 'Har'
*                      %param-sum1 = '11' ) ).

*    result = value #( for ls_key1 in keys
*                    ( %pid = ls_key1-%pid
*                      %param-message = 'Har har Mahadev'
*                      %param-sum1 = '11' ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcolcus DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.
    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zcolcus IMPLEMENTATION.

  METHOD finalize.
    DATA(w) = '2'.
  ENDMETHOD.

  METHOD check_before_save.
    DATA(w) = '2'.
  ENDMETHOD.

  METHOD save.
    DATA(a) = '2'.
    "reported-zcolcus = value #( for ls_re in)
  ENDMETHOD.

  METHOD cleanup.
    DATA(w) = '2'.
  ENDMETHOD.

  METHOD cleanup_finalize.
    DATA(w) = '2'.
  ENDMETHOD.

  METHOD adjust_numbers.


    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          it_post    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    SELECT SINGLE FROM i_operationalacctgdocitem FIELDS accountingdocument WHERE accountingdocument ='1900000000' INTO @DATA(lv_accountno).
*
*    lt_je_deep = VALUE #( ( %cid = lv_cid
*                             %param = VALUE #(  businesstransactiontype = 'AZBU'
*                                                accountingdocumenttype = 'KZ'
*                                                documentreferenceid = lv_accountno
*
*                                                companycode = '1000' " Success
*                                                createdbyuser = 'CB9980000010'
*                                                documentdate  = sy-datlo              "'2025-03-04'
*                                                postingdate =   sy-datlo                     " '2025-03-04'
*                                                %control = VALUE #( businesstransactiontype = if_abap_behv=>mk-on
*                                                                     accountingdocumenttype = if_abap_behv=>mk-on
*                                                                     documentreferenceid = if_abap_behv=>mk-on
*                                                                     companycode = if_abap_behv=>mk-on
*                                                                     createdbyuser = if_abap_behv=>mk-on
*                                                                      documentdate  = if_abap_behv=>mk-on
*                                                                      postingdate =  if_abap_behv=>mk-on
*                                                                     _glitems = if_abap_behv=>mk-on )
*                                                _glitems = VALUE #( (   glaccountlineitem = |001| companycode = '1000'  glaccount = '0021001012' profitcenter = '0000100000' documentitemtext = 'G/L Line Item Text' housebank = 'HDFC1' housebankaccount =
*'03512'
*                                                                        _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-1000.55' currency = 'INR'
*                                                                                                    %control = VALUE #( currencyrole = if_abap_behv=>mk-on journalentryitemamount = if_abap_behv=>mk-on currency = if_abap_behv=>mk-on )
*                                                                                                 ) )
*                                                                        %control = VALUE #( glaccountlineitem = if_abap_behv=>mk-on companycode = if_abap_behv=>mk-on  glaccount = if_abap_behv=>mk-on profitcenter = if_abap_behv=>mk-on documentitemtext =
*if_abap_behv=>mk-on  housebank = if_abap_behv=>mk-on housebankaccount = if_abap_behv=>mk-on )
*                                                                             ) )
*
*                                                _apitems = VALUE #( ( glaccountlineitem = '000002' supplier = '0000010001'   documentitemtext = 'Vendor Line Item Text' businessplace = 'MH27' specialglcode =  'A'
*                                                                       _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '1000.55' currency = 'INR'
*                                                                                                    %control = VALUE #( currencyrole = if_abap_behv=>mk-on journalentryitemamount = if_abap_behv=>mk-on currency = if_abap_behv=>mk-on )
*                                                                                                 ) )
*                                                                      %control = VALUE #( glaccountlineitem = if_abap_behv=>mk-on supplier = if_abap_behv=>mk-on   documentitemtext = if_abap_behv=>mk-on businessplace =
*if_abap_behv=>mk-on specialglcode =  if_abap_behv=>mk-on   )
*                                                                   ) )
*                                                )    ) ).
*
*    MODIFY ENTITIES OF i_journalentrytp
*         ENTITY journalentry
*         EXECUTE post FROM lt_je_deep
*           FAILED DATA(ls_failed_deep)
*           REPORTED DATA(ls_reported_deep)
*         MAPPED DATA(ls_mapped_deep).
*
*    it_post =  lt_je_deep.




*    MODIFY ENTITIES OF i_journalentrytp
*         ENTITY journalentry
*         EXECUTE post FROM lt_je_deep
*           FAILED DATA(ls_failed_deep)
*           REPORTED DATA(ls_reported_deep)
***           MAPPED DATA(ls_mapped_deep).
**
**    IF ls_failed_deep IS NOT INITIAL.
**
**
**      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
**        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
**        ...
**      ENDLOOP.
**
**    ENDIF.
**    reported-zcolcus = VALUE #( FOR ls_je IN ls_reported_deep-journalentry
**                                       ( CORRESPONDING #( ls_je  ) )     ).
**
***   mapped-zcolcus = value #( for ls1_mapped in ls_mapped_deep-journalentry
***                              ( CORRESPONDING #( ls1_mapped ) ).
***
**
**    mapped-zcolcus = CORRESPONDING #( ls_mapped_deep-journalentry  ).
    DATA(a) = '2'.
  ENDMETHOD.

ENDCLASS.

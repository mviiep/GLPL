CLASS lhc_zcust_document DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcust_document RESULT result.

    METHODS det_pst FOR DETERMINE ON SAVE
      IMPORTING keys FOR zcust_document~det_pst.
    METHODS postdata FOR MODIFY
      IMPORTING keys FOR ACTION zcust_document~postdata RESULT result.

ENDCLASS.

CLASS lhc_zcust_document IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.



    METHOD det_pst.

*    READ ENTITIES OF zcust_document IN LOCAL MODE
*    ENTITY zcust_document
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(it_result).

*    zdata2=>get_instance(  )->pst(
*      EXPORTING
*        keys     = keys
*      CHANGING
*        result   = result
*        mapped   = mapped
*        failed   = failed
*        reported = reported
*    ).

*     DATA(wa_msg) = me->new_message(
*                                      id       = 'ZMSG_SERVICE_MAT'
*                                      number   = '001'
*                                      severity = if_abap_behv_message=>severity-success
*                                      v1       = 'success'
*                                    ).
*
*              DATA wa_record LIKE LINE OF reported-zcust_document.
**              wa_record- = '001'
*              wa_record-%msg = wa_msg.
*              APPEND wa_record TO reported-zcust_document.


data(q) = 'a'.

*    LOOP AT it_result ASSIGNING FIELD-SYMBOL(<ls_symbol>).
*
*      append( ( companycode = <ls_symbol>-companycode
*               accountingdocument = <ls_symbol>-accountingdocument
*               fiscalyear = <ls_symbol>-fiscalyear )
*        ) to reported-zcust_document.
*
*   ENDLOOP.
**  DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
**      lv_cid TYPE abp_behv_cid.
**
*TRY.
*    lv_cid  = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
*  CATCH cx_uuid_error.
*    ASSERT 1 = 0.
*ENDTRY.
*APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).
*
** Header Control
*DATA ls_header_control LIKE <je>-%param-%control.
*ls_header_control-documentheadertext           = if_abap_behv=>mk-on.
*ls_header_control-documentreferenceid          = if_abap_behv=>mk-on.
*
*
** GL Item Control
*DATA lt_glitem           LIKE <je>-%param-_glitems.
*DATA ls_glitem           LIKE LINE OF lt_glitem.
*DATA ls_glitem_control   LIKE ls_glitem-%control.
*ls_glitem_control-glaccountlineitem              = if_abap_behv=>mk-on.
*ls_glitem_control-documentitemtext               = if_abap_behv=>mk-on.
*ls_glitem_control-assignmentreference            = if_abap_behv=>mk-on.
*ls_glitem_control-statecentralbankpaymentreason  = if_abap_behv=>mk-on.
*ls_glitem_control-supplyingcountry               = if_abap_behv=>mk-on.
*
** APAR Item Control
*DATA lt_aparitem         LIKE <je>-%param-_aparitems.
*DATA ls_aparitem         LIKE LINE OF lt_aparitem.
*DATA ls_aparitem_control LIKE ls_aparitem-%control.
*ls_aparitem_control-glaccountlineitem             = if_abap_behv=>mk-on.
*ls_aparitem_control-documentitemtext              = if_abap_behv=>mk-on.
*ls_aparitem_control-assignmentreference           = if_abap_behv=>mk-on.
*ls_aparitem_control-specialglaccountassignment    = if_abap_behv=>mk-on.
*
*
** Test Data
*<je>-accountingdocument = '1800000003' .
*<je>-fiscalyear         = '2020'.
*<je>-companycode        = '0001'.
*<je>-%param = VALUE #(  documentheadertext           = 'TEST by 20220216'
*                        documentreferenceid          = 'DEBK1DEAC121004'
*                        %control                     =  ls_header_control
*            _glitems = VALUE #(  (  glaccountlineitem              = '000002'
*                                    documentitemtext               = 'GL Item test 1400000959-2'
*                                    assignmentreference            = '20210204'
*                                    statecentralbankpaymentreason  = '017'
*                                    supplyingcountry               = 'CN'
*                                    %control                       =  ls_glitem_control )
*                              )
*            _aparitems =  VALUE #(  (
*                                    glaccountlineitem               = '000001'
*                                    documentitemtext                = 'APAR Item te0959-4'
*                                    assignmentreference             = '20210204'
*                                    specialglaccountassignment      = '123'
*                                    %control                        =  ls_aparitem_control )
*                              )
*                      ) .
*MODIFY ENTITIES OF i_journalentrytp FORWARDING PRIVILEGED
*     ENTITY journalentry
*     EXECUTE change FROM lt_je
*       FAILED DATA(ls_failed_deep)
*       REPORTED DATA(ls_reported_deep)
*       MAPPED DATA(ls_mapped_deep).

*IF ls_failed_deep IS NOT INITIAL.
*  ROLLBACK ENTITIES.
*ELSE.
*  COMMIT ENTITIES BEGIN
*    RESPONSE OF i_journalentrytp
*      FAILED DATA(lt_commit_failed)
*      REPORTED DATA(lt_commit_reported).
*  COMMIT ENTITIES END.
*ENDIF.
*DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~Post,
* lv_cid TYPE abp_behv_cid.
*
*
*TRY.
* lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
* CATCH cx_uuid_error.
* ASSERT 1 = 0.
* ENDTRY.
*
*loop at keys ASSIGNING FIELD-SYMBOL(<ls_data>).
*APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
*<je_deep>-%cid = lv_cid .
*
*<je_deep>-%param = VALUE #(
* companycode = <ls_data>-CompanyCode " Success
* AccountingDocument = <ls_data>-AccountingDocument
*
* documentreferenceid = 'BKPFF'
* createdbyuser = 'TESTER'
* businesstransactiontype = 'RFBU'
* accountingdocumenttype = 'SA'
* documentdate = sy-datlo
* postingdate = sy-datlo
* accountingdocumentheadertext = 'RAP rules'
* _glitems = VALUE #( ( glaccountlineitem = |001| glaccount = '0000400000' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-100.55' currency = 'JPY' ) ) )
* ( glaccountlineitem = |002| glaccount = '0000400000' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '100.55' currency = 'JPY' ) ) ) )
*
*
*).
*
*endloop.
*
*MODIFY ENTITIES OF i_journalentrytp FORWARDING PRIVILEGED
* ENTITY journalentry
* EXECUTE Post FROM lt_je_deep
* FAILED DATA(ls_failed_deep)
* REPORTED DATA(ls_reported_deep)
* MAPPED DATA(ls_mapped_deep).
*
*
*IF ls_failed_deep IS NOT INITIAL.
*
*
*LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
* DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
* ...
* ENDLOOP.
* ELSE.
*
*
**COMMIT ENTITIES BEGIN
** RESPONSE OF i_journalentrytp
** FAILED DATA(lt_commit_failed)
** REPORTED DATA(lt_commit_reported).
** ...
** COMMIT ENTITIES END.
* ENDIF.



    ENDMETHOD.

  METHOD postdata.

DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
 lv_cid TYPE abp_behv_cid.


TRY.
 lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
 CATCH cx_uuid_error.
 ASSERT 1 = 0.
 ENDTRY.


APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
<je_deep>-%cid = lv_cid.
<je_deep>-%param = VALUE #(
 companycode = 'F001' " Success
 documentreferenceid = 'BKPFF'
 createdbyuser = 'TESTER'
 businesstransactiontype = 'RFBU'
 accountingdocumenttype = 'SA'
 documentdate = sy-datlo
 postingdate = sy-datlo
 accountingdocumentheadertext = 'RAP rules'
 _glitems = VALUE #( ( glaccountlineitem = |001| glaccount = '0000400000' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '-100.55' currency = 'JPY' ) ) )
 ( glaccountlineitem = |002| glaccount = '0000400000' _currencyamount = VALUE #( ( currencyrole = '00' journalentryitemamount = '100.55' currency = 'JPY' ) ) ) )


).


MODIFY ENTITIES OF i_journalentrytp FORWARDING PRIVILEGED
 ENTITY journalentry
 EXECUTE post FROM lt_je_deep
 FAILED DATA(ls_failed_deep)
 REPORTED DATA(ls_reported_deep)
 MAPPED DATA(ls_mapped_deep).


IF ls_failed_deep IS NOT INITIAL.


LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
 DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
 ...
 ENDLOOP.
 ELSE.

*
*COMMIT ENTITIES BEGIN
* RESPONSE OF i_journalentrytp
* FAILED DATA(lt_commit_failed)
* REPORTED DATA(lt_commit_reported).
* ...
* COMMIT ENTITIES END.
* ENDIF.
endif.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcust_document DEFINITION INHERITING FROM cl_abap_behavior_saver.
PROTECTED SECTION.

  METHODS save_modified REDEFINITION.

  METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcust_document IMPLEMENTATION.

METHOD save_modified.
ENDMETHOD.

METHOD cleanup_finalize.
ENDMETHOD.

ENDCLASS.

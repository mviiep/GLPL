CLASS zgi_catalog DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGI_CATALOG IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

*  modify entities of ZCOLCUS~
*  ENTITY ZCOLCUS
    "data: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.



  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA: lt_je_deep  TYPE TABLE  FOR ACTION IMPORT  zcolcus~pst,
          lt_je_deep3  TYPE TABLE  FOR ACTION IMPORT  zcolcus~pst,
          lt_je_deep1 TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lt_je_deep2 TYPE TABLE FOR CREATE  zcolcus,


" DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
 lv_cid TYPE abp_behv_cid.


TRY.
 lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
 CATCH cx_uuid_error.
 ASSERT 1 = 0.
 ENDTRY.


    DATA(a) = '2'.
    lt_je_deep = value #( (    " %cid_ref = lv_cid
                                cust_id = '001'
                                 ) ).
     lt_je_deep2 = value #( (  %cid = lv_cid
                                cust_id = '001'
                               weekstatus = '123'
                               %control = value #( cust_id = if_abap_behv=>mk-on weekstatus = if_abap_behv=>mk-on )     ) ).

    MODIFY ENTITIES OF zcolcus
     ENTITY zcolcus
     EXECUTE pst FROM lt_je_deep
     FAILED DATA(ls_failed_deep)
     REPORTED DATA(ls_reported_deep)
     MAPPED DATA(ls_mapped_deep).



*     MODIFY ENTITIES OF zcolcus
*     ENTITY zcolcus
*     CREATE FROM lt_je_deep2
*     FAILED DATA(ls_failed_deep)
*     REPORTED DATA(ls_reported_deep)
*     MAPPED DATA(ls_mapped_deep1).
*
*     MODIFY ENTITIES OF zcolcus
*     ENTITY zcolcus
*     EXECUTE pst FROM lt_je_deep
*     FAILED DATA(ls_failed_deep1)
*     REPORTED DATA(ls_reported_deep2)
*     MAPPED DATA(ls_mapped_deep2).

data(b) = '2'.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.

    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
      CATCH cx_apj_rt_content.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_zcollectionreport DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcollectionreport RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zcollectionreport.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcollectionreport.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zcollectionreport.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcollectionreport RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcollectionreport.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zcollectionreport RESULT result.
    METHODS zstatus FOR MODIFY
      IMPORTING keys FOR ACTION zcollectionreport~zstatus RESULT result.
    METHODS zstatus1 FOR MODIFY
      IMPORTING keys FOR ACTION zcollectionreport~zstatus1 RESULT result.
*    METHODS get_global_features FOR GLOBAL FEATURES
*      IMPORTING REQUEST requested_features FOR zcollectionreport RESULT result.
*
*    METHODS zglobal FOR MODIFY
*      IMPORTING keys FOR ACTION zcollectionreport~zglobal RESULT result.

ENDCLASS.

CLASS lhc_zcollectionreport IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.

  METHOD update.

    DATA(it_entities) = entities.
    DATA(a) = '2'.
    DATA it_potable TYPE TABLE OF zcollectionrpt.

    it_potable = VALUE #(  FOR ls_entity IN entities
                           ( purchaseorder =  ls_entity-purchaseorder
                           purchaseorderitem = ls_entity-purchaseorderitem
                           week1 = ls_entity-week1
                           week2 = ls_entity-week2
                           week3 = ls_entity-week3
                           week4 = ls_entity-week4
                           week5 = ls_entity-week5
                           week6 = ls_entity-week6
                           week7 = ls_entity-week7
                          " weekstatus = ls_entity-weekstatus
                                  )       ).

    DATA(week1) = VALUE #( entities[ 1 ]-week1  OPTIONAL ).
    DATA(week2) = VALUE #( entities[ 1 ]-week2  OPTIONAL ).

    DATA(lv_po) = VALUE #( entities[ 1 ]-purchaseorder  OPTIONAL ).
    DATA(lv_poi) = VALUE #( entities[ 1 ]-purchaseorderitem  OPTIONAL ).
    "modify zcollectionrpt FROM table @it_potable.
    IF week1 IS NOT INITIAL.
      UPDATE zcollectionrpt SET week1 = @week1  WHERE purchaseorder = @lv_po AND purchaseorderitem = @lv_poi.
    ENDIF.

    IF week2 IS NOT INITIAL.
      UPDATE zcollectionrpt SET week2 = @week2  WHERE purchaseorder = @lv_po AND purchaseorderitem = @lv_poi.
    ENDIF.
    " mapped-zcollectionreport = for



  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD get_instance_features.

    DATA(it_po) = keys[ 1 ]-purchaseorder.
    DATA(it_poitem) = keys[ 1 ]-purchaseorderitem.
    DATA(weekstatusselection) = keys[ 1 ]-weekstatusselection.
    DATA lv_weektemp TYPE c LENGTH 6.
    DATA(lv_flag) = '0'.





    SELECT FROM zcollectionrpt FIELDS DISTINCT purchaseorder, purchaseorderitem, weekstatus WHERE purchaseorder = @it_po AND purchaseorderitem = @it_poitem INTO TABLE @DATA(it_weekstatus).
    result = VALUE #( FOR ls_weekstatus IN it_weekstatus
             (   purchaseorder =   ls_weekstatus-purchaseorder
                purchaseorderitem =   ls_weekstatus-purchaseorderitem
                weekstatusselection = weekstatusselection
                 %features-%field-week1 =   if_abap_behv=>fc-f-read_only
                 %features-%field-week2 =   if_abap_behv=>fc-f-read_only
                 %features-%field-week3 =   if_abap_behv=>fc-f-read_only
                 %features-%field-week4 =   if_abap_behv=>fc-f-read_only
                 %features-%field-week5 =   if_abap_behv=>fc-f-read_only
                 %features-%field-week6 =   if_abap_behv=>fc-f-read_only
                 %features-%field-week7 =   if_abap_behv=>fc-f-read_only
*
                                             )   ).


    "
    "select from zweekselection FIELDS weekselection into TABLE @data(it_weekselection).
    SELECT SINGLE FROM zcollectionrpt FIELDS  * WHERE purchaseorder = @it_po AND purchaseorderitem = @it_poitem INTO  @DATA(it_weeks).


    IF it_weekstatus IS NOT INITIAL.
      " lv_weektemp = it_weekstatus[ purchaseorder = it_po purchaseorderitem = it_poitem ]-weekstatus.
      lv_weektemp = weekstatusselection.


      CASE lv_weektemp.
        WHEN 'Week1'.
          IF it_weeks-week1 IS INITIAL.
            result[ 1 ]-%field-week1 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.

        WHEN 'Week2'.
          IF it_weeks-week2 IS INITIAL.
            result[ 1 ]-%field-week2 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'Week3'.
          result[ 1 ]-%field-week3 =  if_abap_behv=>fc-f-unrestricted.
        WHEN 'Week4'.
          result[ 1 ]-%field-week4 =  if_abap_behv=>fc-f-unrestricted.
        WHEN 'Week5'.
          result[ 1 ]-%field-week5 =  if_abap_behv=>fc-f-unrestricted.
        WHEN 'Week6'.
          result[ 1 ]-%field-week6 =  if_abap_behv=>fc-f-unrestricted.
        WHEN 'Week7'.
          result[ 1 ]-%field-week7 =  if_abap_behv=>fc-f-unrestricted.

      ENDCASE.
    ENDIF.


    "select from zweekselection FIELDS weekselection into table @data(it_week).
*SELECT FROM i_purchaseorderitemapi01 FIELDS DISTINCT purchaseorder, purchaseorderitem, CompanyCode, Customer WHERE purchaseorder = @it_po AND purchaseorderitem = @it_poitem
*    INTO TABLE @DATA(it_data).
*
*    result = VALUE #( FOR ls_data IN it_data
*          (   purchaseorder =   ls_data-purchaseorder
*             purchaseorderitem =   ls_data-purchaseorderitem
*              %features-%field-week1 =   if_abap_behv=>fc-f-read_only
*              %features-%field-week2 =   if_abap_behv=>fc-f-read_only
*              %features-%field-week3 =   if_abap_behv=>fc-f-read_only
*              %features-%field-week4 =   if_abap_behv=>fc-f-read_only
*              %features-%field-week5 =   if_abap_behv=>fc-f-read_only
*              %features-%field-week6 =   if_abap_behv=>fc-f-read_only
*              %features-%field-week7 =   if_abap_behv=>fc-f-read_only
***
*                                        )   ).
*
*   select single from zweekflag   FIELDS weekflag, id where id1 = '1' into  @data(ls_weekflag).
*data(temp) = ls_weekflag-weekflag.
*
*   if ls_weekflag is not initial.
*       " lv_weektemp = it_weekstatus[ purchaseorder = it_po purchaseorderitem = it_poitem ]-weekstatus.
*
*
*      CASE temp.
*        WHEN 'Week1'.
*          result[ 1 ]-%field-week1 =  if_abap_behv=>fc-f-unrestricted.
*        WHEN 'Week2'.
*          result[ 1 ]-%field-week2 =  if_abap_behv=>fc-f-unrestricted.
*        WHEN 'Week3'.
*          result[ 1 ]-%field-week3 =  if_abap_behv=>fc-f-unrestricted.
*        WHEN 'Week4'.
*          result[ 1 ]-%field-week4 =  if_abap_behv=>fc-f-unrestricted.
*        WHEN 'Week5'.
*          result[ 1 ]-%field-week5 =  if_abap_behv=>fc-f-unrestricted.
*        WHEN 'Week6'.
*          result[ 1 ]-%field-week6 =  if_abap_behv=>fc-f-unrestricted.
*        WHEN 'Week7'.
*          result[ 1 ]-%field-week7 =  if_abap_behv=>fc-f-unrestricted.
*
*      ENDCASE.
*endif.



  ENDMETHOD.



  METHOD zstatus.

    DATA: it_collection TYPE TABLE OF zcollectionrpt.
    DATA(lv_po) = keys[ 1 ]-purchaseorder.
    DATA(lv_poitem) = keys[ 1 ]-purchaseorderitem.
    DATA(lv_weekstatus) = keys[ 1 ]-WeekStatusselection.



    SELECT FROM i_purchaseorderitemapi01 FIELDS DISTINCT purchaseorder, purchaseorderitem, companycode, customer WHERE purchaseorder = @lv_po AND purchaseorderitem = @lv_poitem
    INTO TABLE @DATA(it_potable).

    SELECT FROM zcollectionrpt FIELDS * WHERE purchaseorder = @lv_po AND purchaseorderitem = @lv_poitem
    INTO TABLE @DATA(it_zcollection).
*
*    IF it_zcollection IS INITIAL.
*      it_collection = CORRESPONDING #( it_potable ).
*      it_collection[ purchaseorder = lv_po purchaseorderitem = lv_poitem ]-weekstatus = lv_weekstatus.
*      MODIFY  zcollectionrpt  FROM TABLE @it_collection.
*    ENDIF.
*
*    IF it_zcollection IS NOT INITIAL.
*      UPDATE zcollectionrpt SET weekstatus = @lv_weekstatus  WHERE purchaseorder = @lv_po AND purchaseorderitem = @lv_poitem.
*    ENDIF.

    result = VALUE #( FOR ls_potable IN it_potable
                                                     ( purchaseorder = ls_potable-purchaseorder
                                                     purchaseorderitem = ls_potable-purchaseorderitem
                                                     WeekStatusselection = lv_weekstatus
                                                  "    %param-weekstatus = lv_weekstatus
                                                      %param-PurchaseOrder = '123456'
*                                                      %param-companycode = 'Hello'
*                                                      %param-customer = 'Hello'

                                                                                                              )    ).

*    mapped-zcollectionreport = VALUE #(  FOR ls_potable IN it_potable
*                  (  purchaseorder = ls_potable-purchaseorder
*                                        purchaseorderitem = ls_potable-purchaseorderitem       )    ).


  ENDMETHOD.

*  METHOD get_global_features.
*
*
*  ENDMETHOD.
*
*  METHOD zglobal.
*  ENDMETHOD.

  METHOD zstatus1.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcollectionreport DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcollectionreport IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

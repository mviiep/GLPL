CLASS lhc_zfi_msme_report DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR msme_report RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE msme_report.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE msme_report.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE msme_report.

    METHODS read FOR READ
      IMPORTING keys FOR READ msme_report RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK msme_report.
    METHODS zcomments FOR MODIFY
      IMPORTING keys FOR ACTION msme_report~zcomments RESULT result.

ENDCLASS.

CLASS lhc_zfi_msme_report IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
*    DATA: it_data TYPE TABLE OF zmsme_tb,
*          ls_data TYPE zmsme_tb.
*
*    DATA(it_entities) = entities.
*
*    LOOP AT it_entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
*      ls_data = CORRESPONDING #( <ls_entity> ).
*      APPEND ls_data TO it_data.
*      CLEAR ls_data.
*    ENDLOOP.
*
*
*    MODIFY zmsme_tb FROM TABLE @it_data.

*  read ENTITIES OF zfi_msme_report IN LOCAL MODE
*  ENTITY Msme_report
* ALL FIELDS WITH CORRESPONDING #( entities )
*  result data(it_result)
*  FAILED DATA(lt_failure)
*  REPORTED DATA(lt_reported).

    TYPES: BEGIN OF ty_comments,
             supplier TYPE zmsme_tb-supplier,
             zcomment TYPE zmsme_tb-zcomment,
           END OF ty_comments.

    TYPES: BEGIN OF r_comment,
             sign   TYPE zsign,
             option TYPE zoption,
             low    TYPE lifnr,
             high   TYPE lifnr,
           END OF r_comment.

    DATA : ls_comment TYPE ty_comments,
           it_comment TYPE TABLE OF  ty_comments.


    DATA: ls_commentkey TYPE zmsme_tb-supplier,
          it_commentkey TYPE TABLE OF zmsme_tb-supplier.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entitycomment>).

      ls_comment-supplier = <ls_entitycomment>-supplier.
      ls_comment-zcomment = <ls_entitycomment>-zcomment.
      APPEND ls_comment TO it_comment.
    ENDLOOP.


    SELECT * FROM zmsme_tb
    FOR ALL ENTRIES IN @it_comment
    WHERE supplier = @it_comment-supplier
    INTO TABLE @DATA(it_msmedata).

    loop at it_comment ASSIGNING FIELD-SYMBOL(<ls_commentdata>).
    READ TABLE it_msmedata INTO DATA(ls_msmedata) WITH KEY supplier = <ls_commentdata>-supplier.
    if ls_msmedata is not initial.
    it_msmedata[ supplier = <ls_commentdata>-supplier ]-zcomment = <ls_commentdata>-zcomment.
    endif.

    endloop.

     MODIFY zmsme_tb FROM TABLE @it_msmedata.

  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.

    "data(z) = 2.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD zcomments.

   TYPES: BEGIN OF ty_comments,
             supplier TYPE zmsme_tb-supplier,
             zcomment TYPE zmsme_tb-zcomment,
           END OF ty_comments.

    DATA : ls_comment TYPE ty_comments,
           it_comment TYPE TABLE OF  ty_comments.

    DATA: ls_commentkey TYPE zmsme_tb-supplier,
          it_commentkey TYPE TABLE OF zmsme_tb-supplier.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_entitycomment>).
      ls_comment-supplier = <ls_entitycomment>-supplier.
      ls_comment-zcomment = <ls_entitycomment>-%param-comments.
      APPEND ls_comment TO it_comment.
    ENDLOOP.


    SELECT * FROM zmsme_tb
    FOR ALL ENTRIES IN @it_comment
    WHERE supplier = @it_comment-supplier
    INTO TABLE @DATA(it_msmedata).

    loop at it_comment ASSIGNING FIELD-SYMBOL(<ls_commentdata>).
    READ TABLE it_msmedata INTO DATA(ls_msmedata) WITH KEY supplier = <ls_commentdata>-supplier.
    if ls_msmedata is not initial.
    it_msmedata[ supplier = <ls_commentdata>-supplier ]-zcomment = <ls_commentdata>-zcomment.
    endif.

    endloop.

 MODIFY zmsme_tb FROM TABLE @it_msmedata.

select c~supplier,  m~sno ,m~bp_name, m~pan_no, m~no1, m~amt1, m~no2, m~amt2, m~no3, m~amt3, m~no4, m~amt4, m~zcomment
 from @it_comment as c inner join @it_msmedata as m
ON c~supplier = m~supplier
inner JOIN @keys as k ON c~supplier = k~supplier

 INTO table @data(it_final).

 result = value #( for ls_final in it_final (
                                        %tky = keys[ supplier = ls_final-supplier ]-%tky
                                       " %key = ls_final-supplier
                                        supplier = keys[ supplier = ls_final-supplier ]-supplier
                                        %param-Amt1 = ls_final-amt1
*                                        %param-No1 = ls_final-no1
*                                        %param-Amt2 = ls_final-amt2
*                                        %param-No2 = ls_final-no2
*                                        %param-Amt3 = ls_final-amt3
*                                        %param-No3 = ls_final-no3
*                                        %param-Amt4 = ls_final-amt4
*                                        %param-No4 = ls_final-no4
*                                        %param-bp = ls_final-bp_name
*                                        %param-pan = ls_final-pan_no
*                                        %param-sno = ls_final-sno
*                                        %param-zcomment = ls_final-zcomment

                                         )   ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfi_msme_report DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfi_msme_report IMPLEMENTATION.

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

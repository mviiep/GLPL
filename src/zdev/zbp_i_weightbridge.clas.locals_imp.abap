CLASS lhc_zi_weightbridge DEFINITION INHERITING FROM cl_abap_behavior_handler.


  PRIVATE SECTION.
  METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR weight RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR weight RESULT result.



ENDCLASS.

CLASS lhc_zi_weightbridge IMPLEMENTATION.
METHOD get_instance_features.
DATA(lv_plant1) = keys[ 1 ]-plant1.
    DATA(lv_plant2) = keys[ 1 ]-plant2.
    DATA(lv_wbid) = keys[ 1 ]-wbid.

  data:ls_weight1 type zweightbridge.
    select * from  zweightbridge   WHERE plant1 = @lv_plant1 and plant2 = @lv_plant2 and wbid = @lv_wbid
    INTO TABLE @DATA(lt_weight).
    IF sy-subrc = 0.
      result = VALUE #( FOR ls_weight IN lt_weight
               (   plant1 =   ls_weight-plant1
                   plant2  = ls_weight-plant2
                    wbid = ls_weight-wbid
                "  clearing_date = lv_clearingdate
                   "%features-%field-changeby =   if_abap_behv=>fc-f-read_only
                   %features-%field-changeby =   if_abap_behv=>fc-f-unrestricted
                    %features-%field-changeond =   if_abap_behv=>fc-f-unrestricted
               )   ).



               ENDIF.
           select SINGLE * from  zweightbridge   WHERE plant1 = @lv_plant1 and plant2 = @lv_plant2 and wbid = @lv_wbid
             INTO  @ls_weight1.
           if   sy-subrc = 0.
            ls_weight1-changeby = sy-uname.
           " ls_weight1-changeond =
           MODIFY  zweightbridge from @ls_weight1.
           IF sy-subrc = 0.
      result = VALUE #( FOR ls_weight IN lt_weight
               (   plant1 =   ls_weight-plant1
                   plant2  = ls_weight-plant2
                    wbid = ls_weight-wbid
                "  clearing_date = lv_clearingdate
                   "%features-%field-changeby =   if_abap_behv=>fc-f-read_only
                   %features-%field-changeby =   if_abap_behv=>fc-f-read_only
                    %features-%field-changeond =   if_abap_behv=>fc-f-read_only
               )   ).



               ENDIF.

           ENDIF.


endmethod.
  METHOD get_instance_authorizations.




  ENDMETHOD.


ENDCLASS.

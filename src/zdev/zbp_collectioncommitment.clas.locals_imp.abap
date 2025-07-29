CLASS lhc_zcollectioncommitment DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zcollectioncommitment RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zcollectioncommitment RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE zcollectioncommitment.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zcollectioncommitment.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE zcollectioncommitment.

    METHODS read FOR READ
      IMPORTING keys FOR READ zcollectioncommitment RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zcollectioncommitment.

ENDCLASS.

CLASS lhc_zcollectioncommitment IMPLEMENTATION.

  METHOD get_instance_features.

    DATA(lv_cust) = keys[ 1 ]-cust_id.
    DATA(lv_accountingno) = keys[ 1 ]-accountingnumber.
    DATA(lv_weekstatusselection) = keys[ 1 ]-weekstatus.
   " data(lv_clearingdate) = keys[ 1 ]-clearing_date.
    " DATA lv_weektemp TYPE c LENGTH 6.
    "  DATA(lv_flag) = '0'.


    Select single from i_journalentryitem FIELDS ClearingDate
    where AccountingDocument = @lv_accountingno
    and Ledger = '0L'
    and FinancialAccountType = 'D'
    INTO @data(lv_clearingdate).



    SELECT FROM zcollectioncomnt FIELDS DISTINCT accountingdocument,companycode, fiscalyear WHERE accountingdocument = @lv_accountingno
    INTO TABLE @DATA(it_weekstatus).
    IF sy-subrc = 0.
      result = VALUE #( FOR ls_weekstatus IN it_weekstatus
               (   accountingnumber =   ls_weekstatus-accountingdocument
                  cust_id =   lv_cust
                  weekstatus = lv_weekstatusselection
                "  clearing_date = lv_clearingdate
                   %features-%field-week1 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week2 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week3 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week4 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week5 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week6 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week7 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week8 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week9 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week10 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week11 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week12 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week13 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week14 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week15 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week16 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week17 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week18 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week19 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week20 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week21 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week22 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week23 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week24 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week25 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week26 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week27 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week28 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week29 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week30 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week31 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week32 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week33 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week34 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week35 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week36 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week37 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week38 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week39 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week40 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week41 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week42 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week43 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week44 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week45 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week46 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week47 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week48 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week49 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week50 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week51 =   if_abap_behv=>fc-f-read_only
                   %features-%field-week52 =   if_abap_behv=>fc-f-read_only

*
                                               )   ).
    ENDIF.


    "
    "select from zweekselection FIELDS weekselection into TABLE @data(it_weekselection).
    SELECT SINGLE FROM zcollectioncomnt  FIELDS  * WHERE accountingdocument = @lv_accountingno
    INTO  @DATA(it_weeks).


    IF it_weekstatus IS NOT INITIAL.
      DATA(lv_weektemp) = lv_weekstatusselection.

      CASE lv_weektemp.
        WHEN 'WEEK01'.
          IF it_weeks-week1 IS INITIAL
          and (   it_weeks-week2 is initial  and it_weeks-week3 is initial and it_weeks-week4 is initial and it_weeks-week5 is initial and it_weeks-week6 is initial and  it_weeks-week7 is initial
           and it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
          and lv_clearingdate is initial ).
            result[ 1 ]-%field-week1 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.

        WHEN 'WEEK02'.
          IF it_weeks-week2 IS INITIAL
            and ( it_weeks-week3 is initial and it_weeks-week4 is initial and it_weeks-week5 is initial and it_weeks-week6 is initial and  it_weeks-week7 is initial
          and it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial  ).
            result[ 1 ]-%field-week2 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK03'.

          IF it_weeks-week3 IS INITIAL
             and (  it_weeks-week4 is initial and it_weeks-week5 is initial and it_weeks-week6 is initial and  it_weeks-week7 is initial
          and it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week3 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK04'.

          IF it_weeks-week4 IS INITIAL
          and (   it_weeks-week5 is initial and it_weeks-week6 is initial and  it_weeks-week7 is initial
          and it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial  ).
            result[ 1 ]-%field-week4 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.

        WHEN 'WEEK05'.
          IF it_weeks-week5 IS INITIAL
         and (  it_weeks-week6 is initial and  it_weeks-week7 is initial
          and it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week5 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK06'.
          IF it_weeks-week6 IS INITIAL
          and   ( it_weeks-week7 is initial
          and it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).

            result[ 1 ]-%field-week6 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK07'.
          IF it_weeks-week7 IS INITIAL
            and ( it_weeks-week8 is initial  and it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
          .
            result[ 1 ]-%field-week7 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK08'.
          IF it_weeks-week8 IS INITIAL
           and (  it_weeks-week9 is initial and it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
          .
            result[ 1 ]-%field-week8 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK09'.
          IF it_weeks-week9 IS INITIAL
           and (  it_weeks-week10 is initial and it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week9 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK10'.
          IF it_weeks-week10 IS INITIAL
           and ( it_weeks-week11 is initial and it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week10 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK11'.
          IF it_weeks-week11 IS INITIAL
           and (  it_weeks-week12 is initial
          and    it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week11 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK12'.
          IF it_weeks-week12 IS INITIAL
          and ( it_weeks-week13 is initial and it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week12 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK13'.
          IF it_weeks-week13 IS INITIAL
           and (  it_weeks-week14 is initial and it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week13 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK14'.
          IF it_weeks-week14 IS INITIAL
           and ( it_weeks-week15 is initial and it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week14 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK15'.
          IF it_weeks-week15 IS INITIAL
            and (  it_weeks-week16 is initial and it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week15 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK16'.
          IF it_weeks-week16 IS INITIAL
            and ( it_weeks-week17 is initial and it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week16 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK17'.
          IF it_weeks-week17 IS INITIAL
            and ( it_weeks-week18 is initial
          and it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week17 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK18'.
          IF it_weeks-week18 IS INITIAL
            and ( it_weeks-week19 is initial and it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week18 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK19'.
          IF it_weeks-week19 IS INITIAL
          and ( it_weeks-week20 is initial and it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week19 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK20'.
          IF it_weeks-week20 IS INITIAL
          and ( it_weeks-week21 is initial and it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week20 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK21'.
          IF it_weeks-week21 IS INITIAL
          and ( it_weeks-week22 is initial and it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week21 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK22'.
          IF it_weeks-week22 IS INITIAL
          and ( it_weeks-week23 is initial and it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week22 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK23'.
          IF it_weeks-week23 IS INITIAL
          and ( it_weeks-week24 is initial and it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week23 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK24'.
          IF it_weeks-week24 IS INITIAL
          and (  it_weeks-week25 is initial
          and it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week24 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK25'.
          IF it_weeks-week25 IS INITIAL
          and ( it_weeks-week26 is initial and it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week25 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK26'.
          IF it_weeks-week26 IS INITIAL
          and ( it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week26 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK27'.
          IF it_weeks-week27 IS INITIAL
          and ( it_weeks-week27 is initial and it_weeks-week28 is initial and it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week27 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK28'.
          IF it_weeks-week28 IS INITIAL
           and ( it_weeks-week29 is initial and it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week28 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK29'.
          IF it_weeks-week29 IS INITIAL
           and (  it_weeks-week30 is initial and it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week29 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK30'.
          IF it_weeks-week30 IS INITIAL
           and ( it_weeks-week31 is initial and it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week30 =  if_abap_behv=>fc-f-unrestricted.

          ENDIF.
        WHEN 'WEEK31'.
          IF it_weeks-week31 IS INITIAL
           and (  it_weeks-week32 is initial
          and it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week31 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK32'.
          IF it_weeks-week32 IS INITIAL
           and ( it_weeks-week33 is initial and it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week32 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK33'.
          IF it_weeks-week33 IS INITIAL
           and ( it_weeks-week34 is initial and it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week33 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK34'.
          IF it_weeks-week34 IS INITIAL
           and ( it_weeks-week35 is initial and it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week34 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK35'.
          IF it_weeks-week35 IS INITIAL
           and ( it_weeks-week36 is initial and it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week35 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK36'.
          IF it_weeks-week36 IS INITIAL
           and ( it_weeks-week37 is initial and it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week36 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK37'.
          IF it_weeks-week37 IS INITIAL
           and ( it_weeks-week38 is initial
          and it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week37 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK38'.
          IF it_weeks-week38 IS INITIAL
           and ( it_weeks-week39 is initial and it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week38 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK39'.
          IF it_weeks-week39 IS INITIAL
           and ( it_weeks-week40 is initial and it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week39 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK40'.
          IF it_weeks-week40 IS INITIAL
           and ( it_weeks-week41 is initial and it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week40 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK41'.
          IF it_weeks-week41 IS INITIAL
           and ( it_weeks-week42 is initial and it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week41 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK42'.
          IF it_weeks-week42 IS INITIAL
          and (  it_weeks-week43 is initial and it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week42 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK43'.
          IF it_weeks-week43 IS INITIAL
          and (  it_weeks-week44 is initial
          and it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week43 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK44'.
          IF it_weeks-week44 IS INITIAL
          and ( it_weeks-week45 is initial and it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week44 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK45'.
          IF it_weeks-week45 IS INITIAL
          and (  it_weeks-week46 is initial and it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week45 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK46'.
          IF it_weeks-week46 IS INITIAL
          and ( it_weeks-week47 is initial and it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial ).
            result[ 1 ]-%field-week46 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK47'.
          IF it_weeks-week47 IS INITIAL
          and ( it_weeks-week48 is initial and it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..

          result[ 1 ]-%field-week47 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK48'.
          IF it_weeks-week48 IS INITIAL
          and ( it_weeks-week49 is initial and it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week48 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK49'.
          IF it_weeks-week49 IS INITIAL
          and (  it_weeks-week50 is initial
           and it_weeks-week51 is initial and it_weeks-week52 is initial
           and lv_clearingdate is initial )..
            result[ 1 ]-%field-week49 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK50'.
          IF it_weeks-week50 IS INITIAL
          and ( it_weeks-week51 is initial and it_weeks-week52 is initial
          and lv_clearingdate is initial )..
            result[ 1 ]-%field-week50 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK51'.
          IF it_weeks-week51 IS INITIAL
          and (  it_weeks-week52 is initial
          and lv_clearingdate is initial )..
            result[ 1 ]-%field-week51 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
        WHEN 'WEEK52'.
          IF it_weeks-week52 IS INITIAL
          and lv_clearingdate is initial.
            result[ 1 ]-%field-week52 =  if_abap_behv=>fc-f-unrestricted.
          ENDIF.
      ENDCASE.


    ENDIF.


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.

  METHOD update.
    DATA(it_entities) = entities.
    DATA(a) = '2'.

    DATA(lv_cus) = VALUE #( entities[ 1 ]-cust_id  OPTIONAL ).
    DATA(lv_accountingno) = VALUE #( entities[ 1 ]-accountingnumber  OPTIONAL ).
    DATA(lv_weekstatus) = VALUE #( entities[ 1 ]-weekstatus OPTIONAL ).

*    DATA it_potable TYPE TABLE OF zcollectionrpt.
*
*    it_potable = VALUE #(  FOR ls_entity IN entities
*                           ( purchaseorder =  ls_entity-purchaseorder
*                           purchaseorderitem = ls_entity-purchaseorderitem
*                           week1 = ls_entity-week1
*                           week2 = ls_entity-week2
*                           week3 = ls_entity-week3
*                           week4 = ls_entity-week4
*                           week5 = ls_entity-week5
*                           week6 = ls_entity-week6
*                           week7 = ls_entity-week7
*                          " weekstatus = ls_entity-weekstatus
*                                  )       ).

    DATA(week1) = VALUE #( entities[ 1 ]-week1  OPTIONAL ).
    DATA(week2) = VALUE #( entities[ 1 ]-week2  OPTIONAL ).
    DATA(week3) = VALUE #( entities[ 1 ]-week3  OPTIONAL ).
    DATA(week4) = VALUE #( entities[ 1 ]-week4  OPTIONAL ).
    DATA(week5) = VALUE #( entities[ 1 ]-week5  OPTIONAL ).
    DATA(week6) = VALUE #( entities[ 1 ]-week6  OPTIONAL ).
    DATA(week7) = VALUE #( entities[ 1 ]-week7  OPTIONAL ).
    DATA(week8) = VALUE #( entities[ 1 ]-week8  OPTIONAL ).
    DATA(week9) = VALUE #( entities[ 1 ]-week9  OPTIONAL ).
    DATA(week10) = VALUE #( entities[ 1 ]-week10 OPTIONAL ).
    DATA(week11) = VALUE #( entities[ 1 ]-week11 OPTIONAL ).
    DATA(week12) = VALUE #( entities[ 1 ]-week12 OPTIONAL ).
    DATA(week13) = VALUE #( entities[ 1 ]-week13 OPTIONAL ).
    DATA(week14) = VALUE #( entities[ 1 ]-week14 OPTIONAL ).
    DATA(week15) = VALUE #( entities[ 1 ]-week15 OPTIONAL ).
    DATA(week16) = VALUE #( entities[ 1 ]-week16 OPTIONAL ).
    DATA(week17) = VALUE #( entities[ 1 ]-week17 OPTIONAL ).
    DATA(week18) = VALUE #( entities[ 1 ]-week18 OPTIONAL ).
    DATA(week19) = VALUE #( entities[ 1 ]-week19 OPTIONAL ).
    DATA(week20) = VALUE #( entities[ 1 ]-week20 OPTIONAL ).
    DATA(week21) = VALUE #( entities[ 1 ]-week21 OPTIONAL ).
    DATA(week22) = VALUE #( entities[ 1 ]-week22 OPTIONAL ).
    DATA(week23) = VALUE #( entities[ 1 ]-week23 OPTIONAL ).
    DATA(week24) = VALUE #( entities[ 1 ]-week24 OPTIONAL ).
    DATA(week25) = VALUE #( entities[ 1 ]-week25 OPTIONAL ).
    DATA(week26) = VALUE #( entities[ 1 ]-week26 OPTIONAL ).
    DATA(week27) = VALUE #( entities[ 1 ]-week27 OPTIONAL ).
    DATA(week28) = VALUE #( entities[ 1 ]-week28 OPTIONAL ).
    DATA(week29) = VALUE #( entities[ 1 ]-week29 OPTIONAL ).
    DATA(week30) = VALUE #( entities[ 1 ]-week30 OPTIONAL ).
    DATA(week31) = VALUE #( entities[ 1 ]-week31 OPTIONAL ).
    DATA(week32) = VALUE #( entities[ 1 ]-week32 OPTIONAL ).
    DATA(week33) = VALUE #( entities[ 1 ]-week33 OPTIONAL ).
    DATA(week34) = VALUE #( entities[ 1 ]-week34 OPTIONAL ).
    DATA(week35) = VALUE #( entities[ 1 ]-week35 OPTIONAL ).
    DATA(week36) = VALUE #( entities[ 1 ]-week36 OPTIONAL ).
    DATA(week37) = VALUE #( entities[ 1 ]-week37 OPTIONAL ).
    DATA(week38) = VALUE #( entities[ 1 ]-week38 OPTIONAL ).
    DATA(week39) = VALUE #( entities[ 1 ]-week39 OPTIONAL ).
    DATA(week40) = VALUE #( entities[ 1 ]-week40 OPTIONAL ).
    DATA(week41) = VALUE #( entities[ 1 ]-week41 OPTIONAL ).
    DATA(week42) = VALUE #( entities[ 1 ]-week42 OPTIONAL ).
    DATA(week43) = VALUE #( entities[ 1 ]-week43 OPTIONAL ).
    DATA(week44) = VALUE #( entities[ 1 ]-week44 OPTIONAL ).
    DATA(week45) = VALUE #( entities[ 1 ]-week45 OPTIONAL ).
    DATA(week46) = VALUE #( entities[ 1 ]-week46 OPTIONAL ).
    DATA(week47) = VALUE #( entities[ 1 ]-week47 OPTIONAL ).
    DATA(week48) = VALUE #( entities[ 1 ]-week48 OPTIONAL ).
    DATA(week49) = VALUE #( entities[ 1 ]-week49 OPTIONAL ).
    DATA(week50) = VALUE #( entities[ 1 ]-week50 OPTIONAL ).
    DATA(week51) = VALUE #( entities[ 1 ]-week51 OPTIONAL ).
    DATA(week52) = VALUE #( entities[ 1 ]-week52 OPTIONAL ).


    DATA(it_entities1) = entities.


    "modify zcollectionrpt FROM table @it_potable.
*    IF week1 IS NOT INITIAL.
*      UPDATE zcollectioncomnt SET week1 = @week1  WHERE accountingdocument = @lv_accountingno.
*
*    ENDIF.
*
*    IF week2 IS NOT INITIAL.
*      UPDATE zcollectioncomnt SET week2 = @week2  WHERE accountingdocument = @lv_accountingno.
*    ENDIF.
*
*      IF week2 IS NOT INITIAL.
*      UPDATE zcollectioncomnt SET week2 = @week2  WHERE accountingdocument = @lv_accountingno.
*    ENDIF.
*
*      IF week2 IS NOT INITIAL.
*      UPDATE zcollectioncomnt SET week2 = @week2  WHERE accountingdocument = @lv_accountingno.
*    ENDIF.
*
*      IF week2 IS NOT INITIAL.
*      UPDATE zcollectioncomnt SET week2 = @week2  WHERE accountingdocument = @lv_accountingno.
*    ENDIF.


    DATA(it_entities2) = entities.

    CASE it_entities[ 1 ]-weekstatus.
      WHEN 'WEEK01'.
        IF week1 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week1 = @week1  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK02'.
        IF week2 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week2 = @week2  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK03'.

        IF week3 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week3 = @week3  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK04'.

        IF week4 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week4 = @week4  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK05'.
        IF week5 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week5 = @week5  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK06'.
        IF week6 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week6 = @week6  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK07'.
        IF week7 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week7 = @week7  WHERE accountingdocument = @lv_accountingno.

        ENDIF.
      WHEN 'WEEK08'.
        IF week8 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week8 = @week8  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK09'.
        IF week9 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week9 = @week9  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK10'.
        IF week10 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week10 = @week10  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'Week11'.
        IF week11 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week11 = @week11  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK12'.

        IF week12 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week12 = @week12  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK13'.

        IF week13 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week13 = @week13  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK14'.
        IF week14 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week14 = @week14  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK15'.
        IF week15 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week15 = @week15  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK16'.
        IF week16 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week16 = @week16  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK17'.
        IF week17 IS NOT INITIAL.
          IF week17 IS NOT INITIAL.
            UPDATE zcollectioncomnt SET week17 = @week17  WHERE accountingdocument = @lv_accountingno.
          ENDIF.
        ENDIF.
      WHEN 'WEEK18'.
        IF week18 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week18 = @week18  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK19'.
        IF week19 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week19 = @week19  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK20'.
        IF week20 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week20 = @week20  WHERE accountingdocument = @lv_accountingno.
        ENDIF..
      WHEN 'WEEK21'.
        IF week21 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week21 = @week21  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK22'.
        IF week22 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week22 = @week22  WHERE accountingdocument = @lv_accountingno.
        ENDIF..
        IF week23 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week23 = @week23  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK24'.
        IF week24 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week24 = @week24  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK25'.
        IF week25 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week25 = @week25  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK26'.
        IF week26 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week26 = @week26  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK27'.
        IF week27 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week27 = @week27  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK28'.
        IF week28 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week28 = @week28  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK29'.
        IF week29 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week29 = @week29  WHERE accountingdocument = @lv_accountingno.
        ENDIF..
      WHEN 'WEEK30'.
        IF week30 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week30 = @week30  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK31'.
        IF week31 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week31 = @week31  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK32'.
        IF week32 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week32 = @week32  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK33'.
        IF week33 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week33 = @week33  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK35'.
        IF week19 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week35 = @week35  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK34'.
        IF week34 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week34 = @week34  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK36'.
        IF week36 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week36 = @week36  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK37'.
        IF week19 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week37 = @week37  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK38'.
        IF week38 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week38 = @week38  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK39'.
        IF week39 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week39 = @week39  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK40'.
        IF week40 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week40 = @week40  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK41'.
        IF week41 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week41 = @week41  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK42'.
        IF week42 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week42 = @week42  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK43'.
        IF week43 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week43 = @week43  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK44'.
        IF week44 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week44 = @week44  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK45'.
        IF week45 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week45 = @week45  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK46'.
        IF week46 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week46 = @week46  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK47'.
        IF week47 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week47 = @week47  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK48'.
        IF week19 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week48 = @week48  WHERE accountingdocument = @lv_accountingno.
        ENDIF..
      WHEN 'WEEK49'.
        IF week49 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week49 = @week49  WHERE accountingdocument = @lv_accountingno.
        ENDIF..
      WHEN 'WEEK50'.
        IF week50 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week50 = @week50  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK51'.
        IF week51 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week51 = @week51  WHERE accountingdocument = @lv_accountingno.
        ENDIF.
      WHEN 'WEEK52'.
        IF week52 IS NOT INITIAL.
          UPDATE zcollectioncomnt SET week52 = @week52  WHERE accountingdocument = @lv_accountingno.
        ENDIF.


    ENDCASE.







    SELECT FROM zcollectioncomnt FIELDS *
    WHERE accountingdocument = @lv_accountingno
    INTO TABLE @DATA(it_data).
    mapped-zcollectioncommitment = VALUE #( FOR ls_data IN it_data
                                        ( cust_id = lv_cus
                                        accountingnumber = ls_data-accountingdocument
                                        weekstatus = lv_weekstatus  ) ).





  ENDMETHOD.

*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zcollectioncommitment DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zcollectioncommitment IMPLEMENTATION.

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

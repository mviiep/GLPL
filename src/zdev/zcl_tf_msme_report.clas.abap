CLASS zcl_tf_msme_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES :BEGIN OF  ty_final,
             client   TYPE mandt,
             sno      TYPE lifnr,
             supplier TYPE lifnr,
             bp       TYPE zchar40,
             pan      TYPE zchar40,
             no1      TYPE lifnr,
             amt1     TYPE  znetwr,
             no2      TYPE lifnr,
             amt2     TYPE  znetwr,
             no3      TYPE lifnr,
             amt3     TYPE  znetwr,
             no4      TYPE lifnr,
             amt4     TYPE  znetwr,
             zcomment TYPE zcomment,
           END OF ty_final.

    DATA:lt_final TYPE TABLE OF ty_final,
         wa_final TYPE ty_final.

    INTERFACES if_amdp_marker_hdb. "Marks the class as an AMDP implementation
    CLASS-METHODS get_msme
      AMDP OPTIONS READ-ONLY CDS SESSION CLIENT DEPENDENT
      IMPORTING VALUE(it_final) LIKE lt_final OPTIONAL
      EXPORTING VALUE(et_final) LIKE lt_final.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TF_MSME_REPORT IMPLEMENTATION.


  METHOD get_msme BY DATABASE PROCEDURE
      FOR HDB
      LANGUAGE SQLSCRIPT
      OPTIONS READ-ONLY
      .

    et_final = SELECT
             client,
             sno,
             supplier,
             bp,
             pan,
             no1,
             amt1,
             no2,
             amt2,
             no3,
             amt3,
             no4,
             amt4,
             zcomment
      FROM :it_final;

  ENDMETHOD.
ENDCLASS.

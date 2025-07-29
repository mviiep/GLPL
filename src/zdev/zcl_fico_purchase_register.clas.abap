CLASS zcl_fico_purchase_register DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FICO_PURCHASE_REGISTER IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: it_final TYPE TABLE OF zi_fico_purreg,
          ls_final TYPE  zi_fico_purreg.

    DATA: temp       TYPE zi_fico_purreg-amountintrnscur,
          temp1      TYPE zi_fico_purreg-amountintrnscur,
          temp2      TYPE zi_fico_purreg-amountintrnscur,
          lv_taxcode TYPE zi_fico_purreg-taxcode.

    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE pag ).
    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
    DATA(lsort) = io_request->get_sort_elements( ) .
*    data(page) = io_request->
    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
    ENDTRY.

    DATA(lt_fields)  = io_request->get_requested_elements( ).
    DATA(lt_sort)    = io_request->get_sort_elements( ).

    DATA(set) = io_request->get_requested_elements( )."  --> could be used for optimizations
    DATA(lvs) = io_request->get_search_expression( ).
    DATA(filter1) = io_request->get_filter(  ).
    DATA(p1) = io_request->get_parameters(  ).
    DATA(p2) = io_request->get_requested_elements(  ).


    TRY.
        DATA(ran) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range. "#EC NO_HANDLER
       "handle exception
    ENDTRY.
    LOOP AT ran ASSIGNING FIELD-SYMBOL(<ls_ran>).
      CASE <ls_ran>-name.
        WHEN  'ACCOUNTINGDOCUMENT'.
          DATA(lv_accountingdocument) = <ls_ran>-range.
        WHEN 'POSTINGDATE'.
          DATA(lv_postingdate) = <ls_ran>-range.
        WHEN 'ACCOUNTINGDOCUMENTITEM'.
          DATA(lv_accountdocumentitem) =  <ls_ran>-range.
      ENDCASE.
    ENDLOOP.




    SELECT FROM i_journalentryitem AS ji INNER JOIN i_journalentry AS jh
     ON ji~accountingdocument = jh~accountingdocument
     AND ji~fiscalyear = jh~fiscalyear
     AND ji~companycode = jh~companycode
     AND ji~accountingdocumenttype = jh~accountingdocumenttype
     FIELDS DISTINCT  ji~supplier, ji~accountingdocument, ji~accountingdocumentitem, ji~amountintransactioncurrency,ji~financialaccounttype,
     ji~transactiontypedetermination, ji~ledgergllineitem, ji~profitcenter,
     ji~originctrlgdebitcreditcode, ji~glaccount, ji~costcenter, ji~purchasingdocument, ji~purchasingdocumentitem , ji~fixedasset,ji~taxcode,ji~companycodecurrency,
     jh~branch, jh~documentreferenceid, jh~documentdate, jh~postingdate, jh~companycode, jh~accountingdocumenttype,jh~fiscalyear,jh~reversedocument,
     jh~reversedocumentfiscalyear, jh~accountingdoccreatedbyuser,jh~accountingdocumentcreationdate
    WHERE ji~accountingdocument IN @lv_accountingdocument  "= '1900000004' or  ji~accountingdocument = '1900000005'
*    and ji~PostingDate in @lv_postingdate "uncommented by sanjay func-nikhil 23.05.2025
    AND jh~accountingdocumenttype IN ( 'KG', 'KR', 'RE', 'RK', 'RN' )
     AND ji~ledger = '0L'
*      and jh~Ledger = '0L'
     INTO TABLE @DATA(it_data).

delete it_data where PostingDate not in lv_postingdate. "added by madhuri given by kaliprasanna 18/07/205

    SELECT * FROM @it_data AS it_data
    WHERE financialaccounttype <> 'K'
    ORDER BY accountingdocument
    INTO TABLE @DATA(it_dataprocess).


    SELECT FROM @it_data AS supplierno
    FIELDS DISTINCT
    supplier, financialaccounttype, accountingdocumenttype, accountingdocument
    WHERE financialaccounttype = 'K'
    ORDER BY financialaccounttype
    INTO TABLE @DATA(it_suppliernumber).



    SELECT DISTINCT b~bptaxnumber, i~supplier, i~financialaccounttype FROM  i_businesspartnertaxnumber AS b
    INNER JOIN  @it_data AS i
    ON b~businesspartner = i~supplier
    AND b~bptaxtype = 'IN3'
    INTO TABLE @DATA(it_taxnum).



    SELECT DISTINCT  i~supplier, s~suppliername FROM  i_supplier AS s
    INNER JOIN  @it_data AS i
    ON s~supplier = i~supplier
    INTO TABLE @DATA(it_supplier).

    SELECT DISTINCT i~accountingdocument, o~in_gstplaceofsupply, o~in_hsnorsaccode FROM i_operationalacctgdocitem AS o
    INNER JOIN @it_data AS i
    ON o~accountingdocument = i~accountingdocument
AND o~companycode = i~companycode
AND o~fiscalyear = i~fiscalyear
AND o~accountingdocumentitem = i~accountingdocumentitem

    INTO TABLE @DATA(it_supply).



    SELECT DISTINCT i~accountingdocument,i~accountingdocumentitem, o~in_hsnorsaccode FROM i_operationalacctgdocitem AS o
INNER JOIN @it_data AS i
ON o~accountingdocument = i~accountingdocument
AND o~companycode = i~companycode
AND o~fiscalyear = i~fiscalyear
AND o~accountingdocumentitem = i~accountingdocumentitem

INTO TABLE @DATA(it_supply1).


    SELECT DISTINCT  i~accountingdocument , g~companycode ,g~glaccount,   glaccountlongname FROM i_glaccounttextincompanycode AS g
    INNER JOIN @it_data AS i
    ON g~companycode = i~companycode
    AND g~glaccount = i~glaccount
    INTO TABLE @DATA(it_glaccount).


    "Remain mail id
    SELECT DISTINCT p~purchaseorder , p~purchasinggroup, p~createdbyuser FROM i_purchaseorderapi01 AS p
    INNER JOIN @it_data AS i
    ON p~purchaseorder = i~purchasingdocument
    INTO TABLE @DATA(it_purchaseheader).


    SELECT DISTINCT pi~purchaseorder, pi~purchaseorderitem,  pi~orderquantity, pi~baseunit FROM i_purchaseorderitemapi01 AS pi
   INNER JOIN @it_data AS ph
   ON pi~purchaseorder = ph~purchasingdocument
   INTO TABLE @DATA(it_purchaseitem).


    SELECT DISTINCT p~profitcenter,  p~profitcenterlongname FROM i_profitcentertext AS p
   INNER JOIN @it_data AS i
   ON p~profitcenter = i~profitcenter
   INTO TABLE @DATA(it_profitcenter).


*    SELECT FROM @it_data AS itdata1 FIELDS accountingdocument, amountintransactioncurrency, financialaccounttype, transactiontypedetermination, TaxCode
*    WHERE accountingdocument   IN @lv_accountingdocument  "= '1900000004' OR accountingdocument = '1900000005'
*    "and PostingDate in @lv_postingdate
*    INTO TABLE @DATA(it_processdata).


*    SELECT FROM I_JournalEntryItem AS i
*    inner join I_OperationalAcctgDocItem as o
*    on i~AccountingDocument = o~AccountingDocument
*    and LTRIM( i~LedgerGLLineItem, '0' ) =  LTRIM( o~AccountingDocumentItem, '0' )
*    and i~FiscalYear = o~FiscalYear
*    and i~CompanyCode = o~CompanyCode
*    and i~Ledger = '0L'
*
*    FIELDS DISTINCT i~accountingdocument,i~AccountingDocumentItem, i~amountintransactioncurrency, i~financialaccounttype, i~transactiontypedetermination,
*    i~TaxCode , o~TaxBaseAmountInCoCodeCrcy
*    WHERE i~accountingdocument   IN @lv_accountingdocument  "= '1900000004' OR accountingdocument = '1900000005'
*    "and PostingDate in @lv_postingdate
*    INTO TABLE @DATA(it_processdata).


    SELECT FROM @it_data AS i
INNER JOIN i_operationalacctgdocitem AS o
ON i~accountingdocument = o~accountingdocument
AND ltrim( i~ledgergllineitem, '0' ) =  ltrim( o~accountingdocumentitem, '0' )
AND i~fiscalyear = o~fiscalyear
AND i~companycode = o~companycode
" and i~Ledger = '0L'

FIELDS DISTINCT i~accountingdocument,i~accountingdocumentitem, i~amountintransactioncurrency, i~financialaccounttype, i~transactiontypedetermination,
i~taxcode , o~taxbaseamountincocodecrcy
WHERE i~accountingdocument   IN @lv_accountingdocument  "= '1900000004' OR accountingdocument = '1900000005'
"and PostingDate in @lv_postingdate
INTO TABLE @DATA(it_processdata).


    SELECT * FROM @it_data AS itdata2
    WHERE accountingdocument IN @lv_accountingdocument    "'1900000004'  OR accountingdocument = '1900000005'
    AND transactiontypedetermination = ''
    INTO TABLE @DATA(it_finaldata).

    SELECT accountingdocument, supplier FROM @it_data AS itdata2
    WHERE accountingdocument IN @lv_accountingdocument "'1900000004'  OR accountingdocument = '1900000005'
    "and PostingDate in @lv_postingdate
    AND accountingdocumenttype = 'K'
    INTO TABLE @DATA(it_supplierdetails).

    "mail ID

    SELECT FROM @it_purchaseheader AS i INNER JOIN i_businessuserbasic AS b
ON i~createdbyuser = b~userid
   " on b~createdbyuser =
    INNER JOIN i_workplaceaddress AS w
    ON b~businesspartneruuid = w~businesspartneruuid
    FIELDS DISTINCT
    i~purchaseorder, w~defaultemailaddress
    INTO TABLE @DATA(it_mail).


    DATA lv_supplier TYPE i_journalentryitem-supplier.
    " LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>).



    " LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>).
    LOOP AT it_dataprocess ASSIGNING FIELD-SYMBOL(<ls_data>).

      READ TABLE it_suppliernumber INTO DATA(ls_suppliernumber) WITH KEY financialaccounttype = 'K' accountingdocument = <ls_data>-accountingdocument.
      IF ls_suppliernumber IS NOT INITIAL.
        lv_supplier = ls_suppliernumber-supplier.
      ENDIF.

      IF  <ls_data>-transactiontypedetermination = ''  OR <ls_data>-transactiontypedetermination = 'WRX'.  "Added WRX


        "Journal entry item fields
        ls_final-accountingdocument = <ls_data>-accountingdocument.
       ls_final-accountingdocumentitem = <ls_data>-accountingdocumentitem.
*        ls_final-accountingdocumentitem = <ls_data>-LedgerGLLineItem.
        ls_final-postingdate = <ls_data>-postingdate.
        ls_final-branch = <ls_data>-branch.
        ls_final-supplier = <ls_data>-supplier.


        CASE <ls_data>-financialaccounttype.
          WHEN 'S'.


*            ls_final-amountintrnscur = REDUCE #( INIT total = 0
*                                                 FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S' AND accountingdocument = <ls_data>-accountingdocument  )
*                                                 NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
            ls_final-taxablevalue = <ls_data>-amountintransactioncurrency.




        ENDCASE.

        IF <ls_data>-transactiontypedetermination <> 'JRC' AND <ls_data>-transactiontypedetermination <> 'JRS' AND
       <ls_data>-transactiontypedetermination <> 'JRI' AND <ls_data>-transactiontypedetermination <> 'JRU' ."and <ls_data>-FinancialAccountType <> 'S' .

*          temp = REDUCE #( INIT total = 0
*                           FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND (  transactiontypedetermination = '' OR transactiontypedetermination = 'WRX' )  AND accountingdocument = <ls_data>-accountingdocument )  "Added WRX
*                           NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          temp1 = REDUCE #( INIT total = 0
*                          FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
*                          transactiontypedetermination <> 'JRC' AND transactiontypedetermination <> 'JRS' AND
*                          transactiontypedetermination <> 'JRI' AND transactiontypedetermination <> 'JRU' AND   transactiontypedetermination <> '' AND transactiontypedetermination <> 'WRX' AND accountingdocument = <ls_data>-accountingdocument )
*"Added WRX
*                          NEXT total = total +  ls_processdata-amountintransactioncurrency   ).


          temp2 = VALUE #( it_dataprocess[ accountingdocument = <ls_data>-accountingdocument accountingdocumentitem = <ls_data>-accountingdocumentitem ]-amountintransactioncurrency OPTIONAL ).
          lv_taxcode = VALUE #( it_dataprocess[ accountingdocument = <ls_data>-accountingdocument accountingdocumentitem = <ls_data>-accountingdocumentitem ]-taxcode OPTIONAL ).


          temp = REDUCE #( INIT total = 0
                           FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND (  transactiontypedetermination = '' OR transactiontypedetermination = 'WRX' )
                            AND accountingdocument = <ls_data>-accountingdocument AND accountingdocumentitem = <ls_data>-accountingdocumentitem )  "Added WRX
                           NEXT total = total +  ls_processdata-amountintransactioncurrency   ).

          temp1 = REDUCE #( INIT total = 0
                          FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
                          transactiontypedetermination <> 'JRC' AND transactiontypedetermination <> 'JRS' AND
                          transactiontypedetermination <> 'JRI' AND transactiontypedetermination <> 'JRU' AND   transactiontypedetermination <> '' AND transactiontypedetermination <> 'WRX'
                          AND accountingdocument = <ls_data>-accountingdocument AND taxbaseamountincocodecrcy = temp2 AND taxcode = lv_taxcode
                          AND  ( transactiontypedetermination = 'JIC' OR transactiontypedetermination = 'JIS' OR transactiontypedetermination = 'JII' ) )
"Added WRX
                          NEXT total = total +  ls_processdata-amountintransactioncurrency   ).


          IF temp <> 0 AND temp <> 0.
            ls_final-rate = (  temp1 / temp ) * 100.
          ENDIF .
          CLEAR temp.
          CLEAR temp1.
          CLEAR temp2.


        ENDIF.


        CASE <ls_data>-transactiontypedetermination.
          WHEN 'JRC' OR 'JRS' OR 'JRI' OR 'JRU'.
            temp = REDUCE #( INIT total = 0
                              FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
                              NEXT total = total +  ls_processdata-amountintransactioncurrency   ).

            temp1 = REDUCE #( INIT total = 0
                            FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
                            ( transactiontypedetermination <> 'JRC' OR transactiontypedetermination <> 'JRS' OR
                            transactiontypedetermination <> 'JRI' OR transactiontypedetermination <> 'JRU' OR  transactiontypedetermination <> '' ) )
                            NEXT total = total +  ls_processdata-amountintransactioncurrency   ).

            IF temp <> 0 AND temp1 <> 0.
              ls_final-raterevision = (  temp1 / temp ) * 100.
            ENDIF.
            CLEAR temp.
            CLEAR temp1.

          WHEN '' OR 'WRX'. "Added WRX

*            ls_final-taxablevalue =  REDUCE #( INIT total = 0
*                             FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  ( transactiontypedetermination = '' OR transactiontypedetermination = 'WRX' ) AND accountingdocument = <ls_data>-accountingdocument )
*                             NEXT total = total +  ls_processdata-amountintransactioncurrency   ).



            IF it_processdata[ accountingdocument = <ls_data>-accountingdocument accountingdocumentitem = <ls_data>-accountingdocumentitem ]-transactiontypedetermination = '' OR
             it_processdata[ accountingdocument = <ls_data>-accountingdocument accountingdocumentitem = <ls_data>-accountingdocumentitem ]-transactiontypedetermination = 'WRX'.
              temp = VALUE #( it_processdata[ accountingdocument = <ls_data>-accountingdocument accountingdocumentitem = <ls_data>-accountingdocumentitem ]-amountintransactioncurrency OPTIONAL ).
              lv_taxcode =  VALUE #( it_processdata[ accountingdocument = <ls_data>-accountingdocument accountingdocumentitem = <ls_data>-accountingdocumentitem ]-taxcode OPTIONAL ).


              ls_final-amountintrnscur = REDUCE #( INIT total = 0
                                                   FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S' AND taxbaseamountincocodecrcy = temp AND taxcode = lv_taxcode AND
                                                                                              ( transactiontypedetermination = 'JIC' OR transactiontypedetermination = 'JIS' OR transactiontypedetermination = 'JII' ) )
                                                   NEXT total = total +  ls_processdata-amountintransactioncurrency   ).

              ls_final-amountintrnscur = ls_final-amountintrnscur +  temp.
              CLEAR temp.

            ENDIF.

          WHEN 'JII'.

            " ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
            ls_final-inttaxamount = <ls_data>-amountintransactioncurrency.

          WHEN 'JIC'.
            ls_final-centraltaxamt = <ls_data>-amountintransactioncurrency.

          WHEN 'JIS'.

            ls_final-stateuttaxamt = <ls_data>-amountintransactioncurrency.
*
*          WHEN 'JII'.
*            ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
*
*          WHEN 'JIC'.
*            ls_final-centralitcamt = <ls_data>-amountintransactioncurrency.
*
*          WHEN 'JIS'.
*            ls_final-stateutitcamt = <ls_data>-amountintransactioncurrency.

        ENDCASE.



*      IF <ls_data>-transactiontypedetermination = 'JII'.
*        ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
*      ENDIF.

*      IF <ls_data>-transactiontypedetermination = 'JIC'.
*        ls_final-centraltaxamt = <ls_data>-amountintransactioncurrency.
*      ENDIF.

*      IF <ls_data>-transactiontypedetermination = 'JIS'.
*        ls_final-stateuttaxamt = <ls_data>-amountintransactioncurrency.
*      ENDIF.

*        IF <ls_data>-transactiontypedetermination = 'JRC' OR <ls_data>-transactiontypedetermination = 'JRS' OR
*   <ls_data>-transactiontypedetermination = 'JRI' OR <ls_data>-transactiontypedetermination = 'JRU' .
*          ls_final-reversecgeindicator = 'Y'.
*        ELSEIF <ls_data>-transactiontypedetermination <> 'JRC' OR <ls_data>-transactiontypedetermination <> 'JRS' OR
*   <ls_data>-transactiontypedetermination <> 'JRI' OR <ls_data>-transactiontypedetermination <> 'JRU' .
*          ls_final-reversecgeindicator = 'N'.
*        ENDIF.


        "ls_final-ledgerglitem = <ls_data>-LedgerGLLineItem.
        ls_final-taxcode = <ls_data>-taxcode.
        ls_final-profitcenter = <ls_data>-profitcenter.
        ls_final-debitcreditcode = <ls_data>-originctrlgdebitcreditcode.

        IF <ls_data>-transactiontypedetermination = '' OR <ls_data>-transactiontypedetermination = 'WRX'.
          ls_final-glaccount = <ls_data>-glaccount.

        ENDIF.

        ls_final-costcenter = <ls_data>-costcenter.
        ls_final-purchasingdocument = <ls_data>-purchasingdocument.


        "Journal entry fields

        ls_final-branch = <ls_data>-branch.

        IF <ls_data>-transactiontypedetermination <> 'JRC' AND <ls_data>-transactiontypedetermination <> 'JRS' AND
    <ls_data>-transactiontypedetermination <> 'JRI' AND <ls_data>-transactiontypedetermination <> 'JRU'  .
          ls_final-documentreferid = <ls_data>-documentreferenceid.
        ENDIF.

*        IF <ls_data>-transactiontypedetermination = 'JRC' OR <ls_data>-transactiontypedetermination = 'JRS' OR
*     <ls_data>-transactiontypedetermination = 'JRI' OR <ls_data>-transactiontypedetermination = 'JRU'  .
*          ls_final-documentreferenceidrcm = <ls_data>-documentreferenceid.
*        ENDIF.



        "
        ls_final-documentdate = <ls_data>-documentdate.
        ls_final-postingdate = <ls_data>-postingdate.
        ls_final-companycode = <ls_data>-companycode.
        ls_final-fiscalyear = <ls_data>-fiscalyear.
        ls_final-documenttype = <ls_data>-accountingdocumenttype.
        ls_final-reversedocument = <ls_data>-reversedocument.
        ls_final-reversedocumentyear = <ls_data>-reversedocumentfiscalyear.
        ls_final-accountingdocreatedby = <ls_data>-accountingdoccreatedbyuser.
        ls_final-fixedasset = <ls_data>-fixedasset.
        ls_final-entrydate = <ls_data>-accountingdocumentcreationdate.
        ls_final-companycodecurrency = <ls_data>-companycodecurrency.
        ls_final-ledgerglitem = <ls_data>-ledgergllineitem.



        " READ TABLE it_taxnum INTO DATA(ls_taxnum) INDEX 1.
        READ TABLE it_taxnum INTO DATA(ls_taxnum) WITH KEY supplier = lv_supplier .

        IF ls_taxnum IS NOT INITIAL.

          ls_final-bptaxnumber = ls_taxnum-bptaxnumber.
          ls_final-originaltaxnumber = ls_taxnum-bptaxnumber.

        ENDIF.
        "GST vendor registeration
        CASE ls_taxnum-bptaxnumber.
          WHEN ''.
            ls_final-vendorregis = 'Not Registered'.
          WHEN OTHERS.
            ls_final-vendorregis = 'Registered'.
        ENDCASE.

*      "Business partnr tax number
*
*        " READ TABLE it_taxnum INTO DATA(ls_taxnum) INDEX 1.
**     READ TABLE it_taxnum INTO DATA(ls_taxnum) WITH KEY Supplier = lv_supplier .
**
**      IF ls_taxnum IS NOT INITIAL.
**
**        ls_final-bptaxnumber = ls_taxnum-bptaxnumber.
**        ls_final-originaltaxnumber = ls_taxnum-bptaxnumber.
**
**        "GST vendor registeration
**        CASE ls_taxnum-bptaxnumber.
**          WHEN ''.
**            ls_final-vendorregis = 'Not Registered'.
**          WHEN OTHERS.
**            ls_final-vendorregis = 'Registered'.
**        ENDCASE.
**
**
**      ENDIF.
*
        " Supplier fields
*
        READ TABLE it_supplier INTO DATA(ls_supplier)  WITH KEY supplier = lv_supplier.

        IF ls_supplier IS NOT INITIAL.

          ls_final-supplier = ls_supplier-supplier.
          ls_final-suppliername = ls_supplier-suppliername.

        ENDIF.
*
*
        "GST Place of supply
        READ TABLE it_supply INTO DATA(ls_supply)  WITH KEY accountingdocument = <ls_data>-accountingdocument .
        IF ls_supply IS NOT INITIAL.
          ls_final-gstplaceoofsupply = ls_supply-in_gstplaceofsupply.
          " ls_final-hsncode = ls_supply-in_hsnorsaccode.
        ENDIF.
*

        "GST Place of supply
        READ TABLE it_supply1 INTO DATA(ls_hsn)  WITH KEY accountingdocument = <ls_data>-accountingdocument  accountingdocumentitem = <ls_data>-accountingdocumentitem.
        IF ls_supply IS NOT INITIAL.
          "  ls_final-gstplaceoofsupply = ls_supply-in_gstplaceofsupply.
          ls_final-hsncode = ls_hsn-in_hsnorsaccode.
        ENDIF.
*
*
*
*
*      "GLA Account long name
*
        READ TABLE it_glaccount INTO DATA(ls_glaccount) WITH KEY accountingdocument = <ls_data>-accountingdocument companycode = <ls_data>-companycode glaccount = <ls_data>-glaccount.

        IF ls_glaccount IS NOT INITIAL.

          ls_final-glaccountlongname = ls_glaccount-glaccountlongname.

        ENDIF.
*

        "Purchase header fields

        READ TABLE it_purchaseheader INTO DATA(ls_purchaseheader) WITH KEY purchaseorder = <ls_data>-purchasingdocument.
        IF ls_purchaseheader IS NOT INITIAL.

          ls_final-purchasegroup = ls_purchaseheader-purchasinggroup.
          ls_final-pocreatedby = ls_purchaseheader-createdbyuser.

        ENDIF.
*
*
        "Purchase header item fields

        READ TABLE it_purchaseitem INTO DATA(ls_purchaseitem)  WITH KEY purchaseorder = <ls_data>-purchasingdocument purchaseorderitem = <ls_data>-purchasingdocumentitem .
        IF ls_purchaseitem IS NOT INITIAL.

          ls_final-orderquantity = ls_purchaseitem-orderquantity.
          ls_final-baseunit = ls_purchaseitem-baseunit.

        ENDIF.
*
        "Email.
        " read table it_mail ASSIGNING FIELD-SYMBOL(<ls_mail>) with KEY
        ls_final-pocreatormailid = VALUE #( it_mail[ purchaseorder = <ls_data>-purchasingdocument ]-defaultemailaddress OPTIONAL ).

        READ TABLE it_profitcenter INTO DATA(ls_profitcenter) WITH KEY profitcenter = <ls_data>-profitcenter.
        IF ls_profitcenter IS NOT INITIAL.
          ls_final-profitcenterdesc = ls_profitcenter-profitcenterlongname.
        ENDIF.

        ls_final-transdetermination = <ls_data>-transactiontypedetermination.
        " ls_final-percentage = '%'.
        APPEND ls_final TO it_final.
        CLEAR ls_final.
        "  CLEAR ls_taxnum1.
        CLEAR ls_suppliernumber.
        CLEAR ls_supplier.
        CLEAR ls_supply.
        CLEAR ls_taxnum.



      ENDIF.
      "      CLEAR ls_taxnum1.
      CLEAR ls_suppliernumber.
    ENDLOOP.


*    SELECT FROM @it_final AS i INNER JOIN i_journalentryitem AS ji
*    ON i~accountingdocument = ji~accountingdocument
*    INNER JOIN i_journalentry AS jh
*    ON ji~accountingdocument = jh~accountingdocument
*    FIELDS DISTINCT
*     ji~amountintransactioncurrency ,ji~accountingdocument, ji~accountingdocumentitem, ji~transactiontypedetermination, ji~TaxCode, jh~documentreferenceid
*   ORDER BY ji~accountingdocument
*    INTO TABLE @DATA(it_datafinal).


*    SELECT FROM @it_final AS i INNER JOIN i_journalentryitem AS ji
*    ON i~accountingdocument = ji~accountingdocument
*    INNER JOIN i_journalentry AS jh
*    ON ji~accountingdocument = jh~accountingdocument
*    INNER JOIN i_operationalacctgdocitem AS o
*    ON i~accountingdocument = o~accountingdocument
*    AND ltrim( ji~ledgergllineitem, '0' ) =  ltrim( o~accountingdocumentitem, '0' )
*    AND i~fiscalyear = o~fiscalyear
*    AND i~companycode = o~companycode
*    FIELDS DISTINCT
*     ji~amountintransactioncurrency ,ji~accountingdocument, ji~accountingdocumentitem, ji~transactiontypedetermination, ji~taxcode,
*      jh~documentreferenceid, o~taxbaseamountincocodecrcy
*   ORDER BY ji~accountingdocument
*    INTO TABLE @DATA(it_datafinal).





    SELECT FROM @it_final AS i INNER JOIN i_journalentryitem AS ji
    ON i~accountingdocument = ji~accountingdocument
    AND  ji~Ledger EQ '0L' and i~fiscalyear = ji~FiscalYear
*   AND   i~accountingdocumentitem = ji~AccountingDocumentItem
    INNER JOIN i_journalentry AS jh
    ON ji~accountingdocument = jh~accountingdocument
    INNER JOIN i_operationalacctgdocitem AS o
    ON i~accountingdocument = o~accountingdocument
*     ON ji~accountingdocument = o~accountingdocument
    AND ltrim( ji~ledgergllineitem, '0' ) =  ltrim( o~accountingdocumentitem, '0' )
*    and i~TaxCode = o~TaxCode
*    and ji~TransactionTypeDetermination = o~TransactionTypeDetermination
    And i~taxablevalue = o~TaxBaseAmountInCoCodeCrcy
*    AND i~fiscalyear = o~fiscalyear
    AND ji~fiscalyear = o~fiscalyear


    AND i~companycode = o~companycode
    FIELDS DISTINCT
     o~amountintransactioncurrency ,ji~accountingdocument, o~accountingdocumentitem, o~transactiontypedetermination, o~taxcode,
    jh~documentreferenceid,  o~taxbaseamountincocodecrcy, i~taxablevalue
   ORDER BY ji~accountingdocument
    INTO TABLE @DATA(it_datafinal).
*    SORT it_datafinal BY accountingdocumentitem ASCENDING.
*    DELETE ADJACENT DUPLICATES FROM  it_datafinal COMPARING accountingdocumentitem.





    DATA: it_final1 TYPE TABLE OF zi_fico_purreg,
          ls_final1 TYPE zi_fico_purreg.
    DATA : flag TYPE c LENGTH 1 VALUE '0'.
    DATA : flag1 TYPE c LENGTH 1 VALUE '0'.


    LOOP AT it_final ASSIGNING FIELD-SYMBOL(<ls_final>).
      ls_final1 = CORRESPONDING #( <ls_final> ).

      flag = REDUCE #( INIT rcm TYPE c
                       FOR ls_processdata IN it_processdata WHERE ( accountingdocument = <ls_final>-accountingdocument  AND  ( transactiontypedetermination = 'JRC' OR transactiontypedetermination = 'JRS' OR
                                                                   transactiontypedetermination = 'JRI' OR transactiontypedetermination = 'JRU'  ) )
                       NEXT rcm = '1'  ).
      CASE flag.
        WHEN '1'.
          ls_final1-documentreferenceidrcm = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = '' ]-documentreferenceid optional ).
          ls_final1-documentreferid = ''.
          ls_final1-raterevision = <ls_final>-rate  .
          ls_final1-rate = ''.
        WHEN OTHERS.
          ls_final1-documentreferenceidrcm = ''.
      ENDCASE.
      CLEAR flag.


*      READ TABLE it_datafinal ASSIGNING FIELD-SYMBOL(<ls_gst>) WITH KEY accountingdocument = <ls_final>-accountingdocument  transactiontypedetermination = 'JIC'.
*      IF <ls_gst> IS ASSIGNED.
*        ls_final1-centraltaxamt = <ls_gst>-amountintransactioncurrency.
*        ls_final1-centralitcamt = <ls_gst>-amountintransactioncurrency.
*        CLEAR <ls_gst>.
*
*      ENDIF.

*****      temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem ]-amountintransactioncurrency OPTIONAL ).
*****      IF temp IS NOT INITIAL.
*****        lv_taxcode = <ls_final>-taxcode.
*****
*****        ls_final1-centraltaxamt = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JIC'
*****                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-amountintransactioncurrency OPTIONAL ).
*****
*****        ls_final1-centralitcamt = ls_final1-centraltaxamt.
*****        CLEAR temp.
*****        CLEAR lv_taxcode.
*****      ENDIF.

*temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem ]-amountintransactioncurrency OPTIONAL ).

    Read Table it_datafinal into data(wa_datafinal) with key accountingdocument = <ls_final>-accountingdocument
                                                               taxbaseamountincocodecrcy = <ls_final>-taxablevalue.

        temp = wa_datafinal-taxbaseamountincocodecrcy.


      IF temp IS NOT INITIAL.
        lv_taxcode = <ls_final>-taxcode.

        ls_final1-centraltaxamt = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JIC'
                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-amountintransactioncurrency OPTIONAL ).

        ls_final1-centralitcamt = ls_final1-centraltaxamt.
        CLEAR temp.
        CLEAR lv_taxcode.

      ENDIF.

*      READ TABLE it_datafinal ASSIGNING FIELD-SYMBOL(<ls_sgst>) WITH KEY accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JIS'.
*      IF <ls_sgst> IS ASSIGNED.
*        ls_final1-stateuttaxamt = <ls_sgst>-amountintransactioncurrency.
*        ls_final1-stateutitcamt = <ls_sgst>-amountintransactioncurrency.
*        CLEAR <ls_sgst>.
*
*      ENDIF.


*****      temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem ]-amountintransactioncurrency OPTIONAL ).
*****
*****      IF temp IS NOT INITIAL.
*****        lv_taxcode = <ls_final>-taxcode.
*****
*****        ls_final1-stateuttaxamt = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JIS'
*****                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-amountintransactioncurrency OPTIONAL ).
*****
*****        ls_final1-stateutitcamt = ls_final1-stateuttaxamt.
*****        CLEAR temp.
*****        CLEAR lv_taxcode.
*****      ENDIF.

*  temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem ]-amountintransactioncurrency OPTIONAL ).
       Read Table it_datafinal into wa_datafinal with key accountingdocument = <ls_final>-accountingdocument
                                                               taxbaseamountincocodecrcy = <ls_final>-taxablevalue.

        temp = wa_datafinal-taxbaseamountincocodecrcy.
      IF temp IS NOT INITIAL.
        lv_taxcode = <ls_final>-taxcode.

        ls_final1-stateuttaxamt = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JIS'
                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-amountintransactioncurrency OPTIONAL ).

        ls_final1-stateutitcamt = ls_final1-stateuttaxamt.
        CLEAR temp.
        CLEAR lv_taxcode.
      ENDIF.


*
*      READ TABLE it_datafinal  ASSIGNING FIELD-SYMBOL(<ls_igst>) WITH KEY accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JII'.
*      IF <ls_igst> IS ASSIGNED.
*        ls_final1-inttaxamount = <ls_igst>-amountintransactioncurrency.
*        ls_final1-integrateditcamt = <ls_igst>-amountintransactioncurrency.
*        CLEAR <ls_igst>.
*      ENDIF.


*****      temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem  ]-amountintransactioncurrency OPTIONAL ).
*****      IF temp IS NOT INITIAL.
*****        lv_taxcode = <ls_final>-taxcode.
*****
*****        ls_final1-inttaxamount = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JII'
*****                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-amountintransactioncurrency OPTIONAL ).
*****
*****        ls_final1-integrateditcamt = ls_final1-inttaxamount.
*****        CLEAR temp.
*****        CLEAR lv_taxcode.
*****      ENDIF.



*    temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem  ]-amountintransactioncurrency OPTIONAL ).
      Read Table it_datafinal into wa_datafinal with key accountingdocument = <ls_final>-accountingdocument
                                                               taxbaseamountincocodecrcy = <ls_final>-taxablevalue.
            temp = wa_datafinal-taxbaseamountincocodecrcy.

      IF temp IS NOT INITIAL.
        lv_taxcode = <ls_final>-taxcode.

        ls_final1-inttaxamount = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JII'
                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-amountintransactioncurrency OPTIONAL ).

        ls_final1-integrateditcamt = ls_final1-inttaxamount.
        CLEAR temp.
        CLEAR lv_taxcode.
      ENDIF.




      flag = REDUCE #( INIT rcm TYPE c
                FOR ls_processdata IN it_processdata WHERE ( accountingdocument = <ls_final>-accountingdocument  AND  ( transactiontypedetermination = 'JRC' OR transactiontypedetermination = 'JRS' OR
                                                            transactiontypedetermination = 'JRI' OR transactiontypedetermination = 'JRU'  ) )
                NEXT rcm = '1'  ).
      CASE flag.
        WHEN '1'.
          ls_final1-reversecgeindicator = 'Y'.
        WHEN OTHERS.
          ls_final1-reversecgeindicator = 'N'.
      ENDCASE.
      CLEAR flag.

*          case it_datafinal[ AccountingDocument = <ls_final>-accountingdocument ]-TransactionTypeDetermination .
*          WHEN 'JRC' OR 'JRS' OR 'JRI' OR 'JRU'.
*            temp = REDUCE #( INIT total = 0
*                              FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
*                              NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*            temp1 = REDUCE #( INIT total = 0
*                            FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
*                            ( transactiontypedetermination <> 'JRC' OR transactiontypedetermination <> 'JRS' OR
*                            transactiontypedetermination <> 'JRI' OR transactiontypedetermination <> 'JRU' OR  transactiontypedetermination <> '' ) )
*                            NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*            IF temp <> 0 AND temp1 <> 0.
*              ls_final1-raterevision = (  temp1 / temp ) * 100.
*            ENDIF.
*            CLEAR temp.
*            CLEAR temp1.
*            endcase.

******SOC added by sanjay func-Nikhil 23.05.2025
ls_final1-amountintrnscur = ls_final1-taxablevalue + ls_final1-inttaxamount + ls_final1-centraltaxamt + ls_final1-stateUtITCamt.
******EOC added by sanjay func-Nikhil 23.05.2025
      APPEND ls_final1 TO it_final1.
      CLEAR ls_final1.
      " CLEAR <ls_gst>.
      "  UNASSIGN <ls_gst>.
      " CLEAR <ls_sgst>.
      " UNASSIGN <ls_sgst>.
    ENDLOOP.

  data : lv_rate type string.

 LOOP AT it_final1 ASSIGNING FIELD-SYMBOL(<fs_final1>).
  <fs_final1>-accountingdocumentitem = <fs_final1>-ledgerglitem.
  lv_rate = (  <fs_final1>-inttaxamount + <fs_final1>-centraltaxamt + <fs_final1>-stateuttaxamt ) /  <fs_final1>-taxablevalue.
  <fs_final1>-rate = lv_rate * 100.
  clear : lv_rate.
ENDLOOP.

    it_final = CORRESPONDING #( it_final1 ).











    IF lv_accountdocumentitem IS INITIAL.

      SELECT DISTINCT * FROM @it_final AS it_final      "#EC CI_NOWHERE
where postingdate in @lv_postingdate
               ORDER BY accountingdocument

               INTO TABLE @DATA(it_output)
               OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

      SELECT COUNT( * )
          FROM @it_final AS it_final                    "#EC CI_NOWHERE
          INTO @DATA(lv_totcount).

      io_response->set_total_number_of_records( lv_totcount ).
      io_response->set_data( it_output ).

    ELSE.
      SELECT DISTINCT * FROM @it_final AS it_final      "#EC CI_NOWHERE
   WHERE accountingdocumentitem IN @lv_accountdocumentitem
*        and postingdate in @lv_postingdate
              ORDER BY accountingdocument

              INTO TABLE @DATA(it_output1)
              OFFSET @lv_skip UP TO  @lv_max_rows ROWS.

      SELECT COUNT( * )
          FROM @it_output1 AS it_final                  "#EC CI_NOWHERE
          INTO @DATA(lv_totcount1).

      io_response->set_total_number_of_records( lv_totcount1 ).
      io_response->set_data( it_output1 ).

    ENDIF.

*      SELECT COUNT( * )
*          FROM @it_fin AS it_fin                    "#EC CI_NOWHERE
*          INTO @DATA(lv_totcount).

    "  IF io_request->is_total_numb_of_rec_requested(  ).
*    io_response->set_total_number_of_records( lv_totcount ).
*    io_response->set_data( it_output ).
    " ENDIF.




  ENDMETHOD.
ENDCLASS.

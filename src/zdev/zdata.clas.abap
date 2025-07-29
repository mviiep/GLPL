CLASS zdata DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZDATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    DATA: it_final TYPE TABLE OF zi_fico_purreg,
*          ls_final TYPE  zi_fico_purreg.
*
*    SELECT FROM i_journalentryitem AS ji INNER JOIN i_journalentry AS jh
*     ON ji~accountingdocument = jh~accountingdocument
*     AND ji~fiscalyear = jh~fiscalyear
*     AND ji~companycode = jh~companycode
*     AND ji~accountingdocumenttype = jh~accountingdocumenttype
*     FIELDS  ji~supplier, ji~accountingdocument, ji~amountintransactioncurrency,ji~financialaccounttype, ji~transactiontypedetermination, ji~ledgergllineitem, ji~profitcenter,
*     ji~originctrlgdebitcreditcode, ji~glaccount, ji~costcenter, ji~purchasingdocument, ji~fixedasset,ji~taxcode,
*     jh~branch, jh~documentreferenceid, jh~documentdate, jh~postingdate, jh~companycode, jh~accountingdocumenttype,jh~fiscalyear,jh~reversedocument,
*     jh~reversedocumentfiscalyear, jh~accountingdoccreatedbyuser,jh~accountingdocumentcreationdate
*
*
*    WHERE ji~accountingdocument = '1900000005'
*    AND jh~accountingdocumenttype IN ( 'KG', 'KR', 'RE', 'RK', 'RN' )
*     AND ji~ledger ='0L'
**      and jh~Ledger = '0L'
*     INTO TABLE @DATA(it_data).
*
*
**  select from  I_Businesspartnertaxnumber as b
** inner join  @it_data as i
** on b~BusinessPartner = i~Supplier
** and b~BPTaxType = 'IN3'
** FIELDS b~BPTaxNumber
** INTO TABLE @data(taxnum).
*
*   SELECT DISTINCT b~bptaxnumber, i~supplier FROM  i_businesspartnertaxnumber AS b
*   INNER JOIN  @it_data AS i
*   ON b~businesspartner = i~supplier
*   AND b~bptaxtype = 'IN3'
*   INTO TABLE @DATA(it_taxnum).
*
*
*
*    SELECT DISTINCT s~suppliername FROM  i_supplier AS s
*    INNER JOIN  @it_data AS i
*    ON s~supplier = i~supplier
*    INTO TABLE @DATA(it_supplier).
*
*    SELECT DISTINCT in_gstplaceofsupply FROM i_operationalacctgdocitem
*    INTO TABLE @DATA(it_supply).
*
*
*    SELECT DISTINCT glaccountlongname FROM i_glaccounttextincompanycode AS g
*    INNER JOIN @it_data AS i
*    ON g~companycode = i~companycode
*    AND g~glaccount = i~glaccount
*    INTO TABLE @DATA(it_glaccount).
*
*
*    "Remain mail id
*    SELECT DISTINCT p~purchasinggroup, p~createdbyuser FROM i_purchaseorderapi01 AS p
*    INNER JOIN @it_data AS i
*    ON p~purchaseorder = i~purchasingdocument
*    INTO TABLE @DATA(it_purchaseheader).
*
*
*    SELECT DISTINCT pi~orderquantity, pi~baseunit FROM i_purchaseorderitemapi01 AS pi
*   INNER JOIN @it_data AS ph
*   ON pi~purchaseorder = ph~purchasingdocument
*   INTO TABLE @DATA(it_purchaseitem).
*
*
*    SELECT DISTINCT profitcenterlongname FROM i_profitcentertext AS p
*   INNER JOIN @it_data AS i
*   ON p~profitcenter = i~profitcenter
*   INTO TABLE @DATA(it_profitcenter).
*
*
*    SELECT FROM @it_data AS itdata1 FIELDS accountingdocument, amountintransactioncurrency, financialaccounttype, transactiontypedetermination
*    WHERE accountingdocument  = '1900000005'
*    INTO TABLE @DATA(it_processdata).
*
*
*    SELECT * FROM @it_data AS itdata2
*    WHERE accountingdocument = '1900000005'
*    AND transactiontypedetermination = ''
*    INTO TABLE @DATA(it_finaldata).
*
*
*
*    DATA: temp  TYPE zi_fico_purreg-amountintrnscur,
*          temp1 TYPE zi_fico_purreg-amountintrnscur.
*
*    LOOP AT it_finaldata ASSIGNING FIELD-SYMBOL(<ls_data>).
*
*      "Journal entry item fields
*      ls_final-accountingdocument = <ls_data>-accountingdocument.
*      ls_final-postingdate = <ls_data>-postingdate.
*      ls_final-branch = <ls_data>-branch.
*      ls_final-supplier = <ls_data>-supplier.
*
*
*      CASE <ls_data>-financialaccounttype.
*        WHEN 'S'.
*
*
*          ls_final-amountintrnscur = REDUCE #( INIT total = 0
*                                               FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S' )
*                                               NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*      ENDCASE.
*
*      IF <ls_data>-transactiontypedetermination <> 'JRC' AND <ls_data>-transactiontypedetermination <> 'JRS' AND
*     <ls_data>-transactiontypedetermination <> 'JRI' AND <ls_data>-transactiontypedetermination <> 'JRU'  .
*
*        temp = REDUCE #( INIT total = 0
*                         FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
*                         NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*        temp1 = REDUCE #( INIT total = 0
*                        FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
*                        transactiontypedetermination <> 'JRC' AND transactiontypedetermination <> 'JRS' AND
*                        transactiontypedetermination <> 'JRI' AND transactiontypedetermination <> 'JRU' AND  transactiontypedetermination <> '' )
*                        NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*        ls_final-rate = (  temp1 / temp ) * 100.
*        CLEAR temp.
*        CLEAR temp1.
*
*
*      ENDIF.
*
*
*
*      CASE <ls_data>-transactiontypedetermination.
*        WHEN 'JRC' OR 'JRS' OR 'JRI' OR 'JRU'.
*          temp = REDUCE #( INIT total = 0
*                            FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
*                            NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          temp1 = REDUCE #( INIT total = 0
*                          FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
*                          ( transactiontypedetermination <> 'JRC' OR transactiontypedetermination <> 'JRS' OR
*                          transactiontypedetermination <> 'JRI' OR transactiontypedetermination <> 'JRU' OR  transactiontypedetermination <> '' ) )
*                          NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          ls_final-raterevision = (  temp1 / temp ) * 100.
*          CLEAR temp.
*          CLEAR temp1.
*
*        WHEN ''.
*
*          ls_final-taxablevalue =  REDUCE #( INIT total = 0
*                           FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
*                           NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*        WHEN 'JII'.
*
*          " ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
*          ls_final-inttaxamount = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIC'.
*          ls_final-centraltaxamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIS'.
*
*          ls_final-stateuttaxamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JII'.
*          ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIC'.
*          ls_final-centralitcamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIS'.
*          ls_final-stateutitcamt = <ls_data>-amountintransactioncurrency.
*
*      ENDCASE.
*
*
*
**      IF <ls_data>-transactiontypedetermination = 'JII'.
**        ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
**      ENDIF.
*
**      IF <ls_data>-transactiontypedetermination = 'JIC'.
**        ls_final-centraltaxamt = <ls_data>-amountintransactioncurrency.
**      ENDIF.
*
**      IF <ls_data>-transactiontypedetermination = 'JIS'.
**        ls_final-stateuttaxamt = <ls_data>-amountintransactioncurrency.
**      ENDIF.
*
*      IF <ls_data>-transactiontypedetermination = 'JRC' OR <ls_data>-transactiontypedetermination = 'JRS' OR
* <ls_data>-transactiontypedetermination = 'JRI' OR <ls_data>-transactiontypedetermination = 'JRU' .
*        ls_final-reversecgeindicator = 'Y'.
*      ELSEIF <ls_data>-transactiontypedetermination <> 'JRC' OR <ls_data>-transactiontypedetermination <> 'JRS' OR
* <ls_data>-transactiontypedetermination <> 'JRI' OR <ls_data>-transactiontypedetermination <> 'JRU' .
*        ls_final-reversecgeindicator = 'N'.
*      ENDIF.
*
*
*      "ls_final-ledgerglitem = <ls_data>-LedgerGLLineItem.
*      ls_final-taxcode = <ls_data>-taxcode.
*      ls_final-profitcenter = <ls_data>-profitcenter.
*      ls_final-debitcreditcode = <ls_data>-originctrlgdebitcreditcode.
*
*      IF <ls_data>-transactiontypedetermination = ''.
*        ls_final-glaccount = <ls_data>-glaccount.
*
*      ENDIF.
*
*      ls_final-costcenter = <ls_data>-costcenter.
*      ls_final-purchasingdocument = <ls_data>-purchasingdocument.
*
*
*      "Journal entry fields
*
*      ls_final-branch = <ls_data>-branch.
*
*      IF <ls_data>-transactiontypedetermination <> 'JRC' and <ls_data>-transactiontypedetermination <> 'JRS' and
*  <ls_data>-transactiontypedetermination <> 'JRI' and <ls_data>-transactiontypedetermination <> 'JRU'  .
*        ls_final-documentreferid = <ls_data>-documentreferenceid.
*      ENDIF.
*
*      IF <ls_data>-transactiontypedetermination = 'JRC' OR <ls_data>-transactiontypedetermination = 'JRS' OR
*   <ls_data>-transactiontypedetermination = 'JRI' OR <ls_data>-transactiontypedetermination = 'JRU'  .
*        ls_final-documentreferenceidrcm = <ls_data>-amountintransactioncurrency.
*      ENDIF.
*
*
*      "
*      ls_final-documentdate = <ls_data>-documentdate.
*      ls_final-postingdate = <ls_data>-postingdate.
*      ls_final-companycode = <ls_data>-companycode.
*      ls_final-fiscalyear = <ls_data>-fiscalyear.
*      ls_final-documenttype = <ls_data>-accountingdocumenttype.
*      ls_final-reversedocument = <ls_data>-ReverseDocument.
*      ls_final-reversedocumentyear = <ls_data>-reversedocumentfiscalyear.
*      ls_final-accountingdocreatedby = <ls_data>-accountingdoccreatedbyuser.
*      ls_final-fixedasset = <ls_data>-fixedasset.
*      ls_final-entrydate = <ls_data>-accountingdocumentcreationdate.
*
*
*      "Business partnr tax number
*
*      READ TABLE it_taxnum INTO DATA(ls_taxnum) WITH KEY Supplier = <ls_data>-Supplier.
*
*      IF ls_taxnum IS NOT INITIAL.
*
*        ls_final-bptaxnumber = ls_taxnum-bptaxnumber.
*
*      ENDIF.
*
*      " Supplier fields
*
*      READ TABLE it_supplier INTO DATA(ls_supplier) INDEX 1.
*
*      IF ls_supplier IS NOT INITIAL.
*
*        ls_final-suppliername = ls_supplier-suppliername.
*
*      ENDIF.
*
*
*      "GST Place of supply
*      "   ls_final-gstplaceoofsupply = <ls_data>-.
*
*
*      "GST vendor registeration
*
*      "ls_final-vendorregis = <ls_data>-AccountingDocument.
*
*
*      "GLA Account long name
*
*      READ TABLE it_glaccount INTO DATA(ls_glaccount) INDEX 1.
*
*      IF ls_glaccount IS NOT INITIAL.
*
*        ls_final-glaccountlongname = ls_glaccount-glaccountlongname.
*
*      ENDIF.
*
*
*      "Purchase header fields
*
*      READ TABLE it_purchaseheader INTO DATA(ls_purchaseheader) INDEX 1.
*      IF ls_purchaseheader IS NOT INITIAL.
*
*        ls_final-purchasegroup = ls_purchaseheader-purchasinggroup.
*        ls_final-pocreatedby = ls_purchaseheader-createdbyuser.
*
*      ENDIF.
*
*
*      "Purchase header item fields
*
*      READ TABLE it_purchaseitem INTO DATA(ls_purchaseitem) INDEX 1.
*      IF ls_purchaseitem IS NOT INITIAL.
*
*        ls_final-orderquantity = ls_purchaseitem-orderquantity.
*        ls_final-baseunit = ls_purchaseitem-baseunit.
*
*      ENDIF.
*
*      READ TABLE it_profitcenter INTO DATA(ls_profitcenter) INDEX 1.
*      IF ls_profitcenter IS NOT INITIAL.
*        ls_final-profitcenterdesc = ls_profitcenter-profitcenterlongname.
*      ENDIF.
*
*      APPEND ls_final TO it_final.
*      CLEAR ls_final.
*    ENDLOOP.
*
**      out->write( it_data ).
**      out->write( it_taxnum ).
**      out->write( it_supplier ).
**      out->write( it_supply ).
**      out->write( it_glaccount ).
**      out->write( it_purchaseheader ).
**      out->write( it_purchaseitem ).
**      out->write( it_profitcenter ).
*    out->write( it_final ).


*    DATA: it_final TYPE TABLE OF zi_fico_purreg,
*          ls_final TYPE  zi_fico_purreg.
*
*    SELECT FROM i_journalentryitem AS ji INNER JOIN i_journalentry AS jh
*     ON ji~accountingdocument = jh~accountingdocument
*     AND ji~fiscalyear = jh~fiscalyear
*     AND ji~companycode = jh~companycode
*     AND ji~accountingdocumenttype = jh~accountingdocumenttype
*     FIELDS distinct  ji~supplier, ji~accountingdocument, ji~accountingdocumentitem, ji~amountintransactioncurrency,ji~financialaccounttype, ji~transactiontypedetermination, ji~ledgergllineitem, ji~profitcenter,
*     ji~originctrlgdebitcreditcode, ji~glaccount, ji~costcenter, ji~purchasingdocument, ji~fixedasset,ji~taxcode,ji~companycodecurrency,
*     jh~branch, jh~documentreferenceid, jh~documentdate, jh~postingdate, jh~companycode, jh~accountingdocumenttype,jh~fiscalyear,jh~reversedocument,
*     jh~reversedocumentfiscalyear, jh~accountingdoccreatedbyuser,jh~accountingdocumentcreationdate
*
*
*    WHERE ji~accountingdocument = '1900000004' or  ji~accountingdocument = '1900000005'
*    AND jh~accountingdocumenttype IN ( 'KG', 'KR', 'RE', 'RK', 'RN' )
*     AND ji~ledger ='0L'
**      and jh~Ledger = '0L'
*     INTO TABLE @DATA(it_data).
*
*     select * from @it_data as it_data
*     WHERE FinancialAccountType <> 'K'
*     ORDER BY AccountingDocument
*     into table @data(it_dataprocess).
*
*
*    SELECT FROM @it_data AS supplierno
*    FIELDS distinct
*    supplier, FinancialAccountType, AccountingDocumentType, AccountingDocument
*    WHERE FinancialAccountType = 'K'
*    ORDER BY FinancialAccountType
*    INTO table @data(it_suppliernumber).
*
*
*
*   SELECT DISTINCT b~bptaxnumber, i~supplier, i~financialaccounttype FROM  i_businesspartnertaxnumber AS b
*   INNER JOIN  @it_data AS i
*   ON b~businesspartner = i~supplier
*   AND b~bptaxtype = 'IN3'
*   INTO TABLE @DATA(it_taxnum).
*
*
*
*    SELECT DISTINCT  i~supplier, s~suppliername FROM  i_supplier AS s
*    INNER JOIN  @it_data AS i
*    ON s~supplier = i~supplier
*    INTO TABLE @DATA(it_supplier).
*
*    SELECT DISTINCT i~accountingdocument, o~in_gstplaceofsupply, o~in_hsnorsaccode FROM i_operationalacctgdocitem AS o
*    INNER JOIN @it_data AS i
*    ON o~accountingdocument = i~accountingdocument
*AND o~companycode = i~companycode
*AND o~fiscalyear = i~fiscalyear
*AND o~accountingdocumentitem = i~accountingdocumentitem
*
*    INTO TABLE @DATA(it_supply).
*
*
*    SELECT DISTINCT  i~accountingdocument , g~companycode ,g~glaccount,   glaccountlongname FROM i_glaccounttextincompanycode AS g
*    INNER JOIN @it_data AS i
*    ON g~companycode = i~companycode
*    AND g~glaccount = i~glaccount
*    INTO TABLE @DATA(it_glaccount).
*
*
*    "Remain mail id
*    SELECT DISTINCT p~purchasinggroup, p~createdbyuser FROM i_purchaseorderapi01 AS p
*    INNER JOIN @it_data AS i
*    ON p~purchaseorder = i~purchasingdocument
*    INTO TABLE @DATA(it_purchaseheader).
*
*
*    SELECT DISTINCT pi~orderquantity, pi~baseunit FROM i_purchaseorderitemapi01 AS pi
*   INNER JOIN @it_data AS ph
*   ON pi~purchaseorder = ph~purchasingdocument
*   INTO TABLE @DATA(it_purchaseitem).
*
*
*    SELECT DISTINCT p~profitcenter,  p~profitcenterlongname FROM i_profitcentertext AS p
*   INNER JOIN @it_data AS i
*   ON p~profitcenter = i~profitcenter
*   INTO TABLE @DATA(it_profitcenter).
*
*
*    SELECT FROM @it_data AS itdata1 FIELDS accountingdocument, amountintransactioncurrency, financialaccounttype, transactiontypedetermination
*    WHERE accountingdocument = '1900000004' OR accountingdocument = '1900000005'
*    INTO TABLE @DATA(it_processdata).
*
*
*    SELECT * FROM @it_data AS itdata2
*    WHERE accountingdocument = '1900000004'  OR accountingdocument = '1900000005'
*    AND transactiontypedetermination = ''
*    INTO TABLE @DATA(it_finaldata).
*
*    SELECT accountingdocument, supplier FROM @it_data AS itdata2
*    WHERE accountingdocument = '1900000004'  OR accountingdocument = '1900000005'
*    AND accountingdocumenttype = 'K'
*    INTO TABLE @DATA(it_supplierdetails).
*
*
*    DATA: temp  TYPE zi_fico_purreg-amountintrnscur,
*          temp1 TYPE zi_fico_purreg-amountintrnscur.
*
*    DATA lv_supplier TYPE i_journalentryitem-supplier.
*    " LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>).
*
*
*
*   " LOOP AT it_data ASSIGNING FIELD-SYMBOL(<ls_data>).
*    LOOP AT it_dataprocess ASSIGNING FIELD-SYMBOL(<ls_data>).
*
*    read table it_suppliernumber into data(ls_suppliernumber) WITH KEY FinancialAccountType = 'K' AccountingDocument = <ls_data>-AccountingDocument.
*    if ls_suppliernumber is not INITIAL.
*        lv_supplier = ls_suppliernumber-Supplier.
*    endif.
*
*      IF  <ls_data>-transactiontypedetermination = ''.
*
*
*        "Journal entry item fields
*        ls_final-accountingdocument = <ls_data>-accountingdocument.
*        ls_final-postingdate = <ls_data>-postingdate.
*        ls_final-branch = <ls_data>-branch.
*        ls_final-supplier = <ls_data>-supplier.
*
*
*        CASE <ls_data>-financialaccounttype.
*          WHEN 'S'.
*
*
*            ls_final-amountintrnscur = REDUCE #( INIT total = 0
*                                                 FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S' AND accountingdocument = <ls_data>-accountingdocument )
*                                                 NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*        ENDCASE.
*
*        IF <ls_data>-transactiontypedetermination <> 'JRC' AND <ls_data>-transactiontypedetermination <> 'JRS' AND
*       <ls_data>-transactiontypedetermination <> 'JRI' AND <ls_data>-transactiontypedetermination <> 'JRU' ."and <ls_data>-FinancialAccountType <> 'S' .
*
*          temp = REDUCE #( INIT total = 0
*                           FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = ''  AND accountingdocument = <ls_data>-accountingdocument )
*                           NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          temp1 = REDUCE #( INIT total = 0
*                          FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
*                          transactiontypedetermination <> 'JRC' AND transactiontypedetermination <> 'JRS' AND
*                          transactiontypedetermination <> 'JRI' AND transactiontypedetermination <> 'JRU' AND  transactiontypedetermination <> '' AND accountingdocument = <ls_data>-accountingdocument )
*                          NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          ls_final-rate = (  temp1 / temp ) * 100.
*          CLEAR temp.
*          CLEAR temp1.
*
*
*        ENDIF.
*
*
*           CASE <ls_data>-transactiontypedetermination.
*        WHEN 'JRC' OR 'JRS' OR 'JRI' OR 'JRU'.
*          temp = REDUCE #( INIT total = 0
*                            FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
*                            NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          temp1 = REDUCE #( INIT total = 0
*                          FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND
*                          ( transactiontypedetermination <> 'JRC' OR transactiontypedetermination <> 'JRS' OR
*                          transactiontypedetermination <> 'JRI' OR transactiontypedetermination <> 'JRU' OR  transactiontypedetermination <> '' ) )
*                          NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*          ls_final-raterevision = (  temp1 / temp ) * 100.
*          CLEAR temp.
*          CLEAR temp1.
*
*        WHEN ''.
*
*          ls_final-taxablevalue =  REDUCE #( INIT total = 0
*                           FOR ls_processdata IN it_processdata WHERE ( financialaccounttype = 'S'  AND  transactiontypedetermination = '' )
*                           NEXT total = total +  ls_processdata-amountintransactioncurrency   ).
*
*        WHEN 'JII'.
*
*          " ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
*          ls_final-inttaxamount = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIC'.
*          ls_final-centraltaxamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIS'.
*
*          ls_final-stateuttaxamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JII'.
*          ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIC'.
*          ls_final-centralitcamt = <ls_data>-amountintransactioncurrency.
*
*        WHEN 'JIS'.
*          ls_final-stateutitcamt = <ls_data>-amountintransactioncurrency.
*
*      ENDCASE.
*
*
*
**      IF <ls_data>-transactiontypedetermination = 'JII'.
**        ls_final-integrateditcamt = <ls_data>-amountintransactioncurrency.
**      ENDIF.
*
**      IF <ls_data>-transactiontypedetermination = 'JIC'.
**        ls_final-centraltaxamt = <ls_data>-amountintransactioncurrency.
**      ENDIF.
*
**      IF <ls_data>-transactiontypedetermination = 'JIS'.
**        ls_final-stateuttaxamt = <ls_data>-amountintransactioncurrency.
**      ENDIF.
*
*      IF <ls_data>-transactiontypedetermination = 'JRC' OR <ls_data>-transactiontypedetermination = 'JRS' OR
* <ls_data>-transactiontypedetermination = 'JRI' OR <ls_data>-transactiontypedetermination = 'JRU' .
*        ls_final-reversecgeindicator = 'Y'.
*      ELSEIF <ls_data>-transactiontypedetermination <> 'JRC' OR <ls_data>-transactiontypedetermination <> 'JRS' OR
* <ls_data>-transactiontypedetermination <> 'JRI' OR <ls_data>-transactiontypedetermination <> 'JRU' .
*        ls_final-reversecgeindicator = 'N'.
*      ENDIF.
*
*
*      "ls_final-ledgerglitem = <ls_data>-LedgerGLLineItem.
*      ls_final-taxcode = <ls_data>-taxcode.
*      ls_final-profitcenter = <ls_data>-profitcenter.
*      ls_final-debitcreditcode = <ls_data>-originctrlgdebitcreditcode.
*
*      IF <ls_data>-transactiontypedetermination = ''.
*        ls_final-glaccount = <ls_data>-glaccount.
*
*      ENDIF.
*
*      ls_final-costcenter = <ls_data>-costcenter.
*      ls_final-purchasingdocument = <ls_data>-purchasingdocument.
*
*
*      "Journal entry fields
*
*      ls_final-branch = <ls_data>-branch.
*
*      IF <ls_data>-transactiontypedetermination <> 'JRC' AND <ls_data>-transactiontypedetermination <> 'JRS' AND
*  <ls_data>-transactiontypedetermination <> 'JRI' AND <ls_data>-transactiontypedetermination <> 'JRU'  .
*        ls_final-documentreferid = <ls_data>-documentreferenceid.
*      ENDIF.
*
*      IF <ls_data>-transactiontypedetermination = 'JRC' OR <ls_data>-transactiontypedetermination = 'JRS' OR
*   <ls_data>-transactiontypedetermination = 'JRI' OR <ls_data>-transactiontypedetermination = 'JRU'  .
*        ls_final-documentreferenceidrcm = <ls_data>-amountintransactioncurrency.
*      ENDIF.
*
*
*      "
*      ls_final-documentdate = <ls_data>-documentdate.
*      ls_final-postingdate = <ls_data>-postingdate.
*      ls_final-companycode = <ls_data>-companycode.
*      ls_final-fiscalyear = <ls_data>-fiscalyear.
*      ls_final-documenttype = <ls_data>-accountingdocumenttype.
*      ls_final-reversedocument = <ls_data>-reversedocument.
*      ls_final-reversedocumentyear = <ls_data>-reversedocumentfiscalyear.
*      ls_final-accountingdocreatedby = <ls_data>-accountingdoccreatedbyuser.
*      ls_final-fixedasset = <ls_data>-fixedasset.
*      ls_final-entrydate = <ls_data>-accountingdocumentcreationdate.
*      ls_final-companycodecurrency = <ls_data>-companycodecurrency.
*      ls_final-ledgerglitem = <ls_data>-LedgerGLLineItem.
*
*
*
*        " READ TABLE it_taxnum INTO DATA(ls_taxnum) INDEX 1.
*        READ TABLE it_taxnum INTO DATA(ls_taxnum) WITH KEY supplier = lv_supplier .
*
*        IF ls_taxnum IS NOT INITIAL.
*
*          ls_final-bptaxnumber = ls_taxnum-bptaxnumber.
*          ls_final-originaltaxnumber = ls_taxnum-bptaxnumber.
*
*          "GST vendor registeration
*          CASE ls_taxnum-bptaxnumber.
*            WHEN ''.
*              ls_final-vendorregis = 'Not Registered'.
*            WHEN OTHERS.
*              ls_final-vendorregis = 'Registered'.
*          ENDCASE.
*
*
*        ENDIF.
*
**      "Business partnr tax number
**
**        " READ TABLE it_taxnum INTO DATA(ls_taxnum) INDEX 1.
***     READ TABLE it_taxnum INTO DATA(ls_taxnum) WITH KEY Supplier = lv_supplier .
***
***      IF ls_taxnum IS NOT INITIAL.
***
***        ls_final-bptaxnumber = ls_taxnum-bptaxnumber.
***        ls_final-originaltaxnumber = ls_taxnum-bptaxnumber.
***
***        "GST vendor registeration
***        CASE ls_taxnum-bptaxnumber.
***          WHEN ''.
***            ls_final-vendorregis = 'Not Registered'.
***          WHEN OTHERS.
***            ls_final-vendorregis = 'Registered'.
***        ENDCASE.
***
***
***      ENDIF.
**
*        " Supplier fields
**
*      READ TABLE it_supplier INTO DATA(ls_supplier)  WITH KEY supplier = lv_supplier.
*
*      IF ls_supplier IS NOT INITIAL.
*
*        ls_final-supplier = ls_supplier-supplier.
*        ls_final-suppliername = ls_supplier-suppliername.
*
*      ENDIF.
**
**
*      "GST Place of supply
*      read table it_supply into data(ls_supply)  WITH KEY AccountingDocument = <ls_data>-AccountingDocument .
*      if ls_supply is NOT INITIAL.
*      ls_final-gstplaceoofsupply = ls_supply-IN_GSTPlaceOfSupply.
*      ls_final-hsncode = ls_supply-IN_HSNOrSACCode.
*       endif.
**
**
**
**
**
**      "GLA Account long name
**
*      READ TABLE it_glaccount INTO DATA(ls_glaccount) WITH KEY AccountingDocument = <ls_data>-AccountingDocument CompanyCode = <ls_data>-CompanyCode GLAccount = <ls_data>-GLAccount.
*
*      IF ls_glaccount IS NOT INITIAL.
*
*        ls_final-glaccountlongname = ls_glaccount-glaccountlongname.
*
*      ENDIF.
**
**
**      "Purchase header fields
**
**      READ TABLE it_purchaseheader INTO DATA(ls_purchaseheader) INDEX 1.
**      IF ls_purchaseheader IS NOT INITIAL.
**
**        ls_final-purchasegroup = ls_purchaseheader-purchasinggroup.
**        ls_final-pocreatedby = ls_purchaseheader-createdbyuser.
**
**      ENDIF.
**
**
**      "Purchase header item fields
**
**      READ TABLE it_purchaseitem INTO DATA(ls_purchaseitem) INDEX 1.
**      IF ls_purchaseitem IS NOT INITIAL.
**
**        ls_final-orderquantity = ls_purchaseitem-orderquantity.
**        ls_final-baseunit = ls_purchaseitem-baseunit.
**
**      ENDIF.
**
*      READ TABLE it_profitcenter INTO DATA(ls_profitcenter) WITH KEY ProfitCenter = <ls_data>-ProfitCenter.
*      IF ls_profitcenter IS NOT INITIAL.
*        ls_final-profitcenterdesc = ls_profitcenter-profitcenterlongname.
*      ENDIF.
*
*  ls_final-transdetermination = <ls_data>-transactiontypedetermination.
*        APPEND ls_final TO it_final.
*        CLEAR ls_final.
*      "  CLEAR ls_taxnum1.
*        CLEAR ls_suppliernumber.
*        clear ls_supplier.
*        clear ls_supply.
*
*
*      ENDIF.
*"      CLEAR ls_taxnum1.
*      CLEAR ls_suppliernumber.
*    ENDLOOP.
*
*
*
*    SELECT  * FROM @it_final  AS final
*    WHERE transdetermination = ''
*    AND accountingdocument = '1900000005' OR accountingdocument = '1900000004'
*    ORDER BY accountingdocument
*    INTO TABLE @DATA(it_table).
*
*
*    out->write( it_table ).


    DATA: lo_http_client TYPE REF TO if_web_http_client.
    DATA: lv_url      TYPE string VALUE 'https://catfact.ninja/fact',
          lo_request  TYPE REF TO if_web_http_request,
          lo_response TYPE REF TO if_web_http_response,
          lv_joke     TYPE string.


    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
         i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
          ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(a) = '122'.

    lo_request = lo_http_client->get_http_request( ).

    lo_request = lo_http_client->get_http_request( ).
    lo_request->set_header_fields( VALUE #( ( name = 'Accept' value = 'application/json' ) ) ).

    TRY.
        lo_response = lo_http_client->execute( i_method = if_web_http_client=>get ).
      CATCH cx_web_http_client_error INTO DATA(lx_error).
        "   WRITE: / 'Error executing HTTP request:', lx_error->get_text( ).
        RETURN.
    ENDTRY.

    DATA(lv_json_response) = lo_response->get_text( ).
    FIELD-SYMBOLS: <json_data> TYPE any.
    TRY.
        DATA(lr_data) = /ui2/cl_json=>generate( json = lv_json_response ).
        ASSIGN lr_data->* TO <json_data>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT 'joke' OF STRUCTURE <json_data> TO FIELD-SYMBOL(<joke_field>).
          IF sy-subrc = 0.
            ASSIGN <joke_field>->* TO FIELD-SYMBOL(<joke_text>).
            IF sy-subrc = 0.
              lv_joke = <joke_text>.
            ENDIF.
          ENDIF.
        ENDIF.
      CATCH cx_root INTO DATA(lx_error1).
        lx_error1->get_text( ).
        RETURN.
    ENDTRY.






  ENDMETHOD.
ENDCLASS.

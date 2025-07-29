CLASS zcl_sales_reg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES_REG IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA(off) = io_request->get_paging( )->get_offset(  ).
    DATA(pag) = io_request->get_paging( )->get_page_size( ).
    DATA(lv_max_rows) = COND #( WHEN pag = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE pag ).
    DATA lv_rows TYPE int8.

    lv_rows = lv_max_rows.
    DATA(lsort) = io_request->get_sort_elements( ) .

    DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
    IF lv_top < 0.
      lv_top = 1.
    ENDIF.
    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

    DATA(lv_max_rows_top) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0
                                ELSE lv_top ).

    DATA(lt_fields)  = io_request->get_requested_elements( ).
    DATA(lt_sort)    = io_request->get_sort_elements( ).

    DATA(set) = io_request->get_requested_elements( ).
    DATA(lvs) = io_request->get_search_expression( ).
    DATA(filter1) = io_request->get_filter(  ).
    DATA(p1) = io_request->get_parameters(  ).
    DATA(p2) = io_request->get_requested_elements(  ).

    DATA(filter_tree) =   io_request->get_filter( )->get_as_tree(  ).


    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ). "  get_filter_conditions( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
    ENDTRY.

*     read table lt_filter_cond into data(lw_filter) index 1.
*      if sy-subrc = 0.
*      DATA(lt_option) = lw_filter-range.
*      endif.
*
*
*      read table lt_filter_cond into data(lf_filter) index 1.
*      if sy-subrc = 0.
*      DATA(lf_fiscal) = lf_filter-range.
*      endif.

     LOOP AT lt_filter_cond ASSIGNING FIELD-SYMBOL(<ls_ran>).
      CASE <ls_ran>-name.
        WHEN  'POSTINGDATE'.
        DATA(lt_option) = <ls_ran>-range.

        WHEN  'FISCALYEAR'.
        DATA(lf_fiscal) = <ls_ran>-range.

      ENDCASE.
    ENDLOOP.

    TYPES : BEGIN OF ty_final,
              accountingdocument     TYPE  c length 10,
              accountingdocumentitem type  zsales_register_et-accountingdocumentitem,
              documentreferenceid    TYPE  c length 16,
              creationdate           TYPE  c length 8,
              postingdate            TYPE  i_accountingdocumentjournal-PostingDate,
              tax_amt                TYPE  p LENGTH 16 DECIMALS 2,
              central_amount         TYPE  p LENGTH 16  DECIMALS 2,
              stut_amt               TYPE  p LENGTH 16  DECIMALS 2,
              companycode            TYPE  c length 4,
              fiscalyear             TYPE  c length 4,
              accountingdocumenttype TYPE  c length 4,
              item_val               TYPE  p LENGTH 16  DECIMALS 2,
              customer               TYPE  c length 10,
              glaccount              TYPE  c length 10,
              creationdat            TYPE  i_accountingdocumentjournal-CreationDate,
              companycodecurrency    TYPE  c length 5,
              businessplace          TYPE  c length 4,
              bptaxlongnumber        TYPE  c LENGTH 60,
              in_hsnorsaccode        TYPE  c length 16,
              businesspartnername1   TYPE  c LENGTH 40,
              glaccountlongname      TYPE  c LENGTH 50,
              profitcenter           TYPE  c length 10,
              LEDGERGLLINEITEM       type  c length 6,
              int_tax_amt            type  p LENGTH 16  DECIMALS 2,
              profitcenterdesc       type c length 50,
              inv_val                type p LENGTH 16  DECIMALS 2,
              rate                   type INT8,
              inv_ref                type C LENGTH 64,
              place_supply           type c length 40,
              taxcode type i_accountingdocumentjournal-TaxCode, ""ADDED on 19-02-2025
              deb_cocode    type i_accountingdocumentjournal-DEBITAMOUNTINCOCODECRCY,
              deb_cred       type i_accountingdocumentjournal-DEBITCREDITCODE,
              transactiontypedeerminaion type i_Accountingdocumentjournal-TransactionTypeDetermination,
            END OF ty_final.

    DATA:lt_final TYPE STANDARD TABLE OF ty_final,
         lw_final TYPE ty_final.

    data lv_amt TYPE  p LENGTH 16  DECIMALS 2.

    "if

    SELECT DISTINCT  accountingdocument, accountingdocumentitem, documentreferenceid, creationdate, postingdate, creditamountincocodecrcy, companycode,
                     fiscalyear, OFFSETTINGACCOUNT, glaccount, CompanyCodeCurrency, AccountingDocumentType, salesorder, customer,
                     documentdate, taxcode, DEBITAMOUNTINCOCODECRCY, DEBITCREDITCODE, Transactiontypedetermination
    FROM i_accountingdocumentjournal
    WHERE accountingdocumenttype IN ( 'RV', 'DR', 'ZA', 'DG' )
      AND billingdocumenttype IN ( 'F2', '' )
      and TransactionTypeDetermination = ''
      and postingdate in @LT_option
      and FinancialAccountType = 'S'
      and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(lt_doc).


    loop at lt_doc ASSIGNING FIELD-SYMBOL(<ls_doc1>).
     if <ls_doc1>-DebitCreditCode = 'S'.
       <ls_doc1>-CreditAmountInCoCodeCrcy = <ls_doc1>-DebitAmountInCoCodeCrcy.
       clear <ls_doc1>-DebitAmountInCoCodeCrcy.
     endif.
    endloop.




                                              "pick documentdate
if lt_doc is not initial.
    SELECT IN_EDOCEINVCEXTNMBR, IN_ElectronicDocInvcRefNmbr             "#EC CI_NOWHERE
    FROM I_IN_ELECTRONICDOCINVOICE
    FOR ALL ENTRIES IN @lt_doc
    WHERE IN_EDOCEINVCEXTNMBR = @lt_doc-DOCUMENTREFERENCEID
      INTO TABLE @DATA(inv_ref_id).

    SELECT customer, BusinessPartnerName1
    FROM i_customer
    FOR ALL ENTRIES IN @lt_doc
    where  CUSTOMER  = @lt_doc-Customer
    INTO  TABLE @DATA(LT_CUSTnm).

    SELECT customer , region
    FROM i_customer
    FOR ALL ENTRIES IN @lt_doc
    where  CUSTOMER  = @lt_doc-OFFSETTINGACCOUNT
    INTO  TABLE @DATA(place_supply).


    SELECT glaccount, GLAccountLongName
    FROM i_glaccounttextrawdata
    FOR ALL ENTRIES IN @lt_doc
    WHERE glaccount  = @lt_doc-glaccount
      INTO TABLE @DATA(lt_glname).

    SELECT accountingdocument, ProfitCenter
    FROM I_JOURNALENTRYitem
    FOR ALL ENTRIES IN @lt_DOC
     WHERE accountingdocument = @LT_DOC-accountingdocument
     and      fiscalyear = @LT_DOC-fiscalyear
      INTO TABLE @DATA(lt_profitcenter).

    SELECT plant, accountingdocument
    FROM I_JOURNALENTRYitem
    FOR ALL ENTRIES IN @lt_DOC
     WHERE accountingdocument = @LT_DOC-accountingdocument
       AND accountingdocumenttype IN (  'RV' ,'ZA' , 'DR', 'DG' )
       AND PLANT NE ''
       and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(lt_BJNCPLC).

    SELECT accountingdocument, branch
    FROM I_JOURNALENTRY
    FOR ALL ENTRIES IN @lt_DOC
     WHERE accountingdocument = @LT_DOC-accountingdocument
       AND accountingdocumenttype IN (  'RV' ,'ZA' , 'DR', 'DG' )
       and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(lt_BJNCPLC2).

            SELECT accountingdocument, IN_HSNORSACCODE
    FROM I_OPERATIONALACCTGDOCITEM
    FOR ALL ENTRIES IN @lt_doc
    WHERE accountingdocument = @lt_doc-accountingdocument
      and TransactionTypeDetermination = ''
      and FinancialAccountType = 'S'
      and fiscalyear in @lf_fiscal               "ADDED BY MT
      INTO TABLE @DATA(lt_hsn1).

    select businesspartner, BPTaxNumber, bptaxlongnumber
    from I_Businesspartnertaxnumber
    FOR ALL ENTRIES IN @lt_doc
    "where  businesspartner  = @lt_doc-Customer           "pass offsetting account instead of customer
    where  businesspartner  = @lt_doc-OffsettingAccount   "passed offsetting account instead of customer
      and  bptaxtype        = 'IN3'
      INTO TABLE @DATA(LT_GSTI).

    select accountingdocument, OFFSETTINGACCOUNT
    FROM i_accountingdocumentjournal
    for ALL ENTRIES IN @lt_doc
    WHERE accountingdocument = @lt_doc-accountingdocument
      and TransactionTypeDetermination = ''
      and FinancialAccountType = 'S'
      and postingdate in @LT_option
      and fiscalyear in @lf_fiscal               "ADDED BY MT
      INTO TABLE @DATA(lt_cust).
    endif.

   if lt_BJNCPLC is not initial.
    SELECT plant, BusinessPlace
    FROM I_IN_PlantBusinessPlaceDetaiL
    FOR ALL ENTRIES IN @lt_BJNCPLC
     WHERE PLANT = @lt_BJNCPLC-Plant
       INTO TABLE @DATA(lt_BJNCPLC1).
     endif.

if lt_profitcenter is not initial.
    SELECT ProfitCenter, ProfitCenterLongName
    FROM I_PROFITCENTERTEXT
    FOR ALL ENTRIES IN @lt_profitcenter
     WHERE profitcenter = @lt_profitcenter-ProfitCenter
      INTO TABLE @DATA(lt_profitcentertext).
  endif.

    SELECT accountingdocument, LedgerGLLineItem
    FROM i_accountingdocumentjournal
    WHERE accountingdocumenttype IN ( 'RV', 'DR', 'ZA', 'DG' )
      AND billingdocumenttype IN ( 'F2', '' )
      AND  FinancialAccountType = 'S'
      and postingdate in @LT_option
      AND TransactionTypeDetermination = ''
      and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(INV_ITM).

    SELECT accountingdocument, CreditAmountInCoCodeCrcy
    FROM i_accountingdocumentjournal
    WHERE accountingdocumenttype IN ( 'RV', 'DR', 'ZA', 'DG' )
      AND billingdocumenttype IN ( 'F2', '' )
      AND  FinancialAccountType = 'S'
      and postingdate in @LT_option
      AND TransactionTypeDetermination = 'JOI'
      and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(INT_TAX).

    SELECT accountingdocument, CreditAmountInCoCodeCrcy
    FROM i_accountingdocumentjournal
    WHERE accountingdocumenttype IN ( 'RV', 'DR', 'ZA', 'DG' )
      AND billingdocumenttype IN ( 'F2', '' )
      AND  FinancialAccountType = 'S'
      and postingdate in @LT_option
      AND TransactionTypeDetermination = 'JOC'
      and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(CNTRL_AMT).

    SELECT accountingdocument, CreditAmountInCoCodeCrcy
    FROM i_accountingdocumentjournal
    WHERE accountingdocumenttype IN ( 'RV', 'DR', 'ZA', 'DG' )
      AND billingdocumenttype IN ( 'F2', '' )
      AND  FinancialAccountType = 'S'
      and postingdate in @LT_option
      AND TransactionTypeDetermination in ( 'JOS' , 'JOU' )
      and fiscalyear in @lf_fiscal
      INTO TABLE @DATA(UT_TAX).

   DATA(lt_salesord) =  LT_DOC.
   DELETE lt_salesord WHERE accountingdocumenttype NE 'RV'.

if lt_salesord is not initial.
    SELECT product, plant, SALESORDER
    FROM  i_salesorderitem
    FOR ALL ENTRIES IN @lt_salesord
    WHERE salesorder = @lt_salesord-salesorder
    INTO TABLE @DATA(lt_plant).
  endif.

if lt_plant is not initial.
    SELECT  product, plant, ConsumptionTaxCtrlCode
    FROM i_productplantbasic
    FOR ALL ENTRIES IN @lt_plant
    WHERE plant   = @lt_plant-plant
      AND product = @lt_plant-product
      and ConsumptionTaxCtrlCode in @lf_fiscal               "ADDED BY MT
      INTO TABLE @DATA(lt_hsn).
   endif.

if lt_cust is not initial.
    SELECT customer, BusinessPartnerName1
    FROM i_customer
    FOR ALL ENTRIES IN @lt_cust
    where  CUSTOMER  = @lt_cust-OFFSETTINGACCOUNT
    INTO  TABLE @DATA(LT_CUSTnm1).
    endif.

    LOOP AT lt_doc INTO DATA(lw_doc).
      lw_final-accountingdocument  =  lw_doc-accountingdocument.
      lw_final-accountingdocumentitem = lw_doc-AccountingDocumentItem.
      lw_final-documentreferenceid =  lw_doc-documentreferenceid.
  "    lw_final-creationdate        =  lw_doc-creationdate. "Replace with documentdate
      lw_final-creationdate        =  lw_doc-DocumentDate.  "Replaced with documentdate
      lw_final-postingdate         =  lw_doc-postingdate.

      lw_final-tax_amt             =  lw_doc-creditamountincocodecrcy  * -1.
      lw_final-item_val            =  lw_doc-creditamountincocodecrcy * -1.

      lw_final-companycode         =  lw_doc-companycode.
      lw_final-fiscalyear          =  lw_doc-fiscalyear.

      lw_final-glaccount           =  lw_doc-glaccount.
      lw_final-creationdat         =  lw_doc-creationdate.
      lw_final-CompanyCodeCurrency =  lw_doc-CompanyCodeCurrency.
      lw_final-accountingdocumenttype  =  lw_doc-AccountingDocumentType.
            lw_final-taxcode = lw_doc-TaxCode.

read table inv_ref_id into data(lw_ref) with key IN_EDOCEINVCEXTNMBR = lw_DOC-DOCUMENTREFERENCEID.
 if sy-subrc = 0.
 lw_final-inv_ref   =  lw_ref-IN_ElectronicDocInvcRefNmbr.
 endif.

read table lt_cust into data(lw_cust) with key accountingdocument = lw_final-accountingdocument.
 if sy-subrc = 0.
 lw_final-customer            =  lw_doc-OFFSETTINGACCOUNT.
 endif.

 read table place_supply into data(lw_supply) with key CUSTOMER  = lw_doc-OFFSETTINGACCOUNT.
  if sy-subrc = 0.
  lw_final-place_supply =  lw_supply-Region.
  endif.

    READ TABLE LT_CUSTnm INTO DATA(LW_CUSTnm) WITH KEY CUSTOMER = lw_final-CUSTOMER.
    IF SY-SUBRC = 0.
    LW_FINAL-businesspartnername1 = LW_CUSTnm-BusinessPartnerName1.
    ENDIF.

   if LW_FINAL-businesspartnername1 is initial.
    READ TABLE LT_CUSTnm1 INTO DATA(LW_CUSTnm1) WITH KEY CUSTOMER = lw_cust-OFFSETTINGACCOUNT.
    IF SY-SUBRC = 0.
    LW_FINAL-businesspartnername1 = LW_CUSTnm1-BusinessPartnerName1.
    ENDIF.
    endif.

 READ TABLE LT_SALESORD INTO DATA(LW_SALESORD) WITH KEY accountingdocument = lw_final-accountingdocument.
  IF SY-SUBRC = 0.
 READ TABLE LT_PLANT INTO DATA(LW_PLANT) WITH KEY SALESORDER = LW_SALESORD-SalesOrder.
   IF SY-SUBRC = 0.
 READ TABLE LT_HSN INTO DATA(LW_HSN) WITH KEY plant   = lW_plant-plant product = lW_plant-product.
   IF SY-SUBRC = 0.
    lw_final-IN_HSNORSACCODE =  LW_HSN-ConsumptionTaxCtrlCode.
   ENDIF.
   ENDIF.
  ENDIF.
if lw_final-IN_HSNORSACCODE is initial.
  READ TABLE LT_HSN1 INTO DATA(LW_HSN1) WITH KEY accountingdocument = lw_final-accountingdocument.
   IF SY-SUBRC = 0.
    lw_final-IN_HSNORSACCODE =  LW_HSN1-IN_HSNORSACCODE.
   ENDIF.
endif.

 READ TABLE LT_GSTI INTO DATA(LW_GST) WITH KEY businesspartner = LW_FINAL-CUSTOMER.
  IF SY-SUBRC = 0.
   LW_FINAL-bptaxlongnumber = LW_GST-BPTaxNumber.
*   lw_final-in_gstplaceofsupply = LW_FINAL-bptaxlongnumber(2).

  ENDIF.

    READ TABLE lt_glname INTO DATA(lW_glname) WITH KEY glaccount  = LW_doc-glaccount.
     IF SY-SUBRC = 0.
       LW_FINAL-glaccountlongname = LW_GLNAME-GLAccountLongName.
     ENDIF.

     read table lt_BJNCPLC into data(lw_bsncplc) with key  accountingdocument = lw_final-accountingdocument.
       if sy-subrc = 0.
       read table lt_BJNCPLC1 into data(lw_bsncplc1) with key PLANT = lw_bsncplc-PLANT.
        IF SY-SUBRC = 0.
        LW_FINAL-businessplace =  lw_bsncplc1-BusinessPlace.
        ENDIF.
       endif.

       if LW_FINAL-businessplace is  initial.
       read table lt_BJNCPLC2 into data(lw_bsncplc2) with key accountingdocument = lw_final-accountingdocument.
        IF SY-SUBRC = 0.
        LW_FINAL-businessplace =  lw_bsncplc2-branch.
        ENDIF.
       endif.

     read table INV_ITM into data(lw_item) with key accountingdocument = lw_final-accountingdocument.
      if sy-subrc = 0.
      lw_final-ledgergllineitem =  lw_item-LedgerGLLineItem.
      endif.

*      read table INT_TAX into data(lw_inttax) with key accountingdocument = lw_final-accountingdocument.
*       if sy-subrc = 0.
*       lw_final-int_tax_amt = lw_inttax-CreditAmountInCoCodeCrcy  * -1.
*       endif.

*       read table cntrl_amt into data(lw_cntrl) with key accountingdocument = lw_final-accountingdocument.
*       if sy-subrc = 0.
*       lw_final-central_amount      =  LW_cntrl-creditamountincocodecrcy  * -1.
*       endif.

*       read table UT_TAX into data(lw_UT) with key accountingdocument = lw_final-accountingdocument.
*       if sy-subrc = 0.
*       lw_final-stut_amt      =  lw_UT-creditamountincocodecrcy  * -1.
*       endif.


     read table lt_profitcenter into data(lw_prcenter) with key accountingdocument = lw_final-accountingdocument.
      if sy-subrc = 0.
      lw_final-profitcenter =  lw_prcenter-ProfitCenter.

      read table lt_profitcentertext into data(lw_prcentertext) with key ProfitCenter = lw_final-ProfitCenter.
      if sy-subrc = 0.
      lw_final-profitcenterdesc =  lw_prcentertext-ProfitCenterLongName.
      endif.
      endif.

     " lw_final-inv_val =  lw_final-central_amount + lw_final-stut_amt + lw_final-tax_amt + lw_final-int_tax_amt.

*      if  lw_final-tax_amt is not initial.
*      lv_amt = lw_final-central_amount + lw_final-stut_amt + lw_final-int_tax_amt.
*     lw_final-rate  = lv_amt * 100 / lw_final-tax_amt.
*     clear lv_amt.
*      endif.



      APPEND lw_final TO lt_final.
      clear : lw_doc, lw_prcentertext, lw_prcenter, lw_item, lw_bsncplc1, lw_bsncplc, lw_glname, lw_cust,
              LW_GST, lw_plant, LW_SALESORD, lw_hsn , lw_doc, lw_final, lw_supply, LW_HSN1, LW_CUSTnm1 .
    ENDLOOP.
   sort lt_final by accountingdocument.
"   DELETE ADJACENT DUPLICATES FROM lt_final COMPARING accountingdocument.

 "  DELETE lt_final where  tax_amt is initial.


 """ADDED ON 19-12-2025

     SELECT FROM @lt_doc AS i INNER JOIN I_AccountingDocumentJournal AS ji
    ON i~accountingdocument = ji~accountingdocument
    INNER JOIN i_journalentry AS jh
    ON ji~accountingdocument = jh~accountingdocument
    INNER JOIN i_operationalacctgdocitem AS o
    ON i~accountingdocument = o~accountingdocument
    AND ltrim( ji~ledgergllineitem, '0' ) =  ltrim( o~accountingdocumentitem, '0' )
    AND i~fiscalyear = o~fiscalyear
    AND i~companycode = o~companycode
    FIELDS DISTINCT
     ji~creditamountincocodecrcy ,ji~accountingdocument, ji~accountingdocumentitem, ji~transactiontypedetermination, ji~taxcode,
      jh~documentreferenceid, o~taxbaseamountincocodecrcy, ji~FiscalYear, ji~DebitCreditCode, ji~DebitAmountInCoCodeCrcy
   ORDER BY ji~accountingdocument
    INTO TABLE @DATA(it_datafinal).

     loop at it_datafinal ASSIGNING FIELD-SYMBOL(<ls_datafinal>).
     if <ls_datafinal>-DebitCreditCode = 'S'.
       <ls_datafinal>-CreditAmountInCoCodeCrcy = <ls_datafinal>-DebitAmountInCoCodeCrcy.
       clear <ls_datafinal>-DebitAmountInCoCodeCrcy.
     endif.
    endloop.

 data: temp type I_AccountingDocumentJournal-CreditAmountInCoCodeCrcy,
                lv_taxcode type I_AccountingDocumentJournal-TaxCode.
  DATA: it_final1 TYPE TABLE OF ty_final,
          ls_final1 TYPE ty_final.

 loop at lt_final ASSIGNING FIELD-SYMBOL(<ls_final>).
 ls_final1 = CORRESPONDING #( <ls_final> ).

       if ls_final1-tax_amt < 0.
           ls_final1-tax_amt =   <ls_final>-tax_amt  * -1.
           ls_final1-item_val = <ls_final>-item_val * -1.
       endif.


       temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem TaxCode = <ls_final>-Taxcode FiscalYear = <ls_final>-fiscalyear ]-CreditAmountInCoCodeCrcy OPTIONAL ).
      IF temp IS NOT INITIAL.
        lv_taxcode = <ls_final>-taxcode.

        ls_final1-central_amount = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JOC' FiscalYear = <ls_final>-fiscalyear
                                            taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-CreditAmountInCoCodeCrcy OPTIONAL ).

       if ls_final1-central_amount < 0.
        ls_final1-central_amount = ls_final1-central_amount * -1.
        endif.
        ls_final1-stut_amt = ls_final1-central_amount.
        CLEAR temp.
        CLEAR lv_taxcode.
      ENDIF.



*      temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem ]-CreditAmountInCoCodeCrcy OPTIONAL ).
*      IF temp IS NOT INITIAL.
*        lv_taxcode = <ls_final>-taxcode.
*
*       data(lv_transactiondetermination) = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem ]-TransactionTypeDetermination OPTIONAL ).
*        if lv_transactiondetermination = 'JOS' OR lv_transactiondetermination = 'JOU'.
*        ls_final1-stut_amt = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument
*                                      taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-CreditAmountInCoCodeCrcy OPTIONAL ).
*
*
*        ls_final1-stut_amt = ls_final1-stut_amt * -1.
*
*        endif.
*         CLEAR temp.
*        CLEAR lv_taxcode.
*      ENDIF.

    temp = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument accountingdocumentitem = <ls_final>-accountingdocumentitem TaxCode = <ls_final>-Taxcode FiscalYear = <ls_final>-fiscalyear ]-CreditAmountInCoCodeCrcy OPTIONAL ).
      IF temp IS NOT INITIAL.
        lv_taxcode = <ls_final>-taxcode.

        ls_final1-int_tax_amt = VALUE #( it_datafinal[ accountingdocument = <ls_final>-accountingdocument transactiontypedetermination = 'JOI' FiscalYear = <ls_final>-fiscalyear
                                      taxbaseamountincocodecrcy = temp  taxcode = lv_taxcode ]-CreditAmountInCoCodeCrcy OPTIONAL ).

        if ls_final1-int_tax_amt < 0.
        ls_final1-int_tax_amt = ls_final1-int_tax_amt * -1.
        endif.
        CLEAR temp.
        CLEAR lv_taxcode.
      ENDIF.


     ls_final1-inv_val = ls_final1-tax_amt + ls_final1-central_amount + ls_final1-stut_amt + ls_final1-int_tax_amt.

     "Rate
     ls_final1-rate = ( ( ls_final1-central_amount + ls_final1-stut_amt + ls_final1-int_tax_amt ) / ls_final1-tax_amt ) * 100.



      APPEND ls_final1 TO it_final1.
      CLEAR ls_final1.







 endloop.

lt_final = CORRESPONDING #( it_final1 ).




    SELECT * FROM @lt_final AS lt_final
    WHERE tax_amt <> ''
     ORDER BY accountingdocument, accountingdocumentitem
     INTO TABLE @DATA(it_fin)
     OFFSET @lv_skip UP TO @lv_max_rows ROWS.


    SELECT COUNT( * )
        FROM @lt_final AS it_final           ##ITAB_DB_SELECT
        INTO @DATA(lv_totcount).

    io_response->set_total_number_of_records( lv_totcount ).
    io_response->set_data( it_fin ).


  ENDMETHOD.
ENDCLASS.

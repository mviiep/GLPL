CLASS zcl_tax_invoice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_final,
             customer                       TYPE  i_accountingdocumentjournal-customer,
             plant                          TYPE i_accountingdocumentjournal-plant,
             customername                   TYPE i_customer-customername,
             businesspartnername1           TYPE i_customer-businesspartnername1,
             businesspartnername2           TYPE i_customer-businesspartnername2,
             creationdate                   TYPE i_accountingdocumentjournal-creationdate,
             cityname                       TYPE i_address_2-cityname,
             cityname1                      TYPE i_address_2-cityname,
             postalcode                     TYPE i_address_2-postalcode,
             streetname                     TYPE i_address_2-streetname,
             streetname1                    TYPE i_address_2-streetname,
             streetprefixname1              TYPE i_address_2-streetprefixname1,
             streetprefixname2              TYPE i_address_2-streetprefixname2,
             region1                        TYPE i_regiontext-regionname,
             country                        TYPE i_countrytext-countryname,
             bptaxlongnumber                TYPE i_businesspartnertaxnumber-bptaxnumber,
             businessplace                  TYPE i_in_plantbusinessplacedetail-businessplace,
             addressname                    TYPE i_profitcenter-addressname,
             additionalname                 TYPE i_profitcenter-additionalname,
             profitcenteraddrname3          TYPE  i_profitcenter-profitcenteraddrname3,
             profitcenteraddrname4          TYPE  i_profitcenter-profitcenteraddrname4,
             streetprofitaddress            TYPE   i_profitcenter-streetaddressname,
             streetaddressname(600)         TYPE  c,
             profitcity                     TYPE i_profitcenter-cityname,
             glaccountlongname              TYPE i_glaccounttextrawdata-glaccountlongname,
             salesorder                     TYPE i_accountingdocumentjournal-salesorder,
             bankacc(15)                    TYPE c,
             reference                      TYPE i_salesdocumentitem-YY1_REFERENCETEXTITEM_SDI,
             yy1_fromdate_sdh               TYPE  d,
             yy1_todate_sdh(10)             TYPE  c,
             product                        TYPE i_salesorderitem-product,
             consumptiontaxctrlcode         TYPE i_productplantbasic-consumptiontaxctrlcode,
             in_gstidentificationnumber     TYPE i_in_businessplacetaxdetail-in_gstidentificationnumber,
             creditamountincocodecrcy       TYPE i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy1      TYPE i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy2      TYPE  i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy3      TYPE  i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy4      TYPE i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy5      TYPE i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy6      TYPE  i_journalentryitem-creditamountincocodecrcy,
             creditamountincocodecrcy7      TYPE  i_journalentryitem-creditamountincocodecrcy,
              creditamountincocodecrcy8      TYPE i_journalentryitem-creditamountincocodecrcy,
             addressid                      TYPE i_in_businessplacetaxdetail-addressid,
             businessplacedescription       TYPE i_in_businessplacetaxdetail-businessplacedescription,
             region                         TYPE i_address_2-region,
             companycodeparametervalue      TYPE i_addlcompanycodeinformation-companycodeparametervalue,
             supplier                       TYPE i_journalentryitem-supplier,
             documentitemtext               TYPE i_journalentryitem-documentitemtext,
             accountingdocument             TYPE i_journalentryitem-accountingdocument,
             accountingdocumentitem         TYPE i_journalentryitem-accountingdocumentitem,
             amountintransactioncurrency    TYPE i_journalentryitem-amountintransactioncurrency,
             financialaccounttype           TYPE i_journalentryitem-financialaccounttype,
             transactiontypedetermination   TYPE i_journalentryitem-transactiontypedetermination,
             ledgergllineitem               TYPE i_journalentryitem-ledgergllineitem,
             profitcenter                   TYPE i_journalentryitem-profitcenter,
             originctrlgdebitcreditcode     TYPE i_journalentryitem-originctrlgdebitcreditcode,
             glaccount                      TYPE i_journalentryitem-glaccount,
             costcenter                     TYPE i_journalentryitem-costcenter,
             purchasingdocument             TYPE i_journalentryitem-purchasingdocument,
             fixedasset                     TYPE i_journalentryitem-fixedasset,
             taxcode                        TYPE i_journalentryitem-taxcode,
             companycodecurrency            TYPE i_journalentryitem-companycodecurrency,
             branch                         TYPE i_journalentry-branch,
             documentreferenceid            TYPE i_journalentry-documentreferenceid,
             documentdate                   TYPE i_journalentry-documentdate,
             postingdate                    TYPE i_journalentry-postingdate,
             companycode                    TYPE i_journalentry-companycode,
             accountingdocumenttype         TYPE i_journalentry-accountingdocumenttype,
             fiscalyear                     TYPE i_journalentry-fiscalyear,
             reversedocument                TYPE i_journalentry-reversedocument,
             reversedocumentfiscalyear      TYPE i_journalentry-reversedocumentfiscalyear,
             accountingdoccreatedbyuser     TYPE i_journalentry-accountingdoccreatedbyuser,
             accountingdocumentcreationdate TYPE i_journalentry-accountingdocumentcreationdate,
             total                          TYPE string,                       "  TYPE i_journalentryitem-creditamountincocodecrcy,  "for total
             total11                         TYPE string,
             amountinwords(300)             TYPE c,
             regiontext                     TYPE i_regiontext-regionname,
             lv_date1                       TYPE string,
             lv_date2                       TYPE string,
             lv_var(2)                      TYPE   c,
             in_electronicdocinvcrefnmbr    TYPE i_in_electronicdocinvoice-in_electronicdocinvcrefnmbr,
             in_electronicdocqrcodetxt      TYPE i_in_electronicdocinvoice-in_electronicdocqrcodetxt,
             cgstname(5)                    TYPE c,
             sgstname(5)                    TYPE c,
             igstname(5)                    TYPE c,
             cgstrate(10)                   TYPE c,
             sgstrate(10)                   TYPE c,
             igstrate(10)                   TYPE c,
             percentage1(2)                 TYPE c,
             lv_data(2)                     type c,
*             percentage2(2)                 TYPE c,
*             percentage3(2)                 TYPE c,


           END OF ty_final.




    DATA: lv_date   TYPE string.
          DATA:  LV_RES TYPE STRING.


    CONSTANTS : c(1) VALUE '.'.


    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'N7O',
          lv_qas(3) TYPE c VALUE 'M2S',
          lv_prd(3) TYPE c VALUE 'MLN'.

    DATA : lv_account TYPE i_accountingdocumentjournal-accountingdocument,
           lv_supp    TYPE  i_accountingdocumentjournal-fiscalyear,     "added by amit (09/01/2025)
           it_final   TYPE STANDARD TABLE OF ty_final,
           wa_final   LIKE LINE OF it_final,
           r_token    TYPE string.
*    DATA:      mo_http_destination TYPE REF TO if_http_destination,
*                mv_client           TYPE REF TO if_web_http_client.


****Methods


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_obj | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.



    METHODS xmldata
      RETURNING VALUE(r_xml) TYPE string.
    "  METHODS xmldata IMPORTING accountingdocument TYPE i_accountingdocumentjournal-accountingdocument.
    "     RETURNING VALUE(r_data)  TYPE string.
*                      METHODS get_obj RETURNING VALUE(r_obj) TYPE string.



    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS tax_invoice
      RETURNING VALUE(r_base64) TYPE string.

    INTERFACES if_http_service_extension.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TAX_INVOICE IMPLEMENTATION.


  METHOD get_obj.
    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    r_token = tokenmethod->token( ).


    DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
    DATA: lo_http_client TYPE REF TO if_web_http_client.

    TRY.
        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
         i_destination = cl_http_destination_provider=>create_by_url( i_url = lv_url )
          ).
      CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lo_request) = lo_http_client->get_http_request( ).

    CASE sy-sysid.
      WHEN lv_dev.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/TAX_DEV' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/TAX_QAS' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/TAX_PRD' ).
    ENDCASE.



    lo_request->set_header_fields( VALUE #(
                (  name = 'Authorization' value =  | { r_token } | )
                ) ).

    TRY.
        DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>get
                            ).
      CATCH cx_web_http_client_error.                   "#EC NO_HANDLER
        "handle exception
    ENDTRY.

    DATA(lv_json_response) =   lv_response->get_text( ).

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <templates>           TYPE data,
      <templates_result>    TYPE any,
      <metafield_result>    TYPE data,
      <metadata_result>     TYPE data,
      <metadata>            TYPE STANDARD TABLE,
      <pdf_based64_encoded> TYPE any.

    DATA lr_data TYPE REF TO data.
    DATA templates TYPE REF TO data.

    lr_data = /ui2/cl_json=>generate( json = lv_json_response  pretty_name  = /ui2/cl_json=>pretty_mode-user ).

    DATA: lv_test TYPE string.


    IF lr_data IS BOUND.
      ASSIGN lr_data->* TO <data>.


      ASSIGN COMPONENT 'templates' OF STRUCTURE <data> TO <templates>.
      IF <templates> IS BOUND.
        ASSIGN <templates>->* TO <templates_result>.

        ASSIGN <templates_result> TO <metadata>.

        READ TABLE <metadata> ASSIGNING FIELD-SYMBOL(<metafield>) INDEX 1.
        ASSIGN <metafield>->* TO <metafield_result>.

        ASSIGN COMPONENT 'METADATA' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata>).
        ASSIGN <mdata>->* TO FIELD-SYMBOL(<mdata_result>).

        ASSIGN COMPONENT 'OBJECTID' OF STRUCTURE <mdata_result> TO FIELD-SYMBOL(<objectid>).
        ASSIGN <objectid>->* TO FIELD-SYMBOL(<objectid_result>).

      ENDIF.
    ENDIF.


    r_obj = <objectid_result>.


  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

    DATA(lt_params) = request->get_form_fields( ).
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'accountingdocument' .
    lv_account = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'fiscalyear' .
    lv_supp = ls_params-value.



    IF lv_account IS NOT INITIAL AND  lv_supp IS NOT INITIAL .
      TRY.
          response->set_text( tax_invoice( ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.
    ENDIF.


  ENDMETHOD.


  METHOD tax_invoice.

*****************************POST METHOD*****************************
    TYPES :
      BEGIN OF struct,
        xdp_template     TYPE string,
        xml_data         TYPE string,
        form_type        TYPE string,
        form_locale      TYPE string,
        tagged_pdf       TYPE string,
        embed_font       TYPE string,
        changenotallowed TYPE string,
      END OF struct.

    DATA(tokenmethod) = NEW zcl_adobe_token( ).
    DATA(r_token) = tokenmethod->token( ).

    DATA(xmldata) = me->xmldata( ).

    DATA(objectid)    = me->get_obj( ).


    IF objectid IS NOT INITIAL AND xmldata IS NOT INITIAL AND r_token IS NOT INITIAL.

      DATA: lv_url TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com'.
      DATA: lo_http_client TYPE REF TO if_web_http_client.

      TRY.
          lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination =
          cl_http_destination_provider=>create_by_url( i_url = lv_url ) ).
        CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
          "handle exception
      ENDTRY.

      DATA(lo_request) = lo_http_client->get_http_request( ).

      lo_request->set_uri_path( i_uri_path = '/v1/adsRender/pdf' ).
      lo_request->set_query( query =  'templateSource=storageId' ).

      lo_request->set_header_fields(  VALUE #(
                 (  name = 'Content-Type' value = 'application/json' )
                 (  name = 'Accept' value = 'application/json' )
                  )  ).

      lo_request->set_header_fields(  VALUE #(
                      (  name = 'Authorization' value =  | { r_token } | )
                      ) ).




      CASE sy-sysid.
        WHEN lv_dev.
          DATA(ls_body) = VALUE struct(  xdp_template = 'TAX_DEV/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'TAX_QAS/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'TAX_PRD/' && |{ objectid }|
                                               xml_data  = xmldata ).
      ENDCASE.

      DATA(lv_json) = /ui2/cl_json=>serialize( data = ls_body compress = abap_true
                                               pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).

      lo_request->append_text(
            EXPORTING
              data   = lv_json
          ).

      TRY.
          DATA(lv_response) = lo_http_client->execute(
                              i_method  = if_web_http_client=>post ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.

      DATA(lv_json_response) = lv_response->get_text( ).

      FIELD-SYMBOLS:
        <data>                TYPE data,
        <field>               TYPE any,
        <pdf_based64_encoded> TYPE any.

      DATA lr_data TYPE REF TO data.

      lr_data = /ui2/cl_json=>generate( json = lv_json_response ).

      IF lr_data IS BOUND.
        ASSIGN lr_data->* TO <data>.
        ASSIGN COMPONENT `fileContent` OF STRUCTURE <data> TO <field>.
        IF sy-subrc EQ 0.
          ASSIGN <field>->* TO <pdf_based64_encoded>.
          r_base64 = <pdf_based64_encoded>.
        ENDIF.
      ENDIF.



    ENDIF.

  ENDMETHOD.


  METHOD xmldata.


*     SELECT FROM i_journalentryitem AS ji INNER JOIN i_journalentry AS jh
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
*    WHERE ji~accountingdocument = @accountingdocument  "= '1900000004' or  ji~accountingdocument = '1900000005'
*    "and ji~PostingDate in @lv_postingdate
*    AND jh~accountingdocumenttype IN ( 'KG', 'KR', 'RE', 'RK', 'RN' )
*     AND ji~ledger ='0L'
**      and jh~Ledger = '0L'
*     INTO TABLE @it_data.







*    SELECT  customer,     "commented
*            companycode,
*            documentreferenceid,
*            glaccount,
*            glaccounttype,
*            financialaccounttype,
*            creationdate,
*            plant,
*            salesorder,
*            profitcenter,
*            accountingdocument
*    FROM  i_accountingdocumentjournal
*    WHERE accountingdocument = @lv_account
*          AND glaccounttype = 'P'
*    INTO TABLE @DATA(lt_cust).


    SELECT  customer,       "Added 30/12/2024
            companycode,
            documentreferenceid,
            glaccount,
            glaccounttype,
            financialaccounttype,
            fiscalyear,
            creationdate,
            plant,
            salesorder,
            profitcenter,
            accountingdocument,
            offsettingaccount,
           transactiontypedetermination,
           ReferenceDocumentItem
    FROM  i_accountingdocumentjournal
    WHERE accountingdocument = @lv_account
          AND fiscalyear = @lv_supp
          AND financialaccounttype = 'S'
          AND transactiontypedetermination = ''
          AND Ledger = '0L'
    INTO TABLE @DATA(lt_cust).




    IF  lt_cust[] IS NOT INITIAL.


*    select ElectronicDocSourceKey,IN_ElectronicDocInvcRefNmbr,IN_ElectronicDocQRCodeTxt
*        from I_IN_ElectronicDocInvoice
*        for ALL ENTRIES IN @lt_cust
*     "   where  ElectronicDocSourceKey = @lt_cust-DocumentReferenceID
*        where  ElectronicDocSourceKey = cast( @lt_cust-DocumentReferenceid AS CHAR )
*         into table @data(lt_electronic).


      SELECT FROM i_in_electronicdocinvoice AS i INNER JOIN @lt_cust AS c      "irn and QR Code
      ON i~in_edoceinvcextnmbr = c~documentreferenceid
      FIELDS
      i~in_edoceinvcextnmbr,
      i~electronicdoccompanycode,
      i~in_electronicdocinvcrefnmbr,
      i~in_electronicdocqrcodetxt

      INTO TABLE @DATA(lt_electronic).









      SELECT accountingdocument, financialaccounttype,transactiontypedetermination,organizationdivision, fiscalyear  "added for bank account no.
      FROM i_accountingdocumentjournal
      FOR ALL ENTRIES IN @lt_cust
      WHERE accountingdocument = @lt_cust-accountingdocument
         AND fiscalyear = @lv_supp
           AND financialaccounttype = 'S'
           AND transactiontypedetermination = ''
       INTO TABLE @DATA(lt_bankdetails).




*
*      SELECT  customer ,
*              customername,
*              addressid
*        FROM i_customer
*        FOR ALL ENTRIES IN @lt_cust
*        WHERE customer = @lt_cust-customer
*        INTO TABLE @DATA(lt_cusname).


      SELECT  customer ,             "Added 30/12/2024
              customername,
              addressid,
              businesspartnername1,
              businesspartnername2
        FROM i_customer
        FOR ALL ENTRIES IN @lt_cust
        WHERE customer = @lt_cust-offsettingaccount
        INTO TABLE @DATA(lt_cusname).



*
*      SELECT addressid, cityname,postalcode,streetname ,streetprefixname1,streetprefixname2
*      FROM i_address_2
*      FOR ALL ENTRIES IN @lt_cust
*      WHERE addressid  = @lt_cust-customer
*      INTO TABLE @DATA(lt_adress).

*****************************      "gstin , address "24/12/2024
      SELECT  accountingdocument, branch,fiscalyear
          FROM i_journalentry
          FOR ALL ENTRIES IN  @lt_cust
          WHERE accountingdocument =  @lt_cust-accountingdocument
          AND  fiscalyear = @lv_supp
          INTO TABLE @DATA(lt_journal).

      IF lt_journal IS NOT INITIAL.
        SELECT businessplace,                           "#EC CI_NOWHERE
               addressid,
               in_gstidentificationnumber
               FROM i_in_businessplacetaxdetail
               FOR ALL ENTRIES IN @lt_journal
               WHERE  businessplace = @lt_journal-branch
               INTO TABLE @DATA(lt_place).
      ENDIF.


*****************************      regular logic
      IF lt_cusname IS NOT INITIAL.
        SELECT addressid, cityname,postalcode,streetname ,streetprefixname1,streetprefixname2,region,country "#EC CI_NOWHERE
        FROM i_address_2 WITH PRIVILEGED ACCESS
        FOR ALL ENTRIES IN @lt_cusname
        WHERE addressid  = @lt_cusname-addressid
        INTO TABLE @DATA(lt_adress).
      ENDIF.


      IF lt_adress IS NOT INITIAL.

        SELECT country,region , language ,regionname
        FROM i_regiontext
        FOR ALL ENTRIES IN @lt_adress
        WHERE region = @lt_adress-region
             AND country = @lt_adress-country
              AND language = 'E'
        INTO TABLE @DATA(lt_text) .

        SELECT country , language, countryname
        FROM i_countrytext
        FOR ALL ENTRIES IN @lt_adress
        WHERE country = @lt_adress-country
            AND language = 'E'
        INTO TABLE @DATA(lt_countryt).

      ENDIF.

*      SELECT businesspartner,
*              bptaxtype ,
*              bptaxnumber
*
*      FROM i_businesspartnertaxnumber
*      FOR ALL ENTRIES IN @lt_cust
*      WHERE businesspartner =  @lt_cust-customer
*          AND bptaxtype = 'IN3'
*      INTO TABLE @DATA(lt_number).


      SELECT businesspartner,                     "added 30/12/2024
              bptaxtype ,
              bptaxnumber

      FROM i_businesspartnertaxnumber
      FOR ALL ENTRIES IN @lt_cust
      WHERE businesspartner =  @lt_cust-offsettingaccount
          AND bptaxtype = 'IN3'
      INTO TABLE @DATA(lt_number).






      SELECT plant ,
             companycode ,
             businessplace
          FROM i_in_plantbusinessplacedetail
          FOR ALL ENTRIES IN  @lt_cust
          WHERE  plant = @lt_cust-plant
             AND companycode  = @lt_cust-companycode
          INTO TABLE @DATA(lt_businessplace).

      SELECT profitcenter,
             addressname,
             additionalname,
             profitcenteraddrname3,
             profitcenteraddrname4,
*             streetaddressname,
             cityname
             FROM i_profitcenter
             FOR ALL ENTRIES IN @lt_cust
             WHERE profitcenter = @lt_cust-profitcenter
             INTO TABLE @DATA(lt_address).

********************************************

             if lt_cust is not INITIAL.
             select AccountingDocument,AccountingDocumentType , FiscalYear,ACCOUNTINGDOCUMENTHEADERTEXT
             from I_ACCOUNTINGDOCUMENTJOURNAL
             FOR ALL ENTRIES IN @lt_cust
             where AccountingDocument = @lt_cust-AccountingDocument
             and  FiscalYear = @lt_cust-FiscalYear
             INTO TABLE @DATA(lt_address9).

           select AccountingDocument , FiscalYear , REFERENCEDOCUMENT
           from I_ACCOUNTINGDOCUMENTJOURNAL
           FOR ALL ENTRIES IN @lt_cust
          where AccountingDocument = @lt_cust-AccountingDocument
             and  FiscalYear = @lt_cust-FiscalYear
             into table @data(lt_address10).

             endif.

             if lt_address10 is not initial.

             select BILLINGDOCUMENT , YY1_ADDRESS_BDH
             from I_BILLINGDOCUMENT
             for ALL ENTRIES IN @lt_address10
             where BillingDocument = @lt_address10-ReferenceDocument
             into table @data(lt_address11).

             endif.





******************************

      SELECT glaccount,                  "G/L Account Long Name
            glaccountlongname
     FROM  i_glaccounttextrawdata
     FOR ALL ENTRIES IN @lt_cust
     WHERE glaccount = @lt_cust-glaccount
     INTO TABLE @DATA(lt_glaname).


*      SELECT  salesdocument,
*              yy1_referencetext_sdh,                               " sales to date and from date
*              yy1_fromdate_sdh,
*              yy1_todate_sdh
*              FROM i_salesdocument
*              FOR ALL ENTRIES IN @lt_cust
*              WHERE salesdocument = @lt_cust-salesorder
*              INTO TABLE @DATA(lt_sales).

      SELECT  salesdocument,
              salesdocumentitem,
              YY1_REFERENCETEXTITEM_SDI,                               " sales to date and from date
              YY1_FROMDATE1_SDI,
              YY1_TODATE1_SDI
              FROM i_salesdocumentitem
              FOR ALL ENTRIES IN @lt_cust
              WHERE salesdocument = @lt_cust-salesorder
              and salesdocumentitem = @lt_cust-ReferenceDocumentItem
  INTO TABLE @DATA(lt_sales).

      SELECT accountingdocument ,
             accountingdocumenttype,
             salesorder,
             fiscalyear
             FROM i_accountingdocumentjournal
             FOR ALL ENTRIES IN @lt_cust
             WHERE accountingdocument = @lt_cust-accountingdocument
              AND  fiscalyear = @lv_supp

                  AND accountingdocumenttype = 'RV'
                  INTO TABLE @DATA(lt_order).

      DELETE lt_order WHERE salesorder EQ '' .

      SELECT accountingdocument,       " Manual text Description
              referencedocumentitem,
              documentitemtext,
              ledger,
              glaccounttype,
              fiscalyear
              FROM  i_journalentryitem
              FOR ALL ENTRIES IN @lt_cust
              WHERE accountingdocument = @lt_cust-accountingdocument
              AND  fiscalyear = @lv_supp
              and referencedocumentitem = @lt_cust-ReferenceDocumentItem

              AND        ledger        = '0L'
              AND        glaccounttype = 'P'
              INTO TABLE @DATA(lt_jounal).

      SELECT FROM i_journalentryitem FIELDS accountingdocument ,  financialaccounttype, transactiontypedetermination ,creditamountincocodecrcy,ReferenceDocumentItem, FiscalYear   "unitrate
      FOR ALL ENTRIES IN @lt_cust
      WHERE accountingdocument =  @lt_cust-accountingdocument
      and ReferenceDocumentItem = @lt_cust-ReferenceDocumentItem
      AND financialaccounttype = 'S'
      AND transactiontypedetermination = ''
      and FiscalYear = @lv_supp
      INTO TABLE @DATA(it_unitrate).

      SELECT FROM i_journalentryitem FIELDS accountingdocument ,  financialaccounttype, transactiontypedetermination , creditamountincocodecrcy,ReferenceDocumentItem, FiscalYear  "cgstrate
      FOR ALL ENTRIES IN @lt_cust
      WHERE accountingdocument =  @lt_cust-accountingdocument
*       and ReferenceDocumentItem = @lt_cust-ReferenceDocumentItem
      AND financialaccounttype = 'S'
      AND transactiontypedetermination = 'JOC'
      and FiscalYear = @lv_supp
      INTO TABLE @DATA(it_cgstrate).

      SELECT FROM i_journalentryitem FIELDS accountingdocument ,  financialaccounttype, transactiontypedetermination , creditamountincocodecrcy,ReferenceDocumentItem,FiscalYear
   FOR ALL ENTRIES IN @lt_cust
   WHERE accountingdocument =  @lt_cust-accountingdocument
*    and ReferenceDocumentItem = @lt_cust-ReferenceDocumentItem
   AND financialaccounttype = 'S'
   AND transactiontypedetermination = 'JOS'
   and FiscalYear = @lv_supp
   INTO TABLE @DATA(it_sgstrate).

      SELECT FROM i_journalentryitem FIELDS accountingdocument ,  financialaccounttype, transactiontypedetermination , creditamountincocodecrcy,ReferenceDocumentItem, FiscalYear    "igstrate
 FOR ALL ENTRIES IN @lt_cust
 WHERE accountingdocument =  @lt_cust-accountingdocument
*  and ReferenceDocumentItem = @lt_cust-ReferenceDocumentItem
 AND financialaccounttype = 'S'
 AND transactiontypedetermination = 'JOI'
 and FiscalYear = @lv_supp
 INTO TABLE @DATA(it_igstrate).

      SELECT FROM i_journalentryitem FIELDS accountingdocument ,  financialaccounttype, transactiontypedetermination , creditamountincocodecrcy,ReferenceDocumentItem,FiscalYear     "Ugstrate
 FOR ALL ENTRIES IN @lt_cust
 WHERE accountingdocument =  @lt_cust-accountingdocument
*  and ReferenceDocumentItem = @lt_cust-ReferenceDocumentItem
 AND financialaccounttype = 'S'
 AND transactiontypedetermination = 'JOU'
 and FiscalYear = @lv_supp
 INTO TABLE @DATA(it_ugstrate).


    ENDIF.



    IF lt_order IS NOT INITIAL.
      SELECT salesorder,                                "#EC CI_NOWHERE
           product,
             plant
      FROM i_salesorderitem
      FOR ALL ENTRIES IN @lt_order
      WHERE salesorder  = @lt_order-salesorder
      INTO TABLE @DATA(lt_item).
    ENDIF.

    IF lt_item IS NOT INITIAL.
      SELECT product,                                   "#EC CI_NOWHERE
             plant,
             consumptiontaxctrlcode
             FROM i_productplantbasic
             FOR  ALL ENTRIES IN @lt_item
             WHERE product = @lt_item-product
               AND  plant = @lt_item-plant
            INTO TABLE @DATA(lt_control).
    ENDIF.

    IF lt_cust IS NOT INITIAL.
      SELECT accountingdocument, financialaccounttype ,transactiontypedetermination,in_hsnorsaccode,fiscalyear  "#EC CI_NOWHERE
          FROM i_operationalacctgdocitem
          FOR ALL ENTRIES IN @lt_cust
          WHERE accountingdocument = @lt_cust-accountingdocument
          AND  fiscalyear = @lv_supp
            AND financialaccounttype = 'S'
            AND transactiontypedetermination = ''
            INTO TABLE @DATA(lt_operation).
    ENDIF.
**************************************************

    IF lt_businessplace[] IS NOT INITIAL .          "place  supply  main

      SELECT businessplace,
          businessplacedescription
    FROM i_businessplacevh
    FOR ALL ENTRIES IN @lt_businessplace
    WHERE  businessplace = @lt_businessplace-businessplace
    INTO TABLE @DATA(it_businessdesc).

    ENDIF.

    IF lt_journal[] IS NOT INITIAL.            "added logic for place of supply

      SELECT businessplace,
            businessplacedescription
      FROM i_businessplacevh
      FOR ALL ENTRIES IN @lt_journal
      WHERE  businessplace = @lt_journal-branch
      INTO TABLE @DATA(lt_placesupply).

    ENDIF.


********************************************




    SELECT companycode ,         "pan
           companycodeparametertype ,
           companycodeparametervalue
           FROM i_addlcompanycodeinformation
           WHERE companycode  = '1000'
           AND  companycodeparametertype = 'J_1I02'
           INTO TABLE @DATA(lt_pan).


    IF lt_businessplace[] IS NOT INITIAL.

      SELECT businessplace,          "gstno.
            addressid,
            in_gstidentificationnumber

       FROM i_in_businessplacetaxdetail
       FOR ALL ENTRIES IN @lt_businessplace
       WHERE  businessplace =  @lt_businessplace-businessplace
       INTO TABLE @DATA(lt_gstn).

    ENDIF.

    IF lt_gstn[] IS  NOT INITIAL .    "business  place address

      SELECT addressid,
             cityname,
             streetname,
             region,
             country
             FROM i_address_2 WITH PRIVILEGED ACCESS
             FOR ALL ENTRIES IN @lt_gstn
             WHERE addressid = @lt_gstn-addressid
             INTO TABLE @DATA(lt_add).

      IF lt_add IS NOT INITIAL .

        SELECT country,region , language ,regionname
      FROM i_regiontext
      FOR ALL ENTRIES IN @lt_add
      WHERE region = @lt_add-region
           AND country = @lt_add-country
            AND language = 'E'
      INTO TABLE @DATA(lt_iregion) .



      ENDIF.

    ENDIF.

    IF lt_add IS INITIAL.

      IF lt_place IS NOT INITIAL .   "added 30/12/2024


        SELECT addressid,
               cityname,
               streetname,
               region,
               country
               FROM i_address_2  WITH PRIVILEGED ACCESS
               FOR ALL ENTRIES IN @lt_place
               WHERE addressid = @lt_place-addressid
               INTO TABLE @DATA(lt_adddown).

        IF lt_adddown IS NOT INITIAL .

          SELECT country,region , language ,regionname
        FROM i_regiontext
        FOR ALL ENTRIES IN @lt_adddown
        WHERE region = @lt_adddown-region
             AND country = @lt_adddown-country
              AND language = 'E'
        INTO TABLE @DATA(lt_iregion1) .



        ENDIF.




      ENDIF.

    ENDIF .

  if lt_text  IS NOT INITIAL .

select statecode ,statecodeno
from zstatecode_no
FOR ALL ENTRIES IN @lt_text
where statecode = @lt_text-Region
into table @data(lt_statecode).

endif.






    LOOP AT lt_cust INTO DATA(wa_cust).

      wa_final-customer   = wa_cust-customer.
      wa_final-companycode = wa_cust-companycode.
      wa_final-creationdate = wa_cust-creationdate.
      wa_final-documentreferenceid = wa_cust-documentreferenceid.
      wa_final-glaccount    = wa_cust-glaccount.
      wa_final-plant       = wa_cust-plant.
      wa_final-salesorder  = wa_cust-salesorder.
      wa_final-profitcenter = wa_cust-profitcenter.


      READ TABLE lt_electronic INTO DATA(wa_electronic) WITH KEY in_edoceinvcextnmbr = wa_cust-documentreferenceid.     "qr

      IF sy-subrc = 0.

        wa_final-in_electronicdocinvcrefnmbr = wa_electronic-in_electronicdocinvcrefnmbr.
        CONDENSE wa_final-in_electronicdocinvcrefnmbr.

        wa_final-in_electronicdocqrcodetxt   = wa_electronic-in_electronicdocqrcodetxt.

      ENDIF.



      READ TABLE lt_bankdetails INTO DATA(wa_bankdetails) WITH KEY accountingdocument = wa_cust-accountingdocument
                                                                   financialaccounttype = 'S'
                                                                   transactiontypedetermination = ''.


      IF  wa_bankdetails-organizationdivision EQ '30' .

        wa_final-bankacc = '57500001380121'.

      ELSE.
        wa_final-bankacc = '57500000903512' .

      ENDIF.

*      READ TABLE lt_cusname INTO DATA(wa_cusname) WITH KEY customer = wa_cust-customer.
*
*      IF sy-subrc = 0.
*        wa_final-customername = wa_cusname-customername.
*      ENDIF.





      READ TABLE lt_cusname INTO DATA(wa_cusname) WITH KEY customer = wa_cust-offsettingaccount.  "

      IF sy-subrc = 0.
        wa_final-customername = wa_cusname-customername.
        wa_final-businesspartnername1  = wa_cusname-businesspartnername1.
        wa_final-businesspartnername2  = wa_cusname-businesspartnername2.
      ENDIF.

*      READ TABLE lt_adress INTO DATA(wa_adress) WITH KEY addressid = wa_cust-customer.

      READ TABLE lt_adress INTO DATA(wa_adress) WITH KEY addressid = wa_cusname-addressid.


      IF sy-subrc = 0.

        wa_final-cityname1   =  wa_adress-cityname.
        wa_final-streetname1   =  wa_adress-streetname.
        wa_final-streetprefixname1   =  wa_adress-streetprefixname1.
        wa_final-streetprefixname2   =  wa_adress-streetprefixname2.
        wa_final-postalcode          = wa_adress-postalcode.



      ENDIF.




      READ TABLE lt_text INTO DATA(wa_text) WITH KEY region = wa_adress-region
                                                     country = wa_adress-country
                                                     language = 'E'.

      IF sy-subrc = 0.
        wa_final-region1             =     wa_text-regionname.
      ENDIF.


      READ TABLE lt_countryt INTO DATA(wa_countryt) WITH KEY country = wa_adress-country
                                                             language = 'E'.

      IF sy-subrc = 0.
        wa_final-country    =  wa_countryt-countryname.
      ENDIF.


*      READ TABLE lt_number INTO DATA(wa_number) WITH KEY businesspartner = wa_cust-customer
*                                                              bptaxtype = 'IN3'.
*      IF sy-subrc = 0.
*        wa_final-bptaxlongnumber = wa_number-bptaxnumber.
*      ENDIF .

      READ TABLE lt_number INTO DATA(wa_number) WITH KEY businesspartner = wa_cust-offsettingaccount    "added 30/12/2024
                                                              bptaxtype = 'IN3'.
      IF sy-subrc = 0.
        wa_final-bptaxlongnumber = wa_number-bptaxnumber.
*        wa_final-lv_data         = wa_number-BPTaxNumber.
      ENDIF .

      read table lt_statecode into data(wa_statecode) with key statecode = wa_text-Region.

      if sy-subrc = 0.

      wa_final-lv_data = wa_statecode-statecodeno .

      endif.






      READ TABLE lt_businessplace INTO DATA(wa_businessplace) WITH KEY plant = wa_cust-plant
                                                                       companycode = wa_cust-companycode.
      IF sy-subrc = 0.
        wa_final-businessplace = wa_businessplace-businessplace.
      ENDIF .

      READ TABLE it_businessdesc INTO DATA(wa_businessdesc) WITH KEY businessplace =  wa_businessplace-businessplace.
*       businessplace = wa_final-businessplace.
      IF sy-subrc = 0.
        wa_final-businessplacedescription = wa_businessdesc-businessplacedescription+7(11).

      ENDIF.

      READ TABLE lt_gstn INTO DATA(wa_gstn) WITH KEY businessplace =  wa_businessplace-businessplace.
*      businessplace = wa_final-businessplace.
      IF sy-subrc = 0.
        wa_final-addressid                 = wa_gstn-addressid.
        wa_final-in_gstidentificationnumber = wa_gstn-in_gstidentificationnumber.
      ENDIF.

***************************
      READ TABLE lt_journal INTO DATA(wa_entry) WITH KEY accountingdocument =  wa_cust-accountingdocument .  "added {24/12/2024}

      IF  wa_final-in_gstidentificationnumber IS INITIAL.

        READ TABLE lt_place INTO DATA(wa_place) WITH KEY businessplace = wa_entry-branch.
        IF sy-subrc = 0 .
          wa_final-in_gstidentificationnumber = wa_place-in_gstidentificationnumber.
        ENDIF.

      ENDIF.

      IF  wa_final-businessplacedescription IS INITIAL .    "added for place of supply additional

        READ TABLE lt_placesupply INTO DATA(wa_placesupply) WITH KEY businessplace = wa_entry-branch.

        IF sy-subrc = 0 .
          wa_final-businessplacedescription = wa_placesupply-businessplacedescription+7(11).
        ENDIF.


      ENDIF.






*****************************


      READ TABLE lt_add INTO DATA(wa_add) WITH KEY addressid = wa_gstn-addressid.
*      wa_final-addressid.
      IF sy-subrc = 0.
        wa_final-cityname      =  wa_add-cityname.
        wa_final-streetname    = wa_add-streetname.
        wa_final-region        = wa_add-region.
      ENDIF.



      READ TABLE lt_iregion INTO DATA(wa_iregion) WITH KEY region = wa_add-region
                                                           country = wa_add-country
                                                            language = 'E'.
      IF sy-subrc = 0.
        wa_final-regiontext    = wa_iregion-regionname.
      ENDIF.



      READ TABLE  lt_address INTO  DATA(wa_address) WITH KEY profitcenter = wa_cust-profitcenter.
      IF sy-subrc = 0.

        wa_final-addressname     = wa_address-addressname.
        wa_final-additionalname  = wa_address-additionalname.
        wa_final-profitcenteraddrname3 = wa_address-profitcenteraddrname3.
        wa_final-profitcenteraddrname4 = wa_address-profitcenteraddrname4.
*        wa_final-streetprofitaddress = wa_address-streetaddressname.
        wa_final-profitcity        = wa_address-cityname.

*        CONCATENATE  wa_final-addressname wa_final-additionalname  wa_final-profitcenteraddrname3 wa_final-profitcenteraddrname4 wa_final-streetprofitaddress wa_final-profitcity INTO wa_final-streetaddressname SEPARATED BY ','.


*        REPLACE ALL OCCURRENCES OF `,,` IN wa_final-streetaddressname WITH `,`.


      ENDIF.

      READ TABLE lt_address9 INTO DATA(wa_address9) WITH KEY AccountingDocument = wa_cust-AccountingDocument
                                                             FiscalYear         = wa_CUST-FiscalYear.

      IF SY-subrc = 0.
      WA_FINAL-streetaddressname = wa_address9-AccountingDocumentHeaderText.
      ENDIF.

      if  Wa_address9-AccountingDocumentType EQ 'RV'.

      read table lt_address10 into data(wa_address10) with key AccountingDocument = wa_cust-AccountingDocument.


      READ TABLE lt_address11 into data(wa_address11) with key BillingDocument = wa_address10-ReferenceDocument.

      if sy-subrc = 0.
      wa_final-streetaddressname = wa_address11-YY1_Address_BDH.
      endif.

      endif.





      READ TABLE lt_glaname INTO DATA(wa_glaname) WITH KEY glaccount = wa_cust-glaccount.
      IF sy-subrc = 0.
        wa_final-glaccountlongname = wa_glaname-glaccountlongname.
      ENDIF .

      READ TABLE lt_sales INTO DATA(wa_sales) WITH KEY salesdocument = wa_cust-salesorder  "From date / to date
                                                       SalesDocumentItem = wa_cust-ReferenceDocumentItem.
      IF sy-subrc = 0 .
        wa_final-reference                = wa_sales-YY1_REFERENCETEXTITEM_SDI.
        wa_final-yy1_fromdate_sdh         = wa_sales-YY1_FROMDATE1_SDI.
*        wa_final-lv_date2      = wa_sales-yy1_fromdate_sdh.
        wa_final-yy1_todate_sdh           = wa_sales-YY1_TODATE1_SDI.



        IF  wa_final-yy1_fromdate_sdh  EQ '00000000'.

          wa_final-lv_date2 = ''.

        ELSE.

          wa_final-lv_date2 =   wa_final-yy1_fromdate_sdh .

        ENDIF.


        IF  wa_final-yy1_todate_sdh EQ '00000000'  .

          wa_final-lv_var = ''.
          wa_final-lv_date1 = '' .

        ELSE.

          wa_final-lv_var = 'to'.
          wa_final-lv_date1 = wa_final-yy1_todate_sdh.

        ENDIF.



      ENDIF.




      READ TABLE lt_order INTO  DATA(wa_order) WITH KEY accountingdocument = wa_cust-accountingdocument
                                                     accountingdocumenttype = 'RV'.
      IF sy-subrc = 0.
        wa_final-salesorder  = wa_order-salesorder.
      ENDIF.

      READ TABLE lt_item INTO  DATA(wa_item) WITH KEY salesorder = wa_order-salesorder.
      IF sy-subrc = 0.
        wa_final-product = wa_item-product.
        wa_final-plant   = wa_item-plant.
      ENDIF.

      READ TABLE lt_control INTO DATA(wa_control) WITH KEY product = wa_item-product
                                                            plant = wa_item-plant.
      IF sy-subrc = 0.
        wa_final-consumptiontaxctrlcode   = wa_control-consumptiontaxctrlcode .
      ENDIF.


      IF wa_final-consumptiontaxctrlcode IS INITIAL.

        READ TABLE lt_operation INTO DATA(wa_operation) WITH KEY accountingdocument = wa_cust-accountingdocument
                                                                 financialaccounttype = 'S'
                                                                 transactiontypedetermination = ''.
        IF sy-subrc = 0.
          wa_final-consumptiontaxctrlcode        = wa_operation-in_hsnorsaccode.
        ENDIF.


      ENDIF.



      IF wa_final-reference IS INITIAL .

        READ TABLE lt_jounal INTO  DATA(wa_journal) WITH KEY accountingdocument = wa_cust-accountingdocument
                                                             referencedocumentitem = wa_cust-ReferenceDocumentItem
                                                              ledger        = '0L'
                                                              glaccounttype = 'P'.
        IF sy-subrc = 0.
          wa_final-reference      = wa_journal-documentitemtext.
        ENDIF.

      ENDIF.

      READ TABLE it_unitrate INTO DATA(wa_unitrate) WITH KEY accountingdocument = wa_cust-accountingdocument
                                                             ReferenceDocumentItem = wa_cust-ReferenceDocumentItem
                                                             financialaccounttype = 'S'
                                                             transactiontypedetermination = ''.

      IF sy-subrc = 0.
        wa_final-creditamountincocodecrcy  = wa_unitrate-creditamountincocodecrcy * -1.

      ENDIF.



      wa_final-percentage1 = '%'.

      READ TABLE it_cgstrate INTO DATA(wa_cgstrate) WITH KEY accountingdocument = wa_cust-accountingdocument    "cgstrate
*                                                           ReferenceDocumentItem = wa_cust-ReferenceDocumentItem
                                                           financialaccounttype = 'S'
                                                           transactiontypedetermination = 'JOC'.

      IF sy-subrc = 0.
*        wa_final-creditamountincocodecrcy1  = wa_cgstrate-creditamountincocodecrcy * -1.
*      ENDIF.

        IF wa_cgstrate-transactiontypedetermination = 'JOC'.

          wa_final-cgstname = 'CGST'.
          wa_final-creditamountincocodecrcy1  = wa_cgstrate-creditamountincocodecrcy * -1.
          wa_final-cgstrate    = wa_final-creditamountincocodecrcy1 * 100 / wa_final-creditamountincocodecrcy.



          DATA(lv_round) = round( val = wa_final-cgstrate dec = 2 ) .
          wa_final-cgstrate = lv_round.

          CONDENSE wa_final-cgstrate.

          CONCATENATE wa_final-cgstrate wa_final-percentage1 INTO wa_final-cgstrate SEPARATED BY space.
        ENDIF.

      ENDIF.


      Loop at it_cgstrate into wa_cgstrate  where AccountingDocument = wa_cust-AccountingDocument .
       wa_final-creditamountincocodecrcy5 = wa_final-creditamountincocodecrcy5 + wa_cgstrate-CreditAmountInCoCodeCrcy.

      endloop.

    wa_final-creditamountincocodecrcy5 = wa_final-creditamountincocodecrcy5 * -1 .

*wa_final-creditamountincocodecrcy1 = wa_final-creditamountincocodecrcy1 * -1 .




      READ TABLE it_sgstrate INTO DATA(wa_sgstrate) WITH KEY accountingdocument = wa_cust-accountingdocument    "Sgst rate
*                                                          ReferenceDocumentItem = wa_cust-ReferenceDocumentItem
                                                          financialaccounttype = 'S'
                                                          transactiontypedetermination = 'JOS'.

      IF sy-subrc = 0.

        IF wa_sgstrate-transactiontypedetermination = 'JOS'.
          wa_final-sgstname = 'SGST'.
          wa_final-creditamountincocodecrcy2  = wa_sgstrate-creditamountincocodecrcy * -1.

*         CONDENSE wa_final-creditamountincocodecrcy2.
          wa_final-sgstrate   = wa_final-creditamountincocodecrcy2 * 100 / wa_final-creditamountincocodecrcy.



          lv_round = round( val = wa_final-sgstrate dec = 2 ) .
          wa_final-sgstrate = lv_round.
          CONDENSE wa_final-sgstrate.

          CONCATENATE wa_final-sgstrate wa_final-percentage1 INTO wa_final-sgstrate SEPARATED BY space.
        ENDIF.

      ENDIF.

      Loop at it_sgstrate into wa_sgstrate  where AccountingDocument = wa_cust-AccountingDocument .
       wa_final-creditamountincocodecrcy6 = wa_final-creditamountincocodecrcy6 +  wa_sgstrate-CreditAmountInCoCodeCrcy.

      endloop.

 wa_final-creditamountincocodecrcy6 = wa_final-creditamountincocodecrcy6 * -1 .

*    wa_final-creditamountincocodecrcy2 = wa_final-creditamountincocodecrcy2 * -1 .

      READ TABLE it_igstrate INTO DATA(wa_igstrate) WITH KEY accountingdocument = wa_cust-accountingdocument     "Igst rate
*                                                           ReferenceDocumentItem = wa_cust-ReferenceDocumentItem
                                                           financialaccounttype = 'S'
                                                           transactiontypedetermination = 'JOI'.
      IF  sy-subrc = 0.

        IF wa_igstrate-transactiontypedetermination = 'JOI'.

          wa_final-igstname = 'IGST'.
          wa_final-creditamountincocodecrcy3  = wa_igstrate-creditamountincocodecrcy * -1.
          wa_final-igstrate   = wa_final-creditamountincocodecrcy3 * 100 / wa_final-creditamountincocodecrcy.

          lv_round = round( val = wa_final-igstrate dec = 2 ) .
          wa_final-igstrate = lv_round.

          CONDENSE wa_final-igstrate.
          CONCATENATE wa_final-igstrate wa_final-percentage1 INTO wa_final-igstrate SEPARATED BY space.



        ENDIF.

      ENDIF.



      Loop at it_igstrate into wa_igstrate where AccountingDocument = wa_cust-AccountingDocument .
       wa_final-creditamountincocodecrcy7 = wa_final-creditamountincocodecrcy7 +  wa_igstrate-CreditAmountInCoCodeCrcy.

      endloop.

 wa_final-creditamountincocodecrcy7 = wa_final-creditamountincocodecrcy7 * -1 .


*    wa_final-creditamountincocodecrcy3 = wa_final-creditamountincocodecrcy3 * -1 .


      READ TABLE it_ugstrate INTO DATA(wa_ugstrate) WITH KEY accountingdocument = wa_cust-accountingdocument     "Ugst rate
*                                                           ReferenceDocumentItem = wa_cust-ReferenceDocumentItem
                                                           financialaccounttype = 'S'
                                                           transactiontypedetermination = 'JOU'.

      IF sy-subrc = 0.

        IF wa_ugstrate-transactiontypedetermination = 'JOU'.

          wa_final-sgstname = 'UGST'.
          wa_final-creditamountincocodecrcy2  = wa_ugstrate-creditamountincocodecrcy * -1.
          wa_final-sgstrate   = wa_final-creditamountincocodecrcy2 * 100 / wa_final-creditamountincocodecrcy.

          lv_round = round( val = wa_final-sgstrate dec = 2 ) .
          wa_final-sgstrate = lv_round.

          CONDENSE wa_final-sgstrate.

          CONCATENATE wa_final-sgstrate  wa_final-percentage1 INTO wa_final-sgstrate SEPARATED BY space.
        ENDIF.
      ENDIF.




      Loop at it_ugstrate  into wa_ugstrate where AccountingDocument = wa_cust-AccountingDocument .
       wa_final-creditamountincocodecrcy6 = wa_final-creditamountincocodecrcy6 + wa_ugstrate-CreditAmountInCoCodeCrcy.

      endloop.

   if wa_final-creditamountincocodecrcy6 < 0.
    wa_final-creditamountincocodecrcy6 = wa_final-creditamountincocodecrcy6 * -1 .
  endif.



      READ TABLE lt_pan INTO DATA(wa_pan) WITH KEY  companycode  = '1000'
                                                    companycodeparametertype = 'J_1I02'    .

      IF sy-subrc = 0.
        wa_final-companycodeparametervalue = wa_pan-companycodeparametervalue.
      ENDIF.

      IF lt_add IS INITIAL .
        READ TABLE lt_adddown INTO DATA(wa_adddown) WITH KEY addressid = wa_place-addressid.

        IF sy-subrc = 0.

          wa_final-cityname      =  wa_adddown-cityname.
          wa_final-streetname    = wa_adddown-streetname.
          wa_final-region        = wa_adddown-region.





        ENDIF.

        READ TABLE lt_iregion1 INTO DATA(wa_iregion1) WITH KEY region = wa_adddown-region
                                                             country = wa_adddown-country
                                                              language = 'E'.
        IF sy-subrc = 0.
          wa_final-regiontext    = wa_iregion1-regionname.
        ENDIF.

      ENDIF.


*ENDLOOP.

      wa_final-total = wa_final-creditamountincocodecrcy.
*    wa_final-total =  wa_final-total + wa_final-creditamountincocodecrcy5 + wa_final-creditamountincocodecrcy6 + wa_final-creditamountincocodecrcy7.

     lv_res  = lv_res + WA_FINAL-total.
     WA_FINAL-total = lv_res.
*
*      CLEAR   WA_FINAL-total .
*      WA_FINAL-total = lv_res.
*WA_FINAL-total = WA_FINAL-total + wa_final-creditamountincocodecrcy5 + wa_final-creditamountincocodecrcy6 + wa_final-creditamountincocodecrcy7.

*      CONDENSE wa_final-total.
*      SPLIT wa_final-total AT '.' INTO: DATA(text1) DATA(text2).
*      IF text2 > 50.
*        data lv_a9 type p DECIMALS 1.
*        lv_a9 = round(  val = wa_final-total dec = 0 mode = cl_abap_math=>round_up  ).
*        wa_final-total = lv_a9.
*      ELSEIF TEXT2 < 50.
*       split wa_final-total at '.' into text1 text2.
*       wa_final-total = text1 .
*      ENDIF.

*   LV_RES = WA_FINAL-total.



if wa_final-cgstrate is not initial and wa_final-sgstrate is not INITIAL.

wa_final-cgstrate = '9%'.
wa_final-sgstrate = '9%'.

ELSEif wa_final-igstrate is NOT INITIAL.
wa_final-igstrate = '18%'.


endif.

if wa_final-cgstname = 'CGST' and
wa_FINAL-sgstname = 'SGST'.

WA_FINAL-igstname = 'IGST'.
WA_FINAL-igstrate = '0%' .

ELSE.

wa_final-cgstname = 'CGST' .
WA_FINAL-cgstrate = '0%'.
wa_FINAL-sgstname = 'SGST'.
WA_FINAL-sgstrate = '0%' .

endif.



      APPEND wa_final TO it_final.




      CLEAR : wa_final,wa_cust, wa_cusname,wa_adress, wa_number, wa_businessplace,wa_businessdesc, wa_gstn, wa_add ,wa_address,wa_glaname,wa_sales,wa_order,wa_item,wa_control,wa_unitrate,wa_sgstrate,wa_cgstrate, wa_igstrate, wa_ugstrate, wa_pan,lv_date,
      wa_operation,wa_placesupply,wa_bankdetails, lv_round.
*      text1 , text2, lv_a9.
    ENDLOOP.


    DATA(LV_COUNT) = lines( it_final ).
    READ TABLE it_final INTO DATA(wa_header) INDEX LV_COUNT.
    REPLACE ALL OCCURRENCES OF `,,` IN wa_header-streetaddressname  WITH ``.
   wa_header-total =  wa_header-total + wa_header-creditamountincocodecrcy5 + wa_header-creditamountincocodecrcy6 + wa_header-creditamountincocodecrcy7.


      CONDENSE wa_header-total.
      SPLIT  wa_header-total AT '.' INTO: DATA(text1) DATA(text2).
      IF text2 > 50.
        data lv_a9 type p DECIMALS 1.
        lv_a9 = round(  val =  wa_header-total dec = 0 mode = cl_abap_math=>round_up  ).
         wa_header-total = lv_a9.
      ELSEIF TEXT2 < 50.
       split  wa_header-total at '.' into text1 text2.
       wa_header-total = text1 .
      ENDIF.

    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_tax_invoice    SOURCE it_final         = it_final[]
                                                header              = wa_header
                                              RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.

  ENDMETHOD.
ENDCLASS.

CLASS zcl_http_test DEFINITION
  PUBLIC
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
             reference                      TYPE i_salesdocument-yy1_referencetext_sdh,
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
*             percentage2(2)                 TYPE c,
*             percentage3(2)                 TYPE c,


           END OF ty_final.



    DATA: lv_date   TYPE string.



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


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS tax_invoice
      RETURNING VALUE(r_base64) TYPE string.

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_TEST IMPLEMENTATION.


  METHOD get_obj.

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

  ENDMETHOD.


  METHOD xmldata.

  ENDMETHOD.
ENDCLASS.

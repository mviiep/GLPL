CLASS zcl_rfq_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


**data Declaration
    TYPES: BEGIN OF ty_rfq,
             companyname        TYPE i_address_2-addressid,   "plant
             companystreet      TYPE c length 200,"i_address_2-streetname,
             compstreetsuffix   TYPE i_address_2-streetsuffixname1,
             companydist        TYPE i_address_2-districtname,
             companypincode     TYPE i_address_2-postalcode,
             companycity        TYPE i_address_2-cityname,
             country            TYPE i_countrytext-countryname,
             sitename           TYPE i_profitcenter-additionalname,
             sitecity           TYPE i_profitcenter-cityname,
             siteaddname        TYPE c length 500, "i_profitcenter-addressname,
             siteadditionalname TYPE c length 500, "i_profitcenter-additionalname,
             siteprofitname3    TYPE i_profitcenter-profitcenteraddrname3,
             siteprofitname4    TYPE i_profitcenter-profitcenteraddrname4,
             sitestreetaddname  TYPE i_profitcenter-streetaddressname,
             sitedist           TYPE i_profitcenter-district,
             sitepincode        TYPE i_profitcenter-postalcode,
             siteregion         TYPE i_regiontext-regionname,
             suppliername       TYPE c length 500, "i_address_2-streetname,
             streetname         TYPE c length 200,
             streetsuffixname1 type c length 100,
             suppaddress        TYPE c length 500, "i_address_2-streetprefixname1,
             suppaddress2       TYPE i_address_2-streetprefixname2,
             supplierstate      TYPE i_address_2-districtname,
             supplierpincode    TYPE i_address_2-postalcode,
             suppregion         TYPE i_regiontext-regionname,
             rfqnumber          TYPE i_rfqitem_api01-requestforquotation,
             rfqmail            TYPE i_rfqitem_api01-requestforquotation,
             quotationdead      TYPE i_purreqnacctassgmtapi01-validitydate,
             rfqdate            TYPE i_requestforquotation_api01-creationdate,
             contact            TYPE i_requestforquotation_api01-yy1_contactpersonname_pdh,
             telephone          TYPE i_requestforquotation_api01-yy1_mobilenumber_pdh,
             gst                TYPE i_businesspartnertaxnumber-bptaxnumber,
           END OF ty_rfq.

    TYPES : BEGIN OF ty_item,
              item(4)     TYPE c,
              description TYPE   i_rfqitem_api01-purchasingdocumentitemtext,
              material    TYPE  i_rfqitem_api01-material,
              quantity    TYPE   i_rfqscheduleline_api01-schedulelineorderquantity,
              unit        TYPE   i_rfqitem_api01-baseunit,
              targetrate  TYPE i_rfqitem_api01-yy1_targetrate_pdi,
              remarks     TYPE i_rfqitem_api01-yy1_remark_pdi,
            END OF ty_item.

    DATA: r_token TYPE string.
    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'N7O'.
    DATA :lv_qas(3) TYPE c VALUE 'M2S'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.



    DATA : wa_header      TYPE ty_rfq,
           it_item        TYPE TABLE OF ty_item,
           wa_item        TYPE ty_item,
           lv_rfq         TYPE i_rfqitem_api01-requestforquotation,
           lv_supp        TYPE i_rfqbidder_api01-supplier,
           lv_rec_counter TYPE zirfq_suppmail-rec_counter.



****Methods


    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_obj | <p class="shorttext synchronized" lang="en"></p>
    METHODS get_obj RETURNING VALUE(r_obj) TYPE string.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_XML | <p class="shorttext synchronized" lang="en"></p>
    METHODS xmldata
      RETURNING VALUE(r_xml) TYPE string.



    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter r_base64 | <p class="shorttext synchronized" lang="en"></p>
    METHODS rfq
      IMPORTING
                p_rfq           TYPE i_rfqitem_api01-requestforquotation
                p_supplier      TYPE i_supplier-supplier
                p_rec_counter   TYPE zirfq_suppmail-rec_counter OPTIONAL
      RETURNING VALUE(r_base64) TYPE string.

    INTERFACES if_http_service_extension .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RFQ_CUSTOM IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/RFQ_DEV' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/RFQ_DEV' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/RFQ_PRD' ).
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
    READ TABLE lt_params INTO DATA(ls_params) WITH KEY name = 'rfq' .
    lv_rfq = ls_params-value.

    READ TABLE lt_params INTO ls_params WITH KEY name = 'supplier' .
    lv_supp = ls_params-value.


    IF lv_rfq IS NOT INITIAL AND lv_supp IS NOT INITIAL.
      TRY.
          response->set_text( rfq(
                                p_rfq      = lv_rfq
                                p_supplier = lv_supp
                              ) ).
        CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
      ENDTRY.
    ENDIF.


  ENDMETHOD.


  METHOD rfq.

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

    IF lv_rfq IS INITIAL.
      lv_rfq = p_rfq.
    ENDIF.

    IF lv_supp IS INITIAL.
      lv_supp = p_supplier.
    ENDIF.

    IF lv_rec_counter IS INITIAL.
      lv_rec_counter = p_rec_counter.
    ENDIF.

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
          DATA(ls_body) = VALUE struct(  xdp_template = 'RFQ_DEV/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'RFQ_DEV/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'RFQ_PRD/' && |{ objectid }|
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



    SELECT SINGLE requestforquotation, plant,
           purchaserequisition, yy1_targetrate_pdi, yy1_remark_pdi FROM i_rfqitem_api01
           WHERE requestforquotation = @lv_rfq
           INTO @DATA(i_rfq).

    SELECT SINGLE creationdate, yy1_mobilenumber_pdh, yy1_contactpersonname_pdh
                  FROM i_requestforquotation_api01
                  WHERE  requestforquotation = @lv_rfq
                  INTO @DATA(i_contact).

    SELECT SINGLE costcenter, profitcenter, creationdate, validitydate
           FROM i_purreqnacctassgmtapi01
           WHERE purchaserequisition = @i_rfq-purchaserequisition
           INTO @DATA(i_cost).

    SELECT  * FROM i_profitcenter
             WHERE profitcenter = @i_cost-profitcenter
             INTO TABLE @DATA(i_address).

    SELECT SINGLE addressid,  plant
           FROM  i_plant
           WHERE plant = @i_rfq-plant
           INTO @DATA(i_plant).

    SELECT SINGLE addressid, cityname, postalcode, streetname, streetsuffixname1, country, region
           FROM i_address_2 WITH PRIVILEGED ACCESS
           WHERE addressid = @i_plant-addressid
           INTO @DATA(i_addid).

    SELECT * FROM
            i_rfqitem_api01
            WHERE requestforquotation = @lv_rfq
            INTO TABLE @DATA(lt_item).


    SELECT SINGLE supplier, addressid,suppliername
    FROM    i_supplier
           WHERE supplier = @lv_supp
            INTO @DATA(lt_supp).

    SELECT SINGLE addressid, cityname, postalcode, streetname, streetsuffixname1, streetprefixname1, streetprefixname2, country, region
           FROM i_address_2 WITH PRIVILEGED ACCESS
           WHERE addressid = @lt_supp-addressid
              INTO @DATA(lt_address2).


    SELECT SINGLE supplier, suppliername
     FROM   zirfq_suppmail
     WHERE requestforquotation = @lv_rfq
     AND   supplier = @lv_supp
     AND   rec_counter = @lv_rec_counter
     INTO @DATA(lt_rfqsupp).


    SELECT *
        FROM i_regiontext
        WHERE language = 'E'
          AND country = 'IN'
          INTO TABLE @DATA(it_regiontext) .

    SELECT country, language, countryname  FROM i_countrytext
    WHERE language = 'E'
       AND country = 'IN'
       INTO TABLE @DATA(it_countrytext).

    SELECT * FROM i_rfqscheduleline_api01
    WHERE requestforquotation = @lv_rfq
        INTO TABLE @DATA(lt_qty).

    SELECT SINGLE businesspartner, bptaxnumber
    FROM i_businesspartnertaxnumber
    WHERE businesspartner = @lv_supp
    INTO @DATA(lt_buss).

    select single plant, in_gstidentificationnumber
    from zi_mm_address
    where plant = @i_rfq-Plant
    into @data(i_gst).

    wa_header-rfqnumber           = i_rfq-requestforquotation.
    wa_header-quotationdead       = i_cost-validitydate.
    wa_header-companycity         = i_addid-cityname.
    wa_header-companystreet       = i_addid-streetname.
    wa_header-companypincode      = i_addid-postalcode.
    wa_header-compstreetsuffix    = i_addid-streetsuffixname1.
    wa_header-country             = VALUE #( it_countrytext[ country = i_addid-country ]-countryname OPTIONAL ).
    wa_header-rfqdate             = i_contact-creationdate.
    wa_header-contact             = i_contact-yy1_contactpersonname_pdh.
    wa_header-telephone           = i_contact-yy1_mobilenumber_pdh.
    wa_header-gst                 = i_gst-IN_GSTIdentificationNumber. "lt_buss-bptaxnumber.

    CONCATENATE WA_HEADER-COMPANYSTREET WA_HEADER-COMPSTREETSUFFIX INTO WA_HEADER-COMPANYSTREET SEPARATED BY SPACE.
*    CONDENSE WA_HEADER-COMPANYSTREET.

    READ TABLE i_address INTO DATA(wa_address) WITH KEY profitcenter = i_cost-profitcenter.
    wa_header-sitedist = wa_address-district.
    wa_header-sitepincode = wa_address-postalcode.
    wa_header-siteaddname = wa_address-addressname.
    wa_header-siteadditionalname    = wa_address-additionalname.
    wa_header-siteprofitname3   = wa_address-profitcenteraddrname3.
    wa_header-siteprofitname4   = wa_address-profitcenteraddrname4.
    wa_header-sitestreetaddname    = wa_address-streetaddressname.
    wa_header-sitecity = wa_address-cityname.
    wa_header-siteregion  = VALUE #( it_regiontext[ region = wa_address-region ]-regionname OPTIONAL ).

    CONCATENATE wa_header-siteadditionalname wa_header-siteprofitname3 wa_header-siteprofitname4
    wa_header-sitestreetaddname wa_header-sitecity wa_header-sitedist wa_header-siteregion wa_header-sitepincode into wa_header-siteadditionalname SEPARATED BY SPACE.
    CONDENSE wa_header-siteadditionalname.
    IF lt_address2 IS INITIAL.
      wa_header-suppliername = lt_rfqsupp-suppliername.
    ELSE.
      wa_header-suppliername     = lt_supp-suppliername.
      wa_header-suppaddress      = lt_address2-streetprefixname1.    " street2
      wa_header-suppaddress2     = lt_address2-streetprefixname2.   "street3
      wa_header-streetname     = lt_address2-streetname.         "Street/House number
      wa_header-streetsuffixname1 = lt_address2-streetsuffixname1. "street4
      wa_header-supplierstate    = lt_address2-cityname.
      wa_header-supplierpincode  = lt_address2-postalcode.
      wa_header-suppregion       = VALUE #( it_regiontext[ region = lt_address2-region ]-regionname OPTIONAL ).
    ENDIF.

   CONCATENATE  wa_header-streetname wa_header-suppaddress wa_header-suppaddress2 wa_header-streetsuffixname1 wa_header-supplierstate
            wa_header-suppregion wa_header-supplierpincode into wa_header-suppaddress separated by space.
     CONDENSE wa_header-suppaddress.

    LOOP AT lt_item INTO DATA(ls_item) WHERE requestforquotation = lv_rfq.
      READ TABLE lt_qty INTO DATA(ls_qty) WITH KEY requestforquotation = ls_item-requestforquotation
                                                   requestforquotationitem = ls_item-requestforquotationitem.
      wa_item-quantity = ls_qty-schedulelineorderquantity.
      SHIFT ls_item-purchaserequisitionitem LEFT DELETING LEADING '0'.
      wa_item-item = ls_item-purchaserequisitionitem.
      wa_item-description = ls_item-purchasingdocumentitemtext.
      SHIFT ls_item-material LEFT DELETING LEADING '0'.
      wa_item-material = ls_item-material.
      wa_item-unit = ls_item-baseunit.
      wa_item-targetrate   = ls_item-yy1_targetrate_pdi.
      wa_item-remarks      = ls_item-yy1_remark_pdi.
      APPEND wa_item TO it_item.
      CLEAR: wa_item, ls_qty.
    ENDLOOP.










*     READ TABLE wa_header INTO DATA(header) INDEX 1.

    DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

    CALL TRANSFORMATION ztr_rfq    SOURCE it_item         = it_item[]
                                                header              = wa_header
                                              RESULT XML lo_xml_conv.

    DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.


  ENDMETHOD.
ENDCLASS.

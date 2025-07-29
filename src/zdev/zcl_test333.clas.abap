CLASS zcl_test333 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


   TYPES : BEGIN OF ty_item,
            requestforquotation type i_rfqitem_api01-requestforquotation,
            MaterialGroup   TYPE i_rfqitem_api01-MaterialGroup,
            purchasingdocumentitemtext TYPE   i_rfqitem_api01-purchasingdocumentitemtext,
            material    TYPE  i_rfqitem_api01-material,
            END OF ty_item.


    DATA: r_token TYPE string.
    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'N7O'.
    DATA :lv_qas(3) TYPE c VALUE 'M2S'.
    DATA :lv_prd(3) TYPE c VALUE 'KSZ'.


     DATA :  lv_rfq         TYPE i_rfqitem_api01-requestforquotation,
            it_item        TYPE TABLE OF ty_item,
            wa_item        TYPE ty_item.



****Methods

 METHODS get_obj RETURNING VALUE(r_obj) TYPE string.


  METHODS xmldata
      RETURNING VALUE(r_xml) TYPE string.

  METHODS rfq
        RETURNING VALUE(r_base64) TYPE string.

  INTERFACES if_http_service_extension .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST333 IMPLEMENTATION.


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
        lo_request->set_uri_path( i_uri_path = '/v1/forms/Test' ).
      WHEN lv_qas.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/Test' ).
      WHEN lv_prd.
        lo_request->set_uri_path( i_uri_path = '/v1/forms/Test' ).
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


  ENDMETHOD.


  METHOD rfq.



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
          DATA(ls_body) = VALUE struct(  xdp_template = 'Test/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_qas.
          ls_body = VALUE struct(  xdp_template = 'Test/' && |{ objectid }|
                                               xml_data  = xmldata ).
        WHEN lv_prd.
          ls_body = VALUE struct(  xdp_template = 'Test/' && |{ objectid }|
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

  select requestforquotation, MaterialGroup, purchasingdocumentitemtext, material
  from i_rfqitem_api01
  where requestforquotation = @lv_rfq
  into table @data(ls_item).

  loop at ls_item into data(lv_item).

   wa_item-material = lv_item-Material.
   wa_item-materialgroup = lv_item-MaterialGroup.
    wa_item-purchasingdocumentitemtext = lv_item-PurchasingDocumentItemText.
   wa_item-requestforquotation = lv_item-RequestForQuotation.

  append wa_item to it_item.

  endloop.


   DATA(lo_xml_conv) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_xml10 ).

   CALL TRANSFORMATION zt_rfq    SOURCE it_item = it_item[]
                                       RESULT XML lo_xml_conv.

   DATA(lv_output_xml) = lo_xml_conv->get_output( ).

    DATA(ls_data_xml) = cl_web_http_utility=>encode_x_base64( lv_output_xml ).

    r_xml = ls_data_xml.


  ENDMETHOD.
ENDCLASS.

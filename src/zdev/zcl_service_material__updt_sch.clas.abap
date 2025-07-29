CLASS zcl_service_material__updt_sch DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS update_material.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SERVICE_MATERIAL__UPDT_SCH IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    me->update_material(  ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA  et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
      CATCH cx_apj_rt_content.                          "#EC NO_HANDLER
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD update_material.

    TYPES:
      BEGIN OF ty_layout,
        id TYPE string,
      END OF ty_layout,


      BEGIN OF ty_plant_information,
        _currency___code            TYPE string,
        _price___control___code     TYPE string,
        _taxable___indicator___code TYPE string,
        _profit___center___code     TYPE string,
        _plant___code               TYPE string,
        _control___code             TYPE string,
        _purchase___group___code    TYPE string,
        _valuation___class___code   TYPE string,
      END OF ty_plant_information,

      BEGIN OF ty_organization_information,
        _country___code                    TYPE string,
        _tax___category___4___code         TYPE string,
        _tax___classification__3__code(2),
        _tax___category___6___code         TYPE string,
        _tax___classification__6__code(2),
        _tax___classification__1__code(2),
        _tax___category___1___code         TYPE string,
        _tax___classification__4__code(2),
        _distribution___channel___code     TYPE string,
        _tax___category__3___code          TYPE string,
        _item___category___group__code     TYPE string,
        _tax___category___2___code         TYPE string,
        _tax___classification__2__code(2),
        _tax___category__5___code          TYPE string,
        _tax___classification__5__code(2),
        _acct___assmt___grp__mat__code(10),
      END OF ty_organization_information.


    TYPES: BEGIN OF ty_material,
             _layout                        TYPE  ty_layout,
             _plant___information           TYPE STANDARD TABLE OF ty_plant_information WITH EMPTY KEY,
             _base__unit__of__measure__code TYPE string,
             _material___code               TYPE string,
             _language___key___code         TYPE string,
             _material___type___code        TYPE string,
             _sales___org___code            TYPE string,
             _product___name                TYPE string,
             _sources                       TYPE string,
             _product___status              TYPE string,
             _environment                   TYPE string,
             _organization___information    TYPE STANDARD TABLE OF ty_organization_information WITH EMPTY KEY,
             _material___group___code       TYPE string,
           END OF ty_material.

    DATA: lt_material TYPE TABLE OF ty_material,
          ls_material TYPE ty_material.

    DATA : lv_dev(3) TYPE c VALUE 'N7O',
           lv_qas(3) TYPE c VALUE 'M2S',
           lv_prd(3) TYPE c VALUE 'MLN'.

    TYPES: BEGIN OF ty_jsondata,
             data LIKE lt_material,
           END OF ty_jsondata.

    DATA: wa_jsondata TYPE ty_jsondata.
    DATA lv_json TYPE string.

    DATA: lv_url         TYPE string, "VALUE 'https://glpl-nonprod-apim-02.azure-api.net/Material_Master/Products',
          lo_http_client TYPE REF TO if_web_http_client,
          lv_payload     TYPE string.

    DATA: lt_data TYPE TABLE OF string,
          ls_item TYPE string.

    DATA lr_data TYPE REF TO data.
    DATA : wa_plant TYPE ty_plant_information.
    DATA : wa_org TYPE ty_organization_information.

    TYPES : BEGIN OF ty_errorresult,
              message      TYPE string,
              errormessage TYPE string,
              infodtls     TYPE string,
              status       TYPE string,
              code(3),
              requestid    TYPE string,
            END OF ty_errorresult.

    TYPES : BEGIN OF ty_error,
              results TYPE ty_errorresult,
            END OF ty_error.
    DATA wa_error TYPE ty_error.

    FIELD-SYMBOLS:
      <data>                TYPE data,
      <templates>           TYPE data,
      <templates_result>    TYPE any,
      <metafield_result>    TYPE data,
      <metadata_result>     TYPE data,
      <metadata>            TYPE STANDARD TABLE,
      <pdf_based64_encoded> TYPE any.

    TYPES : BEGIN OF ty_det,
              modi_time TYPE c LENGTH 20,
            END OF ty_det,

            BEGIN OF ty_data,
              code    TYPE c LENGTH 10,
              details TYPE c LENGTH 100,
              message TYPE c LENGTH 30,
              status  TYPE c LENGTH 10,
            END OF ty_data.

    DATA : data TYPE TABLE OF ty_data WITH EMPTY KEY.
    DATA : wa_mat TYPE zmm_material.

    TYPES:BEGIN OF ty_datafin,
            data LIKE data,
          END OF ty_datafin.

    DATA: data1 TYPE STANDARD TABLE OF ty_datafin WITH EMPTY KEY.

    DATA(lv_token) = zoho_ser_mat_token=>tokenmethod( ).

    SELECT product, ismarkedfordeletion, baseunit , producttype, productgroup
       FROM i_product
       WHERE lastchangedate = @sy-datum
       INTO TABLE @DATA(it_data).

    LOOP AT it_data INTO DATA(wa_data).
      SELECT SINGLE matnr, res_matnr
      FROM  zmm_material
      WHERE matnr = @wa_data-product
      INTO  @DATA(lt_mat).

      SELECT matnr, res_matnr, plant, status, msg
      FROM  zmm_material
      WHERE matnr = @wa_data-product
      INTO TABLE @DATA(gt_mat).

      IF lt_mat-res_matnr IS NOT INITIAL.
        SELECT product ,plant, profitcenter, consumptiontaxctrlcode, purchasinggroup , countryoforigin
        FROM i_productplantbasic
        WHERE product = @wa_data-product
        AND ismarkedfordeletion NE 'X'
        INTO TABLE @DATA(lt_plant).

        SELECT product , productdescription, language
          FROM i_productdescription_2
          WHERE product = @wa_data-product
          INTO TABLE @DATA(lt_descr).

        IF lt_plant IS NOT INITIAL.
          SELECT product, productdistributionchnl, itemcategorygroup, accountdetnproductgroup, productsalesorg "#EC NO_HANDLER
          FROM i_productsalesdelivery
          FOR ALL ENTRIES IN @lt_plant
          WHERE product = @lt_plant-product
            AND ismarkedfordeletion NE 'X'
          INTO TABLE @DATA(lt_sales).

          SELECT product, currency , valuationclass, inventoryvaluationprocedure "#EC NO_HANDLER
          FROM i_productvaluationbasic
          FOR ALL ENTRIES IN @lt_plant
          WHERE product = @lt_plant-product
          INTO TABLE @DATA(lt_valuation).

          SELECT product, taxindicator                  "#EC NO_HANDLER
          FROM i_productpurchasetax
          FOR ALL ENTRIES IN @lt_plant
          WHERE product = @lt_plant-product
          INTO TABLE @DATA(lt_purchasetax).

          SELECT product , taxclassification, taxcategory "#EC NO_HANDLER
          FROM i_productsalestax
          FOR ALL ENTRIES IN @lt_plant
          WHERE product = @lt_plant-product
          INTO TABLE @DATA(lt_salestax).
        ENDIF.

        IF  wa_data-ismarkedfordeletion = 'X'.
          DATA(prdct_status) = 'Inactive'.
        ELSE.
          prdct_status = 'Active'.
        ENDIF.

        READ TABLE lt_descr INTO DATA(lw_descr) WITH KEY product = wa_data-product.
        IF sy-subrc = 0.
          ls_material-_product___name = lw_descr-productdescription.
          ls_material-_language___key___code = lw_descr-language.
        ENDIF.

        DATA(lv_count) = lines( lt_plant ).
        SHIFT wa_data-product LEFT DELETING LEADING '0'.

        CASE sy-sysid.
            WHEN lv_dev.
              ls_material-_layout-id = '723303000000000177'.
            WHEN lv_qas.
              ls_material-_layout-id = '723303000000000177'.
            WHEN lv_prd.
              ls_material-_layout-id = '726575000000000177'.
          ENDCASE.

        ls_material-_material___code = wa_data-product.
        ls_material-_base__unit__of__measure__code = wa_data-baseunit.
        ls_material-_material___type___code = wa_data-producttype.
        ls_material-_sources = 'SAP'.
        ls_material-_product___status = prdct_status.

        CASE sy-sysid.
          WHEN lv_dev.
            ls_material-_environment = 'DEV'.
          WHEN lv_qas.
            ls_material-_environment = 'QAS'.
          WHEN lv_prd.
            ls_material-_environment = 'PROD'.
        ENDCASE.

        DATA(lv_product)  = wa_data-product. .
        CLEAR wa_data-product.
        wa_data-product = |000000000{ lv_product }|.
        LOOP AT lt_plant INTO DATA(wa_data1) WHERE product = wa_data-product.
          wa_plant-_plant___code = wa_data1-plant.
          wa_plant-_profit___center___code = wa_data1-profitcenter.
          wa_plant-_plant___code = wa_data1-plant.
          wa_plant-_control___code = wa_data1-consumptiontaxctrlcode.
          wa_plant-_purchase___group___code = wa_data1-purchasinggroup.
*             wa_plant-_layout-id = '723303000001320733'.

          READ TABLE lt_valuation INTO DATA(lw_valuation) WITH KEY product = wa_data1-product.
          IF sy-subrc = 0.
            wa_plant-_currency___code = lw_valuation-currency.
            wa_plant-_price___control___code = lw_valuation-inventoryvaluationprocedure.
            wa_plant-_valuation___class___code = lw_valuation-valuationclass.
          ENDIF.

          READ TABLE lt_purchasetax INTO DATA(lw_purchasetax) WITH KEY product = wa_data1-product.
          IF sy-subrc = 0.
            wa_plant-_taxable___indicator___code = lw_purchasetax-taxindicator.
          ENDIF.
          APPEND wa_plant TO ls_material-_plant___information.
          CLEAR : wa_data1,  lw_valuation, lw_purchasetax.
        ENDLOOP.

        LOOP AT lt_sales INTO DATA(lw_sales) WHERE product = wa_data-product.
          wa_org-_distribution___channel___code = lw_sales-productdistributionchnl.
          wa_org-_item___category___group__code = lw_sales-itemcategorygroup.
          wa_org-_acct___assmt___grp__mat__code = lw_sales-accountdetnproductgroup.
          wa_org-_country___code = 'IN'.
          ls_material-_sales___org___code = lw_sales-productsalesorg.

          LOOP AT lt_salestax INTO DATA(lw_salestax) WHERE product = wa_data-product.
            CASE lw_salestax-taxcategory.
              WHEN 'JOUG'.
                wa_org-_tax___category___4___code = lw_salestax-taxcategory.
                wa_org-_tax___classification__4__code = lw_salestax-taxclassification.
              WHEN  'JOSG'.
                wa_org-_tax___category__3___code = lw_salestax-taxcategory.
                wa_org-_tax___classification__3__code = lw_salestax-taxclassification.
              WHEN  'JTC1'.
                wa_org-_tax___category___6___code = lw_salestax-taxcategory.
                wa_org-_tax___classification__6__code = lw_salestax-taxclassification.
              WHEN  'JOIG'.
                wa_org-_tax___classification__1__code = lw_salestax-taxclassification.
                wa_org-_tax___category___1___code       = lw_salestax-taxcategory.
              WHEN 'JOCG'.
                wa_org-_tax___category___2___code = lw_salestax-taxcategory.
                wa_org-_tax___classification__2__code = lw_salestax-taxclassification.
              WHEN 'JCOS'.
                wa_org-_tax___category__5___code = lw_salestax-taxcategory.
                wa_org-_tax___classification__5__code = lw_salestax-taxclassification.
            ENDCASE.
            CLEAR lw_salestax.
          ENDLOOP.
          APPEND  wa_org TO ls_material-_organization___information.
          CLEAR : lw_sales, lw_salestax, wa_org.
        ENDLOOP.
        SHIFT wa_data-product LEFT DELETING LEADING '0'.

        ls_material-_material___group___code = wa_data-productgroup.

        APPEND ls_material TO lt_material.
        MOVE-CORRESPONDING lt_material TO wa_jsondata-data.

        lv_json = /ui2/cl_json=>serialize(     data         = wa_jsondata
                                               compress     = abap_false
                                               pretty_name  = /ui2/cl_json=>pretty_mode-camel_case ).

        DO lv_count TIMES.
          REPLACE 'Acct_Assmt_Grp_mat_code'    IN lv_json WITH 'Acct_Assmt_Grp_Mat_Code'.
          REPLACE 'Item_Category_Group_code'   IN lv_json WITH 'Item_Category_Group_Code'.
          REPLACE 'Base_unit_of_measure_code'  IN lv_json WITH 'Base_Unit_of_Measure_Code'.
          REPLACE 'Tax_Classification_1_code'  IN lv_json WITH 'Tax_Classification_1_Code'.
          REPLACE 'Tax_Classification_2_code'  IN lv_json WITH 'Tax_Classification_2_Code'.
          REPLACE 'Tax_Classification_3_code'  IN lv_json WITH 'Tax_Classification_3_Code'.
          REPLACE 'Tax_Classification_4_code'  IN lv_json WITH 'Tax_Classification_4_Code'.
          REPLACE 'Tax_Classification_5_code'  IN lv_json WITH 'Tax_Classification_5_Code'.
          REPLACE 'Tax_Classification_6_code'  IN lv_json WITH 'Tax_Classification_6_Code'.
        ENDDO.


        DATA lv_sub TYPE string.
        CASE sy-sysid.
          WHEN lv_dev.
            lv_url  = 'https://glpl-nonprod-apim-02.azure-api.net/Material_Master/Products'.
            lv_sub = '3f3c78ff8cad477c831527f03f71a041' .
          WHEN lv_qas.
            lv_url  = 'https://glpl-nonprod-apim-02.azure-api.net/Material_Master/Products'.
            lv_sub = '3f3c78ff8cad477c831527f03f71a041' .
          WHEN lv_prd.
            lv_url  = 'https://glpl-prod-apim-02.azure-api.net/Material_Master/Products'.
            lv_sub = '90dee5bd8a9d415c924fa4dc008d91ee'.
        ENDCASE.

        CONCATENATE  lv_url  '/'  lt_mat-res_matnr  INTO DATA(gv_url).

        TRY.
            lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
            i_destination = cl_http_destination_provider=>create_by_url( gv_url ) ).
          CATCH cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.

        DATA(lo_request) = lo_http_client->get_http_request( ).

        lo_request->set_header_fields(
        VALUE #(
                ( name = 'Content-Type'  value = 'application/json' )
                ( name = 'Cache-Control' value = 'no-cache' )
                ( name = 'Ocp-Apim-Subscription-Key' value =   lv_sub )
                ( name = 'Authorization' value = lv_token )
               ) ).


        lo_request->append_text(
              EXPORTING
                data   = lv_json
            ).

        TRY.
            DATA(lv_response) = lo_http_client->execute(
                                i_method  = if_web_http_client=>put ).
          CATCH cx_web_message_error cx_web_http_client_error cx_http_dest_provider_error. "#EC NO_HANDLER
        ENDTRY.
        DATA(status) = lv_response->get_status( ).
        DATA(lv_response_text) = lv_response->get_text( ).

        CALL METHOD /ui2/cl_json=>deserialize(
          EXPORTING
            pretty_name = /ui2/cl_json=>pretty_mode-camel_case
          CHANGING
            data        = data
        ).

        lr_data = /ui2/cl_json=>generate( json = lv_response_text  pretty_name  = /ui2/cl_json=>pretty_mode-user ).

        ASSIGN lr_data->* TO <data>.
        IF <data> IS ASSIGNED.
          ASSIGN COMPONENT 'DATA' OF STRUCTURE <data> TO <templates>.
          IF <templates> IS ASSIGNED.
            ASSIGN <templates>->* TO <templates_result>.
          ENDIF.
          IF <templates_result> IS ASSIGNED.
            ASSIGN <templates_result> TO <metadata>.
          ENDIF.
          IF <metadata> IS ASSIGNED.
            READ TABLE <metadata> ASSIGNING FIELD-SYMBOL(<metafield>) INDEX 1.
          ENDIF.
          IF <metafield> IS ASSIGNED.
            ASSIGN <metafield>->* TO <metafield_result>.
          ENDIF.
          IF <metafield_result> IS ASSIGNED.
            ASSIGN COMPONENT 'DETAILS' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata1>).
          ENDIF.
          IF <mdata1> IS ASSIGNED.
            ASSIGN <mdata1>->* TO FIELD-SYMBOL(<mdata_result1>).
          ENDIF.

          IF <mdata_result1> IS ASSIGNED.
            ASSIGN COMPONENT 'ID' OF STRUCTURE <mdata_result1> TO FIELD-SYMBOL(<mdata2>).
          ENDIF.
          IF <mdata2> IS ASSIGNED.
            ASSIGN <mdata2>->* TO FIELD-SYMBOL(<mdata_result2>).
          ENDIF.
          IF <metafield_result> IS ASSIGNED.
            ASSIGN COMPONENT 'STATUS' OF STRUCTURE <metafield_result> TO FIELD-SYMBOL(<mdata3>).
          ENDIF.
          IF <mdata3> IS ASSIGNED.
            ASSIGN <mdata3>->* TO FIELD-SYMBOL(<mdata_result3>).
          ENDIF.
        ENDIF.

        IF <mdata_result3> IS ASSIGNED.
          IF <mdata_result3> EQ 'success'.
            IF <mdata_result2> IS ASSIGNED.
              LOOP AT lt_plant INTO DATA(w_plant).
                wa_mat-matnr         = w_plant-product.
                wa_mat-plant         = w_plant-plant.
                wa_mat-updatedate     = sy-datum.
                wa_mat-updatetime     = sy-uzeit.
                wa_mat-flag           = 'U'.
                wa_mat-res_matnr     = <mdata_result2>.
                wa_mat-status        = '200'.
                wa_mat-msg           = 'Material Code Update Successfully'.
*                wa_mat-matnr = |{ wa_mat-matnr ALPHA = IN }|.
*                insert zmm_material FROM @wa_mat.
                UPDATE zmm_material SET status = @wa_mat-status, updatedate = @wa_mat-updatedate,
                                                  updatetime = @wa_mat-updatetime, flag = @wa_mat-flag, msg = @wa_mat-msg
                                                  WHERE matnr = @w_plant-product.
                CLEAR : wa_mat, w_plant.
              ENDLOOP.
              CLEAR <mdata_result2>.
            ENDIF.
          ELSE.
            IF <mdata_result2> IS ASSIGNED.
              LOOP AT lt_plant INTO w_plant.
                wa_mat-matnr         = w_plant-product.
                wa_mat-plant         = w_plant-plant.
                wa_mat-updatedate     = sy-datum.
                wa_mat-updatetime     = sy-uzeit.
                wa_mat-flag          = 'U'.
                wa_mat-res_matnr     = <mdata_result2>.
                wa_mat-status        = '202'.
                wa_mat-msg           = 'Material Code Not Updated Successfully'.
*                wa_mat-matnr = |{ wa_mat-matnr ALPHA = IN }|.
                UPDATE zmm_material SET status = @wa_mat-status, updatedate = @wa_mat-updatedate,
                                         updatetime = @wa_mat-updatetime, flag = @wa_mat-flag, msg = @wa_mat-msg
                                          WHERE matnr = @w_plant-product.
                CLEAR : wa_mat,  w_plant.
              ENDLOOP.
              CLEAR : <mdata_result2>.
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR : wa_data,  lv_payload, lo_request, lv_token, status, lv_response, lv_response_text, lr_data,
                wa_mat,  gv_url, ls_material,ls_material, lt_purchasetax, lt_salestax, lt_descr, lw_descr,
                wa_jsondata-data, lt_material, lv_json, lv_count, lt_plant, lt_sales, lt_valuation,
                 lt_mat, gt_mat.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

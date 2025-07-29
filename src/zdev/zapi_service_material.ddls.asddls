@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service material API'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZAPI_SERVICE_MATERIAL
  //  as select distinct from I_Product as i
  // // left outer join I_ProductPlantBasic as y on i.Product = y.Product
  //  association to zmm_material            as z    on  i.Product = z.matnr
  //                                       //     and z.plant = y.Plant
  //  association to I_ProductDescription_2  as j    on  i.Product = j.Product
  //  association [0..*] to I_ProductPlantBasic     as k    on  i.Product = k.Product
  //  association to I_ProductSalesTax       as l    on  i.Product = l.Product
  //  association to I_ProductSalesTax       as JOIG on  i.Product        = JOIG.Product
  //                                                 and JOIG.TaxCategory = 'JOIG'
  //  association to I_ProductSalesTax       as JOCG on  i.Product        = JOCG.Product
  //                                                 and JOCG.TaxCategory = 'JOCG'
  //  association to I_ProductSalesTax       as JOSG on  i.Product        = JOSG.Product
  //                                                 and JOSG.TaxCategory = 'JOSG'
  //  association to I_ProductSalesTax       as JOUG on  i.Product        = JOUG.Product
  //                                                 and JOUG.TaxCategory = 'JOUG'
  //   association to I_ProductSalesTax      as JCOS on  i.Product        = JCOS.Product
  //                                                 and JCOS.TaxCategory = 'JCOS'
  //   association to I_ProductSalesTax      as JTC1 on  i.Product        = JTC1.Product
  //                                                 and JTC1.TaxCategory = 'JTC1'
  //  association to I_ProductSalesDelivery  as m    on  i.Product = m.Product
  //  association to I_ProductValuationBasic as n    on  i.Product = n.Product
  //  association to I_ProductPurchaseTax    as o    on  i.Product = o.Product

  as select distinct from I_ProductPlantBasic as i
  association        to zmm_material            as z    on  i.Product = z.matnr
                                                        and i.Plant   = z.plant
  association        to I_ProductDescription_2  as j    on  i.Product = j.Product
  association [0..*] to I_Product               as k    on  i.Product = k.Product
  association        to I_ProductSalesTax       as l    on  i.Product = l.Product
  association        to I_ProductSalesTax       as JOIG on  i.Product        = JOIG.Product
                                                        and JOIG.TaxCategory = 'JOIG'
  association        to I_ProductSalesTax       as JOCG on  i.Product        = JOCG.Product
                                                        and JOCG.TaxCategory = 'JOCG'
  association        to I_ProductSalesTax       as JOSG on  i.Product        = JOSG.Product
                                                        and JOSG.TaxCategory = 'JOSG'
  association        to I_ProductSalesTax       as JOUG on  i.Product        = JOUG.Product
                                                        and JOUG.TaxCategory = 'JOUG'
  association        to I_ProductSalesTax       as JCOS on  i.Product        = JCOS.Product
                                                        and JCOS.TaxCategory = 'JCOS'
  association        to I_ProductSalesTax       as JTC1 on  i.Product        = JTC1.Product
                                                        and JTC1.TaxCategory = 'JTC1'
  association        to I_ProductSalesDelivery  as m    on  i.Product = m.Product
  association        to I_ProductValuationBasic as n    on  i.Product = n.Product
  association        to I_ProductPurchaseTax    as o    on  i.Product = o.Product


{

         @UI.facet                : [
                           {
                             id         :  'Product',
                             purpose    :  #STANDARD,
                             type       :     #IDENTIFICATION_REFERENCE,
                             label      : 'Sevice Material',
                             position   : 10 }
                         ]

         @UI.lineItem: [{ position: 10 }, { type: #FOR_ACTION , dataAction: 'CreateMaterial' , label: 'CreateMaterial' } ]
         @UI.identification: [{ position: 10 }]
         @UI.selectionField: [{ position: 10 }]

         //  key ltrim(i.Product,'0')    as PRODUCT,

  key    i.Product,

         @UI.lineItem: [{ position: 20 }]
         @UI.identification: [{ position: 20 }]
         @UI.selectionField: [{ position: 20 }]
  key    i[ inner ].Plant,

         @UI.lineItem: [{ position: 260 }]
         @UI.identification: [{ position: 260 }]
  key    m.ProductSalesOrg,

         @UI.lineItem: [{ position: 270 }]
         @UI.identification: [{ position: 270 }]
  key    m.ProductDistributionChnl,

         @UI.lineItem: [{ position: 30 }]
         @UI.identification: [{ position: 30 }]
         z.res_matnr            as Zoho_Material,


         @UI.lineItem: [{ position: 40 }]
         @UI.identification: [{ position: 40 }]


         case
         when z.flag = 'C'
            then
            case
         //Error correction in same day
            when z.status = '202' and z.msg is not initial and k.CreationDate = z.createdate and k.LastChangeTime > z.createtime
             then '200'
         //Error correction next of material creation in standard app
            when z.status = '202' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime < z.createtime
             then z.status

         //Error correction next of material creation in standard app
            when z.status = '202' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime > z.createtime
             then '200'


         //Multiple Updates in same day
            when z.status = '201' and z.msg is not initial and k.CreationDate = z.createdate and k.LastChangeTime > z.createtime
             then '200'


         //Error correction next of material creation in standard app
            when z.status = '201' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime > z.createtime
             then '200'


         //Error correction next of material creation in standard app
            when z.status = '201' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime < z.createtime
             then z.status


            when z.status = '201' and z.res_matnr is not initial
              then '201'
             when z.status = '202' and z.res_matnr is initial and z.msg is not initial
             then '202'
             else '200'
            end

         when z.flag = 'U'
          then
            case
              when z.status = '200' and k.LastChangeDate = z.updatedate and k.LastChangeTime > z.updatetime
              then '200'

              when z.status = '200' and k.LastChangeDate > z.updatedate and ( k.LastChangeTime > z.updatetime or k.LastChangeTime < z.updatetime )
              then '200'

              when z.status = '200' and z.res_matnr is not initial and z.msg is not initial
              then '201'
              else '200'
            end
         else '200'
         end                    as Status,


         @UI.lineItem: [{ position: 50 }]
         @UI.identification: [{ position: 50 }]

         case
         when z.flag = 'C'
            then
            case
         //Error correction in same day
            when z.status = '202' and z.msg is not initial and k.CreationDate = z.createdate and k.LastChangeTime > z.createtime
             then 'To be created in ZOHO'

         //Error correction next of material creation in standard app
            when z.status = '202' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime < z.createtime
             then z.msg

         //Error correction next of material creation in standard app
            when z.status = '202' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime > z.createtime
             then 'To be created in ZOHO'


         //Multiple Updates in same day
            when z.status = '201' and z.msg is not initial and k.CreationDate = z.createdate and k.LastChangeTime > z.createtime
             then 'To be Updated in ZOHO'


         //Error correction next of material creation in standard app
            when z.status = '201' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime > z.createtime
             then 'To be Updated in ZOHO'


         //Error correction next of material creation in standard app
            when z.status = '201' and z.msg is not initial and k.LastChangeDate >= z.createdate and
                                                               k.LastChangeTime < z.createtime
             then z.msg


         //Material Created Sucessfully - Message in O/p
            when z.status = '201' and z.res_matnr is not initial
              then 'Created in ZOHO Successfully'

         //Error message in Output
             when z.status = '202' and z.res_matnr is initial and z.msg is not initial
             then z.msg
             else ' '
            end

         when z.flag = 'U'
          then
            case
         //Again in same day update in standard app after successfull material create in ZOHO
              when z.status = '200' and k.LastChangeDate = z.updatedate and k.LastChangeTime > z.updatetime
              then 'To be Updated in ZOHO'

         //Again in Next day update in standard app after successfull material create in ZOHO
              when z.status = '200' and k.LastChangeDate > z.updatedate and ( k.LastChangeTime > z.updatetime or k.LastChangeTime < z.updatetime )
              then 'To be Updated in ZOHO'

              when z.status = '200' and z.res_matnr is not initial and z.msg is not initial
              then 'Updated in ZOHO Successfully'
             else ' '
            end

         //Initial Material Create/Update before ZOHO-CREATE/UPDATE Method
         else 'To be Created in ZOHO'
         end                    as Message,


         @UI: { lineItem:       [ { hidden: true } ],
              identification: [ { hidden: true } ] }
         z.flag,


         @UI.lineItem: [{ position: 20 }, { type: #FOR_ACTION , dataAction: 'UpdateMaterial' , label: 'UpdateMaterial' } ]
         @UI.identification: [{ position: 60 }]
         @UI.selectionField: [{ position: 30 }]
         k.ProductType,

         @UI.lineItem: [{ position: 70 }]
         @UI.identification: [{ position: 70 }]
         k.BaseUnit,

         @UI.lineItem: [{ position: 80 }]
         @UI.identification: [{ position: 80 }]
         k.ProductGroup,

         @UI.lineItem: [{ position: 90 }]
         @UI.identification: [{ position: 90 }]
         m.ItemCategoryGroup,

         @UI.lineItem: [{ position: 100 }]
         @UI.identification: [{ position: 100 }]
         j.Language,

         @UI.lineItem: [{ position: 110 }]
         @UI.identification: [{ position: 110 }]
         j.ProductDescription,

         //  @UI.lineItem: [{ position: 110 }]
         //  @UI.identification: [{ position: 110 }]
         //  k.Plant,

         @UI.lineItem: [{ position: 120 }]
         @UI.identification: [{ position: 120 }]
         i.PurchasingGroup,

         @UI.lineItem: [{ position: 130 }]
         @UI.identification: [{ position: 130 }]
         i.CountryOfOrigin,

         @UI.lineItem: [{ position: 140 }]
         @UI.identification: [{ position: 140 }]
         i.ProfitCenter,

         @UI.lineItem: [{ position: 150 }]
         @UI.identification: [{ position: 150 }]
         i.ConsumptionTaxCtrlCode,


         @UI.lineItem: [{ position: 160 }]
         @UI.identification: [{ position: 160 }]
         JOIG.TaxCategory       as TaxCategory_1,

         @UI.lineItem: [{ position: 170 }]
         @UI.identification: [{ position: 170 }]
         JOIG.TaxClassification as TaxClassification_1,


         @UI.lineItem: [{ position: 180 }]
         @UI.identification: [{ position: 180 }]
         JOCG.TaxCategory       as TaxCategory_2,

         @UI.lineItem: [{ position: 190 }]
         @UI.identification: [{ position: 190 }]
         JOCG.TaxClassification as TaxClassification_2,

         @UI.lineItem: [{ position: 200 }]
         @UI.identification: [{ position: 200 }]
         JOSG.TaxCategory       as TaxCategory_3,

         @UI.lineItem: [{ position: 210 }]
         @UI.identification: [{ position: 210 }]
         JOSG.TaxClassification as TaxClassification_3,

         @UI.lineItem: [{ position: 220 }]
         @UI.identification: [{ position: 220 }]
         JOUG.TaxCategory       as TaxCategory_4,

         @UI.lineItem: [{ position: 210 }]
         @UI.identification: [{ position: 210 }]
         JOUG.TaxClassification as TaxClassification_4,

         @UI.lineItem: [{ position: 220 }]
         @UI.identification: [{ position: 220 }]
         JCOS.TaxCategory       as TaxCategory_5,

         @UI.lineItem: [{ position: 230 }]
         @UI.identification: [{ position: 230 }]
         JCOS.TaxClassification as TaxClassification_5,

         @UI.lineItem: [{ position: 240 }]
         @UI.identification: [{ position: 240 }]
         JTC1.TaxCategory       as TaxCategory_6,

         @UI.lineItem: [{ position: 250 }]
         @UI.identification: [{ position: 250 }]
         JTC1.TaxClassification as TaxClassification_6,

         //      @UI.lineItem: [{ position: 260 }]
         //      @UI.identification: [{ position: 260 }]
         //      m.ProductSalesOrg,

         //      @UI.lineItem: [{ position: 270 }]
         //      @UI.identification: [{ position: 270 }]
         //      m.ProductDistributionChnl,

         @UI.lineItem: [{ position: 280 }]
         @UI.identification: [{ position: 280 }]
         m.AccountDetnProductGroup,

         @UI.lineItem: [{ position: 290 }]
         @UI.identification: [{ position: 290 }]
         n.ValuationClass,

         @UI.lineItem: [{ position: 300 }]
         @UI.identification: [{ position: 300 }]
         n.Currency,

         @UI.lineItem: [{ position: 310 }]
         @UI.identification: [{ position: 310 }]
         n.InventoryValuationProcedure,

         @UI.lineItem: [{ position: 320 }]
         @UI.identification: [{ position: 320 }]
         o.TaxIndicator,

         @UI.lineItem: [{ position: 330 }]
         @UI.identification: [{ position: 330 }]
         i.IsMarkedForDeletion











}

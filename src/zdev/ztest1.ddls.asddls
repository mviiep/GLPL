@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ztest1
  as select from zdb_asset_master as asset
  association[0..1] to I_JournalEntryItem as i on asset.fixedasset = i.AccountingDocument



{
        @UI.facet           : [
       {
         id               : 'FacetControlHeader',
         label            : 'Test',
         type             : #IDENTIFICATION_REFERENCE,
         purpose          : #STANDARD,
         position         : 10
         //targetQualifier  : 'Collection_HEADER'
       }
      ]



      @UI                 : {lineItem: [{ position: 5,label: 'Fixedasset' }  ]}
      @UI.identification: [{ position: 5, label: 'Fixedasset' }]
      
      // @UI                 : {identification: [{  position: 5,label: 'Fixedasset', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
      @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'Fixedasset'
  key fixedasset       as Fixedasset,

      @UI                 : {lineItem: [{ position: 6,label: 'Zohoassetcode' }]}
            //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
          //  @UI.selectionField  : [ { position: 10}]
       @UI.identification: [{ position: 15, label: 'Zohoassetcode' }]
      @EndUserText.label  : 'Zohoassetcode'
      zohoassetcode    as Zohoassetcode,

      @UI                 : {lineItem: [{ position: 7,label: 'CustomerID' }]}
            //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
         //   @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'CustomerID'
      creationdate     as Creationdate,

      @UI                 : {lineItem: [{ position: 8,label: 'Creationdatetime' }]}
            //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
        //    @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'Creationdatetime'
      creationdatetime as Creationdatetime,

      @UI                 : {lineItem: [{ position: 9,label: 'Updateddate' }]}
            //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
         //   @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'Updateddate'
      updateddate      as Updateddate,

      @UI                 : {lineItem: [{ position: 15,label: 'Updateddatetime' }]}
            //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
          //  @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'Updateddatetime'
      updateddatetime  as Updateddatetime,

      @UI                 : {lineItem: [{ position: 25,label: 'Flag' }]}
            //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
          //  @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
         //   @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'Flag'
      flag             as Flag
  //    i._BusinessAreaText,
      
   //   i

}

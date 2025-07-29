@ObjectModel.query.implementedBy: 'ABAP:ZCL_COLLECTION_RPT'
@EndUserText.label: 'Collection Report'
define custom entity zc_collection_rpt
{
      @UI.facet      : [

                        {
      //          id              : '_CHILD',
               purpose         : #STANDARD,
               position        :  1,
               label : 'Collection Report',
               type  :  #LINEITEM_REFERENCE
      //          targetElement   : '_CHILD'
          }

                    ]
      @Consumption.filter.mandatory: true
      @UI            : {
      //      lineItem            : [{position: 0, importance: #HIGH}],
      identification : [{position: 10}],
      selectionField : [{position: 10}]}
      @EndUserText.label  : 'Fiscal year'
      @Consumption.filter: {
      selectionType  : #SINGLE,
            multipleSelections: false
            }
      @Consumption.valueHelpDefinition: [{ entity:
      {name          : 'ZVH_YEAR' , element: 'FiscalYear' },
      distinctValues : true
      }]
      //@consumpion.
  key fiscalyear     : abap.char(4);
      @Consumption.filter.mandatory: true
      @UI            : {
      //      lineItem            : [{position: 0, importance: #HIGH}],
         identification      : [{position: 20}],
         selectionField      : [{position: 20}]}
      @EndUserText.label  : 'Month'
      @Consumption.filter: {
      selectionType  : #SINGLE,
           multipleSelections: false
           }
      @Consumption.valueHelpDefinition: [{ entity:
        {name        : 'ZVH_MONTH' , element: 'value_low' } ,
        distinctValues: true
        }]
      //        @Semantics.amount.currencyCode: '
  key month1         : abap.char(15);

      @UI            : {
               lineItem            : [{position: 30, importance: #HIGH}],
         identification      : [{position: 30}]}
      @EndUserText.label  : 'Profit Center'

  key profitcenter   : abap.char( 40 );

//      @UI            : {
//              lineItem    : [{position: 40, importance: #HIGH}],
//           identification : [{position: 40}]}
//      @EndUserText.label  : 'Opening O/S Within DueDate'
      //      @Semantics.amount.currencyCode: ''
      //@Semantics: { amount : {currencyCode: 'Currency_Code'} }
      Currency_Code  : abap.cuky( 5 );

      @UI            : {
         lineItem    : [{position: 40, importance: #HIGH}],
      identification : [{position: 40}]}
      @EndUserText.label  : 'Opening O/S Within DueDate'
      @Semantics.amount.currencyCode: 'Currency_Code'

      open_withindd  : abap.curr( 16 , 2 );

      @UI            : {
            lineItem : [{position: 50, importance: #HIGH}],
      identification : [{position: 50}]}
      @EndUserText.label  : 'Opening O/S Beyond DueDate'
      @Semantics.amount.currencyCode: 'Currency_Code'

      open_beyonddd  : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 60, importance: #HIGH}],
      identification : [{position: 60}]}
      @EndUserText.label  : 'Billing During the Month'
      @Semantics.amount.currencyCode: 'Currency_Code'

      bill_month     : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 70, importance: #HIGH}],
      identification : [{position: 70}]}
      @EndUserText.label  : 'Received During the Month'
      @Semantics.amount.currencyCode: 'Currency_Code'

      rec_month      : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 80, importance: #HIGH}],
      identification : [{position: 80}]}
      @EndUserText.label  : 'Closing O/S Within DueDate'
      @Semantics.amount.currencyCode: 'Currency_Code'

      close_withindd : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 90, importance: #HIGH}],
      identification : [{position: 90}]}
      @EndUserText.label  : 'CLosing O/S Beyond DueDate'
      @Semantics.amount.currencyCode: 'Currency_Code'

      close_beyonddd : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 100, importance: #HIGH}],
      identification : [{position: 100}]}
      @EndUserText.label  : 'Outstanding 0 to 30 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'

      days_0_to_30   : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 110, importance: #HIGH}],
      identification : [{position: 110}]}
      @EndUserText.label  : 'Outstanding 31 to 60 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'

      days_31_to_60  : abap.curr( 16, 2 );

      @UI            : {
            lineItem : [{position: 120, importance: #HIGH}],
      identification : [{position: 120}]}
      @EndUserText.label  : 'Outstanding 61 to 90 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'

      days_61_to_90  : abap.curr( 16, 2 );
      @UI            : {
            lineItem : [{position: 130, importance: #HIGH}],
      identification : [{position: 130}]}
      @EndUserText.label  : 'Outstanding > 90 Days'
      @Semantics.amount.currencyCode: 'Currency_Code'

      days_91        : abap.curr( 16, 2 );

}

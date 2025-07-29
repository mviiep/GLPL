@EndUserText.label: 'ztest2'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_TEST2'
define custom entity ztest2
  // with parameters parameter_name : parameter_type
{



      @UI.facet        : [
       {
         id            : 'FacetControlHeader',
         label         : 'Collection Information',
         type          : #IDENTIFICATION_REFERENCE,
         purpose       : #STANDARD,
         position      : 10
       }
      ]

      @UI              : {lineItem: [{ position: 5,label: 'CustomerID' }]}
      @UI              : {identification: [{  position: 5,label: 'CustomerID' }] }

      @EndUserText.label  : 'CustomerID'
  key cust_id          : abap.char(10);

      @UI              : {lineItem: [{ position: 15,label: 'weekstatus' }]}
      @UI              : {identification: [{  position: 15,label: 'weekstatus' }] }

      @EndUserText.label  : 'weekstatus'
  key weekstatus       : abap.char( 6 );

      @UI              : {lineItem: [{ position: 25,label: 'accountingnumber' }]}
      @UI              : {identification: [{  position: 25,label: 'accountingnumber' }] }

      @EndUserText.label  : 'accountingnumber'
  key accountingnumber : abap.char( 10 );
}

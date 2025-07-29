@EndUserText.label: 'MSME Report'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FI_MSME_REPORT'


define root custom entity ZFI_MSME_REPORT

{
      //****  @UI                  :{lineItem: [{ position: 10,label: 'Supplier' }]}

      @UI.facet: [
                        {
                          id         :  'MSME',
                          purpose    :  #STANDARD,
                          type       :     #IDENTIFICATION_REFERENCE,
                          label      : 'Sevice Material',
                          position   : 10 }
                      ]

      @UI      : {lineItem: [{ position: 10,label: 'Sr.No'  },{ type: #FOR_ACTION , dataAction: 'Zcomments' , label: 'Remark' }  ]}
     // @UI                 :{lineItem: [{ position: 20,label: 'SNO'  }]}

      @UI.identification: [{ position: 10 }]
  key SNO      : lifnr;
      @UI      : {  lineItem: [ { position: 20 } ],
          identification: [ { position:20 } ],
          selectionField: [ { position:1  } ] }
           //@Consumption.filter.mandatory: true
      @EndUserText.label: 'Supplier'
  key SUPPLIER : lifnr;

      @UI      : {lineItem: [{ position: 30,label: 'Name of MSE Supplier' }]}
      @UI.identification: [{ position: 30 }]
      BP       : zchar40;
      
      @UI      : {lineItem: [{ position: 40,label: 'PAN of the Supplier' }]}
      @UI.identification: [{ position: 40 }]
      pan      : zchar40;
      
      @UI      : {lineItem: [{ position: 50,label: 'No.Items paid within 45 days' }]}
      @UI.identification: [{ position: 50 }]
      No1      : lifnr;
      
      @UI      : {lineItem: [{ position: 60,label: 'Sum of Amt paid within 45 days' }]}
      @UI.identification: [{ position: 60 }]
      Amt1     : znetwr;

      @UI      : {lineItem: [{ position: 70,label: 'No.Items paid after 45 days' }]}
      @UI.identification: [{ position: 70 }]
      No2      : lifnr;
      
      @UI      : {lineItem: [{ position: 80,label: 'Sum of Amt paid after 45 days' }]}
      @UI.identification: [{ position: 80 }]
      Amt2     : znetwr;

      @UI      : {lineItem: [{ position: 90,label: 'No.Items Outstanding within 45 days' }]}
      @UI.identification: [{ position: 90 }]
      No3      : lifnr;
      @UI      : {lineItem: [{ position: 100,label: 'Amt Outstanding within 45 days' }]}
      @UI.identification: [{ position: 100 }]
      Amt3     : znetwr;

      @UI      : {lineItem: [{ position: 110,label: 'No.Items Outstanding after 45 days' }]}
      @UI.identification: [{ position: 110 }]
      No4      : lifnr;
      
      @UI      : {lineItem: [{ position: 120,label: 'Amt Outstanding after 45 days' }]}
      @UI.identification: [{ position: 120 }]
      Amt4     : znetwr;
      
      @UI      : {lineItem: [{ position: 130,label: 'Comment' }]}
      @UI.identification: [{ position: 130 }]
      zcomment : zcomment;










}

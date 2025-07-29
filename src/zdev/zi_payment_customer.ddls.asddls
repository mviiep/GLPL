@EndUserText.label: 'Consumption view of Customer payment'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_FI_MSME_REPORT'

    

define root custom entity ZI_PAYMENT_CUSTOMER
{
  
 @UI.facet                : [
                        {
                          id         :  'Customer Payment',
                          purpose    :  #STANDARD,
                          type       :     #IDENTIFICATION_REFERENCE,
                          label      : 'Sevice Material',
                          position   : 10 }
                      ]
      
          @UI: {  lineItem: [ { position: 10 } ],
              identification: [ { position:10 } ],
              selectionField: [ { position:2  } ] }
               @Consumption.filter.mandatory: true
               @EndUserText.label: 'Customer ID'
               
 key   customerid      :kunnr;      
               
               
               @UI: {  lineItem: [ { position: 20 } ],
              identification: [ { position:20 } ] }
              
               @EndUserText.label: 'Supplier' 
    SUPPLIER                   :lifnr;
    
      
               @UI: {  lineItem: [ { position: 30 } ],
              identification: [ { position:30 } ] }
               @EndUserText.label: 'Acc.Doc.No' 
     accdocno: belnr_d;
      @UI: {  lineItem: [ { position: 40 } ],
              identification: [ { position:40 } ] }
                   @EndUserText.label: 'Inv.No' 
    InvNo :vbeln;
    
  @UI: {  lineItem: [ { position: 50 } ],
              identification: [ { position:50 } ] }
                   @EndUserText.label: 'Inv.Date'    
                   
     INVdate  :bldat;
            
   @UI: {  lineItem: [ { position: 60 } ],
           identification: [ { position:60 } ] }
             @EndUserText.label: 'O/S amount'  
             
             
       Amt              :znetwr;
                   
                     
                   
                      
}

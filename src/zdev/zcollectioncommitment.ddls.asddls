@EndUserText.label: 'custom entity for collection commitment'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_COLLECTIONCOMMITMENT'
//@VDM.viewType: #TRANSACTIONAL
@UI.headerInfo: { typeName: 'Collection Report' ,
                  typeNamePlural: 'Collection Reports' ,
                  title: { type: #STANDARD , value: 'accountingnumber'}
                //  description: { type: #STANDARD, value: 'MaterialName //c

                   }
define root custom entity zcollectioncommitment
  // with parameters parameter_name : parameter_type


{
      @UI.facet           : [
       {
         id               : 'FacetControlHeader',
         label            : 'Collection Information',
         type             : #FIELDGROUP_REFERENCE,
         purpose          : #STANDARD,
         position         : 10,
         targetQualifier  : 'Collection_HEADER'
       },
       {
         id               : 'FacetFieldArea',
         label            : ' Week Information',
         type             : #FIELDGROUP_REFERENCE,
         purpose          : #STANDARD,
         position         : 20,
         targetQualifier  : 'Week_area'
       }
      ]






      @UI                 : {lineItem: [{ position: 5,label: 'CustomerID' }]}
      //  @UI                 : {identification: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 5,label: 'CustomerID', qualifier: 'Collection_HEADER' }] }
      @UI.selectionField  : [ { position: 10}]
      @EndUserText.label  : 'CustomerID'
  key cust_id             : abap.char(10);

      //   @UI                 : {lineItem: [{ position: 10,label: 'Weekstatus' }]}
      //   @UI                 : {identification: [{  position: 10,label: 'Weekstatus', qualifier: 'Collection_info'  }] }
      @UI.selectionField  : [ { position: 20}]
      @EndUserText.label  : 'Weekstatus'
      @Consumption        : {

      filter              : {
        mandatory         : true,

        selectionType     : #SINGLE
       // multipleSelections: false


      },
      valueHelpDefinition : [{
        qualifier         : '',
        entity            : {
            name          : 'zcollectioncommitment_F4',
            element       : 'value_low'
        },
        distinctValues    : true,
        useForValidation  : true
      }]


      }

  key weekstatus          : abap.char( 6 );

      @UI                 : {lineItem: [{ position: 15,label: 'Accounting Number' }]}
      //@UI                 : {identification: [{  position: 15,label: 'Accounting Number',  qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 15,label: 'Accounting Number', qualifier: 'Collection_HEADER' }] }
  key accountingnumber    : abap.char( 10 );

      @UI                 : {lineItem: [{ position: 45,label: 'Clearing Date' }]}
      @UI                 : {identification: [{  position: 45,label: 'Clearing Date' , qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 45,label: 'Clearing Date', qualifier: 'Collection_HEADER' }] }
      clearing_date       : abap.dats;

      @UI                 : {lineItem: [{ position: 7,label: 'Customer Name' }]}
      //     @UI                 : {identification: [{  position: 20,label: 'Customer Name' , qualifier: 'Collection_info'  }] }
      @UI                 : {fieldGroup: [{  position: 7,label: 'Customer Name', qualifier: 'Collection_HEADER' }] }
      cust_name           : abap.char(80);

      @UI                 : {lineItem: [{ position: 21,label: 'Company Code' }]}
      // @UI                 : {identification: [{  position: 20,label: 'Company Code' , qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 21,label: 'Company Code', qualifier: 'Collection_HEADER' }] }

      companycode         : abap.char(4);



      @UI                 : {lineItem: [{ position: 22,label: 'Fiscal Year' }]}
      // @UI                 : {identification: [{  position: 20,label: 'Fiscal Year' , qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 22,label: 'Fiscal Year', qualifier: 'Collection_HEADER' }] }
      fiscalyear          : abap.numc( 4 );

      @UI                 : {lineItem: [{ position: 23,label: 'Invoice Number' }]}
      //@UI                 : {identification: [{  position: 25,label: 'Invoice Number' , qualifier: 'Collection_info'}] }
      @UI                 : {fieldGroup: [{  position: 23,label: 'Invoice Number', qualifier: 'Collection_HEADER' }] }
      invoice_number      : abap.char(16);

      @UI                 : {lineItem: [{ position: 30,label: 'Invoice Date' }]}
      //@UI                 : {identification: [{  position: 30,label: 'Invoice Date' , qualifier: 'Collection_info'}] }
      @UI                 : {fieldGroup: [{  position: 30,label: 'Invoice Date', qualifier: 'Collection_HEADER' }] }
      invoicedate         : abap.dats;

      @UI                 : {lineItem: [{ position: 35,label: 'Invoice Amount' }]}
      //  @UI                 : {identification: [{  position: 35,label: 'Invoice Amount',qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 35,label: 'Invoice Amount', qualifier: 'Collection_HEADER' }] }
      @Semantics.amount.currencyCode: 'companycodecurrency'
      invoiceamount       : abap.dec(23,2);

      @UI                 : {lineItem: [{ position: 40,label: 'Outstanding Amount' }]}
      // @UI                 : {identification: [{  position: 40,label: 'Outstanding Amount', qualifier: 'Collection_info' }] }
      @UI                 : {fieldGroup: [{  position: 40,label: 'Outstanding Amount', qualifier: 'Collection_HEADER' }] }
      @Semantics.amount.currencyCode: 'companycodecurrency'
      outstanding_amt     : abap.dec(23,2);


      //
      //            @UI                 : {lineItem: [{ position: 65,label: 'Week1' }]}
      //            @UI                 : {identification: [{  position: 65,label: 'Week1' }] }
      //          companycodecurrency : abap.cuky( 5 );


      @UI                 : {lineItem: [{ position: 65,label: 'Week1' }]}
      //  @UI                 : {identification: [{  position: 65,label: 'Week1'  , qualifier: 'week_info'}] }
      @UI                 : {fieldGroup: [{  position: 65,label: 'Week1', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week1               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 70,label: 'Week2' }]}
      //@UI                 : {identification: [{  position: 70,label: 'Week2' , qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 70,label: 'Week2', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week2               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 80,label: 'Week3'  }]}
      //@UI                 : {identification: [{  position: 80,label: 'Week3' , qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 80,label: 'Week3', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week3               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 90,label: 'Week4' }]}
      // @UI                 : {identification: [{  position: 90,label: 'Week4' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 90,label: 'Week4', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week4               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 100,label: 'Week5' }]}
      // @UI                 : {identification: [{  position: 100,label: 'Week5' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 100,label: 'Week5', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week5               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 200,label: 'week6' }]}
      //  @UI                 : {identification: [{  position: 200,label: 'week6',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 200,label: 'Week6', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week6               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 210,label: 'Week7' }]}
      // @UI                 : {identification: [{  position: 210,label: 'Week7',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 210,label: 'Week7', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week7               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 220,label: 'Week8' }]}
      // @UI                 : {identification: [{  position: 220,label: 'Week8',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 220,label: 'Week8', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week8               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 230,label: 'Week9' }]}
      // @UI                 : {identification: [{  position: 230,label: 'Week9' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 230,label: 'Week9', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week9               : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 240,label: 'Week10' }]}
      // @UI                 : {identification: [{  position: 240,label: 'Week10',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 240,label: 'Week10', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week10              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 250,label: 'Week11' }]}
      //   @UI                 : {identification: [{  position: 250,label: 'Week11' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 250,label: 'Week11', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true

      week11              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 260,label: 'Week12' }]}
      //  @UI                 : {identification: [{  position: 260,label: 'Week12' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 260,label: 'Week12', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week12              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 270,label: 'Week13' }]}
      // @UI                 : {identification: [{  position: 270,label: 'Week13',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 270,label: 'Week13', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week13              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 280,label: 'Week14' }]}
      // @UI                 : {identification: [{  position: 280,label: 'Week14',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 280,label: 'Week14', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week14              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 290,label: 'Week15' }]}
      // @UI                 : {identification: [{  position: 290,label: 'week15',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 290,label: 'Week15', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week15              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 300,label: 'Week16' }]}
      // @UI                 : {identification: [{  position: 300,label: 'week16',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 300,label: 'Week16', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week16              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 310,label: 'Week17' }]}
      //@UI                 : {identification: [{  position: 310,label: 'Week17',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 310,label: 'Week17', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week17              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 320,label: 'Week18' }]}
      //@UI                 : {identification: [{  position: 320,label: 'Week18',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 320,label: 'Week18', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week18              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 330,label: 'Week19' }]}
      // @UI                 : {identification: [{  position: 330,label: 'Week19',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 330,label: 'Week19', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week19              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 340,label: 'Week20' }]}
      //  @UI                 : {identification: [{  position: 340,label: 'Week20',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 340,label: 'Week20', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week20              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 350,label: 'Week21' }]}
      //  @UI                 : {identification: [{  position: 350,label: 'Week21' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 350,label: 'Week21', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true

      week21              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 360,label: 'Week22' }]}
      //  @UI                 : {identification: [{  position: 360,label: 'Week22',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 360,label: 'Week22', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week22              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 370,label: 'Week23' }]}
      // @UI                 : {identification: [{  position: 370,label: 'Week23' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 370,label: 'Week23', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week23              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 380,label: 'Week24' }]}
      // @UI                 : {identification: [{  position: 380,label: 'Week24',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 380,label: 'Week24', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week24              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 390,label: 'Week25' }]}
      // @UI                 : {identification: [{  position: 390,label: 'Week25',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 390,label: 'Week25', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week25              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 400,label: 'Week26' }]}
      // @UI                 : {identification: [{  position: 400,label: 'Week26' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 400,label: 'Week26', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week26              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 410,label: 'Week27' }]}
      //  @UI                 : {identification: [{  position: 410,label: 'Week27',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 410,label: 'Week27', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week27              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 420,label: 'Week28' }]}

      //@UI                 : {identification: [{  position: 420,label: 'Week28' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 420,label: 'Week28', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week28              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 430,label: 'Week29' }]}
      // @UI                 : {identification: [{  position: 430,label: 'Week29' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 430,label: 'Week29', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week29              : abap.char( 1000 );



      @UI                 : {lineItem: [{ position: 440,label: 'Week30' }]}
      //  @UI                 : {identification: [{  position: 440,label: 'Week30',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 440,label: 'Week30', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week30              : abap.char( 1000 );



      @UI                 : {lineItem: [{ position: 450,label: 'Week31' }]}
      // @UI                 : {identification: [{  position: 450,label: 'Week31', qualifier: 'week_info'   }] }
      @UI                 : {fieldGroup: [{  position: 450,label: 'Week31', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week31              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 460,label: 'Week32' }]}
      //   @UI                 : {identification: [{  position: 460,label: 'Week32',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 460,label: 'Week32', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week32              : abap.char( 1000 );



      @UI                 : {lineItem: [{ position: 470,label: 'Week33' }]}
      //@UI                 : {identification: [{  position: 470,label: 'Week33',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 470,label: 'Week33', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week33              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 480,label: 'Week34' }]}
      // @UI                 : {identification: [{  position: 480,label: 'Week34' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 480,label: 'Week34', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week34              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 490,label: 'Week35' }]}
      //  @UI                 : {identification: [{  position: 490,label: 'Week35' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 490,label: 'Week35', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week35              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 500,label: 'Week36' }]}
      //  @UI                 : {identification: [{  position: 500,label: 'Week36',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 500,label: 'Week36', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week36              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 510,label: 'Week37' }]}
      //@UI                 : {identification: [{  position: 510,label: 'Week37' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 510,label: 'Week37', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week37              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 520,label: 'Week38' }]}
      // @UI                 : {identification: [{  position: 520,label: 'Week38',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 520,label: 'Week38', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week38              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 530,label: 'Week39' }]}
      //@UI                 : {identification: [{  position: 530,label: 'Week39',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 530,label: 'Week39', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week39              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 540,label: 'Week40' }]}
      //@UI                 : {identification: [{  position: 540,label: 'Week40' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 540,label: 'Week40', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week40              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 550,label: 'Week41' }]}
      //@UI                 : {identification: [{  position: 550,label: 'Week41',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 550,label: 'Week41', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week41              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 560,label: 'Week42' }]}
      //@UI                 : {identification: [{  position: 560,label: 'Week42' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 560,label: 'Week42', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week42              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 570,label: 'Week43' }]}
      //    @UI                 : {identification: [{  position: 570,label: 'Week43' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 570,label: 'Week43', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week43              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 575,label: 'Week44' }]}
      // @UI                 : {identification: [{  position: 575,label: 'Week44' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 575,label: 'Week44', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week44              : abap.char( 1000 );



      @UI                 : {lineItem: [{ position: 580,label: 'Week45' }]}
      // @UI                 : {identification: [{  position: 580,label: 'Week45' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 580,label: 'Week45', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week45              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 585,label: 'Week46' }]}
      //  @UI                 : {identification: [{  position: 585,label: 'Week46',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 585,label: 'Week46', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week46              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 587,label: 'Week47' }]}
      //@UI                 : {identification: [{  position: 587,label: 'Week47',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 587,label: 'Week47', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week47              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 590,label: 'Week48' }]}
      //@UI                 : {identification: [{  position: 590,label: 'Week48',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 590,label: 'Week48', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week48              : abap.char( 1000 );


      @UI                 : {lineItem: [{ position: 595,label: 'Week49' }]}
      //@UI                 : {identification: [{  position: 595,label: 'Week49',qualifier: 'week_info'  }] }
      @UI                 : {fieldGroup: [{  position: 595,label: 'Week49', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week49              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 600,label: 'Week50' }]}
      // @UI                 : {identification: [{  position: 600,label: 'Week50' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 600,label: 'Week50', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week50              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 610,label: 'Week51' }]}
      // @UI                 : {identification: [{  position: 610,label: 'Week51' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 610,label: 'Week51', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week51              : abap.char( 1000 );

      @UI                 : {lineItem: [{ position: 620,label: 'Week52' }]}
      // @UI                 : {identification: [{  position: 620,label: 'Week52' ,qualifier: 'week_info' }] }
      @UI                 : {fieldGroup: [{  position: 620,label: 'Week52', qualifier: 'Week_area' }] }
      @UI.multiLineText   : true
      week52              : abap.char( 1000 );

      companycodecurrency : abap.cuky( 5 );

}

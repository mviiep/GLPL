@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for STR PO workflow mail'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_STR_MAIL
  as select from ztab_str_mail
{
      @UI.facet         : [{
                          id      :'STRcode',
                          label   : 'PO Workflow',
                          type    : #IDENTIFICATION_REFERENCE,
                          position: 10}]
      @UI : {  lineItem       : [ { position: 10 } ],
               identification : [ { position:10 } ]}
      @EndUserText.label: 'Strcode'
  key strcode   as Strcode,
      @UI : {  lineItem       : [ { position: 20 } ],
               identification : [ { position: 20 } ]}
      @EndUserText.label: 'Value'
  key value     as Value,
      @UI : {  lineItem       : [ { position: 30 } ],
               identification : [ { position: 30 } ]}
      @EndUserText.label: 'mail to1'
  key famailto  as faMailto,
      @UI : {  lineItem       : [ { position: 40 } ],
               identification : [ { position: 40 } ]}
      @EndUserText.label: 'Mail to 2'
      famailto2 as Famailto2,

      @UI : {  lineItem       : [ { position: 50 } ],
               identification : [ { position: 50 } ]}
      @EndUserText.label: 'Mail to 3'
      famailto3 as Famailto3,

      @UI : {  lineItem       : [ { position: 60 } ],
               identification : [ { position: 60 } ]}
      @EndUserText.label: 'mail cc1'
      famailcc  as Famailcc,

      @UI : {  lineItem       : [ { position: 70 } ],
               identification : [ { position: 70 } ]}
      @EndUserText.label: 'Mail cc2'
      famailcc2 as Famailcc2,

      @UI : {  lineItem       : [ { position: 80 } ],
               identification : [ { position: 80 } ]}
      @EndUserText.label: 'Mail cc3'
      famailcc3 as Famailcc3,

      @UI : {  lineItem       : [ { position: 90 } ],
                identification : [ { position:90 } ]}
      @EndUserText.label: 'Mail cc4'
      famailcc4 as Famailcc4,

      @UI : {  lineItem       : [ { position: 100 } ],
               identification : [ { position: 100 } ]}
      @EndUserText.label: 'Mail cc5'
      famailcc5 as Famailcc5,

      @UI : {  lineItem       : [ { position: 110 } ],
               identification : [ { position: 110 } ]}
      @EndUserText.label: 'Send Mail'
      sendmail  as sendmail



      //
      //      @UI : {  lineItem       : [ { position: 110 } ],
      //               identification : [ { position: 110 } ]}
      //      @EndUserText.label: 'Second approval mail to'
      //      samailto   as Samailto,
      //
      //      @UI : {  lineItem       : [ { position: 120 } ],
      //               identification : [ { position: 120 } ]}
      //      @EndUserText.label: 'Second approval mail to 2'
      //      samailto2  as Samailto2,
      //
      //      @UI : {  lineItem       : [ { position: 130 } ],
      //               identification : [ { position: 130 } ]}
      //      @EndUserText.label: 'Second approval mail to 3'
      //      samailto3  as Samailto3,
      //
      //      @UI : {  lineItem       : [ { position: 140 } ],
      //               identification : [ { position: 140 } ]}
      //      @EndUserText.label: 'Second approval mail cc'
      //      samailcc   as Samailcc,
      //
      //      @UI : {  lineItem       : [ { position: 150 } ],
      //               identification : [ { position: 150 } ]}
      //      @EndUserText.label: 'Second approval mail cc2'
      //      samailcc2  as Samailcc2,
      //
      //      @UI : {  lineItem       : [ { position: 160 } ],
      //               identification : [ { position: 160 } ]}
      //      @EndUserText.label: 'Second approval mail cc3'
      //      samailcc3  as Samailcc3,
      //
      //      @UI : {  lineItem       : [ { position: 170 } ],
      //               identification : [ { position: 170 } ]}
      //      @EndUserText.label: 'Second approval mail cc4'
      //      samailcc4  as Samailcc4,
      //
      //      @UI : {  lineItem       : [ { position: 180 } ],
      //               identification : [ { position: 180 } ]}
      //      @EndUserText.label: 'Second approval mail cc5'
      //      samailcc5  as Samailcc5,
      //
      //      @UI : {  lineItem       : [ { position: 190 } ],
      //               identification : [ { position: 190 } ]}
      //      @EndUserText.label: 'Third approval mail to'
      //      tamailto   as Tamailto,
      //
      //      @UI : {  lineItem       : [ { position: 200 } ],
      //                identification : [ { position: 200 } ]}
      //      @EndUserText.label: 'Third approval mail to 2'
      //      tamailto2  as Tamailto2,
      //
      //      @UI : {  lineItem       : [ { position: 210 } ],
      //               identification : [ { position: 210 } ]}
      //      @EndUserText.label: 'Third approval mail to 3'
      //      tamailto3  as Tamailto3,
      //
      //      @UI : {  lineItem       : [ { position: 220 } ],
      //               identification : [ { position: 220 } ]}
      //      @EndUserText.label: 'Third approval mail to cc'
      //      tamailcc   as Tamailcc,
      //
      //      @UI : {  lineItem       : [ { position: 230 } ],
      //               identification : [ { position: 230 } ]}
      //      @EndUserText.label: 'Third approval mail to cc2'
      //      tamailcc2  as Tamailcc2,
      //
      //      @UI : {  lineItem       : [ { position: 240 } ],
      //               identification : [ { position: 240 } ]}
      //      @EndUserText.label: 'Third approval mail to cc3'
      //      tamailcc3  as Tamailcc3,
      //
      //      @UI : {  lineItem       : [ { position: 250 } ],
      //               identification : [ { position: 250 } ]}
      //      @EndUserText.label: 'Third approval mail to cc4'
      //      tamailcc4  as Tamailcc4,
      //
      //      @UI : {  lineItem       : [ { position: 260 } ],
      //               identification : [ { position: 260 } ]}
      //      @EndUserText.label: 'Third approval mail to cc5'
      //      tamailcc5  as Tamailcc5,
      //
      //      @UI : {  lineItem       : [ { position: 270 } ],
      //               identification : [ { position: 270 } ]}
      //      @EndUserText.label: 'Fourth approval mail to'
      //      fomailto   as Fomailto,
      //
      //      @UI : {  lineItem       : [ { position: 280 } ],
      //               identification : [ { position: 280 } ]}
      //      @EndUserText.label: 'Fourth approval mail to 2'
      //      fomailto2  as Fomailto2,
      //
      //      @UI : {  lineItem       : [ { position: 290 } ],
      //               identification : [ { position: 290 } ]}
      //      @EndUserText.label: 'Fourth approval mail to 3'
      //      fomailto3  as Fomailto3,
      //
      //      @UI : {  lineItem       : [ { position: 300 } ],
      //               identification : [ { position: 300 } ]}
      //      @EndUserText.label: 'Fourth approval mail to cc'
      //      fomailcc   as Fomailcc,
      //
      //      @UI : {  lineItem       : [ { position: 310 } ],
      //               identification : [ { position: 310 } ]}
      //      @EndUserText.label: 'Fourth approval mail to cc2'
      //      fomailcc2  as Fomailcc2,
      //
      //      @UI : {  lineItem       : [ { position: 320 } ],
      //               identification : [ { position: 320 } ]}
      //      @EndUserText.label: 'Fourth approval mail to cc3'
      //      fomailcc3  as Fomailcc3,
      //
      //      @UI : {  lineItem       : [ { position: 330 } ],
      //               identification : [ { position: 330 } ]}
      //      @EndUserText.label: 'Fourth approval mail to cc4'
      //      fomailcc4  as Fomailcc4,
      //
      //      @UI : {  lineItem       : [ { position: 340 } ],
      //                identification : [ { position: 340 } ]}
      //      @EndUserText.label: 'Fourth approval mail to cc5'
      //      fomailcc5  as Fomailcc5,
      //      @UI : {  lineItem       : [ { position: 350 } ],
      //                identification : [ { position: 350 } ]}
      //      @EndUserText.label: 'Final approval mail to '
      //      finmailto  as finmailto,
      //      @UI : {  lineItem       : [ { position: 360 } ],
      //                identification : [ { position: 360 } ]}
      //      @EndUserText.label: 'Final approval mail to 2'
      //      finmailto2 as finmailto2,
      //      @UI : {  lineItem       : [ { position: 370 } ],
      //               identification : [ { position: 370 } ]}
      //      @EndUserText.label: 'Final approval mail to 3'
      //      finmailto3 as finmailto3,
      //      @UI : {  lineItem       : [ { position: 380 } ],
      //               identification : [ { position: 380 } ]}
      //      @EndUserText.label: 'Final approval mail cc'
      //      finmailcc  as finmailcc,
      //      @UI : {  lineItem       : [ { position: 390 } ],
      //               identification : [ { position: 390 } ]}
      //      @EndUserText.label: 'Final approval mail cc2'
      //      finmailcc2 as finmailcc2,
      //      @UI : {  lineItem       : [ { position: 400 } ],
      //               identification : [ { position: 400 } ]}
      //      @EndUserText.label: 'Final approval mail cc3'
      //      finmailcc3 as finmailcc3,
      //      @UI : {  lineItem       : [ { position: 410 } ],
      //               identification : [ { position: 410 } ]}
      //      @EndUserText.label: 'Final approval mail cc4'
      //      fimailcc4  as fimailcc4,
      //      @UI : {  lineItem       : [ { position: 420 } ],
      //               identification : [ { position: 420 } ]}
      //      @EndUserText.label: 'Final approval mail cc5'
      //      finmailcc5 as finmailcc5
}

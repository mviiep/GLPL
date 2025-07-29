@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for PO User'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PO_CREATEUSER
  as select from ztab_po_create
{
      @UI.facet              : [{
                   id          :'cbuser',
                   label       : 'User Email id',
                   type        : #IDENTIFICATION_REFERENCE,
               //          targetQualifier:'Sales_Tender.SoldToParty',
                   position    : 10
                   }
                   ]
      @UI                      : {
       lineItem                 : [{position: 10 }],
       identification           : [{position: 10}]
       }
      @EndUserText.label       : 'CB UserID'
  key cb_user,
      @UI                      : {
        lineItem                 : [{position: 20 }],
        identification           : [{position: 20}]
        }
      @EndUserText.label       : 'Email ID Too'
  key email_id,
      @UI                      : {
        lineItem                 : [{position: 30 }],
        identification           : [{position: 30}]
        }
      @EndUserText.label       : 'Email ID To 2'
      email_id2,
      @UI                      : {
        lineItem                 : [{position: 40 }],
        identification           : [{position: 40}]
        }
      @EndUserText.label       : 'Email ID To 3'
      email_id3,
      @UI                      : {
        lineItem                 : [{position: 50 }],
        identification           : [{position: 50}]
        }
      @EndUserText.label       : 'Email ID CC1'
      email_cc1,
      @UI                      : {
        lineItem                 : [{position: 60 }],
        identification           : [{position: 60}]
        }
      @EndUserText.label       : 'Email ID CC2'
      email_cc2,
      @UI                      : {
        lineItem                 : [{position: 70 }],
        identification           : [{position: 70}]
        }
      @EndUserText.label       : 'Email ID CC3'
      email_cc3,
      @UI                      : {
        lineItem                 : [{position: 80 }],
        identification           : [{position: 80}]
        }
      @EndUserText.label       : 'Email ID CC4'
      email_cc4,
      @UI                      : {
        lineItem                 : [{position: 90 }],
        identification           : [{position: 90}]
        }
      @EndUserText.label       : 'Email ID CC5'
      email_cc5
      //    singletonid as Singletonid,
      //    draftentitycreationdatetime as Draftentitycreationdatetime,
      //    draftentitylastchangedatetime as Draftentitylastchangedatetime,
      //    draftadministrativedatauuid as Draftadministrativedatauuid,
      //    draftentityoperationcode as Draftentityoperationcode,
      //    hasactiveentity as Hasactiveentity,
      //    draftfieldchanges as Draftfieldchanges
}

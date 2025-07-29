//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view entity for booking'
define root view entity ZI_BOOK as select from 
   ztbooking_xxx as booking
{
    key book as book,
    nom as Nom
}

class ZDEVCL_SALESCONTRACTEVENTS definition
  public
  inheriting from ZDEVCL_SALESCONTRACT_D1C5_BASE
  final
  create public .

public section.

  methods ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_CHAN_62F6
    redefinition .
  methods ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_CREA_5C3C
    redefinition .
  methods ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_DELE_99DD
    redefinition .
  methods ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_ITEM_7A98
    redefinition .
  methods ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_ITEM_43FD
    redefinition .
  methods ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_ITEM_27A1
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZDEVCL_SALESCONTRACTEVENTS IMPLEMENTATION.


METHOD ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_CHAN_62F6.

  " Event Type: sap.s4.beh.salescontract.v1.SalesContract.Changed.v1
   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_Changed_v1.


   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.


METHOD ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_CREA_5C3C.

  " Event Type: sap.s4.beh.salescontract.v1.SalesContract.Created.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_Created_v1.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.


METHOD ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_DELE_99DD.

  " Event Type: sap.s4.beh.salescontract.v1.SalesContract.Deleted.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_Deleted_v1.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.


METHOD ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_ITEM_27A1.

  " Event Type: sap.s4.beh.salescontract.v1.SalesContract.ItemDeleted.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_ItemDe_240C.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.


METHOD ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_ITEM_43FD.

  " Event Type: sap.s4.beh.salescontract.v1.SalesContract.ItemCreated.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_ItemCr_EE17.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.


METHOD ZDEVIF_SALESCONTR_4452_HANDLER~HANDLE_SALESCONTRACT_ITEM_7A98.

  " Event Type: sap.s4.beh.salescontract.v1.SalesContract.ItemChanged.v1
   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_ItemCh_483A.


   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.
ENDCLASS.

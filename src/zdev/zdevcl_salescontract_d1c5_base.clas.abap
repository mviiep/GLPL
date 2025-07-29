class ZDEVCL_SALESCONTRACT_D1C5_BASE definition
  public
  abstract
  create public .

public section.

  interfaces /IWXBE/IF_CONSUMER .
  interfaces ZDEVIF_SALESCONTR_4452_HANDLER
      all methods abstract .
protected section.
private section.

  constants:
    GENERATED_AT TYPE STRING VALUE `20241202101640` .
  constants:
    GENERATION_VERSION TYPE I VALUE 1 .
ENDCLASS.



CLASS ZDEVCL_SALESCONTRACT_D1C5_BASE IMPLEMENTATION.


METHOD /IWXBE/IF_CONSUMER~HANDLE_EVENT.

  " This is a generated class, which might be overwritten in the future.
  " Go to ZDEVCL_SALESCONTRACTEVENTS to add custom code.

  CASE io_event->get_cloud_event_type( ).
    WHEN 'sap.s4.beh.salescontract.v1.SalesContract.Changed.v1'.
      me->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_chan_62F6( NEW LCL_SALESCONTRACT_CHANGED_V1( io_event ) ).
    WHEN 'sap.s4.beh.salescontract.v1.SalesContract.Created.v1'.
      me->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_crea_5C3C( NEW LCL_SALESCONTRACT_CREATED_V1( io_event ) ).
    WHEN 'sap.s4.beh.salescontract.v1.SalesContract.Deleted.v1'.
      me->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_dele_99DD( NEW LCL_SALESCONTRACT_DELETED_V1( io_event ) ).
    WHEN 'sap.s4.beh.salescontract.v1.SalesContract.ItemChanged.v1'.
      me->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_item_7A98( NEW LCL_SALESCONTRACT_ITEMCHA_1CF8( io_event ) ).
    WHEN 'sap.s4.beh.salescontract.v1.SalesContract.ItemCreated.v1'.
      me->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_item_43FD( NEW LCL_SALESCONTRACT_ITEMCRE_2C0B( io_event ) ).
    WHEN 'sap.s4.beh.salescontract.v1.SalesContract.ItemDeleted.v1'.
      me->ZDEVIF_SALESCONTR_4452_HANDLER~handle_salescontract_item_27A1( NEW LCL_SALESCONTRACT_ITEMDEL_F1F9( io_event ) ).
    WHEN OTHERS.
      RAISE EXCEPTION TYPE /iwxbe/cx_exception
        EXPORTING
          textid = /iwxbe/cx_exception=>not_supported.
  ENDCASE.

ENDMETHOD.
ENDCLASS.

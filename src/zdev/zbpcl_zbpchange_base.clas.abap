class ZBPCL_ZBPCHANGE_BASE definition
  public
  abstract
  create public .

public section.

  interfaces /IWXBE/IF_CONSUMER .
  interfaces ZBPIF_ZBPCHANGE_HANDLER
      all methods abstract .
protected section.
private section.

  constants:
    GENERATED_AT TYPE STRING VALUE `20250115074657` .
  constants:
    GENERATION_VERSION TYPE I VALUE 1 .
ENDCLASS.



CLASS ZBPCL_ZBPCHANGE_BASE IMPLEMENTATION.


METHOD /IWXBE/IF_CONSUMER~HANDLE_EVENT.

  " This is a generated class, which might be overwritten in the future.
  " Go to ZBPCL_ZBPCHANGE to add custom code.

  CASE io_event->get_cloud_event_type( ).
    WHEN 'sap.s4.beh.businesspartner.v1.BusinessPartner.Changed.v1'.
      me->ZBPIF_ZBPCHANGE_HANDLER~handle_businesspartner_ch_C4F9( NEW LCL_BUSINESSPARTNER_CHANGED_V1( io_event ) ).
    WHEN 'sap.s4.beh.businesspartner.v1.BusinessPartner.Created.v1'.
      me->ZBPIF_ZBPCHANGE_HANDLER~handle_businesspartner_cr_DEB4( NEW LCL_BUSINESSPARTNER_CREATED_V1( io_event ) ).
    WHEN OTHERS.
      RAISE EXCEPTION TYPE /iwxbe/cx_exception
        EXPORTING
          textid = /iwxbe/cx_exception=>not_supported.
  ENDCASE.

ENDMETHOD.
ENDCLASS.

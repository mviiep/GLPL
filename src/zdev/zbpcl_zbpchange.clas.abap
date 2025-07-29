class ZBPCL_ZBPCHANGE definition
  public
  inheriting from ZBPCL_ZBPCHANGE_BASE
  final
  create public .

public section.

  methods ZBPIF_ZBPCHANGE_HANDLER~HANDLE_BUSINESSPARTNER_CH_C4F9
    redefinition .
  methods ZBPIF_ZBPCHANGE_HANDLER~HANDLE_BUSINESSPARTNER_CR_DEB4
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZBPCL_ZBPCHANGE IMPLEMENTATION.


METHOD ZBPIF_ZBPCHANGE_HANDLER~HANDLE_BUSINESSPARTNER_CH_C4F9.

  " Event Type: sap.s4.beh.businesspartner.v1.BusinessPartner.Changed.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZBP_BusinessPartner_Changed_v1.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.


METHOD ZBPIF_ZBPCHANGE_HANDLER~HANDLE_BUSINESSPARTNER_CR_DEB4.

  " Event Type: sap.s4.beh.businesspartner.v1.BusinessPartner.Created.v1
*   DATA ls_business_data TYPE STRUCTURE FOR HIERARCHY ZBP_BusinessPartner_Created_v1.
*
*
*   ls_business_data = io_event->get_business_data( ).



ENDMETHOD.
ENDCLASS.

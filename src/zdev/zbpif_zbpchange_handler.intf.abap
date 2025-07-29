interface ZBPIF_ZBPCHANGE_HANDLER
  public .


  methods HANDLE_BUSINESSPARTNER_CH_C4F9
    importing
      !IO_EVENT type ref to ZBPIF_BUSINESSPARTNER_CHA_57D7
    raising
      /IWXBE/CX_EXCEPTION .
  methods HANDLE_BUSINESSPARTNER_CR_DEB4
    importing
      !IO_EVENT type ref to ZBPIF_BUSINESSPARTNER_CRE_A9A2
    raising
      /IWXBE/CX_EXCEPTION .
endinterface.

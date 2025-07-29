interface ZDEVIF_SALESCONTR_4452_HANDLER
  public .


  methods HANDLE_SALESCONTRACT_CHAN_62F6
    importing
      !IO_EVENT type ref to ZDEVIF_SALESCONTRACT_CHAN_62F6
    raising
      /IWXBE/CX_EXCEPTION .
  methods HANDLE_SALESCONTRACT_CREA_5C3C
    importing
      !IO_EVENT type ref to ZDEVIF_SALESCONTRACT_CREA_5C3C
    raising
      /IWXBE/CX_EXCEPTION .
  methods HANDLE_SALESCONTRACT_DELE_99DD
    importing
      !IO_EVENT type ref to ZDEVIF_SALESCONTRACT_DELE_99DD
    raising
      /IWXBE/CX_EXCEPTION .
  methods HANDLE_SALESCONTRACT_ITEM_7A98
    importing
      !IO_EVENT type ref to ZDEVIF_SALESCONTRACT_ITEM_7A98
    raising
      /IWXBE/CX_EXCEPTION .
  methods HANDLE_SALESCONTRACT_ITEM_43FD
    importing
      !IO_EVENT type ref to ZDEVIF_SALESCONTRACT_ITEM_43FD
    raising
      /IWXBE/CX_EXCEPTION .
  methods HANDLE_SALESCONTRACT_ITEM_27A1
    importing
      !IO_EVENT type ref to ZDEVIF_SALESCONTRACT_ITEM_27A1
    raising
      /IWXBE/CX_EXCEPTION .
endinterface.

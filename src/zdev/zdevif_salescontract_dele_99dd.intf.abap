interface ZDEVIF_SALESCONTRACT_DELE_99DD
  public .


  interfaces /IWXBE/IF_CONSUMER_EVENT .

  aliases GET_ARRIVAL_TIMESTAMP
    for /IWXBE/IF_CONSUMER_EVENT~get_arrival_timestamp .
  aliases GET_CLOUD_EVENT_ID
    for /IWXBE/IF_CONSUMER_EVENT~get_cloud_event_id .
  aliases GET_CLOUD_EVENT_SOURCE
    for /IWXBE/IF_CONSUMER_EVENT~get_cloud_event_source .
  aliases GET_CLOUD_EVENT_SUBJECT
    for /IWXBE/IF_CONSUMER_EVENT~get_cloud_event_subject .
  aliases GET_CLOUD_EVENT_TIMESTAMP
    for /IWXBE/IF_CONSUMER_EVENT~get_cloud_event_timestamp .
  aliases GET_CLOUD_EVENT_TYPE
    for /IWXBE/IF_CONSUMER_EVENT~get_cloud_event_type .

  types:
    TY_S_SALESCONTRACT_DELETED_V1 TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_Deleted_v1 .

  methods GET_BUSINESS_DATA
    returning
      value(RS_BUSINESS_DATA) type ty_s_salescontract_deleted_v1
    raising
      /IWXBE/CX_EXCEPTION .
endinterface.

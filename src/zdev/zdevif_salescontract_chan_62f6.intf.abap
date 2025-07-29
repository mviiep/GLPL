interface ZDEVIF_SALESCONTRACT_CHAN_62F6
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
    TY_S_SALESCONTRACT_CHANGED_V1 TYPE STRUCTURE FOR HIERARCHY ZDEV_SalesContract_Changed_v1 .

  methods GET_BUSINESS_DATA
    returning
      value(RS_BUSINESS_DATA) type ty_s_salescontract_changed_v1
    raising
      /IWXBE/CX_EXCEPTION .
endinterface.

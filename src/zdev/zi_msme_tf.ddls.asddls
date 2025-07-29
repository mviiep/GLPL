@EndUserText.label: 'Table Function for MSME Report'
@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZI_MSME_TF
  with parameters
    @Environment.systemField: #CLIENT
    p_client : mandt
returns
{
      client   : abap.clnt;
  key sno      : lifnr;
  key supplier : lifnr;
      bp       : zchar40;
      pan      : zchar40;
      no1      : lifnr;
      amt1     : znetwr;
      no2      : lifnr;
      amt2     : znetwr;
      no3      : lifnr;
      amt3     : znetwr;
      no4      : lifnr;
      amt4     : znetwr;
      zcomment : zcomment;

}
implemented by method
  zcl_fi_msme_report=>get_itfinal;
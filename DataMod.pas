unit DataMod;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADCompClient, uADPhysIB,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADGUIxFormsWait, uADCompGUIx;

type
  Tdm = class(TDataModule)
    ADConnection: TADConnection;
    ADTransaction: TADTransaction;
    ADPhysIBDriverLink: TADPhysIBDriverLink;
    qCF: TADQuery;
    dCF: TDataSource;
    qMA: TADQuery;
    dMA: TDataSource;
    qMAMAID: TIntegerField;
    qMAN1: TSmallintField;
    qMAN2: TSmallintField;
    qMAN3: TSmallintField;
    qMAN4: TSmallintField;
    qMAN5: TSmallintField;
    qMAN6: TSmallintField;
    qMAT1: TStringField;
    qMAT2: TStringField;
    qMAT3: TStringField;
    qMAT4: TStringField;
    qMAT5: TStringField;
    qMAT6: TStringField;
    qMAT7: TStringField;
    qMAT8: TStringField;
    qMAT9: TStringField;
    qMAT10: TStringField;
    qMAT11: TStringField;
    qMAT12: TStringField;
    qMAT13: TStringField;
    qMAT14: TStringField;
    qMAT15: TStringField;
    qMAT16: TStringField;
    qMAT17: TStringField;
    qMAT18: TStringField;
    qMAT19: TStringField;
    qMAT20: TStringField;
    qMAT21: TStringField;
    qMAT22: TStringField;
    qMAT23: TStringField;
    qMAT24: TStringField;
    qMAT25: TStringField;
    qMAT26: TStringField;
    qMAT27: TStringField;
    qMAT28: TStringField;
    qMAT29: TStringField;
    qMAT30: TStringField;
    qMAT31: TStringField;
    qMAT32: TStringField;
    qMAT33: TStringField;
    qMAT34: TStringField;
    qMAT35: TStringField;
    qMAT36: TStringField;
    qMAT37: TStringField;
    qMAT38: TStringField;
    qMAT39: TStringField;
    qMAT40: TStringField;
    qMAHITCOUNT: TIntegerField;
    qMI: TADQuery;
    dMI: TDataSource;
    qMIMIID: TIntegerField;
    qMINUM: TIntegerField;
    qMITITLE: TStringField;
    qMICBFORSAVE: TStringField;
    qMICBFOREXECUTE: TStringField;
    qMINOTES: TMemoField;
    qMIINCLUSIVE: TStringField;
    qMICALMETHOD: TStringField;
    qMISUBTRACTION: TStringField;
    qMIMANUALENTRY: TStringField;
    qMISUBMETHOD: TStringField;
    qMIRESULTCNT: TIntegerField;
    qMIBUMPTABLE: TStringField;
    qMIRESULTFILE: TStringField;
    qMIROWBEGIN: TIntegerField;
    qMIROWEND: TIntegerField;
    qMIUSEALLROW: TStringField;
    qMIDRL: TStringField;
    qMIUSEROW: TStringField;
    qMIC1: TStringField;
    qMIC2: TStringField;
    qMIC3: TStringField;
    qMIC4: TStringField;
    qMIC5: TStringField;
    qMIC6: TStringField;
    qMIRANGEBEGIN: TIntegerField;
    qMIRANGEEND: TIntegerField;
    qMISAVETO: TStringField;
    qTS: TADQuery;
    qTSTSID: TIntegerField;
    qTSFILENAME: TStringField;
    qTSALIASNAME: TStringField;
    dTS: TDataSource;
    qMR: TADQuery;
    dMR: TDataSource;
    qMRMRID: TIntegerField;
    qMRRB: TIntegerField;
    qMRRE: TIntegerField;
    qMRMINHITCOUNT: TIntegerField;
    tq: TADQuery;
    qCOL: TADQuery;
    qBT: TADQuery;
    qCOLCOID: TIntegerField;
    qCOLMIID: TIntegerField;
    qCOLNUM: TIntegerField;
    qCOLMANUALINPUT: TStringField;
    qCOLTABLENAME: TStringField;
    qCOLSELECTED: TStringField;
    qCOLREPEATS: TIntegerField;
    qBTBTID: TIntegerField;
    qBTMIID: TIntegerField;
    qBTFILENAME: TStringField;
    qBTKEEPB: TIntegerField;
    qBTKEEPE: TIntegerField;
    qBTLINEB: TIntegerField;
    qBTLINEE: TIntegerField;
    qBTHITTED: TIntegerField;
    qBTC1: TStringField;
    qBTC2: TStringField;
    qBTC3: TStringField;
    qBTC4: TStringField;
    qBTC5: TStringField;
    qBTC6: TStringField;
    qBTGRPNO: TIntegerField;
    qBTGRPKEEPB: TIntegerField;
    qBTGRPKEEPE: TIntegerField;
    qBTOGNO: TIntegerField;
    qBTOGRB: TIntegerField;
    qBTOGRE: TIntegerField;
    qBTODDEVEN: TStringField;
    ADGUIxWaitCursor: TADGUIxWaitCursor;
    qMILASTSAVEDDATE: TDateField;
    qMITIMEGAP: TSQLTimeStampField;
    procedure qMIAfterInsert(DataSet: TDataSet);
    procedure qMAAfterInsert(DataSet: TDataSet);
    procedure qMAAfterPost(DataSet: TDataSet);
    procedure qMRAfterInsert(DataSet: TDataSet);
    procedure qMRAfterPost(DataSet: TDataSet);
    procedure qTSAfterPost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure qBTBeforeOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.DFM}


   uses Global, main, SuperType;

procedure Tdm.qMIAfterInsert(DataSet: TDataSet);
begin
   qMIMIID.Value := GenKeyVal('MIID');
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
  var AppPath: String;
begin
  AppPath := ExtractFilePath(ParamStr(0));

  ADConnection.Params.Values['Database'] :=
    IncludeTrailingPathDelimiter(AppPath) + 'SLLLLL.fdb';
  ADPhysIBDriverLink.VendorHome := ' ';
  ADPhysIBDriverLink.VendorLib :=
    IncludeTrailingPathDelimiter(AppPath) + 'fbclient.dll';
  ADConnection.Connected := True;
end;

procedure Tdm.qBTBeforeOpen(DataSet: TDataSet);
begin
  qBT.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure Tdm.qMAAfterInsert(DataSet: TDataSet);
   var i : integer;
begin
   for i := 8 to 47 do
      qMA.fields[i].value := 'N';
   qMAMAID.value := GenKeyVal('MAID');
end;

procedure Tdm.qMAAfterPost(DataSet: TDataSet);
begin
  if frmMain.pc.activepage = frmMain.tsConfiguration then
  begin
    qMA.close;
    qMA.open;
    qMA.last;
  end;
end;


procedure Tdm.qMRAfterInsert(DataSet: TDataSet);
begin
   qMRMRID.Value := GenKeyVal('MRID');
end;

procedure Tdm.qMRAfterPost(DataSet: TDataSet);
begin
   qMR.close;
   qMR.open;
   qMR.last;
end;

procedure Tdm.qTSAfterPost(DataSet: TDataSet);
begin
   qTS.close;
   qTS.open;
   qTS.last;
end;

end.

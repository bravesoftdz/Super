unit Mul;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Wwdatsrc, Grids, AdvGrid, ExtCtrls, StdCtrls,
  DBCtrls, Wwdbigrd, Wwdbgrid, Mask, wwdbedit, Wwdotdot, Wwdbcomb, Buttons,
  uADStanIntf, uADStanOption, uADStanParam, uADStanError, uADDatSManager,
  uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager, uADCompDataSet,
  uADCompClient, AdvObj, BaseGrid;

type
  TfrmMultiple = class(TForm)
    Label1: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Shape1: TShape;
    Label6: TLabel;
    lblCount: TLabel;
    lblTotal: TLabel;
    bGroupPerc: TBitBtn;
    wwDBComboBox1: TwwDBComboBox;
    DBNavigator1: TDBNavigator;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    wwDBGrid1: TwwDBGrid;
    wwDBGrid2: TwwDBGrid;
    wwDBGrid3: TwwDBGrid;
    wwDBGrid4: TwwDBGrid;
    DBNavigator2: TDBNavigator;
    DBNavigator3: TDBNavigator;
    bRunSample: TBitBtn;
    mFileContent: TMemo;
    dbRowSelect: TDBCheckBox;
    pnlRow: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Shape2: TShape;
    Label10: TLabel;
    DBEdit2: TDBEdit;
    DBEdit4: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    wwDBComboBox2: TwwDBComboBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    pnlGroupPerc: TPanel;
    Label3: TLabel;
    bCloseGrp: TButton;
    mResult: TMemo;
    pnlResultRange: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    mDevInfo: TMemo;
    DBCheckBox8: TDBCheckBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    qSrcRG: TADQuery;
    qSrcRGRNID: TIntegerField;
    qSrcRGMIID: TIntegerField;
    qSrcRGBN: TIntegerField;
    qSrcRGEN: TIntegerField;
    qSrcRGCAT: TStringField;
    qSrcRGPERC: TFloatField;
    qSrcRGHIT: TIntegerField;
    qSrcRGHITTED: TIntegerField;
    dSrcRG: TDataSource;
    dMan: TDataSource;
    qMan: TADQuery;
    qManRNID: TIntegerField;
    qManMIID: TIntegerField;
    qManBN: TIntegerField;
    qManEN: TIntegerField;
    qManCAT: TStringField;
    qManPERC: TFloatField;
    qManHIT: TIntegerField;
    qManHITTED: TIntegerField;
    dRN: TDataSource;
    qRN: TADQuery;
    qRNRNID: TIntegerField;
    qRNMIID: TIntegerField;
    qRNBN: TIntegerField;
    qRNEN: TIntegerField;
    qRNCAT: TStringField;
    qRNPERC: TFloatField;
    qRNHIT: TIntegerField;
    qRNHITTED: TIntegerField;
    dCOL: TDataSource;
    qCOL: TADQuery;
    qCOLCOID: TIntegerField;
    qCOLMIID: TIntegerField;
    qCOLNUM: TIntegerField;
    qCOLMANUALINPUT: TStringField;
    qCOLTABLENAME: TStringField;
    qCOLSELECTED: TStringField;
    qCOLREPEATS: TIntegerField;
    advGrid: TAdvStringGrid;
    procedure qCOLBeforePost(DataSet: TDataSet);
    procedure qRNBeforePost(DataSet: TDataSet);
    procedure qManBeforePost(DataSet: TDataSet);
    procedure qSrcRGBeforePost(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMultiple: TfrmMultiple;

implementation

{$R *.DFM}

uses DataMod, Global;

procedure TfrmMultiple.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmMultiple.qCOLBeforePost(DataSet: TDataSet);
begin
  qCOL.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmMultiple.qManBeforePost(DataSet: TDataSet);
begin
  qMan.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmMultiple.qRNBeforePost(DataSet: TDataSet);
begin
  qRN.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmMultiple.qSrcRGBeforePost(DataSet: TDataSet);
begin
  qSrcRG.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

end.

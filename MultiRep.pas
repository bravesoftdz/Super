unit MultiRep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TfrmMultiRep = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    eS1: TEdit;
    eR1: TEdit;
    eS2: TEdit;
    eR2: TEdit;
    eS3: TEdit;
    eR3: TEdit;
    eS4: TEdit;
    eR4: TEdit;
    eS5: TEdit;
    eR5: TEdit;
    bCancel: TButton;
    bOk: TButton;
    bFixFromNow: TButton;
    qs: TADQuery;
    qsCFID: TIntegerField;
    qsCODES: TStringField;
    qsDESCR: TStringField;
    qsINTVAL: TIntegerField;
    qsREALVAL: TFloatField;
    qsSECLEV: TIntegerField;
    qsSTRVAL: TStringField;
    qsINTERNAL: TStringField;
    qsVARNAME: TStringField;
    qsNOTES: TBlobField;
    qsDATEVAL: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bOkClick(Sender: TObject);
    procedure bFixFromNowClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure createrecords;
  end;

var
  frmMultiRep: TfrmMultiRep;

implementation

{$R *.DFM}

   uses global, DataMod;

procedure TfrmMultiRep.FormCreate(Sender: TObject);
begin
   ss[1] := '';
   ss[2] := '';
   ss[3] := '';
   ss[4] := '';
   ss[5] := '';
   sr[1] := '';
   sr[2] := '';
   sr[3] := '';
   sr[4] := '';
   sr[5] := '';
   if not qs.active then qs.open;
   if qs.recordcount < 10 then createrecords;
   eS1.text := qsSTRVAL.AsString;
   qs.next;
   eS2.text := qsSTRVAL.AsString;
   qs.next;
   eS3.text := qsSTRVAL.AsString;
   qs.next;
   eS4.text := qsSTRVAL.AsString;
   qs.next;
   eS5.text := qsSTRVAL.AsString;
   qs.next;
   eR1.text := qsSTRVAL.AsString;
   qs.next;
   eR2.text := qsSTRVAL.AsString;
   qs.next;
   eR3.text := qsSTRVAL.AsString;
   qs.next;
   eR4.text := qsSTRVAL.AsString;
   qs.next;
   eR5.text := qsSTRVAL.AsString;
   qs.next;
   qs.close;
end;

procedure TfrmMultiRep.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if not qs.active then qs.open;
   qs.edit;
   qsSTRVAL.AsString := eS1.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eS2.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eS3.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eS4.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eS5.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eR1.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eR2.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eR3.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eR4.text;
   qs.post;
   qs.next;
   qs.edit;
   qsSTRVAL.AsString := eR5.text;
   qs.post;
   qs.next;
   qs.close;
end;

procedure TfrmMultiRep.bCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfrmMultiRep.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then ModalResult := mrCancel;
end;

procedure TfrmMultiRep.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmMultiRep.createrecords;
begin
   qs.insert;
   qsCFID.Value := 5;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Search1';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'S1';
   qs.post;
   qs.insert;
   qsCFID.Value := 6;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Search2';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'S2';
   qs.post;
   qs.insert;
   qsCFID.Value := 7;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Search3';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'S3';
   qs.post;
   qs.insert;
   qsCFID.Value := 8;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Search4';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'S4';
   qs.post;
   qs.insert;
   qsCFID.Value := 9;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Search5';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'S5';
   qs.post;
   qs.insert;
   qsCFID.Value := 10;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Replace1';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'R1';
   qs.post;
   qs.insert;
   qsCFID.Value := 11;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Replace2';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'R2';
   qs.post;
   qs.insert;
   qsCFID.Value := 12;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Replace3';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'R3';
   qs.post;
   qs.insert;
   qsCFID.Value := 13;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Replace4';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'R4';
   qs.post;
   qs.insert;
   qsCFID.Value := 14;
   qsCODES.Value := 'STR';
   qsDESCR.Value := 'Replace5';
   qsSECLEV.Value := 2;
   qsINTERNAL.Value := 'N';
   qsSTRVAL.Value := '';
   qsVARNAME.Value := 'R5';
   qs.post;
   qs.close;
   qs.open;
end;

procedure TfrmMultiRep.bOkClick(Sender: TObject);
begin
   ss[1] := es1.text;
   ss[2] := es2.text;
   ss[3] := es3.text;
   ss[4] := es4.text;
   ss[5] := es5.text;
   sr[1] := er1.text;
   sr[2] := er2.text;
   sr[3] := er3.text;
   sr[4] := er4.text;
   sr[5] := er5.text;
   ModalResult := mrOk;
end;


procedure TfrmMultiRep.bFixFromNowClick(Sender: TObject);
begin
   ss[1] := es1.text;
   ss[2] := es2.text;
   ss[3] := es3.text;
   ss[4] := es4.text;
   ss[5] := es5.text;
   sr[1] := er1.text;
   sr[2] := er2.text;
   sr[3] := er3.text;
   sr[4] := er4.text;
   sr[5] := er5.text;
   ModalResult := mrYes;
end;

end.

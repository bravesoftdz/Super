unit Range2Delete;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  Data.DB, uADCompDataSet, uADCompClient;

type
  TfrmSpecialRange = class(TForm)
    Label1: TLabel;
    eStartNum: TEdit;
    Label2: TLabel;
    eEndingNum: TEdit;
    Bevel1: TBevel;
    Label3: TLabel;
    eRearrange: TEdit;
    Label4: TLabel;
    bDeleteTheseMenu: TButton;
    bRearrange: TButton;
    qrySelect: TADQuery;
    qryUpdate: TADQuery;
    procedure bRearrangeClick(Sender: TObject);
    procedure bDeleteTheseMenuClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure CheckField(AEdit: TEdit; AMessage: String);
  public
    { Public declarations }
  end;

var
  frmSpecialRange: TfrmSpecialRange;

implementation

{$R *.DFM}

uses Global, DataMod;

procedure TfrmSpecialRange.bDeleteTheseMenuClick(Sender: TObject);
  var
    i: Integer;
begin
  CheckField(eStartNum, 'Starting Menu Number');
  CheckField(eEndingNum, 'Ending Menu Number');

  for i := StrToInt(Trim(eStartNum.Text)) to StrToInt(Trim(eEndingNum.Text)) do
  begin
    dm.ADConnection.ExecSQL('delete from menuitem where num = ' + IntToStr(i));
  end;
end;

procedure TfrmSpecialRange.bRearrangeClick(Sender: TObject);
   var i: Integer;
begin
  CheckField(eStartNum, 'Starting Menu Number');
  CheckField(eEndingNum, 'Ending Menu Number');
  CheckField(eRearrange, 'Rearrange Begins');

  qrySelect.Close;
  qrySelect.SQL.Clear;
  qrySelect.Params.Clear;
  qrySelect.SQL.Add('select * from menuitem where num between ' +
    Trim(eStartNum.Text) + ' and ' + Trim(eEndingNum.Text) + ' order by num');
  qrySelect.Open();
  i := StrToInt(Trim(eRearrange.Text));
  while not qrySelect.Eof do
  begin
    qryUpdate.Params.ParamByName('n').AsInteger := i;
    qryUpdate.Params.ParamByName('id').AsInteger :=
      qrySelect.FieldByName('miid').AsInteger;
    qryUpdate.ExecSQL;
    Inc(i);
    qrySelect.Next;
  end;
end;

procedure TfrmSpecialRange.CheckField(AEdit: TEdit; AMessage: String);
begin
  if Trim(AEdit.Text) = '' then
  begin
    raise Exception.Create(AMessage + ' is not entered.');
  end;
  try
    StrToInt(Trim(AEdit.Text));
  except
    on E: Exception do
    begin
      raise Exception.Create(AMessage + ' is not valid.');
    end;
  end;
end;

procedure TfrmSpecialRange.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

end.

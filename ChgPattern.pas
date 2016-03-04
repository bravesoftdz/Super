unit ChgPattern;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Global;

type
  TfrmChangePattern = class(TForm)
    bOk: TButton;
    bCancel: TButton;
    Label2: TLabel;
    eEndNo: TEdit;
    cbDoFromThisPoint: TCheckBox;
    procedure bCancelClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eEndNoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    EndNo : string;
    ENo : integer;
  end;

var
  frmChangePattern: TfrmChangePattern;

implementation

{$R *.DFM}

procedure TfrmChangePattern.bCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfrmChangePattern.bOkClick(Sender: TObject);
begin
   EndNo := trim(eEndNo.text);
   if length(EndNo) < 1 then begin
      disp('Ending No. is not entered!', 'e');
      eEndNo.SetFocus;
      exit;
   end;
   try
      ENo := StrToInt(EndNo);
   except
      on e:exception do disp(e.message, 'e');
   end;
   modalResult := mrOk;
end;


procedure TfrmChangePattern.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then ModalResult := mrCancel;
end;

procedure TfrmChangePattern.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmChangePattern.eEndNoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_RETURN then bOkClick(Sender);
end;


end.

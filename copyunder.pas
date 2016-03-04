unit copyunder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmCopyUnderneath = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ebn: TEdit;
    een: TEdit;
    bCopy: TButton;
    bCancel: TButton;
    Label4: TLabel;
    procedure bCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bCopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    bn, en : integer;
  end;

var
  frmCopyUnderneath: TfrmCopyUnderneath;

implementation

{$R *.DFM}

   uses global;

procedure TfrmCopyUnderneath.bCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfrmCopyUnderneath.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then Modalresult := mrCancel;
end;

procedure TfrmCopyUnderneath.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmCopyUnderneath.bCopyClick(Sender: TObject);
   var i : integer;
begin
   try
      bn := strtoint(trim(ebn.text));
   except
      on e:exception do begin
         disp('Source Number is not proper number', 'e');;
         exit;
      end;
   end;
   try
      en := strtoint(trim(een.text));
   except
      on e:exception do begin
         disp('Destination Number is not proper number', 'e');;
         exit;
      end;
   end;
   ModalResult := mrOK;
end;


end.

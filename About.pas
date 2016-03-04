unit About;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Global;

type
  TfrmAbout = class(TForm)
    bClose: TBitBtn;
    Image1: TImage;
    Memo1: TMemo;
    lblName: TLabel;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
   height := 198;
end;

procedure TfrmAbout.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_Escape then ModalResult := mrOk;
end;

procedure TfrmAbout.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

end.

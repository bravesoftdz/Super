unit RepNumbers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmReplaceNumbers = class(TForm)
    bOk: TButton;
    bCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    eslb: TEdit;
    lblBegin: TLabel;
    lblEnd: TLabel;
    esle: TEdit;
    erlb: TEdit;
    erle: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bOkClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    slb, sle, rlb, rle : integer;
    ReplaceRanges : boolean;
  end;

var
  frmReplaceNumbers: TfrmReplaceNumbers;

implementation

{$R *.DFM}

   uses global;

procedure TfrmReplaceNumbers.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then ModalResult := mrCancel;
end;

procedure TfrmReplaceNumbers.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmReplaceNumbers.bOkClick(Sender: TObject);
begin
   if length(eslb.text) < 1 then begin
      disp('Search Begin is not entered!', 'e');
      eslb.SetFocus;
      exit;
   end;
   if length(esle.text) < 1 then begin
      disp('Search End is not entered!', 'e');
      esle.SetFocus;
      exit;
   end;
   if length(erlb.text) < 1 then begin
      disp('Replace Begin is not entered!', 'e');
      erlb.SetFocus;
      exit;
   end;
   if length(erle.text) < 1 then begin
      disp('Replace End is not entered!', 'e');
      erle.SetFocus;
      exit;
   end;
   slb := strtoint(trim(eslb.text));
   sle := strtoint(trim(esle.text));
   rlb := strtoint(trim(erlb.text));
   rle := strtoint(trim(erle.text));
   modalResult := mrOk;
end;

procedure TfrmReplaceNumbers.bCancelClick(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfrmReplaceNumbers.FormActivate(Sender: TObject);
begin
   if ReplaceRanges then
      begin
         caption := 'Search / Replace Ranges';
         lblBegin.caption := 'Range Begin';
         lblEnd.caption := 'Range End';
      end
   else
      begin
         caption := 'Search / Replace Numbers';
         lblBegin.caption := 'Line Begin';
         lblEnd.caption := 'Line End';
      end;
end;

end.

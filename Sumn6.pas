unit Sumn6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Db, DBTables;

type
  TfrmSumn6 = class(TForm)
    lbHist: TListBox;
    SaveDialog1: TSaveDialog;
    mSumComb: TMemo;
    Label1: TLabel;
    eTest: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbHistDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSumn6: TfrmSumn6;

implementation

{$R *.DFM}

   uses global, supertype;

procedure TfrmSumn6.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then ModalResult := mrCancel;
end;

procedure TfrmSumn6.FormCreate(Sender: TObject);
begin
   lbHist.items.clear;
   lbHist.items.loadfromfile(DateFileName);
end;

procedure TfrmSumn6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   lbHist.items.clear;
end;

procedure TfrmSumn6.lbHistDblClick(Sender: TObject);
   var i, j, k, p1, p2, p3, p4 : integer;
       ta : TRowArry;
       fn : string;
begin
   mSumComb.lines.clear;

   ParseNumbers(lbHist.items[lbHist.itemindex]);
   if lst.count > 0 then
      for i := 0 to 4 do
         ta[i+1] := strtoint(lst[i]);

   // Fill Up the Temporary Storage with Matches Found

   for j := 1 to 10 do begin
      p1 := TS1[j] div 10;
      p2 := TS1[j] mod 10;
      i := ta[p1] + ta[p2];
      mSumComb.lines.add(inttostr(i));
   end;

   for j := 1 to 10 do begin
      p1 := TS2[j] div 100;
      p2 := (TS2[j] mod 100) div 10;
      p3 := TS2[j] mod 10;
      i := ta[p1] + ta[p2] + ta[p3];
      mSumComb.lines.add(inttostr(i));
   end;

   for j := 1 to 5 do begin
      p1 := TS3[j] div 1000;
      p2 := (TS3[j] mod 1000) div 100;
      p3 := (TS3[j] mod 100) div 10;
      p4 := TS3[j] mod 10;

      i := ta[p1] + ta[p2] + ta[p3] + ta[p4];
      mSumComb.lines.add(inttostr(i));
   end;
   fn := 'f:\lotto\sum' + inttostr(lbHist.itemindex+1) + '.txt';
   mSumComb.lines.savetofile(fn);
   eTest.caption := 'Saved to "' + fn + '" file';
{   for j := 1 to 10 do begin
      i := lst[TS2[j][1]] + lst[TS2[j][2]] + lst[TS2[j][3]];
      mSumComb.lines.add(i);
   end;
   for j := 1 to 5 do begin
      i := lst[TS3[j][1]] + lst[TS3[j][2]] + lst[TS2[j][3]] + lst[TS2[j][4]];
      mSumComb.lines.add(i);
   end;
}
end;

end.

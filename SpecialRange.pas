unit SpecialRange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Db, DBTables;

type
  TfrmSpecialRange = class(TForm)
    Label1: TLabel;
    eStartNum: TEdit;
    Label2: TLabel;
    eEndingNum: TEdit;
    Bevel1: TBevel;
    Label3: TLabel;
    eRearrangeBegin: TEdit;
    Label4: TLabel;
    bDeleteTheseMenu: TButton;
    bRearrange: TButton;
    Query1: TQuery;
    procedure bDeleteTheseMenuClick(Sender: TObject);
    procedure bRearrangeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    menub, menue, rearrangeb, rangecnt : integer;
  end;

var
  frmSpecialRange: TfrmSpecialRange;

implementation

uses DataMod, global;

{$R *.DFM}

procedure TfrmSpecialRange.bDeleteTheseMenuClick(Sender: TObject);
   var i, j : integer;
       s : string;
       q : Tquery;
begin
   if length(eStartNum.text) < 1 then begin
      disp('Staring Menu Number is not entered!', 'e');
      eStartNum.SetFocus;
      exit;
   end;
   if length(eEndingNum.text) < 1 then begin
      disp('Ending Menu Number is not entered!', 'e');
      eEndingNum.SetFocus;
      exit;
   end;
   menub := strtoint(trim(eStartNum.text));
   menue := strtoint(trim(eEndingNum.text));

   dm.tq.close;
   dm.tq.requestlive := false;

   // Cleanup bumptables
   q := Tquery.create(nil);
   q.databasename := 'AppDB';
   q.sql.add('select * from menuitem where num between '
      + eStartNum.text + ' and ' + eEndingNum.text);
   q.open;
   while not q.eof do begin
      dm.tq.sql.clear;
      s := 'delete from bumptables where miid = '
         + q.fieldbyname('miid').asstring;
      dm.tq.sql.add(s);
      dm.tq.execsql;
      dm.tq.close;

      q.next;
   end;
   q.close;

   // Clean up menu items
   with dm.tq do begin
      close;
      sql.clear;
      s := 'delete from menuitem where num between '
         + eStartNum.text + ' and ' + eEndingNum.text;
      sql.add(s);
      execsql;
   end;
end;

procedure TfrmSpecialRange.bRearrangeClick(Sender: TObject);
   var i, j : integer;
       s : string;
begin
   if length(eStartNum.text) < 1 then begin
      disp('Staring Menu Number is not entered!', 'e');
      eStartNum.SetFocus;
      exit;
   end;
   if length(eEndingNum.text) < 1 then begin
      disp('Ending Menu Number is not entered!', 'e');
      eEndingNum.SetFocus;
      exit;
   end;
   if length(eRearrangeBegin.text) < 1 then begin
      disp('Rearrange Beginning Number is not entered!', 'e');
      eRearrangeBegin.SetFocus;
      exit;
   end;
   menub := strtoint(trim(eStartNum.text));
   menue := strtoint(trim(eEndingNum.text));
   rearrangeb := strtoint(trim(eRearrangeBegin.text));

   with dm.tq do begin
      close;
      sql.clear;
      requestlive := true;
      sql.add('select * from menuitem where num between '
         + eStartNum.text + ' and ' + eEndingNum.text
         + ' order by num');
      open;

      while not eof do begin
         edit;
         fieldbyname('num').value := rearrangeb;
         post;
         inc(rearrangeb);
         next;
      end;
      
      close;
      requestlive := false;
   end;
end;

procedure TfrmSpecialRange.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then ModalResult := mrCancel;
end;

end.

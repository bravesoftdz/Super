unit Monitor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Db, Grids, Wwdbigrd, Wwdbgrid, Wwdatsrc,
  Buttons, Printers, Menus, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADCompDataSet, uADCompClient;

const
   ldmax = 25;

type
  TfrmMonitor = class(TForm)
    Panel1: TPanel;
    pnlCenter: TPanel;
    pnlRC: TPanel;
    pnlFD: TPanel;
    Label1: TLabel;
    dbgTest: TwwDBGrid;
    Label3: TLabel;
    Label4: TLabel;
    bRunNow: TBitBtn;
    Panel2: TPanel;
    bPrintResult: TButton;
    PrintDialog1: TPrintDialog;
    mFilter: TMemo;
    mFilterResult: TMemo;
    Label2: TLabel;
    eDurMS: TEdit;
    bRefresh: TButton;
    mReset: TMemo;
    pu: TPopupMenu;
    mnuSavetoFileBump: TMenuItem;
    mnuSaveToFileReset: TMenuItem;
    lblTrackingNo: TLabel;
    qLB: TADQuery;
    dLB: TDataSource;
    qLBLBID: TIntegerField;
    qLBC1: TSmallintField;
    qLBC2: TSmallintField;
    qLBC3: TSmallintField;
    qLBC4: TSmallintField;
    qLBC5: TSmallintField;
    qLBC6: TSmallintField;
    qLBHITCOUNT: TIntegerField;
    qLBB1: TStringField;
    qLBB2: TStringField;
    qLBB3: TStringField;
    qLBB4: TStringField;
    qLBB5: TStringField;
    qLBB6: TStringField;
    qLBB7: TStringField;
    qLBB8: TStringField;
    qLBB9: TStringField;
    qLBB10: TStringField;
    qLBB11: TStringField;
    qLBB12: TStringField;
    qLBB13: TStringField;
    qLBB14: TStringField;
    qLBB15: TStringField;
    qLBB16: TStringField;
    qLBB17: TStringField;
    qLBB18: TStringField;
    qLBB19: TStringField;
    qLBB20: TStringField;
    qLBB21: TStringField;
    qLBB22: TStringField;
    qLBB23: TStringField;
    qLBB24: TStringField;
    qLBB25: TStringField;
    qLBB26: TStringField;
    qLBB27: TStringField;
    qLBB28: TStringField;
    qLBB29: TStringField;
    qLBB30: TStringField;
    qLBB31: TStringField;
    qLBB32: TStringField;
    qLBB33: TStringField;
    qLBB34: TStringField;
    qLBB35: TStringField;
    qLBB36: TStringField;
    qLBB37: TStringField;
    qLBB38: TStringField;
    qLBB39: TStringField;
    qLBB40: TStringField;
    qLBB41: TStringField;
    qLBB42: TStringField;
    qLBB43: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bRefreshClick(Sender: TObject);
    procedure eDurMSKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bRunNowClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bPrintResultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure puPopup(Sender: TObject);
    procedure mnuSaveToFileResetClick(Sender: TObject);
    procedure mnuSavetoFileBumpClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CheckForSizeTagCondition;
    procedure CleanUpAllValuesOnTable;
  end;

var
  frmMonitor: TfrmMonitor;

implementation

{$R *.DFM}

   uses global, SuperType, main, DataMod;


procedure TfrmMonitor.FormCreate(Sender: TObject);
begin
   CheckForSizeTagCondition;
   pnlCenter.align := alClient;
   pnlRC.align := alClient;
   mFilterResult.lines.clear;
   mFilter.lines.clear;
   lblTrackingNo.caption := 'Tracking No : '
      + frmMain.eTrackNo.text;
end;

procedure TfrmMonitor.CheckForSizeTagCondition;
   var i, j : integer;
       q : TADQuery;
       s : string;
begin
   try
      q := TADQuery.create(nil);
      with q do begin
         Connection := dm.ADConnection;
         Transaction := dm.ADTransaction;
         sql.add('select lbid from labellist order by lbid');
         open;
         i := recordcount;
         if i < 1000 then begin
            try
               for j := i + 1 to 1000 do begin
                  insert;
                  fields[0].asinteger := j;
                  post;
               end;
            except
               on e:exception do begin
                  disp(e.message, 'e');
               end;
            end;
         end;
      end;
   except
      on E:Exception do begin
         q.close;
         q.sql.clear;
         s := 'CREATE TABLE Labellist (LBID INTEGER NOT NULL, '
            + ' c1 smallint, '
            + ' c2 smallint, '
            + ' c3 smallint, '
            + ' c4 smallint, '
            + ' c5 smallint, '
            + ' c6 smallint, '
            + ' hitcount integer, '
            + ' b1 char(1), '
            + ' b2 char(1), '
            + ' b3 char(1), ';
         q.sql.add(s);
         s := ' b4 char(1), '
            + ' b5 char(1), '
            + ' b6 char(1), '
            + ' b7 char(1), '
            + ' b8 char(1), '
            + ' b9 char(1), '
            + ' b10 char(1), '
            + ' b11 char(1), '
            + ' b12 char(1), '
            + ' b13 char(1), '
            + ' b14 char(1), '
            + ' b15 char(1), ';
         q.sql.add(s);
         s := ' b16 char(1), '
            + ' b17 char(1), '
            + ' b18 char(1), '
            + ' b19 char(1), '
            + ' b20 char(1), '
            + ' b21 char(1), '
            + ' b22 char(1), '
            + ' b23 char(1), '
            + ' b24 char(1), '
            + ' b25 char(1), ';
         q.sql.add(s);
         s := ' b26 char(1), '
            + ' b27 char(1), '
            + ' b28 char(1), '
            + ' b29 char(1), '
            + ' b30 char(1), '
            + ' b31 char(1), '
            + ' b32 char(1), '
            + ' b33 char(1), '
            + ' b34 char(1), '
            + ' b35 char(1), '
            + ' b36 char(1), '
            + ' b37 char(1), '
            + ' b38 char(1), '
            + ' b39 char(1), '
            + ' b40 char(1), '
            + ' b41 char(1), '
            + ' b42 char(1), '
            + ' b43 char(1), '
            + 'CONSTRAINT PK_Labellist PRIMARY KEY (LBID)); ';
         q.sql.add(s);
         q.execsql;
         q.sql.clear;
         q.sql.add('select lbid from labellist order by lbid');
         q.open;
         if i < 1000 then begin
            try
               for j := 1 to 1000 do begin
                  q.insert;
                  q.fields[0].asinteger := j;
                  q.post;
               end;
            except
               on e:exception do disp(e.message, 'e');
            end;
         end;
      end;
   end;
   q.free;
   q := nil;
end;

procedure TfrmMonitor.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
   l_Coeff := GetScreenCoefficient;

   ChangeScale(l_Coeff, 100);

   CheckForSizeTagCondition;
   qLB.open;
end;

procedure TfrmMonitor.CleanUpAllValuesOnTable;
   var i: integer;
begin
   with qLB do begin
      if not active then open;
      first;
      while not eof do begin
         edit;
         for i := 1 to 7 do fields[i].value := 0;
         for i := 8 to 50 do fields[i].value := 'N';
         post;
         next;
      end;
      first;
   end;
end;

procedure TfrmMonitor.bRefreshClick(Sender: TObject);
   var j, i, k : integer;
       s : string;
begin
   dLB.enabled := false;
   try
      CleanUpAllValuesOnTable;
      j := 0;
      with qLB do begin
         while not eof do begin
            inc(j);
            edit;
            for i := 1 to 6 do fields[i].asinteger := MAry[j].n[i];
            fields[7].Value := MAry[j].HitCount;
            for i := 1 to 41 do begin
               if MAry[j].checks[i] then
                  fields[i+7].Value := 'Y'
               else
                  fields[i+7].Value := 'N';
            end;
            post;
            next;
         end;
         first;
      end;
   except
      on e:exception do disp(inttostr(i), 'i');
   end;
   dLB.enabled := true;
end;

procedure TfrmMonitor.eDurMSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = VK_RETURN then begin
      try
         MonitorDuration := StrToInt(eDurMS.text);
      except
         on e:exception do MonitorDuration := 300;
      end;
   end;
end;

procedure TfrmMonitor.bRunNowClick(Sender: TObject);
begin
   SleepDuration := StrToInt(eDurMS.Text);
   frmMain.bRunNowClick(Sender);
end;

procedure TfrmMonitor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   mon := false;
//   frmMain.cbMonitor.checked := false;
end;

procedure TfrmMonitor.bPrintResultClick(Sender: TObject);
   var
      X: integer;
      StructText: TExtFile;
begin
   if mFilterResult.lines.Count = 0 then Exit;
   if PrintDialog1.execute then begin
      AssignPrn( StructText );
      try
         Rewrite( StructText );
         Printer.Canvas.Font.Assign(mFilterResult.Font);
         for X := 0 to mFilterResult.lines.Count - 1 do
            writeln( StructText, mFilterResult.lines[X] );
      finally
         CloseFile( StructText );
      end;
   end;
end;




procedure TfrmMonitor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = VK_ESCAPE then close;
end;

procedure TfrmMonitor.puPopup(Sender: TObject);
begin
   mnuSavetoFileBump.visible := false;
   mnuSaveToFileReset.visible := false;
   if mFilterResult.focused then
      mnuSavetoFileBump.visible := true;
   if mReset.focused then
      mnuSaveToFileReset.visible := true;
end;

procedure TfrmMonitor.mnuSaveToFileResetClick(Sender: TObject);
begin
   mReset.lines.savetofile('c:\3.txt');
end;

procedure TfrmMonitor.mnuSavetoFileBumpClick(Sender: TObject);
begin
   mFilterResult.lines.savetofile('c:\1.txt');
end;

end.


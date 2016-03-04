unit config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Wwdbigrd, Wwdbgrid, ExtCtrls, StdCtrls, DBCtrls, Mask, Db,
  Wwdatsrc, Printers, uADCompClient, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADCompDataSet;

type
  TConfigRecPtr = ^TConfigNodeRec;

  TConfigNodeRec = record
     id : integer;
     nextp, prevp : TConfigRecPtr;
     code : string[5];
     varname : string[20];
     descrip : string[50];
     IntVal : Integer;
     RealVal : real;
     DateVal : TDateTime;
     Internal : boolean;
     StrVal : string;
  end;

  TConfiguration = class
     head, tail, trav : TConfigRecPtr;
     itemscount : integer;
     private
        procedure addnode(cfid, intval : integer; realval : real;
            dateval : TDateTime;
            internal, strval, codes, varname, descr, notes : string);
     public
        constructor create;
        destructor destroy;
        procedure LoadAll;
        procedure printlist;
        procedure Save(name : string);
        function  int(name : string) : Integer;
        function  float(name : string) : Real;
        function  str(name : string) : String;
        function  dates(name : string) : TDateTime;
  end;

  TfrmConfig = class(TForm)
    Panel1: TPanel;
    dbgItems: TwwDBGrid;
    bClose: TButton;
    pnlEdit: TPanel;
    dbEdit: TDBEdit;
    dbMemo: TDBMemo;
    Label6: TLabel;
    bOk: TButton;
    bCancel: TButton;
    DBText1: TDBText;
    Label1: TLabel;
    lblType: TLabel;
    pnlPrint: TPanel;
    qConfig: TADQuery;
    dConfig: TDataSource;
    qConfigCFID: TIntegerField;
    qConfigCODES: TStringField;
    qConfigDESCR: TStringField;
    qConfigINTVAL: TIntegerField;
    qConfigREALVAL: TFloatField;
    qConfigSECLEV: TIntegerField;
    qConfigSTRVAL: TStringField;
    qConfigINTERNAL: TStringField;
    qConfigVARNAME: TStringField;
    qConfigNOTES: TBlobField;
    qConfigDATEVAL: TDateField;
    procedure dbgItemsDblClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure bOkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure pnlPrintDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IsInternal : boolean;
  end;

var
  frmConfig: TfrmConfig;
  cf : TConfiguration;

implementation

uses DataMod, global, qrConfig;

{$R *.DFM}

procedure TConfiguration.addnode(cfid, intval : integer; realval : real;
   dateval : TDateTime;
   internal, strval, codes, varname, descr, notes : string);
{  codes : str : string,
           Int : integer,
           Real : Real;
           Date : Date,
           Note : Note  }
begin
   try
      if head = nil then
         begin
            new(head);
            head^.nextp := nil;
            head^.prevp := nil;
            tail := head;
         end
      else
         if head <> nil then begin
            new(trav);
            trav^.prevp := tail;
            trav^.nextp := nil;
            tail^.nextp := trav;
            tail := trav;
         end;
      tail^.id := cfid;
      tail^.code := codes;
      tail^.descrip := descr;
      tail^.varname := varname;
      tail^.IntVal := intval;
      tail^.RealVal := realval;
      tail^.DateVal := dateval;
      if internal = 'Y' then
         tail^.Internal := true
      else
         tail^.Internal := false;
      if length(strval) > 0 then
         tail^.StrVal := strval
      else
         tail^.StrVal := notes;
   except
      on e:exception do disp(e.message, 'e');
   end;
end;

procedure TConfiguration.printlist;
   var f: TExtFile;
       s : string;
begin
   try
//      fnt.size := 9;
//      fnt.Name := 'Courier New';
      if head = nil then exit;
      Printer.Canvas.Font.size := 8;
      Printer.Canvas.Font.style := [fsbold];
      Printer.Canvas.Font.name := 'Courier New';
      Printer.Orientation := poLandscape;
      AssignPrn(f);
      Rewrite(f);
      trav := head;
      if trav <> nil then begin
         while trav <> nil do begin
            s := format('%-3d %-5s %-20s %-50s ',
               [trav^.id, trav^.code, trav^.varname, trav^.descrip]);
            if trav^.code = 'INT' then
               s := s + IntToStr(trav^.IntVal);
            if trav^.code = 'STR' then
               s := s + trav^.StrVal;
            if trav^.code = 'NOTE' then
               s := s + trav^.StrVal;
            if trav^.code = 'Date' then
               s := s + DateToStr(trav^.DateVal);
            if trav^.code = 'REAL' then
               s := s + FloatToStr(trav^.RealVal);
            writeln(f, s);
            trav := trav^.nextp;
         end;
      end;
      closefile(f);
   except
      on e:exception do begin
         Disp(e.message, 'e');
         closefile(f);
      end;
   end;
end;

constructor TConfiguration.create;
begin
   try
      head := nil;
      tail := nil;
      trav := nil;
      itemscount := 0;
   except
      on e:exception do disp(e.message, 'e');
   end;
end;

procedure TConfiguration.LoadAll;
   var q : TADQuery;
      cfid, intval : integer;
      realval : real;
      dateval : TDateTime;
      internal, strval, codes, varname, descr, notes : string;
begin
   try
      q := TADQuery.create(nil);
      with q do begin
         Connection := dm.ADConnection;
         Transaction := dm.ADTransaction;
         sql.add('select * from configs where descr is not null');
         open;
         if recordcount > 0 then
            begin
               itemscount := recordcount;
               while not eof do begin
                  cfid := fieldbyname('cfid').asinteger;
                  intval := fieldbyname('intval').asinteger;
                  realval := fieldbyname('realval').asfloat;
                  dateval := fieldbyname('dateval').asdatetime;
                  internal := fieldbyname('internal').asstring;
                  strval := fieldbyname('strval').asstring;
                  codes := fieldbyname('codes').asstring;
                  descr := fieldbyname('descr').asstring;
                  varname := fieldbyname('varname').asstring;                  
                  notes := fieldbyname('notes').asstring;
                  addnode(cfid, intval, realval,
                     dateval, internal, strval, codes, varname, descr, notes);
                  next;
               end;
            end
         else
            begin
               disp('There are no configuration data!', 'e');
            end;
      end;
   except
      on e:exception do disp(e.message, 'e');
   end;
   q.free;
   q := nil;
end;

procedure TConfiguration.Save(name : string);
begin
   try

   except
      on e:exception do disp(e.message, 'e');
   end;
end;

function  TConfiguration.int(name : string) : Integer;
begin
   try
      if head = nil then begin
         result := -1;
         exit;
      end;
      trav := head;
      if trav <> nil then begin
         while trav <> nil do begin
            if CompareText(trav^.varname, name) = 0 then
               begin
                  result := trav^.IntVal;
                  trav := nil;
               end
            else
               trav := trav^.nextp;
         end;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         result := -1;
      end;
   end;
end;

function  TConfiguration.float(name : string) : Real;
begin
   try
      if head = nil then begin
         result := -1;
         exit;
      end;
      trav := head;
      if trav <> nil then begin
         while trav <> nil do begin
            if CompareText(trav^.varname, name) = 0 then
               begin
                  result := trav^.RealVal;
                  trav := nil;
               end
            else
               trav := trav^.nextp;
         end;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         result := -1;
      end;
   end;
end;

function  TConfiguration.str(name : string) : String;
begin
   try
      if head = nil then begin
         result := '';
         exit;
      end;
      trav := head;
      if trav <> nil then begin
         while trav <> nil do begin
            if CompareText(trav^.varname, name) = 0 then
               begin
                  result := trav^.StrVal;
                  trav := nil;
               end
            else
               trav := trav^.nextp;
         end;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         result := '';
      end;
   end;
end;

function  TConfiguration.dates(name : string) : TDateTime;
begin
   try
      if head = nil then begin
         result := -1;
         exit;
      end;
      trav := head;
      if trav <> nil then begin
         while trav <> nil do begin
            if CompareText(trav^.varname, name) = 0 then
               begin
                  result := trav^.DateVal;
                  trav := nil;
               end
            else
               trav := trav^.nextp;
         end;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         result := 0;
      end;
   end;
end;

destructor TConfiguration.destroy;
begin
   try
      if tail = nil then exit;
      while tail <> nil do begin
         trav := tail;
         tail := tail^.prevp;
         dispose(trav);
      end;
   except
      on e:exception do disp(e.message, 'e');
   end;
end;

procedure TfrmConfig.dbgItemsDblClick(Sender: TObject);
   var s : string;
begin
   pnlEdit.top := 2;
   pnlEdit.left := 2;
   s := qConfigCODES.AsString;
   dbEdit.visible := false;
   dbMemo.visible := false;
   if comparetext(s, 'STR') = 0 then begin
      dbEdit.visible := true;
      dbEdit.DataField := 'STRVAL';
      lblType.caption := 'String format.';
   end;
   if comparetext(s, 'INT') = 0 then begin
      dbEdit.visible := true;
      dbEdit.DataField := 'INTVAL';
      lblType.caption := 'Integer format.';
   end;
   if comparetext(s, 'REAL') = 0 then begin
      dbEdit.visible := true;
      dbEdit.DataField := 'REALVAL';
      lblType.caption := 'Real No.';
   end;
   if comparetext(s, 'NOTE') = 0 then begin
      dbMemo.visible := true;
      lblType.caption := 'Notes.';
   end;
   if comparetext(s, 'DATE') = 0 then begin
      dbEdit.visible := true;
      dbEdit.DataField := 'DATEVAL';
      lblType.caption := 'Date Format.';
   end;
   pnlEdit.visible := true;
   qConfig.edit;
end;

procedure TfrmConfig.bCancelClick(Sender: TObject);
begin
   qConfig.cancel;
   pnlEdit.visible := false;
end;

procedure TfrmConfig.bOkClick(Sender: TObject);
begin
   qConfig.post;
   pnlEdit.visible := false;
end;

procedure TfrmConfig.FormDestroy(Sender: TObject);
begin
   try
      qConfig.close;
   except
      on e:exception do;
   end;
end;

procedure TfrmConfig.FormShow(Sender: TObject);
   var s : string;
       l_Coeff : integer;
begin
   with qConfig do begin
      close;
      sql.clear;
      s := 'select * from Configs where descr is not null ';
      if IsInternal then
         begin
            caption := 'System Configuration';
            s := s + 'and internal = ''Y'' '
         end
      else
         begin
            caption := 'Customer Configuration';
            s := s + 'and internal is null ';
         end;
      s := s + 'Order by Descr ';
      sql.add(s);
      open;
   end;

  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);

end;

procedure TfrmConfig.bCloseClick(Sender: TObject);
begin
   cf.Free;
   cf := nil;
   cf := TConfiguration.create;
   cf.LoadAll;
end;

procedure TfrmConfig.pnlPrintDblClick(Sender: TObject);
begin
// cf.printlist;
   frmCFRpt := TfrmCFRpt.create(nil);
   frmCFRpt.qr.Preview;
   frmCFRpt.release;
   frmCFRpt := nil;
end;

end.

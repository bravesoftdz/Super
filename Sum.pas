unit Sum;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Wwdatsrc, Grids, ExtCtrls, StdCtrls,
  DBCtrls, Wwdbigrd, Wwdbgrid, Mask, wwdbedit, Wwdotdot, Wwdbcomb, Buttons,
  ComCtrls, SuperType, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TfrmSum = class(TForm)
    Shape1: TShape;
    DBEdit3: TDBEdit;
    bRunSample: TBitBtn;
    DBCheckBox8: TDBCheckBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    mDevInfo: TMemo;
    Label1: TLabel;
    DBMemo1: TDBMemo;
    mResult: TMemo;
    mFileContent: TMemo;
    Label2: TLabel;
    wwDBGrid2: TwwDBGrid;
    DBNavigator2: TDBNavigator;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    bFromLastDraw: TButton;
    DBEdit1: TDBEdit;
    Label7: TLabel;
    DBEdit2: TDBEdit;
    lblLine: TLabel;
    qQL: TADQuery;
    qQLCOID: TIntegerField;
    qQLMIID: TIntegerField;
    qQLNUM: TIntegerField;
    qQLMANUALINPUT: TStringField;
    qQLTABLENAME: TStringField;
    qQLSELECTED: TStringField;
    qQLREPEATS: TIntegerField;
    dQL: TDataSource;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBEdit3DblClick(Sender: TObject);
    procedure mDevInfoDblClick(Sender: TObject);
    procedure bRunSampleClick(Sender: TObject);
    procedure mFileContentDblClick(Sender: TObject);
    procedure mResultDblClick(Sender: TObject);
    procedure bFromLastDrawClick(Sender: TObject);
    procedure qQLAfterInsert(DataSet: TDataSet);
    procedure qQLBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    procedure ShowResultOnScreen;
    procedure ShowDevelopmentInfo;
  public
    DAry : TDataArray;
    DoReplace : boolean;
    ShowTopCount : integer;
    StartingFromBottom : integer;
    LastTenSum : array [1..10] of byte;
    procedure LoadUpDataFile(b1, b2, b3, b4, b5 : boolean);
    procedure AddToTestView;
    procedure FilterRows(Option : integer);
    procedure RunThisMenuForSUMorGAPonDataFile(IsItForSUM : boolean);
    procedure LocalGetSum(var sum : integer; var FtrPassed : boolean; digit_option : integer);
    procedure GetLastDrawing;
  end;

var
  frmSum: TfrmSum;

implementation

{$R *.DFM}

uses global, DataMod, main;

procedure TfrmSum.LoadUpDataFile(b1, b2, b3, b4, b5 : boolean);
   var s, rf : string;
       i, j, sm : integer;
begin
   {$I-}
   for i := 1 to _MaxData do begin
      for j := 1 to 6 do DAry[i].n[j] := 0;
      DAry[i].sum := 0;
      DAry[i].hitcount := 0;
   end;

   if FileExists(DateFileName) then begin
      dFile.filename := DateFileName;
      AssignFile(dFile.F, DateFileName);
      FileMode := 0;  { Set file access to read only }
      Reset(dFile.F);
      j := 1;
      while not eof(dFile.F) do begin
         readln(dFile.F, s);
         if length(trim(s)) > 0 then begin
            ParseNumbers(s);
            if lst.count > 0 then begin
               for i := 0 to lst.count -1 do begin
                  try
                     DAry[j].n[i+1] := StrToInt(lst[i]);
                  except
                     on e:exception do;
                  end;
               end;

               sm := 0;
               if b1 then sm := sm + DAry[j].n[1];
               if b2 then sm := sm + DAry[j].n[2];
               if b3 then sm := sm + DAry[j].n[3];
               if b4 then sm := sm + DAry[j].n[4];
               if b5 then sm := sm + DAry[j].n[5];
               DAry[j].sum := sm;
               inc(j);
            end;
         end;
      end;
      dFile.linecount := j - 1;
      CloseFile(dFile.F);
   end;
   {$I+}
end;

procedure TfrmSum.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_F2 then bRunSampleClick(Sender);
   if Key = vk_F6 then ShowResultOnScreen;
   if Shift = [ssShift] then
      if Key = vk_F11 then ShowDevelopmentInfo;
   if Key = vk_escape then begin
      if mDevInfo.visible then
         mDevInfo.visible := false
      else
         ModalResult := mrOk;
   end;
end;

procedure TfrmSum.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmSum.FormDestroy(Sender: TObject);
begin
   if dm.qMI.state in [dsEdit, dsInsert] then dm.qMi.post;
end;

procedure TfrmSum.FormCreate(Sender: TObject);
begin
   DoReplace := false;
   mResult.lines.clear;
   if not qQL.active then qQL.open;
   ShowTopCount := 10;
end;

procedure TfrmSum.DBEdit3DblClick(Sender: TObject);
begin
   if length(dm.qMIRESULTFILE.AsString) > 0 then begin
      OpenDialog1.InitialDir := ExtractFilePath(dm.qMIRESULTFILE.AsString);
      OpenDialog1.Filename := ExtractFileName(dm.qMIRESULTFILE.AsString);
   end;
   if SaveDialog1.Execute then begin
      if not (dm.qMI.state in [dsEdit, dsInsert]) then dm.qMi.edit;
      dm.qMIRESULTFILE.text := SaveDialog1.filename;
      dm.qMI.post;
   end;
end;

procedure TfrmSum.mDevInfoDblClick(Sender: TObject);
begin
   mDevInfo.visible := false;
end;

procedure TfrmSum.bRunSampleClick(Sender: TObject);
   var s, rf : string;
       i, j, samplevalue, t : integer;
       c1, c2, c3, c4, c5 : boolean;
       hits : array [1..245] of byte;  // 245 = 51+50+49+48+47
       vals : array [1..245] of byte;
begin
   {$I-}
   for i := 1 to 245 do begin
      vals[i] := i;
      hits[i] := 0;
   end;

   try
      ShowTopCount := dm.qMIROWBEGIN.AsInteger;
   except
      on e:exception do begin
         disp('Show Top Counter Error!', 'e');
         exit;
      end;
   end;

   if dm.qMI.State in [dsEdit] then dm.qMI.post;
   c1 := (dm.qMIC1.Value = 'Y');
   c2 := (dm.qMIC2.Value = 'Y');
   c3 := (dm.qMIC3.Value = 'Y');
   c4 := (dm.qMIC4.Value = 'Y');
   c5 := (dm.qMIC5.Value = 'Y');

   try
      samplevalue := StrToInt(qQLmanualinput.AsString);
   except
      on e:exception do begin
         disp('Quick Look-up Value Error!', 'e');
         exit;
      end;
   end;
   LoadUpDataFile(c1, c2, c3, c4, c5);

   for i := 1 to dFile.linecount-1 do begin
      if DAry[i].sum = samplevalue then begin
         DAry[i+1].hitcount := DAry[i+1].hitcount + 1;
         hits[DAry[i+1].sum] := hits[DAry[i+1].sum] + 1;
      end;
   end;

   mResult.Lines.clear;

   for i := 1 to 244 do begin
      for j := i+1 to 245 do begin
         if hits[j] > hits[i] then begin
            t := hits[i];
            hits[i] := hits[j];
            hits[j] := t;
            t := vals[i];
            vals[i] := vals[j];
            vals[j] := t;
         end;
      end;
   end;
   for i := 1 to ShowTopCount do
      if hits[i] > 0 then mResult.Lines.add(inttostr(vals[i]));

   {$I+}
   ShowResultOnScreen;
   if dm.qMISAVETO.asstring = 'Y' then begin
      rf := trim(dm.qMIRESULTFILE.AsString);
      try
         if length(rf) > 0 then begin
            try
               i := strtoint(trim(frmMain.eMinToStartSaving.text));
            except
               on e:exception do i := 0;
            end;
            if mResult.Lines.count <= i then
               mResult.Lines.SaveToFile(rf);
         end;
      except
         on e:exception do
            disp('File could not be saved for some reason!', 'e');
      end;
   end;
end;

procedure TfrmSum.ShowResultOnScreen;
begin
   with mResult do begin
      left := 274;
      top  := 69;
      visible := true;
   end;
end;

procedure TfrmSum.ShowDevelopmentInfo;
begin
   with mDevInfo do begin
      left := 7;
      top := 4;
      visible := true;
      BringToFront;
   end;
end;

procedure TfrmSum.FilterRows(Option : integer);
   var i, j, k, m, rc, rb, re : integer;
       s : string;
begin
   rc := dm.qMA.recordcount;
   case Option of
      _ALL_ROWS : begin
         rb := 0;
         re := rc;
         dm.qMA.first;
      end;
      _PARTIAL_ROWS : begin
         i  := dm.qMIROWBEGIN.asinteger;
         j  := dm.qMIROWEND.asinteger;
         rb := rc - j;
         re := rc;
         dm.qMA.Last;
         for k := 1 to j do dm.qMA.prior;
         dm.qMA.next;
         k := j
      end;
   end;

   with dm.qMA do begin
      j := 1;
      while not eof do begin
         if lst.count > 0 then lst.clear;
         s := '';
         for m := 1 to 6 do begin
            if FAry[m].sel then
               lst.add(TwoDigitNumber(fields[m].asinteger));
         end;

         if option = _ALL_ROWS then
            mResult.lines.add(s);
         dec(k);
         next;
      end;
   end;
   BumpItemsCount := j - 1;
end;

procedure TfrmSum.RunThisMenuForSUMorGAPonDataFile(IsItForSUM : boolean);
   var j, c, hitted, asked, i, sum, min, max : integer;
       counts, divcount, orders, finalcount : integer;
       FirstOneAdded, FilterPassed : boolean;
       R : TRangeArray;
begin
   inc(cCheckPosition);
   cCheckPosition := 8;  // Always start w/ 1st logic field on local run
   cCheckTempPos := cCheckPosition;
   counts := 0;
   finalcount := 0;

   if CheckForBumpingFile then begin

   end;

   dm.qMA.close;
   SetAllTheHitCountForMainDataToZero;
   dm.qMA.open;

   with dm.tq do begin
      close;                  // Range Checking
      sql.clear;
      sql.add('select * from Ranges where miid = ' + dm.qMIMIID.asstring
         + ' and cat = ''RS'' order by rnid ');
      open;
      if recordcount > 0 then begin
         while not eof do begin
            min := fieldbyname('bn').asinteger;
            max := fieldbyname('en').asinteger;
            dm.qMA.first;
            while not dm.qMA.eof do begin
               LocalGetSum(sum, FilterPassed, digit_option);
               if (sum >= min) and (sum <= max) then begin
                  dm.qMA.edit;
                  dm.qMA.fields[8].Value := 'Y';
                  inc(counts);
                  dm.qMAHITCOUNT.AsInteger := dm.qMAHITCOUNT.AsInteger + 1;
                  dm.qMA.post;
               end;
               dm.qMA.next;
            end;
            next;
         end;
      end;

      if recordcount > 0 then  // Check for manual count's count
         begin
            first;
            orders := cCheckPosition;
            while not eof do begin
               c := 0;  // bracket counter
               asked := fieldbyname('HIT').asinteger;
               j := fieldbyname('HITTED').asinteger;
               if j > 0 then begin
                  if asked > j then asked := j;
                  divcount := j div asked;
                  FirstOneAdded := false;
                  while not dm.qMA.eof do begin
                     if dm.qMA.fields[orders].value = 'Y' then begin
                        dm.qMA.edit;
                        if (c = divcount) or (not FirstOneAdded) then
                           begin
                              c := 0;
                              dm.qMA.fields[orders].value := 'Y';
                              inc(finalcount);
                              FirstOneAdded := true;
                              AddToTestView;
                           end
                        else
                           begin
                              inc(c);
                              dm.qMA.fields[orders].value := 'N';
                           end;
                        dm.qMA.post;
                     end;
                     dm.qMA.next;
                  end;
               end;
               next;
               inc(orders);
            end
         end
      else
         begin // No range is selected
            dm.qMA.first;
            while not dm.qMA.eof do begin
               if dm.qMAHITCOUNT.asinteger > 0 then
                  AddToTestView;
               dm.qMA.next;
            end;
         end;

      close;   // Check for Manual Entry
//      requestlive := true;
      sql.clear;
      sql.add('select * from Ranges where miid = ' + dm.qMIMIID.asstring
         + ' and cat = ''MN'' order by rnid ');
      open;
      if recordcount > 0 then begin
         while not eof do begin
            j := 0;
            min := fieldbyname('bn').asinteger;
            dm.qMA.first;
            while not dm.qMA.eof do begin
               LocalGetSum(sum, FilterPassed, digit_option);
               if sum = min then begin
                  dm.qMA.edit;
                  dm.qMA.fields[cCheckTempPos].Value := 'Y';
                  inc(counts);
                  dm.qMAHITCOUNT.AsInteger := 1;
                  dm.qMA.post;
                  inc(j);
               end;
               dm.qMA.next;
            end;
            edit;
            fieldbyname('Hitted').asinteger := j;
            post;
            next;
            inc(cCheckTempPos);
         end;

      end;
      if recordcount > 0 then
         begin   // If there was any manual count for Manual
            first;
            orders := cCheckPosition;
            while not eof do begin
               c := 0;  // bracket counter
               asked := fieldbyname('HIT').asinteger;
               j := fieldbyname('HITTED').asinteger;
               if j > 0 then begin
                  if asked > j then asked := j;
                  divcount := j div asked;
                  FirstOneAdded := false;
                  dm.qMA.first;
                  while not dm.qMA.eof do begin
                     if dm.qMA.fields[orders].value = 'Y' then begin
                        dm.qMA.edit;
                        if (c = divcount) or (not FirstOneAdded) then
                           begin
                              c := 0;
                              dm.qMA.fields[orders].value := 'Y';
                              inc(finalcount);
                              FirstOneAdded := true;
                              AddToTestView;
                           end
                        else
                           begin
                              inc(c);
                              dm.qMA.fields[orders].value := 'N';
                           end;
                        dm.qMA.post;
                     end;
                     dm.qMA.next;
                  end;
               end;
               next;
               inc(orders);
            end;
         end
      else
         begin // No range is selected
            dm.qMA.first;
            while not dm.qMA.eof do begin
               if dm.qMAHITCOUNT.asinteger > 0 then
                  AddToTestView;
               dm.qMA.next;
            end;
         end;
   end;
//   lblCount.caption := IntToStr(counts);
//   lblTotal.caption := IntToStr(finalcount);
   dm.qMI.Edit;
   dm.qMIRESULTCNT.AsInteger := counts;
   dm.qMI.post;
end;

procedure TfrmSum.LocalGetSum(var sum : integer; var FtrPassed : boolean; digit_option : integer);
   var j, k : integer;
       colpass : boolean;
begin
   sum := 0;
   FtrPassed := true;
   if digit_option = _BOTH_DIGIT then
      for j := 1 to 6 do
         if FAry[j].sel then sum := sum + dm.qMA.fields[j].asinteger;
   if digit_option = _FIRST_DIGIT then
      for j := 1 to 6 do
         if FAry[j].sel then sum := sum + firstdigit(dm.qMA.fields[j].asinteger);
   if digit_option = _LAST_DIGIT then
      for j := 1 to 6 do
         if FAry[j].sel then sum := sum + lastdigit(dm.qMA.fields[j].asinteger);

   for j := 1 to 6 do begin
      if FAry[j].sel then begin
         if FAry[j].noFileter then
            colpass := true
         else
            begin
               colpass := false;
               for k := 1 to FAry[j].count do
                  if dm.qMA.fields[j].asinteger = FAry[j].a[k] then
                     colpass := true;
            end;
         if colpass = false then FtrPassed := false;
      end;
   end;
end;

procedure TfrmSum.AddToTestView;
begin
   with dm.qMA do begin
      mResult.lines.add(
           TwoDigitNumber(fields[1].asinteger) + ',"'
         + TwoDigitNumber(fields[2].asinteger) + '","'
         + TwoDigitNumber(fields[3].asinteger) + '","'
         + TwoDigitNumber(fields[4].asinteger) + '","'
         + TwoDigitNumber(fields[5].asinteger) + '","'
         + TwoDigitNumber(fields[6].asinteger) + '"');
   end;
end;

procedure TfrmSum.mFileContentDblClick(Sender: TObject);
begin
   mFileContent.visible := false;
end;

procedure TfrmSum.mResultDblClick(Sender: TObject);
begin
   mResult.visible := false;
end;

procedure TfrmSum.bFromLastDrawClick(Sender: TObject);
   var i, j, sum : integer;
begin
   GetLastDrawing;
   StartingFromBottom := dm.qMIROWEND.AsInteger;

   with dm.tq do begin
      close;
//      requestlive := false;
      sql.clear;
      sql.add('delete from columns where miid = '
         + dm.qMIMIID.asstring);
      execsql;
      close;
   end;

   with qQL do begin
      close;
      open;
      insert;
      qQLMIID.Value := dm.qMIMIID.AsInteger;
      qQLCOID.Value := GenKeyVal('COID');
      qQLMANUALINPUT.Value := inttostr(LastTenSum[StartingFromBottom]);
      post;
      close;
      open;
   end;
end;

procedure TfrmSum.GetLastDrawing;
   var s, rf : string;
       i, j, k, p, sm, mintop, current : integer;
       c1, c2, c3, c4, c5 : boolean;
       f : TextFile;
       a : TRowArry;
begin
//   sm := 0;
   mintop := 100;
   current := 10;
   for i := 1 to 10 do LastTenSum[i] := 0;
   c1 := (dm.qMIC1.Value = 'Y');
   c2 := (dm.qMIC2.Value = 'Y');
   c3 := (dm.qMIC3.Value = 'Y');
   c4 := (dm.qMIC4.Value = 'Y');
   c5 := (dm.qMIC5.Value = 'Y');

   {$I-}
   if FileExists(DateFileName) then begin
      AssignFile(f, DateFileName);
      FileMode := 0;  { Set file access to read only }
      Reset(f);
      i := 0;
      while not eof(f) do begin
         readln(f, s);
         inc(i);
         if length(trim(s)) > 0 then rf := s;
         lblLine.caption := inttostr(i);
         application.processmessages;
         if i > mintop then begin  // Start retrieving last 10 numbers.
            ParseNumbers(rf);
            if lst.count = 5 then begin
               try
                  for k := 1 to 5 do a[k] := StrToInt(lst[k-1]);
                  sm := 0;
                  if c1 then sm := sm + a[1];
                  if c2 then sm := sm + a[2];
                  if c3 then sm := sm + a[3];
                  if c4 then sm := sm + a[4];
                  if c5 then sm := sm + a[5];
                  if current > 0 then
                     begin
                        LastTenSum[current] := sm;
                        dec(current);
                     end
                  else
                     begin
                        for j := 10 downto 2 do LastTenSum[j] := LastTenSum[j-1];
                        LastTenSum[1] := sm;
//                        disp(inttostr(sm)+ ' : ' + inttostr(i), 'i');
//                        mResult.Lines.clear;
//                        mResult.visible := true;
//                        for p := 10 downto 1 do mResult.lines.add(inttostr(LastTenSum[p]));
                     end;
               except
                  on e:exception do
                     disp(e.message, 'e');
               end;
            end;
         end;
      end;
      CloseFile(f);

  // For testing the last 10 values.
//      mResult.Lines.clear;
//      mResult.visible := true;
//      for j := 10 downto 1 do mResult.lines.add(inttostr(LastTenSum[j]));

   end;
   {$I+}
end;


procedure TfrmSum.qQLAfterInsert(DataSet: TDataSet);
begin
//   qQLMIID.Value := dm.qMIMIID.AsInteger;
//   qQLCOID.Value := GenKeyVal('COID');
end;

procedure TfrmSum.qQLBeforeOpen(DataSet: TDataSet);
begin
  qQL.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

end.

unit Matches;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, DBCtrls, ExtCtrls, Grids, Wwdbigrd, Wwdbgrid,
  Db, Wwdatsrc, wwdbedit, Wwdotdot, Menus, Wwlocate,
  Wwdbcomb, wwDialog, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADCompDataSet, uADCompClient{, Dbtag};

type
  TfrmMatches = class(TForm)
    Label1: TLabel;
    DBEdit3: TDBEdit;
    bRunSample: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    pnlResultRange: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    wwDBGrid1: TwwDBGrid;
    cbFileDlg: TwwDBComboDlg;
    DBNavigator1: TDBNavigator;
    Memo1: TMemo;
    mFileContent: TMemo;
    mResult: TMemo;
    mDevInfo: TMemo;
    DBCheckBox8: TDBCheckBox;
    eGrpFrom: TEdit;
    Label2: TLabel;
    eGrpTo: TEdit;
    bCopyGroup: TBitBtn;
    Label3: TLabel;
    bSearchAndRep: TBitBtn;
    bPrint: TBitBtn;
    bChangePattern: TBitBtn;
    lblItemCount: TLabel;
    bSearchReplaceNumbers: TBitBtn;
    Label4: TLabel;
    eOGFrom: TEdit;
    eOGto: TEdit;
    bCopyOuterGrp: TBitBtn;
    Label5: TLabel;
    wwLocateDialog1: TwwLocateDialog;
    bFind: TBitBtn;
    DBMemo1: TDBMemo;
    bSaveMemo: TBitBtn;
    dbcOddEven: TwwDBComboBox;
    bMultiRepl: TBitBtn;
    bChangeGrpnOG: TBitBtn;
    eDestOGNo: TEdit;
    bSearchReplaceRanges: TBitBtn;
    qBT: TADQuery;
    dBT: TDataSource;
    qBTBTID: TIntegerField;
    qBTMIID: TIntegerField;
    qBTFILENAME: TStringField;
    qBTKEEPB: TIntegerField;
    qBTKEEPE: TIntegerField;
    qBTLINEB: TIntegerField;
    qBTLINEE: TIntegerField;
    qBTHITTED: TIntegerField;
    qBTC1: TStringField;
    qBTC2: TStringField;
    qBTC3: TStringField;
    qBTC4: TStringField;
    qBTC5: TStringField;
    qBTC6: TStringField;
    qBTGRPNO: TIntegerField;
    qBTGRPKEEPB: TIntegerField;
    qBTGRPKEEPE: TIntegerField;
    qBTOGNO: TIntegerField;
    qBTOGRB: TIntegerField;
    qBTOGRE: TIntegerField;
    qBTODDEVEN: TStringField;
    TimerCount: TTimer;
    procedure cbFileDlgCustomDlg(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure qBTAfterInsert(DataSet: TDataSet);
    procedure qBTAfterPost(DataSet: TDataSet);
    procedure DBEdit3DblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bRunSampleClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mFileContentDblClick(Sender: TObject);
    procedure mResultDblClick(Sender: TObject);
    procedure mDevInfoDblClick(Sender: TObject);
    procedure bCopyGroupClick(Sender: TObject);
    procedure bSearchAndRepClick(Sender: TObject);
    procedure bPrintClick(Sender: TObject);
    procedure bChangePatternClick(Sender: TObject);
    procedure qBTAfterOpen(DataSet: TDataSet);
    procedure bSearchReplaceNumbersClick(Sender: TObject);
    procedure bCopyOuterGrpClick(Sender: TObject);
    procedure bFindClick(Sender: TObject);
    procedure bSaveMemoClick(Sender: TObject);
    procedure bMultiReplClick(Sender: TObject);
    procedure bChangeGrpnOGClick(Sender: TObject);
    procedure bSearchReplaceRangesClick(Sender: TObject);
    procedure qBTBeforeOpen(DataSet: TDataSet);
    procedure TimerCountTimer(Sender: TObject);
    procedure qBTAfterDelete(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ShowDevelopmentInfo;
    function  IsFilterPassed(i : integer) : boolean;
  public
    DoReplace : boolean;
    function  OpenBumpingFile : boolean;
    procedure DumpToResultFile;
    procedure FindMatches(cidx : integer);
  end;

var
  frmMatches: TfrmMatches;

implementation

uses DataMod, global, SuperType, SearchRpl, qrMatch, ChgPattern, RepNumbers,
  MultiRep;

{$R *.DFM}

procedure TfrmMatches.cbFileDlgCustomDlg(Sender: TObject);
begin
   if OpenDialog1.Execute then begin
      if not (qBT.state in [dsEdit, dsInsert]) then qBT.edit;
      qBTFILENAME.text := OpenDialog1.filename;
      qBT.post;
   end;
end;

procedure TfrmMatches.FormCreate(Sender: TObject);
begin
   DoReplace := false;
   qBT.open;
end;

procedure TfrmMatches.qBTAfterDelete(DataSet: TDataSet);
begin
  TimerCount.Enabled := True;
end;

procedure TfrmMatches.qBTAfterInsert(DataSet: TDataSet);
begin
   qBTBTID.Value := GenKeyVal('BTID');
   qBTMIID.Value := dm.qMIMIID.asinteger;
end;

procedure TfrmMatches.qBTAfterPost(DataSet: TDataSet);
   var i : integer;
begin
   if DoReplace then exit; 
   i := qBTBTID.asinteger;
   qBT.close;
   qBT.open;
   qBT.locate('BTID', i, []);
end;

procedure TfrmMatches.qBTBeforeOpen(DataSet: TDataSet);
begin
  qBT.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmMatches.DBEdit3DblClick(Sender: TObject);
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

procedure TfrmMatches.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_F2 then bRunSampleClick(Sender);
   if Key = vk_F3 then bFindClick(Sender);
   if Key = vk_F5 then bSearchAndRepClick(Sender);
   if Key = vk_F7 then bMultiReplClick(Sender);
   if Key = vk_F6 then bSearchReplaceNumbersClick(Sender);
   if Shift = [ssShift] then
      if Key = vk_F11 then ShowDevelopmentInfo;
   if Key = vk_escape then
      if mDevInfo.visible then
         mDevInfo.visible := false
      else
         ModalResult := mrOk;
end;

procedure TfrmMatches.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmMatches.bRunSampleClick(Sender: TObject);
   var j, i, idx : integer;
begin
   idx := 1;
   if _debug then begin
      mFileContent.Lines.clear;
   end;

   // Get Column and Filter Condition
   CheckColumnSelectedStatusAndSubType;

   // Clear Master Array's All Conditions
   for i := 1 to ActualMax do begin
      for j := 1 to _CheckNo do MAry[i].checks[j] := false;
      MAry[i].HitCount := 0;
   end;

   // For all the Bumping Files, get the results
   qBT.first;
   while not qBT.eof do begin
      if OpenBumpingFile then begin // If Bump File is proper.
         FindMatches(idx);               // Perform Match Taske.
         Inc(idx);
      end;
      qBT.next;
   end;

   // Save to Result File.
   if dm.qMISAVETO.asstring = 'Y' then
      DumpToResultFile;

   if _debug then begin
      mFileContent.visible := true;
      mFileContent.bringtofront;
   end;
end;

function TfrmMatches.OpenBumpingFile : boolean;
   var fn, s : string;
       i, j, line : integer;
       starting, ending : integer;
       DataOk : boolean;
begin
   ClearBumpArray;  // Clear BDS
   DataOk := false;
   fn := qBTFILENAME.AsString;
   starting := qBTLINEB.AsInteger;
   ending   := qBTLINEE.AsInteger;
   if starting < 1 then starting := 1;
   if ending   < 1 then ending   := 100000;

   if length(fn) > 0 then begin
      if FileExists(fn) then begin
         bFile.filename := fn;
         AssignFile(bFile.F, fn);
         FileMode := 0;  { Set file access to read only }
         Reset(bFile.F);
         j := 1;
         line := 0;
         while not eof(bFile.F) do begin
            readln(bFile.F, s);
            inc(line);
            if (line >= starting) and (line <= ending) then begin
               if length(trim(s)) > 0 then begin
                  ParseNumbers(s);
                  if lst.count > 0 then begin
                     for i := 0 to lst.count -1 do begin
                        try
                           BAry[j].n[i+1] := StrToInt(lst[i]);
                        except
                           on e:exception do;
                        end;
                     end;
                     BAry[j].ItemCnt := lst.count;
                     inc(j);
                  end;
               end;
            end;
         end;
         BumpItemsCount := j - 1;
         DataOk := (BumpItemsCount > 0);
         CloseFile(bFile.F);
      end;

      if _debug then begin  // Debugging of File Reading
         for j := 1 to BumpItemsCount do begin
            s := '';
            for i := 1 to BAry[j].itemcnt do
               s := s + IntToStr(BAry[j].n[i]) + ' ';
            mFileContent.Lines.add(s + ' --- Counts : '
               + IntToStr(BAry[j].itemcnt));
         end;
         mFileContent.Lines.add('Total Count : ' + IntToStr(BumpItemsCount));
      end;
   end;
   result := DataOK;
end;

function TfrmMatches.IsFilterPassed(i : integer) : boolean;
   var j, k : integer;
       colpass, Passed : boolean;
begin
   Passed := true;  // Check for Column Filter Passing Condition
   for j := 1 to 6 do begin
      if FAry[j].sel then begin
         if FAry[j].noFileter then
            colpass := true
         else
            begin
               colpass := false;
               for k := 1 to FAry[j].count do
                  if MAry[i].n[j] = FAry[j].a[k] then colpass := true;
            end;
         if colpass = false then Passed := false;
      end;
   end;
   result := Passed;
end;

procedure TfrmMatches.FindMatches(cidx : integer);
   var h, j, c, k, i, min, max : integer;
       colpass, FilterPassed, MultiColumns : boolean;
begin
   // Get Keep Range for Each Bumping File
   min := qBTKEEPB.asinteger;
   max := qBTKEEPE.asinteger;
   if min < 1 then min := 1;
   if max < 1 then max := 100000;

   // Find out if bumping file is multicolumn or single column
   MultiColumns := (BAry[1].ItemCnt > 1);

   if not MultiColumns then begin  // Single Column BumpFile
      for i := 1 to ActualMax do begin
         if IsFilterPassed(i) then begin
            c := 0;
            for j := 1 to BumpItemsCount do begin
               for h := 1 to 6 do begin
                  if (FAry[h].sel) and (BAry[j].n[1] = MAry[i].n[h]) then inc(c);
               end;
            end;
            if (c >= min) and (c <= max) then
               MAry[i].checks[cidx] := true;
         end;
      end;
   end;

   if MultiColumns then begin   // Multi Column BumpFile
      for i := 1 to ActualMax do begin
         if IsFilterPassed(i) then begin
            MAry[i].HitCount := 0;
            for j := 1 to BumpItemsCount do begin
               c := 0;
               for k := 1 to BAry[j].ItemCnt do
                  for h := 1 to 6 do begin
                     if (FAry[h].sel) and (BAry[j].n[k] = MAry[i].n[h]) then inc(c);
                  end;
               if c = BAry[j].ItemCnt then inc(MAry[i].HitCount);
            end;
            if (MAry[i].HitCount >= min) and (MAry[i].HitCount <= max) then
               MAry[i].checks[cidx] := true;
         end;
      end;
   end;
end;

procedure TfrmMatches.DumpToResultFile;
   var rf, s : string;
       i, j, cnt, min, max : integer;
begin
   rf := trim(dm.qMIRESULTFILE.AsString);
   if length(rf) < 0 then exit;

   // Get Keep Range for Total Result
   min := dm.qMIRANGEBEGIN.asinteger;
   max := dm.qMIRANGEEND.asinteger;
   if min < 1 then min := 1;
   if max < 1 then max := 100000;

   // Calculate Checked Counts
   for i := 1 to ActualMax do begin
      cnt := 0;
      for j := 1 to _CheckNo do begin
         if MAry[i].checks[j] then inc(cnt);
      end;
      MAry[i].HitCount := cnt;
   end;

   try
      rFile.filename := rf;
      AssignFile(rFile.F, rf);
      FileMode := 0;  { Set file access to read only }
      Rewrite(rFile.F);
      for i := 1 to ActualMax do begin
         if (MAry[i].HitCount >= min) and (MAry[i].HitCount <= max) then begin
            s := TwoDigitNumber(MAry[i].n[1]) + ',"'
               + TwoDigitNumber(MAry[i].n[2]) + '","'
               + TwoDigitNumber(MAry[i].n[3]) + '","'
               + TwoDigitNumber(MAry[i].n[4]) + '","'
               + TwoDigitNumber(MAry[i].n[5]) + '","'
               + TwoDigitNumber(MAry[i].n[6]) + '"';
            writeln(rFile.F, s);
         end;
      end;
   except
      on e:exception do begin
         disp('File could not be saved for some reason!', 'e');
      end;
   end;
   CloseFile(rFile.F);
end;

procedure TfrmMatches.FormDestroy(Sender: TObject);
begin
   if qBT.state    in [dsEdit, dsInsert] then qBT.post;
   if dm.qMI.state in [dsEdit, dsInsert] then dm.qMi.post;
end;

procedure TfrmMatches.mFileContentDblClick(Sender: TObject);
begin
   mFileContent.visible := false;
end;


procedure TfrmMatches.mResultDblClick(Sender: TObject);
begin
   mResult.visible := false;
end;

procedure TfrmMatches.mDevInfoDblClick(Sender: TObject);
begin
   mDevInfo.visible := false;
end;

procedure TfrmMatches.ShowDevelopmentInfo;
begin
   with mDevInfo do begin
      left := 7;
      top := 4;
      visible := true;
      BringToFront;
   end;
end;

procedure TfrmMatches.TimerCountTimer(Sender: TObject);
begin
  TimerCount.Enabled := False;
  qBT.Refresh;
  lblItemCount.Caption := 'Count : ' + IntToStr(qBT.RecordCount);
end;

procedure TfrmMatches.bCopyGroupClick(Sender: TObject);
   var grpFrom, grpTo, j, k, i, FinalOgno : integer;
       q1, q2 : TADQuery;
begin
   grpFrom := 0;
   grpTo := 0;
   FinalOgno := 0;
   if length(eGrpFrom.Text) < 1 then begin
      eGrpFrom.SetFocus;
      exit;
   end;
   if length(eGrpTo.Text) < 1 then begin
      eGrpTo.SetFocus;
      exit;
   end;
   if length(eDestOGNo.Text) < 1 then begin
      eDestOGNo.SetFocus;
      exit;
   end;
   try
      grpFrom := StrToInt(Trim(eGrpFrom.text));
      grpTo := StrToInt(Trim(eGrpTo.text));
      FinalOgno := StrToInt(Trim(eDestOGNo.text));
   except
      on e:exception do begin
         disp(e.message, 'e');
         exit;
      end;
   end;

   q1 := TADQuery.create(nil);
   q2 := TADQuery.create(nil);
   q1.Connection := dm.ADConnection;
   q1.Transaction := dm.ADTransaction;
   q2.Connection := dm.ADConnection;
   q2.Transaction := dm.ADTransaction;
   try
      q1.sql.add('select * from bumptables where miid = 0 ');
      q2.sql.add('select * from bumptables where miid = '
         +dm.qMIMIID.AsString+' and grpno = '+eGrpFrom.text+' ');
      q1.open;
      q2.open;
      j := q2.Fieldcount;
      q2.first;
      while not q2.eof do begin
         i := GenKeyVal('btid');
         q1.insert;
         for k := 1 to j - 1 do begin
            try
               q1.fields[k].Value := q2.fields[k].value;
            except
               on e:exception do ;
            end;
         end;
         q1.fieldbyname('btid').value := i;
         q1.fieldbyname('grpno').value := grpTo;
         q1.fieldbyname('ogno').value := FinalOgno;
         q1.post;
         q2.next;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         q1.cancel;
      end;
   end;
   q1.close;
   q2.close;
   q1.free;
   q2.free;
   q1 := nil;
   q2 := nil;
   qBT.close;
   qBT.open;
end;

procedure TfrmMatches.bSearchAndRepClick(Sender: TObject);
   var bp, ep, l, ls : integer;
begin
   DoReplace := false;
   frmSearchAndReplace := TfrmSearchAndReplace.create(nil);
   frmSearchAndReplace.showmodal;
   if DoReplace then begin
      l := length(SearchKey);
      with qBT do begin
         first;
         ls := length(qBTFILENAME.asstring);
         while not eof do begin
            bp := Pos(SearchKey, qBTFILENAME.asstring);
            if bp > 1 then begin
               s := Copy(qBTFILENAME.asstring, 1, bp - 1)
                  + ReplaceKey
                  + Copy(qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
               edit;
               qBTFILENAME.asstring := s;
               post;
            end;
            if bp = 1 then begin
               s := ReplaceKey
                  + Copy(qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
               edit;
               qBTFILENAME.asstring := s;
               post;
            end;
            next;
         end;
      end;

   end;
   frmSearchAndReplace.release;
   frmSearchAndReplace := nil;

   DoReplace := false;
end;

procedure TfrmMatches.bPrintClick(Sender: TObject);
begin
   frmQrMatch := TfrmQrMatch.create(nil);
   frmQrMatch.qr.preview;
   frmQrMatch.release;
   frmQrMatch := nil;
end;

procedure TfrmMatches.bChangePatternClick(Sender: TObject);
   var s : string;
       en, bp, ep, l, ls, i, j : integer;
       DoFromCurrent : boolean;
       q : TADQuery;
begin
   q := TADQuery.create(nil);
   DoReplace := false;
   frmChangePattern := TfrmChangePattern.create(nil);
   if frmChangePattern.showmodal = mrOk then begin
      DoFromCurrent := frmChangePattern.cbDoFromThisPoint.checked;
      en := frmChangePattern.eno;
      DoReplace := true;
   end;
   frmChangePattern.release;
   frmChangePattern := nil;

   if DoReplace then begin
      q.Connection := dm.ADConnection;
      q.Transaction := dm.ADTransaction;
      q.sql.add('select * from bumptables where miid = '
         + qBTMIID.AsString + ' order by ogno, grpno, btid ');
      q.open;
      with qBT do begin
         if not DoFromCurrent then begin
            first;
            for i := 1 to en do next; //  Go to starting position of destination
         end;
//         if bn > 0 then for j := 1 to bn-1 do q.next;
         i := 1;
         while not eof do begin
            edit;
            qBTC1.Value := q.fieldbyname('c1').value;
            qBTC2.Value := q.fieldbyname('c2').value;
            qBTC3.Value := q.fieldbyname('c3').value;
            qBTC4.Value := q.fieldbyname('c4').value;
            qBTC5.Value := q.fieldbyname('c5').value;
            qBTC6.Value := q.fieldbyname('c6').value;
            post;
            next;
            inc(i);
            if i > en then
               begin
                  q.first;
                  i := 1;
               end
            else
               q.next;
         end;
      end;
   end;
   DoReplace := false;
   q.free;
   q := nil;
end;

procedure TfrmMatches.qBTAfterOpen(DataSet: TDataSet);
begin
  lblItemCount.Caption := 'Count : ' + IntToStr(qBT.RecordCount);
end;

procedure TfrmMatches.bSearchReplaceNumbersClick(Sender: TObject);
   var SearchKey, ReplaceKey, s : string;
       bp, ep, l, ls : integer;
       slb, sle, rlb, rle : integer;
begin
   DoReplace := false;
   frmReplaceNumbers := TfrmReplaceNumbers.create(nil);
   frmReplaceNumbers.ReplaceRanges := false;
   if frmReplaceNumbers.showmodal = mrOk then begin
      slb := frmReplaceNumbers.slb;
      sle := frmReplaceNumbers.sle;
      rlb := frmReplaceNumbers.rlb;
      rle := frmReplaceNumbers.rle;
      DoReplace := true;
   end;
   frmReplaceNumbers.release;
   frmReplaceNumbers := nil;
   if DoReplace then begin
      with qBT do begin
         first;
         while not eof do begin
            if qBTLINEB.asinteger = slb then begin
               edit;
               qBTLINEB.asinteger := rlb;
               post;
            end;
            if qBTLINEE.asinteger = sle then begin
               edit;
               qBTLINEE.asinteger := rle;
               post;
            end;
            next;
         end;
      end;

   end;
   DoReplace := false;
end;

procedure TfrmMatches.bCopyOuterGrpClick(Sender: TObject);
   var grpFrom, grpTo, j, k, i : integer;
       q1, q2 : TADQuery;
begin
   grpFrom := 0;
   grpTo := 0;
   if length(eOGFrom.Text) < 1 then begin
      eOGFrom.SetFocus;
      exit;
   end;
   if length(eOGto.Text) < 1 then begin
      eOGto.SetFocus;
      exit;
   end;
   try
      grpFrom := StrToInt(Trim(eOGFrom.text));
      grpTo := StrToInt(Trim(eOGto.text));
   except
      on e:exception do begin
         disp(e.message, 'e');
         exit;
      end;
   end;

   q1 := TADQuery.create(nil);
   q2 := TADQuery.create(nil);
   q1.Connection := dm.ADConnection;
   q1.Transaction := dm.ADTransaction;
   q2.Connection := dm.ADConnection;
   q2.Transaction := dm.ADTransaction;
   try
      q1.sql.add('select * from bumptables where miid = 0 ');
      q2.sql.add('select * from bumptables where miid = '
         + dm.qMIMIID.AsString + ' and ogno = '
         + eOGFrom.text + ' order by ogno, grpno, btid ');
      q1.open;
      q2.open;
      j := q2.Fieldcount;
      q2.first;
      while not q2.eof do begin
         i := GenKeyVal('btid');
         q1.insert;
         for k := 1 to j - 1 do begin
            try
               q1.fields[k].Value := q2.fields[k].value;
            except
               on e:exception do ;
            end;
         end;
         q1.fieldbyname('btid').value := i;
         q1.fieldbyname('ogno').value := grpTo;
         q1.post;
         q2.next;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         q1.cancel;
      end;
   end;
   q1.close;
   q2.close;
   q1.free;
   q2.free;
   q1 := nil;
   q2 := nil;
   qBT.close;
   qBT.open;
end;

procedure TfrmMatches.bFindClick(Sender: TObject);
begin
   wwLocateDialog1.execute;
end;

procedure TfrmMatches.bSaveMemoClick(Sender: TObject);
   var fn : string;
begin
   if SaveDialog1.execute then begin
      fn := SaveDialog1.filename;
      DBMemo1.lines.SaveToFile(fn);
   end;
end;


procedure TfrmMatches.bMultiReplClick(Sender: TObject);
   var s, r : string;
       i, bl, el, tl : integer;
       done : boolean;
       mr : TModalResult;
begin
   frmMultiRep := TfrmMultiRep.create(nil);
   mr := frmMultiRep.showmodal;
   if (mr = mrOk) or (mr = mrYes) then begin
      DoReplace := true;
      with qBT do begin
         if mr = mrOK then first;
         while not eof do begin
            s := qBTFILENAME.asstring;
            if length(s) > 0 then begin
               s := s;
               done := false;
               for i := 1 to 5 do begin
                  if not done then begin
                     if pos(ss[i], s) <> 0 then begin
                        tl := length(s);
                        bl := pos(ss[i], s) - 1;
                        el := bl + length(ss[i]) + 1;
                        r := copy(s, 1, bl) + sr[i]
                           + copy(s, el, (tl-el));
                        edit;
                        qBTFILENAME.asstring := r;
                        post;
                        done := true;
                     end;
                  end;
               end;
            end;
            next;
         end;
         first;
      end;
   end;
   frmMultiRep.release;
   frmMultiRep := nil;
   DoReplace := false;
end;


procedure TfrmMatches.bChangeGrpnOGClick(Sender: TObject);
   var grpFrom, grpTo, j, k, i, FinalOgno, grpdiff, ogdiff : integer;
       q1 : TADQuery;
begin
   grpFrom := 0;
   FinalOgno := 0;
   if length(eGrpFrom.Text) < 1 then begin
      eGrpFrom.SetFocus;
      exit;
   end;
   if length(eDestOGNo.Text) < 1 then begin
      eDestOGNo.SetFocus;
      exit;
   end;
   try
      grpFrom := StrToInt(Trim(eGrpFrom.text));
      FinalOgno := StrToInt(Trim(eDestOGNo.text));
   except
      on e:exception do begin
         disp(e.message, 'e');
         exit;
      end;
   end;
   grpdiff := grpFrom - qBTGRPNO.AsInteger;
   ogdiff := FinalOgno - qBTOGNO.AsInteger;

   q1 := TADQuery.create(nil);
   q1.Connection := dm.ADConnection;
   q1.Transaction := dm.ADTransaction;
   try
      q1.sql.add('select * '
         + 'from bumptables '
         + 'where miid = ' + qBTMIID.AsString + ' '
         + 'order by ogno, grpno, btid');
      q1.open;
      qBT.close;
      while not q1.eof do begin
         q1.edit;
         q1.fieldbyname('grpno').value := q1.fieldbyname('grpno').value + grpdiff;
         q1.fieldbyname('ogno').value := q1.fieldbyname('ogno').value + ogdiff;
         q1.post;
         q1.next;
      end;
   except
      on e:exception do begin
         disp(e.message, 'e');
         q1.cancel;
      end;
   end;
   q1.close;
   q1.free;
   q1 := nil;
   qBT.close;
   qBT.open;
end;


procedure TfrmMatches.bSearchReplaceRangesClick(Sender: TObject);
   var SearchKey, ReplaceKey, s : string;
       bp, ep, l, ls : integer;
       slb, sle, rlb, rle : integer;
begin
   DoReplace := false;
   frmReplaceNumbers := TfrmReplaceNumbers.create(nil);
   frmReplaceNumbers.ReplaceRanges := true;
   if frmReplaceNumbers.showmodal = mrOk then begin
      slb := frmReplaceNumbers.slb;
      sle := frmReplaceNumbers.sle;
      rlb := frmReplaceNumbers.rlb;
      rle := frmReplaceNumbers.rle;
      DoReplace := true;
   end;
   frmReplaceNumbers.release;
   frmReplaceNumbers := nil;
   if DoReplace then begin
      with qBT do begin
         first;
         while not eof do begin
            if qBTKEEPB.asinteger = slb then begin
               edit;
               qBTKEEPB.asinteger := rlb;
               post;
            end;
            if qBTKEEPE.asinteger = sle then begin
               edit;
               qBTKEEPE.asinteger := rle;
               post;
            end;
            next;
         end;
      end;

   end;
   DoReplace := false;
end;

end.

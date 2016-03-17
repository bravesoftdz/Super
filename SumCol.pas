unit SumCol;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Grids, AdvGrid, ExtCtrls, StdCtrls,
  DBCtrls, Wwdbigrd, Wwdbgrid, Mask, wwdbedit, Wwdotdot, Wwdbcomb, Buttons,
  ComCtrls, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TfrmSumCol = class(TForm)
    Shape1: TShape;
    DBEdit3: TDBEdit;
    DBCheckBox8: TDBCheckBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    mDevInfo: TMemo;
    Label1: TLabel;
    wwDBGrid1: TwwDBGrid;
    DBNavigator1: TDBNavigator;
    lblItemCount: TLabel;
    DBMemo1: TDBMemo;
    mResult: TMemo;
    mFileContent: TMemo;
    pnlResultRange: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    bTest: TButton;
    Label2: TLabel;
    eGrpFrom: TEdit;
    Label3: TLabel;
    eGrpTo: TEdit;
    bCopyGroup: TBitBtn;
    Label4: TLabel;
    eOGFrom: TEdit;
    Label5: TLabel;
    eOGto: TEdit;
    bCopyOuterGrp: TBitBtn;
    bChangePattern: TBitBtn;
    cbFileDlg: TwwDBComboDlg;
    eDestOGNo: TEdit;
    bTestAndModify: TButton;
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
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBEdit3DblClick(Sender: TObject);
    procedure mDevInfoDblClick(Sender: TObject);
    procedure qBTAfterInsert(DataSet: TDataSet);
    procedure qBTAfterOpen(DataSet: TDataSet);
    procedure qBTAfterPost(DataSet: TDataSet);
    procedure mFileContentDblClick(Sender: TObject);
    procedure mResultDblClick(Sender: TObject);
    procedure bTestClick(Sender: TObject);
    procedure bCopyGroupClick(Sender: TObject);
    procedure bCopyOuterGrpClick(Sender: TObject);
    procedure bChangePatternClick(Sender: TObject);
    procedure cbFileDlgCustomDlg(Sender: TObject);
    procedure bTestAndModifyClick(Sender: TObject);
    procedure qBTBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure TimerCountTimer(Sender: TObject);
    procedure qBTAfterDelete(DataSet: TDataSet);
  private
    procedure ShowResultOnScreen;
    procedure ShowDevelopmentInfo;
  public
    DoReplace : boolean;
    procedure AddToTestView;
    procedure FilterRows(Option : integer);
    procedure RunThisMenuForSUMorGAPonDataFile(IsItForSUM : boolean);
    procedure LocalGetSum(var sum : integer; var FtrPassed : boolean; digit_option : integer);
  end;

var
  frmSumCol: TfrmSumCol;

implementation

{$R *.DFM}

uses global, SuperType, DataMod, ChgPattern;

procedure TfrmSumCol.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
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

procedure TfrmSumCol.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmSumCol.FormDestroy(Sender: TObject);
begin
   if qBT.state    in [dsEdit, dsInsert] then qBT.post;
   if dm.qMI.state in [dsEdit, dsInsert] then dm.qMi.post;
end;

procedure TfrmSumCol.FormCreate(Sender: TObject);
begin
   DoReplace := false;
   qBT.open;
   mResult.lines.clear;
end;

procedure TfrmSumCol.DBEdit3DblClick(Sender: TObject);
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

procedure TfrmSumCol.mDevInfoDblClick(Sender: TObject);
begin
   mDevInfo.visible := false;
end;

procedure TfrmSumCol.ShowResultOnScreen;
begin
   with mResult do begin
      left := 148;
      top  := 10;
      visible := true;
   end;
end;

procedure TfrmSumCol.TimerCountTimer(Sender: TObject);
begin
  TimerCount.Enabled := False;
  qBT.Refresh;
  lblItemCount.Caption := 'Count : ' + IntToStr(qBT.RecordCount);
end;

procedure TfrmSumCol.ShowDevelopmentInfo;
begin
   with mDevInfo do begin
      left := 7;
      top := 4;
      visible := true;
      BringToFront;
   end;
end;

procedure TfrmSumCol.FilterRows(Option : integer);
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

         // Formating Result to saving format
{         if lst.count > 0 then begin
            for m := 0 to lst.count - 1 do begin
               if ((m = 0) and (m = lst.count - 1)) then // Single
                  s := s + lst[m]
               else
                  if m = 0 then  // For the first one
                     s := s + lst[m] + ',"'
                  else
                     if m = lst.count - 1 then // for the last one
                        s := s + lst[m] + '"'
                     else
                        s := s + lst[m] + '","';
            end;
         end;  }
         if option = _PARTIAL_ROWS then
               if k >= i then begin
{                  if lst.count > 0 then begin
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
            end;}
         end;

{                  BAry[j].n[i+1] := StrToInt(lst[i]);

                  BAry[j].ItemCnt := lst.count;
                  inc(j);
               end;      }
         if option = _ALL_ROWS then
            mResult.lines.add(s);
         dec(k);
         next;
      end;
   end;
   BumpItemsCount := j - 1;
end;

procedure TfrmSumCol.RunThisMenuForSUMorGAPonDataFile(IsItForSUM : boolean);
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

procedure TfrmSumCol.LocalGetSum(var sum : integer; var FtrPassed : boolean; digit_option : integer);
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

procedure TfrmSumCol.AddToTestView;
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

procedure TfrmSumCol.qBTAfterDelete(DataSet: TDataSet);
begin
  TimerCount.Enabled := True;
end;

procedure TfrmSumCol.qBTAfterInsert(DataSet: TDataSet);
begin
   qBTBTID.Value := GenKeyVal('BTID');
   qBTMIID.Value := dm.qMIMIID.asinteger;
end;

procedure TfrmSumCol.qBTAfterOpen(DataSet: TDataSet);
begin
  lblItemCount.Caption := 'Count : ' + inttostr(qBT.recordcount);
end;

procedure TfrmSumCol.qBTAfterPost(DataSet: TDataSet);
   var i : integer;
begin
   if DoReplace then exit;
   i := qBTBTID.asinteger;
   qBT.close;
   qBT.open;
   qBT.locate('BTID', i, []);
end;

procedure TfrmSumCol.qBTBeforeOpen(DataSet: TDataSet);
begin
  qBT.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmSumCol.mFileContentDblClick(Sender: TObject);
begin
   mFileContent.visible := false;
end;

procedure TfrmSumCol.mResultDblClick(Sender: TObject);
begin
   mResult.visible := false;
end;

procedure TfrmSumCol.bTestClick(Sender: TObject);
begin
   TestAndModify := false;
   cCheckPosition := 0;
   cMainMenuOrder := 1;
   cPosition := 1;
   RunThisMenuForSUM;
end;


procedure TfrmSumCol.bCopyGroupClick(Sender: TObject);
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

procedure TfrmSumCol.bCopyOuterGrpClick(Sender: TObject);
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


procedure TfrmSumCol.bChangePatternClick(Sender: TObject);
   var s : string;
       en, bp, ep, l, ls, i : integer;
       q : TADQuery;
begin
   q := TADQuery.create(nil);
   DoReplace := false;
   frmChangePattern := TfrmChangePattern.create(nil);
   if frmChangePattern.showmodal = mrOk then begin
      en := frmChangePattern.eno;
      DoReplace := true;
   end;
   frmChangePattern.release;
   frmChangePattern := nil;

   if DoReplace then begin
      q.Connection := dm.ADConnection;
      q.Transaction := dm.ADTransaction;
      q.sql.add('select * from bumptables where miid = '
         + qBTMIID.AsString + ' order by grpno, btid ');
      q.open;
      with qBT do begin
         first;
         for i := 1 to en do next; //  Go to starting position
         i := 1;
         while not eof do begin
            edit;
            qBTC1.Value := q.fieldbyname('c1').value;
            qBTC2.Value := q.fieldbyname('c2').value;
            qBTC3.Value := q.fieldbyname('c3').value;
            qBTC4.Value := q.fieldbyname('c4').value;
            qBTC5.Value := q.fieldbyname('c5').value;
            post;
            inc(i);
            if i > en then
               begin
                  q.first;
                  i := 1;
               end
            else
               q.next;
            next;
         end;
      end;
   end;
   DoReplace := false;
   q.free;
   q := nil;
end;


procedure TfrmSumCol.cbFileDlgCustomDlg(Sender: TObject);
begin
   if OpenDialog1.Execute then begin
      if not (qBT.state in [dsEdit, dsInsert]) then qBT.edit;
      qBTFILENAME.text := OpenDialog1.filename;
      qBT.post;
   end;
end;



procedure TfrmSumCol.bTestAndModifyClick(Sender: TObject);
begin
   TestAndModify := true;
   cCheckPosition := 0;
   cMainMenuOrder := 2;
   cPosition := 1;
   RunThisMenuForSUM;
end;

end.

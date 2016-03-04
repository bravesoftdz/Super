unit SumReduc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Db, Wwdatsrc, Mask,
  wwdbedit, Wwdotdot, Wwdbcomb, ExtCtrls, DBCtrls, Wwdbigrd, Wwdbgrid,
  AdvGrid, Buttons, ComCtrls, Menus, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADCompDataSet, uADCompClient, AdvObj, BaseGrid;

type
  TfrmSumReduction = class(TForm)
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    wwDBComboBox1: TwwDBComboBox;
    Label5: TLabel;
    SaveDialog1: TSaveDialog;
    DBNavigator1: TDBNavigator;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    wwDBGrid1: TwwDBGrid;
    Label2: TLabel;
    wwDBGrid2: TwwDBGrid;
    wwDBGrid3: TwwDBGrid;
    wwDBGrid4: TwwDBGrid;
    pnlGroupPerc: TPanel;
    Label3: TLabel;
    DBNavigator2: TDBNavigator;
    DBNavigator3: TDBNavigator;
    Label8: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    bCloseGrp: TButton;
    bGroupPerc: TBitBtn;
    bRunSample: TBitBtn;
    Shape1: TShape;
    Label6: TLabel;
    mResult: TMemo;
    lblCount: TLabel;
    lblTotal: TLabel;
    mFileContent: TMemo;
    dbRowSelect: TDBCheckBox;
    pnlRow: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Shape2: TShape;
    DBEdit2: TDBEdit;
    DBEdit4: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    wwDBComboBox2: TwwDBComboBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox7: TDBCheckBox;
    Label10: TLabel;
    pnlResultRange: TPanel;
    Label14: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label15: TLabel;
    mDevInfo: TMemo;
    DBCheckBox8: TDBCheckBox;
    qCOL: TADQuery;
    qCOLCOID: TIntegerField;
    qCOLMIID: TIntegerField;
    qCOLNUM: TIntegerField;
    qCOLMANUALINPUT: TStringField;
    qCOLTABLENAME: TStringField;
    qCOLSELECTED: TStringField;
    qCOLREPEATS: TIntegerField;
    dCOL: TDataSource;
    qRN: TADQuery;
    dRN: TDataSource;
    qRNRNID: TIntegerField;
    qRNMIID: TIntegerField;
    qRNBN: TIntegerField;
    qRNEN: TIntegerField;
    qRNCAT: TStringField;
    qRNPERC: TFloatField;
    qRNHIT: TIntegerField;
    qRNHITTED: TIntegerField;
    qMan: TADQuery;
    dMan: TDataSource;
    qManRNID: TIntegerField;
    qManMIID: TIntegerField;
    qManBN: TIntegerField;
    qManEN: TIntegerField;
    qManCAT: TStringField;
    qManPERC: TFloatField;
    qManHIT: TIntegerField;
    qManHITTED: TIntegerField;
    qSrcRG: TADQuery;
    dSrcRG: TDataSource;
    qSrcRGRNID: TIntegerField;
    qSrcRGMIID: TIntegerField;
    qSrcRGBN: TIntegerField;
    qSrcRGEN: TIntegerField;
    qSrcRGCAT: TStringField;
    qSrcRGPERC: TFloatField;
    qSrcRGHIT: TIntegerField;
    qSrcRGHITTED: TIntegerField;
    advGrid: TAdvStringGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBEdit1DblClick(Sender: TObject);
    procedure DBEdit3DblClick(Sender: TObject);
    procedure qRNAfterInsert(DataSet: TDataSet);
    procedure qCOLAfterInsert(DataSet: TDataSet);
    procedure qRNAfterPost(DataSet: TDataSet);
    procedure qManAfterInsert(DataSet: TDataSet);
    procedure qManAfterPost(DataSet: TDataSet);
    procedure qSrcRGAfterInsert(DataSet: TDataSet);
    procedure qSrcRGAfterPost(DataSet: TDataSet);
    procedure bCloseGrpClick(Sender: TObject);
    procedure bGroupPercClick(Sender: TObject);
    procedure bRunSampleClick(Sender: TObject);
    procedure mResultDblClick(Sender: TObject);
    procedure mFileContentDblClick(Sender: TObject);
    procedure DBCheckBox1Exit(Sender: TObject);
    procedure dbRowSelectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mDevInfoDblClick(Sender: TObject);
    procedure advGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure qCOLBeforeOpen(DataSet: TDataSet);
    procedure qRNBeforeOpen(DataSet: TDataSet);
    procedure qManBeforeOpen(DataSet: TDataSet);
    procedure qSrcRGBeforeOpen(DataSet: TDataSet);
  private
    procedure ShowDevelopmentInfo;
  public
    procedure AddToTestView;
    procedure LocalGetSum(var sum : integer; var FtrPassed : boolean; digit_option : integer);
    procedure LocalGetGap(var sum : integer; var FtrPassed : boolean; digit_option : integer);
    procedure RunThisMenuForSUMorGAPonDataFile(IsItForSUM : boolean);
    procedure ShowResultOnScreen;
    procedure FilterRows(Option : integer);
  end;

var
  frmSumReduction: TfrmSumReduction;

implementation

uses DataMod, global, main, SuperType;

{$R *.DFM}

procedure TfrmSumReduction.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_F5 then bGroupPercClick(Sender);
   if Key = vk_F2 then bRunSampleClick(Sender);
   if Key = vk_F6 then ShowResultOnScreen;
   if Shift = [ssShift] then
      if Key = vk_F11 then ShowDevelopmentInfo;
   if Key = vk_escape then begin
      if pnlGroupPerc.visible then
         pnlGroupPerc.visible := false
      else
         if mDevInfo.visible then
            mDevInfo.visible := false
         else
            ModalResult := mrOk;
   end;
end;

procedure TfrmSumReduction.FormCreate(Sender: TObject);
   var i : integer;
begin
   mResult.visible := false;
   mFileContent.lines.clear;
   qCOL.open;
   qRN.open;
   i := qCOL.recordcount;
   if i = 0 then i := 1;
   if i < 6 then begin
      with qCol do begin
         while i < 7 do begin
            insert;
            qCOLSELECTED.Value := 'N';
            qCOLNUM.Value := i;
            post;
            inc(i);
         end;
      end;
   end;
   with advGrid do begin
      Cells[0,0] := 'Groups / Draws';
      Cells[1,0] := 'Last 10';
      Cells[2,0] := 'Last 25';
      Cells[3,0] := 'Last 50';
      Cells[4,0] := 'Last 100';
      Cells[5,0] := 'All';
      Cells[0,1] := '1-12   %';
      Cells[0,2] := '13-25 %';
      Cells[0,3] := '26-38 %';
      Cells[0,4] := '39-51 %';
   end;
   qSrcRG.open;
   qRN.open;
   qMan.open;
   DBEdit2.visible := (dm.qMIUSEALLROW.AsString = 'N');
   DBEdit4.visible := (dm.qMIUSEALLROW.AsString = 'N');
end;

procedure TfrmSumReduction.FormDestroy(Sender: TObject);
begin
   if qCOL.state   in [dsEdit, dsInsert] then qCOL.post;
   if qRN.state    in [dsEdit, dsInsert] then qRN.post;
   if qSrcRG.state in [dsEdit, dsInsert] then qSrcRG.post;
   if qMan.state   in [dsEdit, dsInsert] then qMan.post;
   if dm.qMI.state in [dsEdit, dsInsert] then dm.qMi.post;
end;

procedure TfrmSumReduction.DBEdit1DblClick(Sender: TObject);
begin
   if OpenDialog1.Execute then begin
      if not (dm.qMI.state in [dsEdit, dsInsert]) then dm.qMi.edit;
      dm.qMIBUMPTABLE.text := OpenDialog1.filename;
      dm.qMI.post;
   end;
end;

procedure TfrmSumReduction.DBEdit3DblClick(Sender: TObject);
begin
   if SaveDialog1.Execute then begin
      if not (dm.qMI.state in [dsEdit, dsInsert]) then dm.qMi.edit;
      dm.qMIRESULTFILE.text := SaveDialog1.filename;
      dm.qMI.post;
   end;
end;

procedure TfrmSumReduction.qRNAfterInsert(DataSet: TDataSet);
begin
   qRNRNID.AsInteger := GenKeyVal('RNID');
   qRNMIID.AsInteger := dm.qMIMIID.asinteger;
   qRNCAT.AsString := 'RS';
end;

procedure TfrmSumReduction.qCOLAfterInsert(DataSet: TDataSet);
begin
   qCOLCOID.Value := GenKeyVal('COID');
   qCOLMIID.Value := dm.qMIMIID.asinteger;
end;

procedure TfrmSumReduction.qCOLBeforeOpen(DataSet: TDataSet);
begin
  qCOL.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmSumReduction.qRNAfterPost(DataSet: TDataSet);
begin
//   qRN.Close;
//   qRN.open;
end;

procedure TfrmSumReduction.qRNBeforeOpen(DataSet: TDataSet);
begin
  qRN.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmSumReduction.qManAfterInsert(DataSet: TDataSet);
begin
   qManRNID.AsInteger := GenKeyVal('RNID');
   qManMIID.AsInteger := dm.qMIMIID.asinteger;
   qManCAT.AsString := 'MN';
end;

procedure TfrmSumReduction.qManAfterPost(DataSet: TDataSet);
begin
   qMan.Close;
   qMan.open;
end;

procedure TfrmSumReduction.qManBeforeOpen(DataSet: TDataSet);
begin
  qMan.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmSumReduction.qSrcRGAfterInsert(DataSet: TDataSet);
begin
   qSrcRGRNID.AsInteger := GenKeyVal('RNID');
   qSrcRGMIID.AsInteger := dm.qMIMIID.asinteger;
   qSrcRGCAT.AsString := 'SR';
end;

procedure TfrmSumReduction.qSrcRGAfterPost(DataSet: TDataSet);
begin
   qSrcRG.Close;
   qSrcRG.open;
end;

procedure TfrmSumReduction.qSrcRGBeforeOpen(DataSet: TDataSet);
begin
  qSrcRG.Params.ParamByName('MIID').AsInteger := dm.qMIMIID.AsInteger;
end;

procedure TfrmSumReduction.advGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
   HAlign := taCenter;
   VAlign := vtaCenter;
end;

procedure TfrmSumReduction.bCloseGrpClick(Sender: TObject);
begin
   pnlGroupPerc.visible := false;
end;

procedure TfrmSumReduction.bGroupPercClick(Sender: TObject);
begin
   with pnlGroupPerc do begin
      visible := true;
      Left := 67;
      Top  := 137;
   end;
end;

procedure TfrmSumReduction.LocalGetSum(var sum : integer; var FtrPassed : boolean; digit_option : integer);
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

procedure TfrmSumReduction.LocalGetGap(var sum : integer; var FtrPassed : boolean; digit_option : integer);
   var a : TRowArry;
       j, k, idx : integer;
       colpass : boolean;
begin
   sum := 0;
   idx := 1;
   FtrPassed := true;
   for k := 1 to 6 do begin
      a[k] := 0;
      if FAry[k].sel then begin
         a[idx] := dm.qMA.fields[k].asinteger;
         inc(idx);
      end;
   end;

   for k := 1 to idx - 1 do begin
      if digit_option = _BOTH_DIGIT then
         sum := sum + a[k+1] - a[k];
      if digit_option = _FIRST_DIGIT then
         sum := sum+abs(firstdigit(a[k+1])-firstdigit(a[k]));
      if digit_option = _LAST_DIGIT then
         sum := sum+abs(lastdigit(a[k+1])-lastdigit(a[k]));
   end;

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

procedure TfrmSumReduction.bRunSampleClick(Sender: TObject);
   var fn, s, rf : string;
       i, j : integer;
begin
   {$I-}
   mResult.lines.clear;
   mFileContent.Lines.clear;
   ClearBumpArray;

   CheckColumnSelectedStatusAndSubType;

   fn := dm.qMIBUMPTABLE.AsString;

   if length(fn) > 0 then begin
      if FileExists(fn) then begin
         bFile.filename := fn;
         AssignFile(bFile.F, fn);
         FileMode := 0;  { Set file access to read only }
         Reset(bFile.F);
         j := 1;
         while not eof(bFile.F) do begin
            readln(bFile.F, s);
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
         BumpItemsCount := j - 1;
         CloseFile(bFile.F);
      end;
      if dm.qMIUSEROW.Value = 'Y' then begin

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
   if ((dm.qMIUSEALLROW.Value = 'Y') or
      ((dm.qMIUSEALLROW.Value = 'N') and (dm.qMIROWBEGIN.AsInteger > 0))) then
      begin
         if dm.qMIUSEALLROW.Value = 'Y' then begin
            FilterRows(_ALL_ROWS);

         end;
         if (dm.qMIUSEALLROW.Value = 'N') and (dm.qMIROWBEGIN.AsInteger > 0) then begin
            FilterRows(_PARTIAL_ROWS)

         end;
      end
   else
      begin
         if dm.qMICALMETHOD.AsString = 'SUM' then
            RunThisMenuForSUMorGAPonDataFile(_FOR_SUM);
         if dm.qMICALMETHOD.AsString = 'GAP' then
            RunThisMenuForSUMorGAPonDataFile(_FOR_GAP);
      end;
   {$I+}
   ShowResultOnScreen;
   if dm.qMISAVETO.asstring = 'Y' then begin
      rf := trim(dm.qMIRESULTFILE.AsString);
      try
         if length(rf) > 0 then
            mResult.Lines.SaveToFile(rf);
      except
         on e:exception do begin
            disp('File could not be saved for some reason!', 'e');
         end;
      end;
   end;
end;

procedure TfrmSumReduction.RunThisMenuForSUMorGAPonDataFile(IsItForSUM : boolean);
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
               if IsItForSUM then
                  LocalGetSum(sum, FilterPassed, digit_option)
               else
                  LocalGetGap(sum, FilterPassed, digit_option);
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
               if IsItForSUM then
                  LocalGetSum(sum, FilterPassed, digit_option)
               else
                  LocalGetGap(sum, FilterPassed, digit_option);
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
   lblCount.caption := IntToStr(counts);
   lblTotal.caption := IntToStr(finalcount);
   dm.qMI.Edit;
   dm.qMIRESULTCNT.AsInteger := counts;
   dm.qMI.post;
end;

procedure TfrmSumReduction.mResultDblClick(Sender: TObject);
begin
   mResult.visible := false;
end;

procedure TfrmSumReduction.AddToTestView;
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

procedure TfrmSumReduction.ShowResultOnScreen;
begin
   with mResult do begin
      left := 148;
      top  := 10;
      visible := true;
   end;
end;

procedure TfrmSumReduction.mFileContentDblClick(Sender: TObject);
begin
   mFileContent.visible := false;
end;

procedure TfrmSumReduction.DBCheckBox1Exit(Sender: TObject);
begin
   DBEdit2.visible := (dm.qMIUSEALLROW.AsString = 'N');
   DBEdit4.visible := (dm.qMIUSEALLROW.AsString = 'N');
end;

procedure TfrmSumReduction.FilterRows(Option : integer);
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


procedure TfrmSumReduction.dbRowSelectClick(Sender: TObject);
begin
//   if dm.qMI.state in [dsInsert, dsEdit] then dm.qMI.post;
   pnlRow.visible := dbRowSelect.Checked;
end;

procedure TfrmSumReduction.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);

  pnlRow.visible := (dm.qMIUSEROW.AsString = 'Y');
end;

procedure TfrmSumReduction.ShowDevelopmentInfo;
begin
   with mDevInfo do begin
      left := 7;
      top := 4;
      visible := true;
      BringToFront;
   end;
end;

procedure TfrmSumReduction.mDevInfoDblClick(Sender: TObject);
begin
   mDevInfo.visible := false;
end;

end.

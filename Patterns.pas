unit Patterns;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, wwdbedit, Wwdotdot, DBCtrls, Mask, ExtCtrls, Db,
  Wwdatsrc, Grids, Wwdbigrd, Wwdbgrid, SuperType, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf,
  uADStanAsync, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TfrmPattern = class(TForm)
    Label1: TLabel;
    mDevInfo: TMemo;
    mFileContent: TMemo;
    DBMemo1: TDBMemo;
    Label2: TLabel;
    DBCheckBox8: TDBCheckBox;
    DBEdit3: TDBEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    bRunSample: TBitBtn;
    mResult: TMemo;
    wwDBGrid2: TwwDBGrid;
    DBNavigator2: TDBNavigator;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    qQL: TADQuery;
    dQL: TDataSource;
    qQLCOID: TIntegerField;
    qQLMIID: TIntegerField;
    qQLNUM: TIntegerField;
    qQLMANUALINPUT: TStringField;
    qQLTABLENAME: TStringField;
    qQLSELECTED: TStringField;
    qQLREPEATS: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mDevInfoDblClick(Sender: TObject);
    procedure mFileContentDblClick(Sender: TObject);
    procedure mResultDblClick(Sender: TObject);
    procedure DBEdit3DblClick(Sender: TObject);
    procedure bRunSampleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ShowResultOnScreen;
    procedure ShowDevelopmentInfo;
  public
    DAry : TDataArray;
    DoReplace : boolean;
    procedure LoadUpDataFileForPattern(b1, b2, b3, b4, b5 : boolean);
    procedure AddToTestView;
    procedure FilterRows(Option : integer);
    procedure RunThisMenuForTextDataFile;
    procedure LocalGetPattern(var sum : integer; var FtrPassed : boolean; digit_option : integer);
  end;

var
  frmPattern: TfrmPattern;

implementation

   uses DataMod, global;

{$R *.DFM}

procedure TfrmPattern.LoadUpDataFileForPattern(b1, b2, b3, b4, b5 : boolean);
   var fn, s, rf, rs : string;
       i, j, t : integer;
begin
   {$I-}
   for i := 1 to _MaxData do begin
      for j := 1 to 6 do DAry[i].n[j] := 0;
      DAry[i].hitcount := 0;
      DAry[i].pattstring := '';
   end;

   mFileContent.lines.clear;

   fn := 'c:\ko\sumn6.txt';

   if FileExists(fn) then begin
      dFile.filename := fn;
      AssignFile(dFile.F, fn);
      FileMode := 0;  { Set file access to read only }
      Reset(dFile.F);
      j := 1;
      while not eof(dFile.F) do begin
         readln(dFile.F, s);
         rs := '';
         if length(trim(s)) > 0 then begin
            ParseNumbers(s);
            if lst.count > 0 then begin
               for i := 0 to lst.count -1 do begin
                  try
                     t := StrToInt(lst[i]);
                     DAry[j].n[i+1] := t div 10;
                  except
                     on e:exception do;
                  end;
               end;
               if b1 then rs := rs + inttostr(DAry[j].n[1]+1);
               if b2 then rs := rs + inttostr(DAry[j].n[2]+1);
               if b3 then rs := rs + inttostr(DAry[j].n[3]+1);
               if b4 then rs := rs + inttostr(DAry[j].n[4]+1);
               if b5 then rs := rs + inttostr(DAry[j].n[5]+1);
               DAry[j].pattstring := rs;

               mFileContent.lines.add(
                    inttostr(DAry[j].n[1]) + '-'
                  + inttostr(DAry[j].n[2]) + '-'
                  + inttostr(DAry[j].n[3]) + '-'
                  + inttostr(DAry[j].n[4]) + '-'
                  + inttostr(DAry[j].n[5]) + ' : ' + DAry[j].pattstring);
               inc(j);
            end;
         end;
      end;
      dFile.linecount := j - 1;
      mFileContent.lines.add('--------------');
      mFileContent.lines.add('Total : ' + inttostr(j-1));
//      mFileContent.visible := true;
      CloseFile(dFile.F);
   end;
   {$I+}
end;

procedure TfrmPattern.FormCreate(Sender: TObject);
begin
   DoReplace := false;
   mResult.lines.clear;
   if not qQL.active then qQL.open;
end;

procedure TfrmPattern.FormDestroy(Sender: TObject);
begin
   if dm.qMI.state in [dsEdit, dsInsert] then dm.qMi.post;
end;

procedure TfrmPattern.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TfrmPattern.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmPattern.mDevInfoDblClick(Sender: TObject);
begin
   mDevInfo.visible := false;
end;

procedure TfrmPattern.mFileContentDblClick(Sender: TObject);
begin
   mFileContent.visible := false;
end;

procedure TfrmPattern.mResultDblClick(Sender: TObject);
begin
   mResult.visible := false;
end;

procedure TfrmPattern.DBEdit3DblClick(Sender: TObject);
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

procedure TfrmPattern.bRunSampleClick(Sender: TObject);
   var s, rf, sv : string;
       i, j, t : integer;
       c1, c2, c3, c4, c5 : boolean;
       n1, n2, n3, n4, n5 : byte;
       hits : array [11111..55555] of integer;// 45555 = max position
       vals : array [11111..55555] of integer;
       nc, vc, modv, addv, subv : integer;
begin
   {$I-}

   vc := 0;
   addv := 0;
   modv := 0;
   subv := 11111;

   for i := 11111 to 55555 do begin
      vals[i] := i;
      hits[i] := 0;
   end;

   c1 := false;
   c2 := false;
   c3 := false;
   c4 := false;
   c5 := false;

   try
      sv := trim(qQLmanualinput.AsString);
      nc := strtoint(sv); // Numeric value test
      nc := length(sv);
      if nc < 1 then begin
         disp('No sample input data!', 'e');
         exit;
      end;
      s := '';
      for i := 1 to nc do s := s + inttostr(strtoint(sv[i])+1);
      sv := s;
   except
      on e:exception do begin
         disp('Quick Look-up Value Error!', 'e');
         exit;
      end;
   end;

   if dm.qMI.State in [dsEdit] then dm.qMI.post;
   c1 := (dm.qMIC1.Value = 'Y');  if c1 then inc(vc);
   c2 := (dm.qMIC2.Value = 'Y');  if c2 then inc(vc);
   c3 := (dm.qMIC3.Value = 'Y');  if c3 then inc(vc);
   c4 := (dm.qMIC4.Value = 'Y');  if c4 then inc(vc);
   c5 := (dm.qMIC5.Value = 'Y');  if c5 then inc(vc);

   LoadUpDataFileForPattern(c1, c2, c3, c4, c5);

   if vc = 5 then begin
      addv := 0;
      modv := 100000;
   end;
   if vc = 4 then begin
      addv := 10000;
      modv := 10000;
   end;
   if vc = 3 then begin
      addv := 11000;
      modv := 1000;
   end;
   if vc = 2 then begin
      addv := 11100;
      modv := 100;
   end;
   if vc = 1 then begin
      addv := 11110;
      modv := 10;
   end;

   for i := 1 to dFile.linecount-1 do begin
      if DAry[i].pattstring = sv then begin
         t := strtoint(DAry[i+1].pattstring);
         t := (t mod modv) + addv;
//         DAry[i+1].hitcount := DAry[i+1].hitcount + 1;
         hits[t] := hits[t] + 1;
      end;
   end;

   mResult.Lines.clear;
   // Test
{   for i := 1 to dFile.linecount do
      mResult.Lines.add(DAry[i].pattstring + ' - '
         + inttostr(DAry[i].hitcount));

   for i := 11111 to 55555 do
      mResult.Lines.add(inttostr(vals[i]) + ' - '
         + inttostr(hits[i]));

   mResult.Lines.add('------------------');}

   // Sort & Display
   mResult.Lines.add('Val.   Hits');
   for i := 11111 to 55555 do begin
      for j := i+1 to 55555 do begin
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
   for i := 11111 to 55555 do
      if hits[i] > 0 then begin
         s := '';
         sv := inttostr(vals[i]);
         s := copy(sv, 6-vc, vc);
         sv := '';
         for j := 1 to vc do
            sv := sv + inttostr(strtoint(s[j])-1);
         mResult.Lines.add(format('%5s  %5d', [sv, hits[i]]));
      end;

   {$I+}
   ShowResultOnScreen;
   if dm.qMISAVETO.asstring = 'Y' then begin
      rf := trim(dm.qMIRESULTFILE.AsString);
      try
         if length(rf) > 0 then
            mResult.Lines.SaveToFile(rf);
      except
         on e:exception do
            disp('File could not be saved for some reason!', 'e');
      end;
   end;
end;

procedure TfrmPattern.ShowResultOnScreen;
begin
   with mResult do begin
      left := 148;
      top  := 10;
      visible := true;
   end;
end;

procedure TfrmPattern.ShowDevelopmentInfo;
begin
   with mDevInfo do begin
      left := 7;
      top := 4;
      visible := true;
      BringToFront;
   end;
end;

procedure TfrmPattern.AddToTestView;
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

procedure TfrmPattern.FilterRows(Option : integer);
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

procedure TfrmPattern.LocalGetPattern(var sum : integer; var FtrPassed : boolean; digit_option : integer);
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

procedure TfrmPattern.RunThisMenuForTextDataFile;
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
               LocalGetPattern(sum, FilterPassed, digit_option);
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
               LocalGetPattern(sum, FilterPassed, digit_option);
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







end.

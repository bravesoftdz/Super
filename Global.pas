unit Global;

interface

  uses StdCtrls, SysUtils, Classes, Dialogs, DB, Registry, Forms, Controls,
       WinProcs, SuperType, uADCompClient, Windows;

type
   TTrackArry = array [1..6] of byte;

var
   Mon, Stopped, RunManualFromConfig, InsideOfRefreshRecursive,
   RunFromReport, ReversePattern, TestAndModify : boolean;
   MonitorDuration, MonI, SleepDuration, TempCountForEachMenu : integer;
   tn : TTrackArry;
   FirstOuterRangeNo, LastManualNo : integer;
   RefreshNo1, RefreshNo2, RefreshNo3 : integer;
   SearchKey, ReplaceKey, s, TestSumResFileName : string;
   ss : array [1..5] of string;
   sr : array [1..5] of string;
   SearchTxt, ReplaceTxt : string;
   TestSum0FileName : string = 'c:\ko\testsum\testsum0';
   TestSum1FileName : string = 'c:\ko\testsum\testsum1';
   TestSum2FileName : string = 'c:\ko\testsum\testsum2';
   TestSum3FileName : string = 'c:\ko\testsum\testsum3';

function  GenKeyVal(const s: String): LongInt;
procedure Disp(s : String; Code : Char);
function  ProperCase(InStr : String) : String;
function  AlphNumOnly(S : String) : String;
procedure SetComboText(var cbox : TComboBox; S : String);
function  OnlyNumerics(T : String) : String;
function  StrToDouble(s : String) : double;
function  AssignStrToInt(s : String) : Integer;
function  AssignStrToFloat(s : String) : Real;
procedure CloseAllQueries;
procedure ParseNumbers(s : string);
function  NoTwoSameNumbers(n1, n2, n3, n4, n5, n6 : integer) : boolean;
procedure AssignNoToRowArray(var a : TRowArry; n1, n2, n3, n4, n5, n6 : integer);
procedure RunThisMenuForSUM;
procedure RunThisMenuForSUMorGAP(IsItForSUM : boolean);
procedure CheckColumnSelectedStatusAndSubType;
procedure OpenMenuItems(fn : String);
function  firstdigit(i : integer) : integer;
function  lastdigit(i : integer) : integer;
function  CheckForBumpingFile : boolean;
procedure GetSum(var sum : integer; var FtrPassed : boolean;
   i, digit_option : integer);
procedure GetGap(var sum : integer; var FtrPassed : boolean;
   i, digit_option : integer);
procedure SetAllTheHitCountForMainDataToZero;
procedure GetInfoFromConfiguration;
procedure SaveConfigurations;
function  TwoDigitNumber(i : integer) : string;
procedure ClearFilterArray;
procedure ClearBumpArray;
procedure RunThisMenuForMatches;
procedure DumpMatchResultFile;
function  OpenBumpingFileForMatches(idx : integer) : boolean;
function  OpenBumpingFileForSumCol(idx : integer) : boolean;
function  OpenBumpingFileForSUM(idx : integer) : boolean;
procedure FindSumColumn(cidx : integer);
procedure FindMatches(cidx : integer);
procedure DoSubGroupSelectionForMatch(grpcnt, grpmin,
   grpmax, bumpidx : integer);
procedure DoOuterGrpSelectionForMatch(ogrpcnt, ogrpmin,
   ogrpmax, bumpidx : integer);
procedure DoFinalSelectionForMatch;
procedure DoFinalSelectionForSumColume;
function  IsFilterPassedForMatch(i : integer) : boolean;
procedure IsThisMenuNumberAnEndingRange(var Ending : boolean;
   var bn, mincount : integer);
procedure IsThisMenuNumberAnBeginningRange;
procedure PerformRevive(Count, MRB, cMenuNum : integer);
function  CheckUpToNo : boolean;
function  CheckStartFrom : boolean;
function  CheckResetNo : boolean;
procedure DoCompactProcedure;
function  CheckForValidity : boolean;
procedure UpdateRangeInfo(oldi, newi : integer);
function  findMinOuterGroupNo : integer;
function  GetLargestInnerGroupNo(miid : integer) : integer;
procedure GetManualList;
function  IsIncludedFromConfigCheck(menuno : integer) : boolean;
procedure PerformGatherManualSelectResult;
procedure CheckForRefreshPointEntryInDB;
function CheckRefreshPoints : boolean;
procedure WriteLog(LogFileName: String; S: String);
function GetScreenCoefficient: Integer;

implementation

   uses datamod, main, config, Monitor;

function  GenKeyVal(const s: String): LongInt;
   var
      p: TADStoredProc;
begin
     p := TADStoredProc.create(nil);
     p.Connection := dm.ADConnection;
     p.Transaction := dm.ADTransaction;
     p.StoredProcName := 'NEW_' + s;
     p.Prepare;
     p.ExecProc;
     Result := p.params[0].asinteger;
     p.free;
end;

procedure Disp(s : String; Code : Char);
begin
   case Code of
     'E', 'e' :
        MessageDlg(S, mtError, [mbOk], 0);
     'I', 'i' :
        MessageDlg(S, mtInformation, [mbOk], 0);
     'D', 'd' :
        MessageDlg('['+S+']', mtInformation, [mbOk], 0);
   else
      MessageDlg(S, mtInformation, [mbOk], 0);
   end;
end;

function  ProperCase(InStr : String) : String;
var
   ResultStr : String;
   i, j, l : Integer;
   c : Char;
   ToUpper : Boolean;
begin
   try
      if length(InStr) < 1 then
         begin
            Result := '';
            Exit;
         end;

      ToUpper := True;
      l := length(InStr);
      ResultStr := Lowercase(InStr);
      for i := 1 to l do begin
         if (ResultStr[i] in ['a'..'z', 'A'..'Z', '0'..'9']) and ToUpper then
            begin
               c := ResultStr[i];
               if (ResultStr[i] in ['a'..'z']) then dec(c, 32);
               ResultStr[i] := c;
               ToUpper := False;
            end
         else
            if not (ResultStr[i] in ['a'..'z', 'A'..'Z', '0'..'9']) then
               ToUpper := True;
      end;
      Result := ResultStr;
   except
      on E: Exception do begin
         Disp(E.Message, 'e');
         Result := InStr;
      end;
   end;
end;

function AlphNumOnly(S : String) : String;
  var
    S1 : String;
    i, j : Integer;
begin
   try
      S := UpperCase(S);
      i := length(S);
      if i < 1 then
         begin
            Result := S;
            Exit;
         end;
      S1 := '';
      for j := 1 to i do
         if S[j] in ['A'..'Z', '0'..'9'] then S1 := S1 + S[j];
      Result := S1;
   except
      on E:Exception do begin
         Disp(E.Message, 'e');
         Result := '';
      end;
   end;
end;

procedure SetComboText(var cbox : TComboBox; S : String);
   var
      i : Integer;
      Found : Boolean;
begin
   Found := False;
   i := 1;
   while (i < cbox.items.Count) and (not Found) do begin
      if (CompareText(cbox.items[i], S) = 0) then
         begin
            cbox.ItemIndex := i;
            Found := True;
         end;
      Inc(i);
   end;
   if not Found then
      cbox.ItemIndex := 0;
end;

function OnlyNumerics(T : String) : String;
   var
      i, j : integer;
      T1 : String;
begin
   try
      j := length(T);
      t1 := '';
      if j < 1 then
         begin
            Result := '';
            Exit;
         end;
      for i := 1 to j do
         if T[i] in ['0'..'9', '.'] then T1 := T1 + T[i];
      Result := T1;
   except
      on E:Exception do Result := '';
   end;
end;

function  StrToDouble(s : String) : double;
   var
      v : double;
begin
   try
      if length(s) < 1 then begin
         Result := 0.00;
         Exit;
      end;
      v := StrToFloat(s);
      Result := v;
   except
      on E: Exception do begin
         Result := 0.00;
         Disp(E.Message, 'e');
      end;
   end;
end;

function AssignStrToInt(s : String) : Integer;
   var
      i : Integer;
begin
   try
      i := 0;
      if length(s) < 1 then
         Result := i
      else
         Result := StrToInt(s);
   except
      on E: Exception do begin
         Disp(E.Message, 'e');
         Result := i;
      end;
   end;
end;

function AssignStrToFloat(s : String) : Real;
var
   num : Real;
begin
   try
      num := 0.00;
      if length(s) < 1 then
         Result := num
      else
         Result := StrToFloat(s);
   except
      on E: Exception do begin
         Disp(E.Message, 'e');
         Result := 0.00;
      end;
   end;
end;

procedure CloseAllQueries;
   var
      i : integer;
begin
   with dm do begin
      for I := 0 to ComponentCount -1 do begin
         if Components[I] is TADQuery then
            TADQuery(Components[I]).Active := False;
//         if Components[I] is TwwQuery then
//            TwwQuery(Components[I]).Active := False;
      end;
   end;
end;

procedure ParseNumbers(s : string);
  var S1, S2 : String;
      i, j, k : Integer;
begin
   try
{      if lst = nil then begin
         disp(dm.qMITITLE.AsString, 'i');
      end; }
      if lst.count > 0 then
         lst.clear;
      if length(S) < 1 then exit;
      S2 := UpperCase(Trim(S));
      S1 := '';
      k := length(s2);
      for j := 1 to k do begin
         if S2[j] in ['0'..'9'] then
            S1 := S1 + S2[j]
         else
            begin
               i := length(s1);
               if S2[j-1] in ['0'..'9'] then begin
                  lst.add(s1);
                  s1 := '';
               end;
            end;
      end;
      if length(s1) > 0 then lst.add(s1);
   except
      on E:Exception do Disp(E.Message, 'e');
   end;
end;

procedure AssignNoToRowArray(var a : TRowArry; n1, n2, n3, n4, n5, n6 : integer);
begin
   a[1] := n1;
   a[2] := n2;
   a[3] := n3;
   a[4] := n4;
   a[5] := n5;
   a[6] := n6;
end;

function  NoTwoSameNumbers(n1, n2, n3, n4, n5, n6 : integer) : boolean;
   var passed : boolean;
       a : TRowArry;
       i, j : integer;
begin
   passed := true;
   AssignNoToRowArray(a, n1, n2, n3, n4, n5, n6);
   for i := 2 to 6 do
      for j := i to 6 do
         if a[i-1] = a[j] then passed := false;
   result := passed;
end;

procedure OpenMenuItems(fn : String);
   var s: string;
begin
   s := 'select * from MenuItem order by ' + fn;
   with dm.qMI do begin
      close;
      sql.Clear;
      sql.add(s);
      open;
   end;
end;

function TwoDigitNumber(i : integer) : string;
begin
   if i < 10 then
      result := '0' + IntToStr(i)
   else
      result := IntToStr(i);
end;

procedure CheckColumnSelectedStatusAndSubType;
   var s : string;
       i, j : integer;
begin
   ClearFilterArray;

   if dm.qMISUBMETHOD.AsString = 'F' then digit_option := _FIRST_DIGIT;
   if dm.qMISUBMETHOD.AsString = 'L' then digit_option := _LAST_DIGIT;
   if dm.qMISUBMETHOD.AsString = 'T' then digit_option := _BOTH_DIGIT;

   dm.qCOL.open;                      // Check for Selected Columns
   for i := 1 to 6 do begin
      dm.qCOL.locate('NUM', i, []);
      FAry[i].sel := (dm.qCOLSELECTED.asstring = 'Y');
      s := dm.qCOLMANUALINPUT.asstring;
      FAry[i].noFileter := (length(trim(s)) < 1);
      if (FAry[i].sel) and (not FAry[i].noFileter) then begin
         ParseNumbers(s);
         FAry[i].count := lst.count;
         if FAry[i].count > 0 then begin
            for j := 1 to FAry[i].count do
               FAry[i].a[j] := StrToInt(lst[j-1]);
         end;
      end;
   end;
   dm.qCOL.close;
end;

function firstdigit(i : integer) : integer;
begin
   result := i div 10;
end;

function lastdigit(i : integer) : integer;
begin
   result := i mod 10;
end;

procedure GetSum(var sum : integer; var FtrPassed : boolean; i, digit_option : integer);
   var j, k : integer;
       colpass : boolean;
begin
   sum := 0;
   FtrPassed := true;
   if digit_option = _BOTH_DIGIT then
      for j := 1 to 6 do
         if FAry[j].sel then sum := sum + MAry[i].n[j];
   if digit_option = _FIRST_DIGIT then
      for j := 1 to 6 do
         if FAry[j].sel then sum := sum + firstdigit(MAry[i].n[j]);
   if digit_option = _LAST_DIGIT then
      for j := 1 to 6 do
         if FAry[j].sel then sum := sum + lastdigit(MAry[i].n[j]);

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
         if colpass = false then FtrPassed := false;
      end;
   end;
end;

procedure GetGap(var sum : integer; var FtrPassed : boolean; i, digit_option : integer);
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
         a[idx] := MAry[i].n[k];
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
                  if MAry[i].n[j] = FAry[j].a[k] then colpass := true;
            end;
         if colpass = false then FtrPassed := false;
      end;
   end;
end;

function CheckForBumpingFile : boolean;
   var fn, s, rf : string;
       i, j : integer;
begin
   ClearBumpArray;
   with bFile do begin
      exists := (length(dm.qMIBUMPTABLE.asstring) > 0);
      filename := dm.qMIBUMPTABLE.asstring;
      index := 0;
      linecount := 0;
      openned := false;
      if list.count > 0 then list.clear;
      if exists then begin
         AssignFile(F, filename);
         Reset(F);
         j := 1;
         while not eof(F) do begin
            Readln(F, s);
            inc(index);
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
      end;
   end;
   if _debug then begin  // Debugging of File Reading
      for j := 1 to BumpItemsCount do begin
         s := '';
         for i := 1 to BAry[j].itemcnt do
            s := s + IntToStr(BAry[j].n[i]) + ' ';
      end;
   end;
   result := bFile.openned;
end;

procedure WriteToResultFileIfMentioned;
begin
   with rFile do begin
      exists := (length(dm.qMIRESULTFILE.asstring) > 0);
      filename := dm.qMIRESULTFILE.asstring;
      index := 0;
      linecount := 0;
      openned := false;
      if list.count > 0 then list.clear;
      if exists then begin
         AssignFile(F, filename);
         Reset(F);
         while not eof(F) do begin
            Readln(F, line);
            inc(index);
            if length(line) > 0 then
               list.add(line);
         end;
         list.add('Total Line Count : ' + inttostr(index));
//         frmMain.eValueLookup.lines.clear;
      end;
   end;
end;

procedure RunThisMenuForSUM;    // Added 7/27/01
   var j, i, idx, cgrp, pgrp, cgrpb, cgrpe, grpcount,
       cogrp, pogrp, cogrpb, cogrpe, ogrpcount: integer;
begin
   idx := 0;
   pgrp := 0;
   pogrp := 0;
   grpcount := 0;
   ogrpcount := 0;

   // Clear Master Array's Check Conditions
   for i := 1 to ActualMax do begin
      for j := cMainMenuOrder to _CheckNo do
         MAry[i].checks[j] := false;
      MAry[i].HitCount := 0;
   end;

   // For all the Filter Records, get the results
   with dm.qBT do begin
      sql.clear;
      sql.add('select * from bumptables where miid = :miid '
         + 'order by ogno, grpno, btid');
      open;

      while not eof do begin
         ClearFilterArray;

         // Added for Sub-Group Configuration
         cgrp := dm.qBTGRPNO.AsInteger;
         if cgrp <> pgrp then begin
            if (pgrp > 0) then begin
               DoSubGroupSelectionForMatch(grpcount, cgrpb, cgrpe,
                  idx);  // Perform Sub-Group Selection
               grpcount := 0;  // reset group count
            end;
            cgrpb := dm.qBTGRPKEEPB.asinteger;
            cgrpe := dm.qBTGRPKEEPE.asinteger;
            pgrp  := cgrp;
         end;

         // Added for Outer-Group Configuration
         cogrp := dm.qBTOGNO.asinteger;
         if cogrp <> pogrp then begin
            if (pogrp > 0) then begin
               DoOuterGrpSelectionForMatch(ogrpcount,
                  cogrpb, cogrpe, idx); // Perform Outer-Group Selection
               ogrpcount := 0;  // reset outer group count
            end;
            cogrpb := dm.qBTOGRB.asinteger;
            cogrpe := dm.qBTOGRE.asinteger;
            pogrp  := cogrp;
         end;

         FAry[1].sel := (dm.qBTC1.asstring = 'Y');
         FAry[2].sel := (dm.qBTC2.asstring = 'Y');
         FAry[3].sel := (dm.qBTC3.asstring = 'Y');
         FAry[4].sel := (dm.qBTC4.asstring = 'Y');
         FAry[5].sel := (dm.qBTC5.asstring = 'Y');

         if OpenBumpingFileForSumCol(idx) then // If Bump File is proper.
            FindSumColumn(idx);  // Perform Column Sum Task

         Inc(idx);
         next;

         inc(grpcount);
         inc(ogrpcount);

         if eof then begin // This will only run at EOF (Last Group Check)
            DoSubGroupSelectionForMatch(grpcount, cgrpb, cgrpe, idx);  // Perform Sub-Group Selection
            DoOuterGrpSelectionForMatch(ogrpcount,
                  cogrpb, cogrpe, idx); // Perform Outer-Group Selection
         end;
      end;
   end;

   DoFinalSelectionForSumColume;

   if frmMain.cbSaveOnEachStep.checked then
      if dm.qMISAVETO.asstring = 'Y' then begin
         try
            i := strtoint(trim(frmMain.eMinToStartSaving.text));
         except
            on e:exception do i := 0;
         end;
         if TempCountForEachMenu <= i then
            DumpMatchResultFile;
      end;
   if TestAndModify then DoCompactProcedure;
end;

procedure FindSumColumn(cidx : integer);
   var h, j, sum, k, i, readval : integer;
       colpass, FilterPassed : boolean;
begin
   try
//      disp('Actual Max : ' + inttostr(ActualMax), 'i');
      for i := 1 to ActualMax do begin
         if IsFilterPassedForMatch(i) then begin
            for j := 1 to BumpItemsCount do begin
               readval := BAry[j].n[1];
//               disp('BAry : ' + inttostr(readval), 'i');
               sum := 0;
               for h := 1 to 5 do
                  if FAry[h].sel then sum := sum + MAry[i].n[h];
               if sum = readval then
                  if MAry[i].n[1] <> 0 then   // check for "00",
                     MAry[i].checks[cidx + cMainMenuOrder] := true;
            end
         end;
      end;
   except
      on e:exception do disp(e.message, 'e');
   end;
end;

procedure DoFinalSelectionForSumColume;
   var s : string;
       i, j, cnt, min, max, total : integer;
       keep : boolean;
begin
   total := 0;
   TempCountForEachMenu := 0;
   keep := (dm.qMIINCLUSIVE.AsString = 'Y');
   // Get Keep Range for Total Result
   min := dm.qMIRANGEBEGIN.asinteger;
   max := dm.qMIRANGEEND.asinteger;

   if min < 1 then min := 0;  // 1
   if max < 1 then max := 0;  // 100000

   // Calculate Checked Counts
   for i := 1 to ActualMax do begin
      cnt := 0;
      for j := cMainMenuOrder to _CheckNo do begin // Get Count
         if MAry[i].checks[j] then begin
            if MAry[i].n[1] <> 0 then inc(cnt);
         end;
         MAry[i].checks[j] := false;
      end;
      // Take care of Delete Situation
      if (not keep) and (MAry[i].checks[cMainMenuOrder-1]) then begin
         MAry[i].checks[cMainMenuOrder] := true;
         inc(total);
      end;
      // DO final Selection
      if (cnt >= min) and (cnt <= max) then begin // Mark final tag
         if keep then
            begin
               MAry[i].checks[cMainMenuOrder] := true;
               inc(total);
            end
         else  // if Delete then
            if MAry[i].checks[cMainMenuOrder - 1] then begin
               MAry[i].checks[cMainMenuOrder] := false;
               dec(total);
            end;
      end;
      MAry[i].HitCount := 0;
   end;
   frmMain.mCounts.lines.add(dm.qMINUM.asstring + ' : ' + IntToStr(total));
   TempCountForEachMenu := total;
   total := 0;
end;


procedure RunThisMenuForSUMorGAP(IsItForSUM : boolean);
   var j, c, hitted, asked, i, sum, min, max : integer;
       counts, divcount, orders, finalcount : integer;
       FirstOneAdded, FilterPassed : boolean;
       R : TRangeArray;
begin
   inc(cCheckPosition);
   cCheckTempPos := cCheckPosition;
   counts := 0;
   finalcount := 0;

   CheckColumnSelectedStatusAndSubType;

   if CheckForBumpingFile then begin

   end;

   with dm.tq do begin
      close;                  // Range Checking
      sql.clear;
//      requestlive := true;
      sql.add('select * from Ranges where miid = ' + dm.qMIMIID.asstring
         + ' and cat = ''RS'' order by rnid ');
      open;
      if recordcount > 0 then begin
         while not eof do begin
            j := 0;
            min := fieldbyname('bn').asinteger;
            max := fieldbyname('en').asinteger;
            for i := 1 to ActualMax do begin
               if IsItForSUM then
                  GetSum(sum, FilterPassed, i, digit_option)
               else
                  GetGap(sum, FilterPassed, i, digit_option);
               if FilterPassed then
                  if (sum >= min) and (sum <= max) then begin
                     MAry[i].Checks[cCheckPosition] := true;
                     inc(counts);
                     inc(MAry[i].HitCount);
//                     AddToViewList(i);
                     inc(j);
                  end;
            end;
            edit;
            fieldbyname('Hitted').asinteger := j;
            post;
            next;
         end;
      end;

      if recordcount > 0 then begin   // If there was any manual count
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
               for i := 1 to _MaxArray do begin
                  if MAry[i].Checks[orders] then begin
                     if (c = divcount) or (not FirstOneAdded) then
                        begin
                           c := 0;
                           MAry[i].Checks[orders] := true;
                           inc(finalcount);
                           FirstOneAdded := true;
                        end
                     else
                        begin
                           inc(c);
                           MAry[i].Checks[orders] := false;
                        end;
                  end;
               end;
            end;
            next;
            inc(orders);
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
            for i := 1 to ActualMax do begin
               if IsItForSUM then
                  GetSum(sum, FilterPassed, i, digit_option)
               else
                  GetGap(sum, FilterPassed, i, digit_option);
               if FilterPassed then
                  if sum = min then begin
                     MAry[i].Checks[cCheckTempPos] := true;
                     inc(counts);
                     inc(MAry[i].HitCount);
                     inc(j);
                  end;
            end;
            edit;
            fieldbyname('Hitted').asinteger := j;
            post;
            next;
            inc(cCheckTempPos);
         end;

      end;
      if recordcount > 0 then begin   // If there was any manual count
         first;
         orders := cCheckPosition;
         while not eof do begin
            c := 0;  // bracket counter
            asked := fieldbyname('HIT').asinteger;
            j := fieldbyname('HITTED').asinteger;
            if j > 0 then begin
               divcount := j div asked;
               FirstOneAdded := false;
               for i := 1 to ActualMax do begin
                  if MAry[i].Checks[orders] then begin
                     if (c = divcount) or (not FirstOneAdded) then
                        begin
                           c := 0;
                           MAry[i].Checks[orders] := true;
                           inc(finalcount);
                           FirstOneAdded := true;
//                         AddToViewList(i);
                        end
                     else
                        begin
                           inc(c);
                           MAry[i].Checks[orders] := false;
                        end;
                  end;
               end;
            end;
            next;
            inc(orders);
         end;
      end;
   end;
   frmMain.sb.Panels[6].text := IntToStr(counts);
   frmMain.sb.Panels[7].text := IntToStr(finalcount);
   dm.qMI.Edit;
   dm.qMIRESULTCNT.AsInteger := counts;
   dm.qMI.post;

//   WriteToResultFileIfMentioned;
end;

procedure SetAllTheHitCountForMainDataToZero;
begin
   with dm.tq do begin
      close;
      sql.clear;
//      requestlive := false;
      sql.add('update maintbl set hitcount = 0');
      execsql;
   end;
end;

procedure GetInfoFromConfiguration;
begin
   try
      cf := TConfiguration.create;
      cf.LoadAll;
      SearchTxt := cf.str('SearchTxt');
      ReplaceTxt := cf.str('ReplaceTxt');
      ParseNumbers(cf.str('InitRange'));
      with frmMain do begin
         eTempSavingFile.text := cf.str('DefTestSaveFileName');
         if lst.count > 0 then begin
            eN1m.text := lst[0];   eN1x.text := lst[1];
            eN2m.text := lst[2];   eN2x.text := lst[3];
            eN3m.text := lst[4];   eN3x.text := lst[5];
            eN4m.text := lst[6];   eN4x.text := lst[7];
            eN5m.text := lst[8];   eN5x.text := lst[9];
            eN6m.text := lst[10];  eN6x.text := lst[11];
            eMinSumRow.text := lst[12];
            eMaxSumRow.text := lst[13];
            cbNo3_2Consecutive.checked := (lst[14] = '1');
            cbNo4Consecutive.checked := (lst[15] = '1');
            cbOdd.checked := (lst[16] = '1');
            cbEven.checked := (lst[17] = '1');
         end;
         eTrackNo.text := cf.str('TrackingNo');
         if length(trim(eTrackNo.text)) > 1 then begin
            ParseNumbers(eTrackNo.text);
            if lst.count > 0 then begin
               tn[1] := strtoint(lst[0]);
               tn[2] := strtoint(lst[1]);
               tn[3] := strtoint(lst[2]);
               tn[4] := strtoint(lst[3]);
               tn[5] := strtoint(lst[4]);
               tn[6] := strtoint(lst[5]);
            end;
         end;
         eMinToStartSaving.text := cf.str('MinSaveNo');
         cbRunManualSelection.checked := (cf.str('RunManual') = 'Y');
         eSelectCountForManual.text := cf.str('RunManualCount');
         eMS.text := cf.str('RunManualNo');
         eTestSumResultFileName.text := cf.str('TestSumFileName');
      end;

   except
      on e:exception do disp(e.message, 'e');
   end;
end;

procedure SaveConfigurations;
   var s : string;
begin
   with frmMain do begin
      s := eN1m.text + ' ' + eN1x.text + ' '
         + eN2m.text + ' ' + eN2x.text + ' '
         + eN3m.text + ' ' + eN3x.text + ' '
         + eN4m.text + ' ' + eN4x.text + ' '
         + eN5m.text + ' ' + eN5x.text + ' '
         + eN6m.text + ' ' + eN6x.text + ' '
         + eMinSumRow.text + ' ' + eMaxSumRow.text + ' ';
      if cbNo3_2Consecutive.checked then
         s := s + '1 '
      else
         s := s + '0 ';
      if cbNo4Consecutive.checked then
         s := s + '1 '
      else
         s := s + '0 ';
      if cbOdd.checked then
         s := s + '1 '
      else
         s := s + '0 ';
      if cbEven.checked then
         s := s + '1 '
      else
         s := s + '0 ';
      dm.tq.close;
//      dm.tq.requestlive := false;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = ''' + s
         + ''' where varname = ''InitRange'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eTempSavingFile.text
         + ''' where varname = ''DefTestSaveFileName'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eTrackNo.text
         + ''' where varname = ''TrackingNo'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eMinToStartSaving.text
         + ''' where varname = ''MinSaveNo'' ');
      dm.tq.execsql;
            dm.tq.sql.clear;
      if frmMain.cbRunManualSelection.Checked then
         dm.tq.sql.add('update configs set strval = ''Y'' '
            + ' where varname = ''RunManual'' ')
      else
         dm.tq.sql.add('update configs set strval = ''N'' '
            + ' where varname = ''RunManual'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eSelectCountForManual.text
         + ''' where varname = ''RunManualCount'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eMS.text
         + ''' where varname = ''RunManualNo'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eTestSumResultFileName.text
         + ''' where varname = ''TestSumFileName'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eRefresh1.text
         + ''' where varname = ''RefreshNo1'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eRefresh2.text
         + ''' where varname = ''RefreshNo2'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eRefresh3.text
         + ''' where varname = ''RefreshNo3'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.eColGrpRange.text
         + ''' where varname = ''GroupRange'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.mTSGrp.Lines.Text
         + ''' where varname = ''TestSumGrp'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.mColPatterns.Lines.Text
         + ''' where varname = ''TestSumCol'' ');
      dm.tq.execsql;
      dm.tq.sql.clear;
      dm.tq.sql.add('update configs set strval = '''
         + frmMain.mTSRPat.Lines.Text
         + ''' where varname = ''TestSumRPat'' ');
      dm.tq.execsql;
   end;
end;

procedure ClearBumpArray;
   var i, j : integer;
begin
   for i := 1 to _MaxBumpArray do begin
      for j := 1 to 6 do BAry[i].n[j] := 0;
      BAry[i].itemcnt := 0;
   end;
   BumpItemsCount := 0;
end;

procedure ClearFilterArray;
   var i, j : integer;
begin
   for i := 1 to 6 do begin
      for j := 1 to 20 do FAry[i].a[j] := 0;
      FAry[i].sel := false;
      FAry[i].count := 0;
      FAry[i].noFileter := true;
   end;
end;

procedure CopyBumpArray(var src, dest : TBumpArray);
   var i, j : integer;
begin
   for i := 1 to _MaxBumpArray do begin
      for j := 1 to 6 do dest[i].n[j] := 0;
      dest[i].itemcnt := 0;
   end;
   BumpItemsCount := 0;
end;

procedure RunThisMenuForMatches;
   var j, i, idx, cgrp, pgrp, cgrpb, cgrpe, grpcount,
       cogrp, pogrp, cogrpb, cogrpe, ogrpcount: integer;
begin
   idx := 0;
   pgrp := 0;
   pogrp := 0;
   grpcount := 0;
   ogrpcount := 0;

   // Clear Master Array's Check Conditions
   for i := 1 to ActualMax do begin
      for j := cMainMenuOrder to _CheckNo do MAry[i].checks[j] := false;
      MAry[i].HitCount := 0;
      if mon then begin
         with frmMonitor.qLB do begin
            locate('LBID', i, []);
            edit;
            fields[7].Value := 0;
            for MonI := cMainMenuOrder to 42 do
               fields[MonI+7].Value := 'N';
            post;
            application.processmessages;
         end;
      end;
   end;

   // For all the Bumping Files, get the results
   with dm.qBT do begin
      sql.clear;
      sql.add('select * from bumptables where miid = :miid '
         + 'order by ogno, grpno, btid');
      open;

      while not eof do begin
         ClearFilterArray;

         // Added for Sub-Group Configuration
         cgrp := dm.qBTGRPNO.AsInteger;
         if cgrp <> pgrp then begin
            if (pgrp > 0) then begin
               DoSubGroupSelectionForMatch(grpcount, cgrpb, cgrpe,
                  idx);  // Perform Sub-Group Selection
               grpcount := 0;  // reset group count
            end;
            cgrpb := dm.qBTGRPKEEPB.asinteger;
            cgrpe := dm.qBTGRPKEEPE.asinteger;
            pgrp  := cgrp;
         end;

         // Added for Outer-Group Configuration
         cogrp := dm.qBTOGNO.asinteger;
         if cogrp <> pogrp then begin
            if (pogrp > 0) then begin
               DoOuterGrpSelectionForMatch(ogrpcount,
                  cogrpb, cogrpe, idx); // Perform Outer-Group Selection
               ogrpcount := 0;  // reset outer group count
            end;
            cogrpb := dm.qBTOGRB.asinteger;
            cogrpe := dm.qBTOGRE.asinteger;
            pogrp  := cogrp;
         end;

         FAry[1].sel := (dm.qBTC1.asstring = 'Y');
         FAry[2].sel := (dm.qBTC2.asstring = 'Y');
         FAry[3].sel := (dm.qBTC3.asstring = 'Y');
         FAry[4].sel := (dm.qBTC4.asstring = 'Y');
         FAry[5].sel := (dm.qBTC5.asstring = 'Y');
         FAry[6].sel := (dm.qBTC6.asstring = 'Y');

         if OpenBumpingFileForMatches(idx) then // If Bump File is proper.
            FindMatches(idx);          // Perform Match Taske.

         Inc(idx);
         next;

         inc(grpcount);
         inc(ogrpcount);

         if eof then begin // This will only run at EOF (Last Group Check)
            DoSubGroupSelectionForMatch(grpcount, cgrpb, cgrpe, idx);  // Perform Sub-Group Selection
            DoOuterGrpSelectionForMatch(ogrpcount,
                  cogrpb, cogrpe, idx); // Perform Outer-Group Selection
         end;
      end;
   end;

   DoFinalSelectionForMatch;

   if frmMain.cbSaveOnEachStep.checked then
      if dm.qMISAVETO.asstring = 'Y' then begin
         try
            i := strtoint(trim(frmMain.eMinToStartSaving.text));
//            disp(inttostr(i), 'i');
         except
            on e:exception do i := 0;
         end;
         if TempCountForEachMenu <= i then
            DumpMatchResultFile;
      end;
end;

procedure FindMatches(cidx : integer);
   var h, j, c, k, i, min, max : integer;
       colpass, FilterPassed, MultiColumns : boolean;
begin
   try
      // Get Keep Range for Each Bumping File
      min := dm.qBTKEEPB.asinteger;
      max := dm.qBTKEEPE.asinteger;
      if min < 1 then min := 0;    // 1
      if max < 1 then max := 0;    // 100000

      // Find out if bumping file is multicolumn or single column
      MultiColumns := (BAry[1].ItemCnt > 1);

      if not MultiColumns then begin  // Single Column BumpFile
         for i := 1 to ActualMax do begin
            if IsFilterPassedForMatch(i) then begin
               c := 0;
               for j := 1 to BumpItemsCount do begin
                  for h := 1 to 6 do begin
                     if (FAry[h].sel) and (BAry[j].n[1] = MAry[i].n[h]) then begin
                        inc(c);
                        if mon then
                           frmMonitor.mReset.lines.add(
                              format('MI#%-2d cMain%-2d cidx%-2d '
                                 + 'Col=%1d Bum=%2d  %2d-%2d-%2d-%2d-%2d',
                              [dm.qMINUM.asinteger, cMainMenuOrder,cidx, h, BAry[j].n[1], MAry[i].n[1],
                              MAry[i].n[2], MAry[i].n[3], MAry[i].n[4], MAry[i].n[5]]));
                     end;
                  end;
               end;
               if (c >= min) and (c <= max) then begin
                  MAry[i].checks[cidx + cMainMenuOrder] := true;
                  if mon then begin
                     with frmMonitor.qLB do begin
                        locate('LBID', i, []);
                        edit;
                        fields[7].Value := MAry[i].HitCount;
                        fields[cidx + cMainMenuOrder+7].Value := 'Y';
                        post;
                        close;
                        open;
                        application.processmessages;
                     end;
                  end;
               end;
            end;
         end;
      end;

      if MultiColumns then begin   // Multi Column BumpFile
         for i := 1 to ActualMax do begin
            if IsFilterPassedForMatch(i) then begin
               MAry[i].HitCount := 0;
               for j := 1 to BumpItemsCount do begin
                  c := 0;
                  for k := 1 to BAry[j].ItemCnt do
                     for h := 1 to 6 do begin
                        if (FAry[h].sel) and (BAry[j].n[k] = MAry[i].n[h]) then inc(c);
                     end;
                  if c = BAry[j].ItemCnt then inc(MAry[i].HitCount);
               end;
               if (MAry[i].HitCount >= min) and (MAry[i].HitCount <= max) then begin
                  MAry[i].checks[cidx + cMainMenuOrder] := true;
                  if mon then begin
                     with frmMonitor.qLB do begin
                        locate('LBID', i, []);
                        edit;
                        fields[7].Value := MAry[i].HitCount;
                        fields[cidx + cMainMenuOrder+7].Value := 'Y';
                        post;
                        application.processmessages;
                     end;
                  end;
               end;
            end;
         end;
      end;
   except
      on e:exception do disp(e.message, 'e');
   end;
end;

function IsFilterPassedForMatch(i : integer) : boolean;
begin
   if WithinRange then  // If within main range
      begin
         // Check for Column Filter Passing Condition
         if (cMainMenuOrder > 1) and // Check for previous selection
            (not MAry[i].Checks[MainRangeStartInx]) then
            result := false
         else
            result := true;
      end
   else
      begin
         // Check for Column Filter Passing Condition
         if (cMainMenuOrder > 1) and // Check for previous selection
            (not MAry[i].Checks[cMainMenuOrder - 1]) then
            result := false
         else
            result := true;
      end;
end;

function OpenBumpingFileForSUM(idx : integer) : boolean;
   var fn, s : string;
       i, j, line : integer;
       starting, ending : integer;
       DataOk : boolean;
begin
   ClearBumpArray;  // Clear BDS
   DataOk := false;
   fn := dm.qBTFILENAME.AsString;
   starting := dm.qBTLINEB.AsInteger;
   ending   := dm.qBTLINEE.AsInteger;
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
            if not eof(bFile.F) then begin
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
         end;
         BumpItemsCount := j - 1;
         DataOk := (BumpItemsCount > 0);
         CloseFile(bFile.F);
      end;
   end;
   result := DataOK;
end;

function OpenBumpingFileForSumCol(idx : integer) : boolean;
   var fn, s : string;
       i, j, line : integer;
       starting, ending : integer;
       DataOk : boolean;
begin
   ClearBumpArray;  // Clear BDS
   DataOk := false;
   fn := dm.qBTFILENAME.AsString;
   starting := dm.qBTLINEB.AsInteger;
   ending   := dm.qBTLINEE.AsInteger;
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
            if dm.qBTODDEVEN.AsString = 'E' then // For Even Line
               readln(bFile.F, s);  // Skip Line for Even Selection
            if not eof(bFile.F) then begin
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
               if dm.qBTODDEVEN.AsString = 'O' then  // For Odd Line
                  if not eof(bFile.F) then
                     readln(bFile.F, s);  // Skip Line for Odd Selection
            end;
         end;
         BumpItemsCount := j - 1;
         DataOk := (BumpItemsCount > 0);
         CloseFile(bFile.F);
      end;
   end;
   result := DataOK;
end;

function OpenBumpingFileForMatches(idx : integer) : boolean;
   var fn, s : string;
       i, j, line, lc: integer;
       starting, ending : integer;
       DataOk : boolean;
       sl: TStringList;
begin
   ClearBumpArray;  // Clear BDS
   DataOk := false;
   fn := dm.qBTFILENAME.AsString;
   starting := dm.qBTLINEB.AsInteger;
   ending   := dm.qBTLINEE.AsInteger;
   if starting < 1 then starting := 1;
   if ending   < 1 then ending   := 100000;

   if length(fn) > 0 then begin
      if FileExists(fn) then begin
         if mon then begin
            frmMonitor.mFilterResult.lines.add('Bfile ['
               + inttostr(idx) + ':' + inttostr(idx+1) +'] G#'
               + dm.qBTGRPNO.AsString + '  ' + dm.qBTFILENAME.AsString);
            frmMonitor.mFilter.lines.clear;
            frmMonitor.mFilter.lines.loadfromfile(fn);
            frmMonitor.mFilterResult.lines.add(frmMonitor.mFilter.text);
         end;
         sl := TStringList.Create;
         try
           sl.LoadFromFile(fn);
  //         bFile.filename := fn;
  //         AssignFile(bFile.F, fn);
  //         FileMode := 0;  { Set file access to read only }
  //         Reset(bFile.F);
           j := 1;
           line := 0;
  //         while not eof(bFile.F) do begin
           for lc := 0 to sl.Count - 1 do
           begin
             if dm.qBTODDEVEN.AsString = 'E' then // For Even Line
               Continue;
  //              readln(bFile.F, s);  // Skip Line for Even Selection
  //           if not eof(bFile.F) then
  //           begin
  //           readln(bFile.F, s);
             s := sl[lc];
  //              WriteLog('super.log',s);
             inc(line);
             if (line >= starting) and (line <= ending) then
             begin
               if length(trim(s)) > 0 then
               begin
                 ParseNumbers(s);
                 if lst.count > 0 then
                 begin
                   for i := 0 to lst.count -1 do
                   begin
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
  //           if dm.qBTODDEVEN.AsString = 'O' then  // For Odd Line
  //               if not eof(bFile.F) then
  //                 readln(bFile.F, s);  // Skip Line for Odd Selection
  //           end;
           end;
         finally
           BumpItemsCount := j - 1;
           DataOk := (BumpItemsCount > 0);
           sl.Free;
         end;
//         CloseFile(bFile.F);
      end;
//    for i := 1 to lst.count do disp(inttostr(BAry[i].n[1]), 'i');
   end;
   result := DataOK;
end;

procedure DoSubGroupSelectionForMatch(grpcnt, grpmin,
   grpmax, bumpidx : integer);
   var s : string;
       i, j, k, gcnt, min, max, total, firstpos : integer;
       keep : boolean;
begin
   total := 0;
   firstpos := cMainMenuOrder + (bumpidx - grpcnt);
   if mon then
      frmMonitor.mReset.lines.add(
         format('  firstpos=%-2d, cMainMenuOrder=%-2d, bumpidx=%-2d, grpcnt=%-2d',
         [firstpos, cMainMenuOrder, bumpidx, grpcnt]));
   // Get Keep Range for Total Result
   min := grpmin;
   max := grpmax;

   if min < 1 then min := 0;    // 1
   if max < 1 then max := 0;    // 100000


   if mon then begin
      frmMonitor.mFilterResult.lines.add(
         Format('SG. Select Begins  grpcnt: %d   grpmin: %d   grpmax: %d',
            [grpcnt, grpmin, grpmax]));
      frmMonitor.mFilterResult.lines.add(
         Format('   cMainMenuOrder: %d   idx: %d   firstpos: %d',
            [cMainMenuOrder, bumpidx, firstpos]));
      frmMonitor.mReset.lines.add(
         format('  GrpCnt %2d  Min %2d Max %2d, BumpIDX : %2d, First Pos : %2d',
         [grpcnt, grpmin, grpmax, bumpidx, firstpos]));
   end;
   // Calculate Checked Counts
   for i := 1 to ActualMax do begin
      gcnt := 0;
      // Get count for group
      for k := firstpos to _CheckNo do begin
         if MAry[i].checks[k] then begin
            inc(gcnt);
            MAry[i].checks[k] := false;
         end;
      end;
      if (gcnt >= min) and (gcnt <= max) then begin // Mark first item for selected
         MAry[i].checks[firstpos] := true;
         inc(total);
      end;

      MAry[i].HitCount := 0;
      if mon then begin
         with frmMonitor.qLB do begin
            locate('LBID', i, []);
            edit;
            for j := firstpos to 42 do
               if MAry[i].checks[j] then begin
                  fields[j+7].Value := 'Y';
                     disp('test','i');
                  end
               else
                  fields[j+7].Value := 'N';
            post;
            application.ProcessMessages;
//            sleep(SleepDuration);
         end;
      end;
   end;
   if mon then frmMonitor.mReset.lines.add(
      '  S.G. Count Done, Found ' + inttostr(total));
   total := 0;
end;

procedure DoOuterGrpSelectionForMatch(ogrpcnt, ogrpmin,
   ogrpmax, bumpidx : integer);
   var s : string;
       i, j, k, gcnt, min, max, total, firstpos : integer;
       keep : boolean;
begin
   total := 0;
   firstpos := cMainMenuOrder + (bumpidx - ogrpcnt);
   if mon then frmMonitor.mReset.lines.add(
         format('firstpos=%-2d, cMainMenuOrder=%-2d, bumpidx=%-2d, ogrpcnt=%-2d',
         [firstpos, cMainMenuOrder, bumpidx, ogrpcnt]));
   // Get Keep Range for Total Result
   min := ogrpmin;
   max := ogrpmax;

//   if min < 1 then min := 1;
//   if max < 1 then max := 100000;

   if min < 1 then min := 0;    // 1
   if max < 1 then max := 0;    // 100000

   if mon then begin
      frmMonitor.mFilterResult.lines.add(
         Format('OG. Select Begins  ogrpcnt: %d   ogrpmin: %d   ogrpmax: %d',
            [ogrpcnt, ogrpmin, ogrpmax]));
      frmMonitor.mFilterResult.lines.add(
         Format('   cMainMenuOrder: %d   idx: %d   firstpos: %d',
            [cMainMenuOrder, bumpidx, firstpos]));
      frmMonitor.mReset.lines.add(
         format('O.Grp# %2d  Min %2d Max %2d, Bumping IDX : %2d, First Pos : %2d',
         [ogrpcnt, ogrpmin, ogrpmax, bumpidx, firstpos]));
   end;
   // Calculate Checked Counts
   for i := 1 to ActualMax do begin
      gcnt := 0;
      // Get count for group
      for k := firstpos to _CheckNo do begin
         if MAry[i].checks[k] then begin
            inc(gcnt);
            MAry[i].checks[k] := false;
         end;
      end;
      if (gcnt >= min) and (gcnt <= max) then begin // Mark first item for selected
         MAry[i].checks[firstpos] := true;
         inc(total);
      end;

      MAry[i].HitCount := 0;
      if mon then begin
         with frmMonitor.qLB do begin
            locate('LBID', i, []);
            edit;
            for j := firstpos to 42 do
               if MAry[i].checks[j] then
                  fields[j+7].Value := 'Y'
               else
                  fields[j+7].Value := 'N';
            post;
            application.ProcessMessages;
         end;
      end;
   end;
   if mon then frmMonitor.mReset.lines.add(
      'O.G. Count Done, Found : ' + inttostr(total));
   total := 0;
end;

procedure DoFinalSelectionForMatch;
   var s : string;
       i, j, cnt, min, max, total : integer;
       keep : boolean;
begin
   total := 0;
   TempCountForEachMenu := 0;
   keep := (dm.qMIINCLUSIVE.AsString = 'Y');
   // Get Keep Range for Total Result
   min := dm.qMIRANGEBEGIN.asinteger;
   max := dm.qMIRANGEEND.asinteger;

   if min < 1 then min := 0;  // 1
   if max < 1 then max := 0;  // 100000

   // Calculate Checked Counts
   for i := 1 to ActualMax do begin
      cnt := 0;
      for j := cMainMenuOrder to _CheckNo do begin // Get Count
         if MAry[i].checks[j] then begin
//            disp(format('%2d, %2d, %2d, %2d, %2d, %2d ',
//               [MAry[i].n[1], MAry[i].n[2], MAry[i].n[3],
//                MAry[i].n[4], MAry[i].n[5], MAry[i].n[6]]), 'i');
            if MAry[i].n[1] <> 0 then inc(cnt);
         end;
         MAry[i].checks[j] := false;
      end;
      // Take care of Delete Situation
      if (not keep) and (MAry[i].checks[cMainMenuOrder-1]) then begin
         MAry[i].checks[cMainMenuOrder] := true;
         inc(total);
      end;
      // DO final Selection
      if (cnt >= min) and (cnt <= max) then begin // Mark final tag
         if keep then
            begin
               MAry[i].checks[cMainMenuOrder] := true;
               inc(total);
            end
         else  // if Delete then
            if MAry[i].checks[cMainMenuOrder - 1] then begin
               MAry[i].checks[cMainMenuOrder] := false;
               dec(total);
            end;
         if mon then begin
            with frmMonitor.qLB do begin
               locate('LBID', i, []);
               edit;
               fields[7].Value := MAry[i].HitCount;
               for MonI := 1 to 25 do
                  if MAry[i].checks[MonI] then
                     fields[MonI+7].Value := 'Y'
                  else
                     fields[MonI+7].Value := 'N';
               post;
//               sleep(SleepDuration);
               application.processmessages;
            end;
         end;
      end;
      MAry[i].HitCount := 0;
   end;
   if mon then begin
      frmMonitor.mReset.lines.add(
         'Final Count of MM # ' + dm.qMINUM.asstring + ' = ' + IntToStr(total));
   end;
   frmMain.mCounts.lines.add(dm.qMINUM.asstring + ' : ' + IntToStr(total));
   TempCountForEachMenu := total;
//   disp(inttostr(TempCountForEachMenu), 'i');
   total := 0;
end;

procedure DumpMatchResultFile;
   var rf, s : string;
       i : integer;
begin
   rf := trim(dm.qMIRESULTFILE.AsString);
   if length(trim(rf)) < 0 then exit;

   try
      rFile.filename := rf;
      AssignFile(rFile.F, rf);
      FileMode := 0;  { Set file access to read only }
      Rewrite(rFile.F);
      for i := 1 to ActualMax do begin
         if MAry[i].checks[cMainMenuOrder] then begin
            if MAry[i].n[1] <> 0 then begin
               s := TwoDigitNumber(MAry[i].n[1]) + ',"'
                  + TwoDigitNumber(MAry[i].n[2]) + '","'
                  + TwoDigitNumber(MAry[i].n[3]) + '","'
                  + TwoDigitNumber(MAry[i].n[4]) + '","'
                  + TwoDigitNumber(MAry[i].n[5]) + '","'
                  + TwoDigitNumber(MAry[i].n[6]) + '"';
               writeln(rFile.F, s);
            end;
         end;
      end;
      CloseFile(rFile.F);
   except
      on e:exception do begin
         disp('File "'+ rf +'" could not be saved for some reason!', 'e');
      end;
   end;
end;

procedure IsThisMenuNumberAnEndingRange(var Ending : boolean;
   var bn, mincount : integer);
   var cMI : integer;
begin
   bn := 0;
   mincount := 0;
   Ending := false;
   cMI := dm.qMINUM.AsInteger;
   if dm.qMR.recordcount > 0 then begin
      dm.qMR.first;
      while not dm.qMR.eof do begin
         if cMI = dm.qMRRE.AsInteger then begin
            mincount := dm.qMRMINHITCOUNT.asinteger;
            bn := dm.qMRRB.asinteger;
            Ending := true;
         end;
         dm.qMR.next;
      end;
   end;
end;

procedure IsThisMenuNumberAnBeginningRange;
   var cMI : integer;
begin
   cMI := dm.qMINUM.AsInteger;
   if dm.qMR.recordcount > 0 then begin
      dm.qMR.first;
      while not dm.qMR.eof do begin
         if cMI = dm.qMRRB.AsInteger then begin
            MainRangeCount := dm.qMRMINHITCOUNT.asinteger;
            MainRangeBegin := dm.qMRRB.asinteger;
            WithinRange := true;
            MainRangeStartInx := cMainMenuOrder - 1;
         end;
         dm.qMR.next;
      end;
   end;
end;

procedure PerformRevive(Count, MRB, cMenuNum : integer);
   var s : string;
       ExecCount, i, j, cnt, min, max, total : integer;
begin
   // Go back in menu item up to ("MRB")for differece,
   // and find out how
   // manu Menu Items are being executed.
   ExecCount := 0;
   with dm.tq do begin
      close;
      sql.clear;
      sql.add('select * '
         + 'from menuitem '
         + 'where ((num <= ' + inttostr(cMenuNum)
         + ') and (num >= ' + inttostr(mrb) + ')) '
         + 'and CBFOREXECUTE = ''Y'' ');
      open;
      ExecCount := recordcount;
      if ExecCount < 1 then exit;       // Error, Do not perform
      if ExecCount <= Count then exit;  // No need to check
   end;

   total := 0;
   // Get Keep Range for Total Result
   min := Count;
   max := ExecCount;

   // Then using that #, subtract from "cMainMenuOrder" value
   // to go back in master array.
   // Find only the numbers that are more of equal
   // to then min. hit count ("MainRangeCount").
   for i := 1 to ActualMax do begin
      cnt := 0;
      // Get Count.
      for j := (cMainMenuOrder - ExecCount) to (cMainMenuOrder - 1) do
         if MAry[i].checks[j] then inc(cnt);
      // Do final Revival Action
      if (cnt >= min) and (cnt <= max) then
         begin // Mark final tag
            MAry[i].checks[cMainMenuOrder-1] := true;
            inc(total);
         end
      else
         MAry[i].checks[cMainMenuOrder-1] := false;
      MAry[i].HitCount := 0;
   end;
   frmMain.mCounts.lines.add('** : ' + IntToStr(total));
   // Result should be with many revived numbers if done correctly.
end;

function CheckUpToNo : boolean;
begin
   try
      UpToNo := 0;
      UpToNo := strtoint(frmMain.eUpto.text);
      result := true;
   except
      on e:exception do begin
         disp('Check for Run-upto-No.', 'e');
         result := false;
      end;
   end;
end;

function CheckStartFrom : boolean;
begin
   try
      StartFrom := 0;
      StartFrom := strtoint(frmMain.eStartFrom.text);
      result := true;
   except
      on e:exception do begin
         disp('Check for Run-Start-From-No.', 'e');
         result := false;
      end;
   end;
end;

function CheckResetNo : boolean;
begin
   try
      ResetNo := strtoint(frmMain.eResetNo.text);
      result := true;
   except
      on e:exception do begin
         disp('Check for Reset No.', 'e');
         result := false;
      end;
   end;
end;

procedure DoCompactProcedure;
   var i, j, k, cur, top, bottom : integer;
begin
   if WithinRange then exit;

   top := 1;
   cur := cMainMenuOrder -1;
   for bottom := 1 to ActualMax do begin
      if MAry[bottom].checks[cur] then begin
         for i := 1 to 7 do MAry[top].n[i] := MAry[bottom].n[i];
         for i := 1 to _CheckNo do
            MAry[top].checks[i] := MAry[bottom].checks[i];
         MAry[top].HitCount := MAry[bottom].HitCount;
         inc(top);
      end;
   end;
   ActualMax := top-1;
   frmMain.sb.Panels[5].text := IntToStr(ActualMax);
end;

function CheckForValidity : boolean;
   var passed : boolean;

   function InMenuListAndActive(num : integer) : boolean;
      var p : boolean;
   begin
      with dm.tq do begin
         close;
//         requestlive := false;
         sql.clear;
         sql.add('select * from MenuItem where num = '
            + inttostr(num) + ' and cbforexecute = ''Y'' '
            + ' and num < 400 ');
         open;
         p := recordcount > 0;
         close;
      end;
      result := p;
   end;

begin
   passed := true;
   with dm.qMR do begin
      first;
      while not eof do begin
         if passed then begin
            if not InMenuListAndActive(dm.qMRRB.AsInteger) then begin
               disp('Menu number ' + dm.qMRRB.asstring + ' is missing or '
                  + 'not active!  Cancelled!', 'i');
               passed := false;
            end;
            if not InMenuListAndActive(dm.qMRRE.AsInteger) then begin
               disp('Menu number ' + dm.qMRRE.asstring + ' is missing or '
                  + 'not active!  Cancelled!', 'i');
               passed := false;
            end;
         end;
         next;
      end;
   end;
   result := passed;
end;

procedure UpdateRangeInfo(oldi, newi : integer);
begin
   with dm.tq do begin
      close;
//      requestlive := false;
      sql.clear;
      sql.add('update menurange set rb = ' + inttostr(newi)
         + ' where rb = ' + inttostr(oldi));
      execsql;
      sql.clear;
      sql.add('update menurange set re = ' + inttostr(newi)
         + ' where re = ' + inttostr(oldi));
      execsql;
   end;
end;

function findMinOuterGroupNo : integer;
   var i : integer;
begin
   i := 1;
   if frmMain.cbMainHitRange.checked then
      begin
         with dm.tq do begin
//            requestlive := false;
            close;
            sql.clear;
            sql.add('select min(rb) from menurange ');
            open;
            i := fields[0].asinteger;
            close;
         end
      end
   else
      i := 10000;
   result := i;
end;

procedure DummyDoFinalSelectionForMatch;
   var s : string;
       i, j, cnt, min, max, total : integer;
       keep : boolean;
begin
   total := 0;
   // Get Keep Range for Total Result
   min := dm.qMIRANGEBEGIN.asinteger;
   max := dm.qMIRANGEEND.asinteger;
   if min < 1 then min := 1;
   if max < 1 then max := 100000;

   // Calculate Checked Counts
   for i := 1 to ActualMax do begin
      cnt := 0;
      for j := cMainMenuOrder to _CheckNo do begin // Get Count
         if MAry[i].checks[j] then inc(cnt);
         MAry[i].checks[j] := false;
      end;
      // DO final Selection
      if (cnt >= min) and (cnt <= max) then begin // Mark final tag
         MAry[i].checks[cMainMenuOrder] := true;
         inc(total);
      end;
      MAry[i].HitCount := 0;
   end;
   frmMain.mCounts.lines.add(dm.qMINUM.asstring + ' : ' + IntToStr(total));
   total := 0;
end;

function GetLargestInnerGroupNo(miid : integer) : integer;
   var i : integer;
begin
   with dm.tq do begin
      close;
//      requestlive := false;
      sql.clear;
      sql.add('select max(grpno) from bumptables where miid = '
         + inttostr(miid));
      open;
      i := fields[0].asinteger;
   end;
   result := i;
end;

procedure GetManualList;
begin
   frmMain.lbTest.Items.clear;
   ParseNumbers(frmMain.eMS.text);
   if lst.count > 0 then frmMain.lbTest.items.Assign(lst);
   LastManualNo := strtoint(lst[lst.count-1]);
end;

function IsIncludedFromConfigCheck(menuno : integer) : boolean;
   var sno : string;
       i : integer;
       passed : boolean;
begin
   passed := false;
   sno := inttostr(menuno);
   for i := 0 to frmMain.lbTest.Items.count - 1 do begin
      if compareText(sno, frmMain.lbTest.Items[i]) = 0 then
         passed := true;
   end;
   result := passed;
end;

procedure PerformGatherManualSelectResult;
   var s : string;
       i, j, cnt, min, max, total : integer;
begin
   total := 0;
   // Get Keep Range for Total Result
   min := strtoint(frmMain.eSelectCountForManual.text);
   max := frmMain.lbTest.Items.count;

   // Then using that #, subtract from "cMainMenuOrder" value
   // to go back in master array.
   // Find only the numbers that are more of equal
   // to then min. hit count ("MainRangeCount").
   for i := 1 to ActualMax do begin
      cnt := 0;
      // Get Count.
      for j := (cMainMenuOrder - frmMain.lbTest.Items.count)
         to (cMainMenuOrder - 1) do
         if MAry[i].checks[j] then inc(cnt);
      // Do final Revival Action
      if (cnt >= min) and (cnt <= max) then
         begin // Mark final tag
            MAry[i].checks[cMainMenuOrder-1] := true;
            inc(total);
         end
      else
         MAry[i].checks[cMainMenuOrder-1] := false;
      MAry[i].HitCount := 0;
   end;
   frmMain.mCounts.lines.add('MC : ' + IntToStr(total));
end;

procedure CheckForRefreshPointEntryInDB;
   var i, j : integer;
       q : TADQuery;
       s : string;
begin
   try
      q := TADQuery.create(nil);
      with q do begin
         Connection := dm.ADConnection;
         Transaction := dm.ADTransaction;
         sql.add('select * from configs where varname = ''RefreshNo1'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.eRefresh1.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 100;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'Refresh No 1';
               fieldbyname('seclev').value := 2;
               fieldbyname('strval').value := '0';
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'RefreshNo1';
               post;
            except
               on e:exception do;
            end;
         end;
         close;
         sql.clear;
         sql.add('select * from configs where varname = ''RefreshNo2'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.eRefresh2.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 101;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'Refresh No 2';
               fieldbyname('seclev').value := 2;
               fieldbyname('strval').value := '0';
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'RefreshNo2';
               post;
            except
               on e:exception do
            end;
         end;
         close;
         sql.clear;
         sql.add('select * from configs where varname = ''RefreshNo3'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.eRefresh3.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 105;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'Refresh No 3';
               fieldbyname('seclev').value := 2;
               fieldbyname('strval').value := '0';
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'RefreshNo3';
               post;
            except
               on e:exception do;
            end;
         end;
         close;
         sql.clear;
         sql.add('select * from configs where varname = ''GroupRange'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.eColGrpRange.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 102;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'TEST SUM Group Range';
               fieldbyname('seclev').value := 2;
               fieldbyname('strval').value := '3-4';
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'GroupRange';
               post;
            except
               on e:exception do
            end;
         end;
         close;
         sql.clear;
         sql.add('select * from configs where varname = ''TestSumGrp'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.mTSGrp.Lines.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 103;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'TEST SUM Groups List';
               fieldbyname('seclev').value := 2;
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'TestSumGrp';
               post;
            except
               on e:exception do
            end;
         end;
         close;
         sql.clear;
         sql.add('select * from configs where varname = ''TestSumCol'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.mColPatterns.Lines.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 104;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'TEST SUM Columns List';
               fieldbyname('seclev').value := 2;
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'TestSumCol';
               post;
            except
               on e:exception do
            end;
         end;
         close;
         sql.clear;
         sql.add('select * from configs where varname = ''TestSumRPat'' ');
         open;
         i := recordcount;
         if i = 1 then frmMain.mTSRPat.Lines.text := fieldbyname('strval').AsString;
         if i < 1 then begin
            try
               insert;
               fieldbyname('cfid').value := 106;
               fieldbyname('codes').value := 'STR';
               fieldbyname('descr').value := 'TEST SUM Reverse Pattern';
               fieldbyname('seclev').value := 2;
               fieldbyname('internal').value := 'N';
               fieldbyname('varname').value := 'TestSumRPat';
               post;
            except
               on e:exception do
            end;
         end;
         close;
      end;
   except
      on E:Exception do begin
         q.close;
      end;
   end;
   q.free;
   q := nil;
end;

function CheckRefreshPoints : boolean;
begin
   if InsideOfRefreshRecursive then exit;
   try
      RefreshNo1 := 0;
      RefreshNo1 := strtoint(frmMain.eRefresh1.text);
      result := true;
   except
      on e:exception do begin
         disp('Check for Refresh No 1.', 'e');
         frmMain.eRefresh1.setfocus;
         result := false;
         exit;
      end;
   end;
   try
      RefreshNo2 := 0;
      RefreshNo2 := strtoint(frmMain.eRefresh2.text);
      result := true;
   except
      on e:exception do begin
         disp('Check for Refresh No 2.', 'e');
         frmMain.eRefresh2.setfocus;
         result := false;
         exit;
      end;
   end;
   try
      RefreshNo3 := 0;
      RefreshNo3 := strtoint(frmMain.eRefresh3.text);
      result := true;
   except
      on e:exception do begin
         disp('Check for Refresh No 3.', 'e');
         frmMain.eRefresh3.setfocus;
         result := false;
         exit;
      end;
   end;
end;

procedure WriteLog(LogFileName: String; S: String);
  var F: TextFile;
      LogFile: String;
begin
  LogFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + LogFileName;
  AssignFile(F, LogFile);
  if not FileExists(LogFile) then
    Rewrite(F)
  else
    Append(F);
  Writeln(F, DateTimeToStr(Now) + ' ' + S);
  CloseFile(F);
end;

function GetScreenCoefficient: integer;
const
  c_InitialWidth = 1024;
  c_InitialHeight = 768;
var
  KoeffWidth,
  KoeffHeight,
  l_ScreenWidth,
  l_ScreenHeight: Integer;

begin
  l_ScreenWidth := GetDeviceCaps(GetDC(0),HORZRES);
  l_ScreenHeight := GetDeviceCaps(GetDC(0),VERTRES);

  KoeffWidth := Round(((l_ScreenWidth - c_InitialWidth) / c_InitialWidth) * 100) + 100;
  KoeffHeight := Round(((l_ScreenHeight - c_InitialHeight) / c_InitialHeight) * 100) + 100;

  if (KoeffHeight >= 100) or (KoeffHeight >= 100) then begin
     if KoeffWidth < KoeffHeight then
        Result := KoeffWidth
     else
        Result := KoeffHeight;
  end
  else begin
     if KoeffWidth > KoeffHeight then
        Result := KoeffWidth
     else
        Result := KoeffHeight;
  end;
//  Result := 135;
end;
end.

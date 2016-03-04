unit SuperType;

interface

  uses classes, IniFiles, SysUtils;

  const
//     _MaxArray     = 900000; // 900000 for Final Version
//    {$IFDEF WIN32}
//     _MaxArray     = 4000000; // 900000 for Final Version
//    {$ENDIF}
//    {$IFDEF WIN64}
//     _MaxArray     = 10000000; // 900000 for Final Version
//    {$ENDIF}
     _CheckNo      = 460;    // 460 for Final Version
     _MaxBumpArray = 10000;  // 10000 for Final Version
     _MaxData      = 30000;   // Currently less than 10000

     _debug    = true;

     _BOTH_DIGIT  = 1;
     _FIRST_DIGIT = 2;
     _LAST_DIGIT  = 3;

     _FOR_SUM = true;
     _FOR_GAP = false;

     _ALL_ROWS     = 1;
     _PARTIAL_ROWS = 2;

     _LCS = 19;   // Local Column Start

     DateFileName = 'c:\ko\sumn6.txt';  // This is data file in text file

  var _MaxArray: Integer;
      Ini: TIniFile;

  type
     TRowArry = array [1..6] of byte;

     TReadRowArry = array [1..20] of byte;

     TCheckArry = array [1.._CheckNo] of boolean;  // It should be 100 at final version

     TFilterRowArray = array [1..20] of byte;

     TDataRec = record // Used for Pattern & Sum
        n : TRowArry;
        sum : integer;
        hitcount : integer;
        pattstring : string[5];
     end;
     TDataArray = array [1.._MaxData] of TDataRec;
{
     TRowRec = record
        n : TRowArry;
        checks : TCheckArry;
        HitCount : integer;
     end;
}
     TRowRec = class
        n : TRowArry;
        checks : TCheckArry;
        HitCount : integer;
     end;

//     TMasterArray = array [1.._MaxArray] of TRowRec;
     TMasterArray = array of TRowRec;

     TBumpRowRec = record
        n : TReadRowArry;
        itemcnt : byte;
     end;
     TBumpArray = array [1.._MaxBumpArray] of TBumpRowRec;

     TRangeRec = record
        bn : integer;
        en : integer;
        perc : integer;
        hit : integer;
        types : string[1];
        hitted : integer;
     end;

     TRangeArray = array [1..30000] of TRangeRec;
//     TRangeArray = array [1..1000] of TRangeRec;

     TFilterRec = record
        a : TFilterRowArray;
        count : integer;
        noFileter : boolean;
        sel : boolean;
     end;

     TFilterArray = array [1..6] of TFilterRec;

     TBumpingFile = record
        F : TextFile;
        filename : string;
        Line : string;
        index : integer;
        linecount : integer;
        exists : boolean;
        openned : boolean;
        list : TStringList;
     end;

     TResultFile = record
        F : TextFile;
        filename : string;
        Line : string;
        index : integer;
        linecount : integer;
        exists : boolean;
        openned : boolean;
        list : TStringList;
     end;

     TDataFile = record
        F : TextFile;
        filename : string;
        Line : string;
        index : integer;
        linecount : integer;
        exists : boolean;
        openned : boolean;
        list : TStringList;
     end;
     TestSum0ColAry = array [1..5] of integer;
     TestSum1ColAry = array [1..10] of integer;
     TestSum2ColAry = array [1..10] of integer;
     TestSum3ColAry = array [1..5] of integer;

  var lst  : TStringList;
      MAry : TMasterArray;
      BAry, BTempAry : TBumpArray;
      FAry : TFilterArray;
      cPosition, MaxSum, MinSum : integer;
      cCheckPosition, cCheckTempPos, cMainMenuOrder : integer;
      ActualMax, BumpItemsCount : integer;
      bFile : TBumpingFile;
      rFile : TResultFile;
      dFile : TDataFile;
      TS0 : TestSum0ColAry = (1, 2, 3, 4, 5);
      TS1 : TestSum1ColAry = (12, 13, 14, 15, 23, 24, 25, 34, 35, 45);
      TS2 : TestSum2ColAry = (123, 124, 125, 134, 135, 145, 234, 235, 245, 345);
      TS3 : TestSum3ColAry = (1234, 1235, 1245, 1345, 2345);
      PSL : TStringList;  // Passing String List for many numbers
      TSR   : array [1..10, 1..30000] of integer;
//      TSR   : array [1..10, 1..1000] of integer;
      TSKey : array [1..100] of integer;

      digit_option, ResetNo, UpToNo, StartFrom : integer;
      WithinRange, InEndingRange : boolean;
      MainRangeCount, MainRangeBegin, MainRangeStartInx : integer;

implementation

initialization
  Ini := TIniFile.Create( IncludeTrailingPathDelimiter(
    ExtractFilePath(ParamStr(0))) + 'super.ini'  );

  // Set 3000000 as Default now
  _MaxArray := Ini.ReadInteger('Parameters','MaxArray',3000000);
  FreeAndNil(Ini);
  // SetLength + 1, becuase array started from Index = 1, not 0
  SetLength(MAry,_MaxArray + 1);

end.

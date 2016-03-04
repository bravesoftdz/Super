unit SearchRpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Wwlocate, Db, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADCompDataSet, uADCompClient, wwDialog;

type
  TfrmSearchAndReplace = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    eSearch: TEdit;
    eReplace: TEdit;
    bFixAll: TButton;
    bCancel: TButton;
    Label3: TLabel;
    bFix: TButton;
    bNext: TButton;
    LocateDlg: TwwLocateDialog;
    bFixFromThisPoint: TButton;
    q: TADQuery;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bCancelClick(Sender: TObject);
    procedure bFixAllClick(Sender: TObject);
    procedure bFixClick(Sender: TObject);
    procedure bNextClick(Sender: TObject);
    procedure bFixFromThisPointClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSearchAndReplace: TfrmSearchAndReplace;

implementation

{$R *.DFM}

   uses global, Matches, DataMod;

procedure TfrmSearchAndReplace.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key = vk_escape then ModalResult := mrCancel;
end;

procedure TfrmSearchAndReplace.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

procedure TfrmSearchAndReplace.bCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  frmMatches.DoReplace := False;
end;

procedure TfrmSearchAndReplace.bFixAllClick(Sender: TObject);
   var bp, ep, l, ls : integer;
begin
   SearchKey := trim(eSearch.text);
   ReplaceKey := trim(eReplace.text);
   if length(SearchKey) < 1 then begin
      disp('Search Key is not entered!', 'e');
      eSearch.SetFocus;
      exit;
   end;
   if length(ReplaceKey) < 1 then begin
      disp('Replace Key is not entered!', 'e');
      eReplace.SetFocus;
      exit;
   end;
   frmMatches.DoReplace := true;
   if frmMatches.DoReplace then begin
      l := length(SearchKey);
      with frmMatches.qBT do begin
         first;
         ls := length(frmMatches.qBTFILENAME.asstring);
         while not eof do begin
            bp := Pos(SearchKey, frmMatches.qBTFILENAME.asstring);
            if bp > 1 then begin
               s := Copy(frmMatches.qBTFILENAME.asstring, 1, bp - 1)
                  + ReplaceKey
                  + Copy(frmMatches.qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
               edit;
               frmMatches.qBTFILENAME.asstring := s;
               post;
            end;
            if bp = 1 then begin
               s := ReplaceKey
                  + Copy(frmMatches.qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
               edit;
               frmMatches.qBTFILENAME.asstring := s;
               post;
            end;
            next;
         end;
      end;
      frmMatches.DoReplace := false;
   end;
end;

procedure TfrmSearchAndReplace.bFixClick(Sender: TObject);
   var bp, ep, l, ls : integer;
begin
   SearchKey := trim(eSearch.text);
   ReplaceKey := trim(eReplace.text);
   if length(SearchKey) < 1 then begin
      disp('Search Key is not entered!', 'e');
      eSearch.SetFocus;
      exit;
   end;
   if length(ReplaceKey) < 1 then begin
      disp('Replace Key is not entered!', 'e');
      eReplace.SetFocus;
      exit;
   end;
   frmMatches.DoReplace := true;
   if frmMatches.DoReplace then begin
      l := length(SearchKey);
      with frmMatches.qBT do begin
         ls := length(frmMatches.qBTFILENAME.asstring);
         bp := Pos(SearchKey, frmMatches.qBTFILENAME.asstring);
         if bp > 1 then begin
            s := Copy(frmMatches.qBTFILENAME.asstring, 1, bp - 1)
               + ReplaceKey
               + Copy(frmMatches.qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
            edit;
            frmMatches.qBTFILENAME.asstring := s;
            post;
         end;
         if bp = 1 then begin
            s := ReplaceKey
               + Copy(frmMatches.qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
            edit;
            frmMatches.qBTFILENAME.asstring := s;
            post;
         end;
      end;
      frmMatches.DoReplace := false;
   end;
end;

procedure TfrmSearchAndReplace.bNextClick(Sender: TObject);
begin
   SearchKey := trim(eSearch.text);
   ReplaceKey := trim(eReplace.text);
   if length(SearchKey) < 1 then begin
      disp('Search Key is not entered!', 'e');
      eSearch.SetFocus;
      exit;
   end;
   if length(ReplaceKey) < 1 then begin
      disp('Replace Key is not entered!', 'e');
      eReplace.SetFocus;
      exit;
   end;
   with LocateDlg do begin
      FieldValue := SearchKey;
      FindNext;
   end;
end;



procedure TfrmSearchAndReplace.bFixFromThisPointClick(Sender: TObject);
   var bp, ep, l, ls : integer;
begin
   SearchKey := trim(eSearch.text);
   ReplaceKey := trim(eReplace.text);
   if length(SearchKey) < 1 then begin
      disp('Search Key is not entered!', 'e');
      eSearch.SetFocus;
      exit;
   end;
   if length(ReplaceKey) < 1 then begin
      disp('Replace Key is not entered!', 'e');
      eReplace.SetFocus;
      exit;
   end;
   frmMatches.DoReplace := true;
   if frmMatches.DoReplace then begin
      l := length(SearchKey);
      with frmMatches.qBT do begin
         ls := length(frmMatches.qBTFILENAME.asstring);
         while not eof do begin
            bp := Pos(SearchKey, frmMatches.qBTFILENAME.asstring);
            if bp > 1 then begin
               s := Copy(frmMatches.qBTFILENAME.asstring, 1, bp - 1)
                  + ReplaceKey
                  + Copy(frmMatches.qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
               edit;
               frmMatches.qBTFILENAME.asstring := s;
               post;
            end;
            if bp = 1 then begin
               s := ReplaceKey
                  + Copy(frmMatches.qBTFILENAME.asstring, (bp + l), ls - (bp + l - 1));
               edit;
               frmMatches.qBTFILENAME.asstring := s;
               post;
            end;
            next;
         end;
      end;
      frmMatches.DoReplace := false;
   end;
end;

procedure TfrmSearchAndReplace.FormDestroy(Sender: TObject);
begin
   SearchTxt := eSearch.Text;
   ReplaceTxt := eReplace.Text;
   try
      dm.ADConnection.ExecSQL('update configs set strval = ''' + SearchTxt + ''' where varname = ''SearchTxt''');

      dm.ADConnection.ExecSQL('update configs set strval = ''' + ReplaceTxt + ''' where varname = ''ReplaceTxt''');
   except
      on e:exception do begin
         disp(e.message, 'e');
      end;
   end;
end;

procedure TfrmSearchAndReplace.FormCreate(Sender: TObject);
begin
   eSearch.text := SearchTxt;
   eReplace.text := ReplaceTxt;
end;

end.

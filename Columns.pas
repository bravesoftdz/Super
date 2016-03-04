unit Columns;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Db, Wwdatsrc, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADCompDataSet, uADCompClient, Global;

type
  TfrmColumes = class(TForm)
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    eManual: TEdit;
    qGap: TADQuery;
    dGap: TDataSource;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmColumes: TfrmColumes;

implementation

{$R *.DFM}

procedure TfrmColumes.FormShow(Sender: TObject);
var
  l_Coeff : integer;
begin
  l_Coeff := GetScreenCoefficient;

  ChangeScale(l_Coeff, 100);
end;

end.

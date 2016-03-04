unit edward;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, quickrpt, Qrctrls, Db, DBTables;

type
  Tfrm1to200 = class(TForm)
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    Query1: TQuery;
    QRDBText1: TQRDBText;
    QRShape1: TQRShape;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm1to200: Tfrm1to200;

implementation

{$R *.DFM}

end.

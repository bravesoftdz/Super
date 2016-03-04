unit qrMatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, quickrpt, ExtCtrls;

type
  TfrmQrMatch = class(TForm)
    qr: TQuickRep;
    SummaryBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    TitleBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    DetailBand1: TQRBand;
    qrC1: TQRDBText;
    qrC2: TQRDBText;
    QRDBText4: TQRDBText;
    qrC5: TQRDBText;
    qrC3: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    qrC4: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    qrC6: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    QRShape1: TQRShape;
    QRLabel2: TQRLabel;
    QRSysData1: TQRSysData;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel12: TQRLabel;
    QRShape2: TQRShape;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    QRSysData2: TQRSysData;
    procedure DetailBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmQrMatch: TfrmQrMatch;

implementation

uses DataMod, Matches;

{$R *.DFM}



procedure TfrmQrMatch.DetailBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   qrC1.enabled := (frmMatches.qBTC1.Value = 'Y');
   qrC2.enabled := (frmMatches.qBTC2.Value = 'Y');
   qrC3.enabled := (frmMatches.qBTC3.Value = 'Y');
   qrC4.enabled := (frmMatches.qBTC4.Value = 'Y');
   qrC5.enabled := (frmMatches.qBTC5.Value = 'Y');
   qrC6.enabled := (frmMatches.qBTC6.Value = 'Y');
end;

end.

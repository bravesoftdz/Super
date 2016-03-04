unit qrConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, Qrctrls, quickrpt, ExtCtrls, uADCompClient;

type
  TfrmCFRpt = class(TForm)
    qr: TQuickRep;
    TitleBand1: TQRBand;
    qlCoName: TQRLabel;
    qlCoAddr2: TQRLabel;
    qlCoAddr1: TQRLabel;
    qlCoAddr3: TQRLabel;
    qlTitle: TQRLabel;
    DetailBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    QRLabel5: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRShape3: TQRShape;
    QRLabel1: TQRLabel;
    QRSysData1: TQRSysData;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRShape1: TQRShape;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    qCF: TADQuery;
  public
    { Public declarations }
  end;

var
  frmCFRpt: TfrmCFRpt;

implementation

{$R *.DFM}

   uses Global, Config, DataMod;

procedure TfrmCFRpt.FormCreate(Sender: TObject);
begin
   qlCoName.Caption  := cf.str('CustName');
   qlCoAddr1.Caption := cf.str('add1');
   qlCoAddr2.Caption := cf.str('add2');
   qlCoAddr3.Caption := cf.str('telline');
   qCF.Connection := dm.ADCOnnection;
   qCF.Transaction := dm.ADTransaction;
   qCF.Sql.Add('Select * from Configs where descr is not null Order by CFID');
   qCF.open;
end;












procedure TfrmCFRpt.FormDestroy(Sender: TObject);
begin
   qCF.close;
end;

end.

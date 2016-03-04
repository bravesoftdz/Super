program Super;

uses
  Forms,
  main in 'main.pas' {frmMain},
  DataMod in 'DataMod.pas' {dm: TDataModule},
  Global in 'Global.pas',
  About in 'About.pas' {frmAbout},
  config in 'config.pas' {frmConfig},
  SumReduc in 'SumReduc.pas' {frmSumReduction},
  Columns in 'Columns.pas' {frmColumes},
  SuperType in 'SuperType.pas',
  Matches in 'Matches.pas' {frmMatches},
  Sum in 'Sum.pas' {frmSum},
  Mul in 'Mul.pas' {frmMultiple},
  Divpas in 'Divpas.pas' {frmDIV},
  Monitor in 'Monitor.pas' {frmMonitor},
  SearchRpl in 'SearchRpl.pas' {frmSearchAndReplace},
  qrMatch in 'qrMatch.pas' {frmQrMatch},
  ChgPattern in 'ChgPattern.pas' {frmChangePattern},
  RepNumbers in 'RepNumbers.pas' {frmReplaceNumbers},
  copyunder in 'copyunder.pas' {frmCopyUnderneath},
  MultiRep in 'MultiRep.pas' {frmMultiRep},
  Patterns in 'Patterns.pas' {frmPattern},
  SumCol in 'SumCol.pas' {frmSumCol};
//  edward in 'edward.pas' {frm1to200};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Dore'' Wizard';
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

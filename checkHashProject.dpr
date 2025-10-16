program checkHashProject;

uses
  Vcl.Forms,
  CheckHASH in 'CheckHASH.pas' {frmMain},
  CheckHASH.Forms.ThanksDelphi in 'CheckHASH.Forms.ThanksDelphi.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  TStyleManager.TrySetStyle('Aqua Light Slate');
  Application.Title := 'Check-Hash';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.

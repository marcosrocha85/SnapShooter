program SnapShooter;

uses
  Forms,
  UMain in 'UMain.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SnapShooter';
  Application.ShowMainForm := False;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.

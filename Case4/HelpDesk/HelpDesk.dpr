library HelpDeskWeb;

uses
  System.SysUtils,
  System.Classes,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  WebModule.Main in 'WebModule.Main.pas' {MainWebModule: TWebModule},
  DataModule.DB in 'DataModule.DB.pas' {DBModule: TDataModule};

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;
  Application.CreateForm(TDBModule, DBModule);
  Application.Run;
end.
program ProjectFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  uPrincipal in 'uPrincipal.pas' {Form1};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.Edit, uLoading;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Rectangle1: TRectangle;
    btnAcessar: TSpeedButton;
    lblCriarConta: TLabel;
    Layout3: TLayout;
    Image2: TImage;
    Label6: TLabel;
    Layout4: TLayout;
    Label7: TLabel;
    Label8: TLabel;
    Edit3: TEdit;
    Label9: TLabel;
    Edit4: TEdit;
    Rectangle2: TRectangle;
    btnCriarConta: TSpeedButton;
    lblLogin: TLabel;
    Label11: TLabel;
    Edit5: TEdit;
    procedure lblCriarContaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure btnAcessarClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
  private
    procedure TerminateLogin(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal;

procedure TFrmLogin.TerminateLogin(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;


    if NOT Assigned(FrmPrincipal) then
        application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;

    FrmLogin.Close;
end;

procedure TFrmLogin.btnAcessarClick(Sender: TObject);
var
    t: TThread;
begin
    TLoading.Show(FrmLogin, ''); // Thread Principal..

    t := TThread.CreateAnonymousThread(procedure
    begin
        Sleep(3000); // Acesso ao server (Thread Paralela)...
    end);

    t.OnTerminate := TerminateLogin;
    t.Start;
end;

procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
var
    t: TThread;
begin
    TLoading.Show(FrmLogin, ''); // Thread Principal..

    t := TThread.CreateAnonymousThread(procedure
    begin
        Sleep(3000); // Acesso ao server (Thread Paralela)...
    end);

    t.OnTerminate := TerminateLogin;
    t.Start;
end;

procedure TFrmLogin.lblCriarContaClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1);
end;

procedure TFrmLogin.lblLoginClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0);
end;

end.

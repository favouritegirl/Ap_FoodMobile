unit UnitConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, uLoading;

type
  TFrmConfiguracoes = class(TForm)
    rectToolBar: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Label6: TLabel;
    edtTaxaEntrega: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure DadosConfig;
    procedure TerminateConfig(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfiguracoes: TFrmConfiguracoes;

implementation

{$R *.fmx}

procedure TFrmConfiguracoes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmConfiguracoes := nil;
end;

procedure TFrmConfiguracoes.FormShow(Sender: TObject);
begin
    DadosConfig;
end;

procedure TFrmConfiguracoes.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmConfiguracoes.imgSalvarClick(Sender: TObject);
begin
    // Salvar os dados...

    close;
end;

procedure TFrmConfiguracoes.TerminateConfig(Sender: TObject);
begin
    TLoading.Hide;

    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;

procedure TFrmConfiguracoes.DadosConfig;
var
    t: TThread;
begin
    TLoading.Show(FrmConfiguracoes, 'Carregando...'); // Thread Principal..

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(1500);

        TThread.Synchronize(TThread.CurrentThread, procedure
        var
            i: integer;
        begin
            edtTaxaEntrega.Text := '5';
        end);

    end);

    t.OnTerminate := TerminateConfig;
    t.Start;
end;


end.

unit UnitPedidoDetalhe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, uCombobox,
  FMX.DialogService, uLoading;

type
  TFrmPedidoDetalhe = class(TForm)
    rectToolBar: TRectangle;
    Label3: TLabel;
    imgFechar: TImage;
    Rectangle1: TRectangle;
    lblPedido: TLabel;
    lblData: TLabel;
    lblCliente: TLabel;
    lblEndereco: TLabel;
    lbProdutos: TListBox;
    lytRodape: TLayout;
    rectValores: TRectangle;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblEntrega: TLabel;
    lblSubtotal: TLabel;
    lblTotal: TLabel;
    rectCmbStatus: TRectangle;
    lblCmbStatus: TLabel;
    Image1: TImage;
    rectBtnFinalizar: TRectangle;
    btnFinalizar: TSpeedButton;
    Label13: TLabel;
    lblStatus: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rectCmbStatusClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
  private
    cmbFiltroStatus: TCustomCombobox;
    procedure AddProduto(id_produto: integer;
                                       url_foto, nome, descricao, obs: string;
                                       preco: double;
                                       ind_ordenacao: boolean = false);
    procedure DetalhesPedido(id_pedido: integer);

    {$IFDEF MSWINDOWS}
    procedure EditarStatusClick(Sender: TObject);
    {$ELSE}
    procedure EditarStatusClick(Sender: TObject; const PointF: TPointF);
    {$ENDIF}

    procedure SetupCombobox;
    procedure TerminateDadosPedido(Sender: TObject);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPedidoDetalhe: TFrmPedidoDetalhe;

implementation

{$R *.fmx}

uses Frame.Produto;

procedure TFrmPedidoDetalhe.AddProduto(id_produto: integer;
                                       url_foto, nome, descricao, obs: string;
                                       preco: double;
                                       ind_ordenacao: boolean = false);
var
    item: TListBoxItem;
    frame: TFrameProduto;
begin
    item := TListBoxItem.Create(lbProdutos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 60;
    item.Tag := id_produto;

    // Frame...
    frame := TFrameProduto.Create(item);
    frame.lblNome.Text := nome;
    frame.lblDescricao.Text := descricao;
    frame.lblPreco.Text := FormatFloat('R$ #,##0.00', preco);
    frame.imgFoto.TagString := url_foto;
    frame.imgUp.visible := ind_ordenacao;
    frame.imgDown.visible := ind_ordenacao;


    item.AddObject(frame);
    lbProdutos.AddObject(item);
end;

{$IFDEF MSWINDOWS}
procedure TFrmPedidoDetalhe.EditarStatusClick(Sender: TObject);
{$ELSE}
procedure TFrmPedidoDetalhe.EditarStatusClick(Sender: TObject; const PointF: TPointF);
{$ENDIF}
begin
    cmbFiltroStatus.HideMenu;

    showmessage('Alterar o status para: ' + cmbFiltroStatus.CodItem);
    close;
end;


procedure TFrmPedidoDetalhe.SetupCombobox;
begin
    cmbFiltroStatus := TCustomCombobox.Create(FrmPedidoDetalhe);
    cmbFiltroStatus.TitleMenuText := 'Alterar Status';
    cmbFiltroStatus.SubTitleMenuText := 'Escolha o status do pedido:';

    cmbFiltroStatus.BackgroundColor := $FFFFFFFF;
    cmbFiltroStatus.ItemBackgroundColor := $FFE84F3D;
    cmbFiltroStatus.ItemFontColor := $FFFFFFFF;

    cmbFiltroStatus.OnClick := EditarStatusClick;

    cmbFiltroStatus.AddItem('A', 'Aberto');
    cmbFiltroStatus.AddItem('C', 'Cancelado');
    cmbFiltroStatus.AddItem('E', 'Entrega');
    cmbFiltroStatus.AddItem('F', 'Finalizado');

end;

procedure TFrmPedidoDetalhe.btnFinalizarClick(Sender: TObject);
begin
    TDialogService.MessageDialog('Deseja finalizar o pedido?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
     procedure(const AResult: TModalResult)
     begin
        if AResult = mrYes then
        begin
            try
                showmessage('Finalizar o pedido');
            finally

            end;
        end;
     end);
end;

procedure TFrmPedidoDetalhe.TerminateDadosPedido(Sender: TObject);
begin
    lbProdutos.EndUpdate;
    TLoading.Hide;

    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;


procedure TFrmPedidoDetalhe.DetalhesPedido(id_pedido: integer);
var
    t: TThread;
begin
    TLoading.Show(FrmPedidoDetalhe, 'Carregando...'); // Thread Principal..
    lbProdutos.BeginUpdate;
    lbProdutos.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    begin
        sleep(2000);

        TThread.Synchronize(TThread.CurrentThread, procedure
        var
            i: integer;
        begin
            AddProduto(0, '', 'X-Salada', '02 x R$ 25,00', 'Sem alface', 25);
            AddProduto(0, '', 'X-Tudo', '03 x R$ 40,00', '', 40);
            AddProduto(0, '', 'X-Egg', '01 x R$ 15,00', '', 15);
        end);

    end);

    t.OnTerminate := TerminateDadosPedido;
    t.Start;
end;


procedure TFrmPedidoDetalhe.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmPedidoDetalhe := nil;
end;

procedure TFrmPedidoDetalhe.FormCreate(Sender: TObject);
begin
    SetupCombobox;
end;

procedure TFrmPedidoDetalhe.FormDestroy(Sender: TObject);
begin
    cmbFiltroStatus.DisposeOf;
end;

procedure TFrmPedidoDetalhe.FormShow(Sender: TObject);
begin
    DetalhesPedido(0);
end;

procedure TFrmPedidoDetalhe.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmPedidoDetalhe.rectCmbStatusClick(Sender: TObject);
begin
    cmbFiltroStatus.ShowMenu;
end;

end.

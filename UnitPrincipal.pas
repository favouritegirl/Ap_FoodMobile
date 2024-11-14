unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Layouts, uCombobox, uLoading;

type
  TFrmPrincipal = class(TForm)
    rectAbas: TRectangle;
    imgAba1: TImage;
    imgAba3: TImage;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Rectangle1: TRectangle;
    Label1: TLabel;
    Image4: TImage;
    Rectangle2: TRectangle;
    Label2: TLabel;
    Image5: TImage;
    Rectangle3: TRectangle;
    Label3: TLabel;
    Image6: TImage;
    rectIndicador: TRectangle;
    lvPedidos: TListView;
    imgPedido: TImage;
    imgData: TImage;
    imgEndereco: TImage;
    imgFone: TImage;
    imgValor: TImage;
    imgAberto: TImage;
    ImgEntrega: TImage;
    imgCancelado: TImage;
    ImgFinalizado: TImage;
    rectFiltro: TRectangle;
    rectBtnFiltro: TRectangle;
    btnFiltrar: TSpeedButton;
    rectFiltroData: TRectangle;
    lblFiltroData: TLabel;
    Image1: TImage;
    rectFiltroStatus: TRectangle;
    lblFiltroStatus: TLabel;
    Image2: TImage;
    imgAddCategoria: TImage;
    lvCardapio: TListView;
    imgMais: TImage;
    imgMenu: TImage;
    rectFundoCardapio: TRectangle;
    lytMenuCardapio: TLayout;
    rectMenuCardapio: TRectangle;
    btnCima: TSpeedButton;
    btnBaixo: TSpeedButton;
    btnProdutos: TSpeedButton;
    btnCancelar: TSpeedButton;
    Line1: TLine;
    rectItemConfig: TRectangle;
    Image3: TImage;
    Label6: TLabel;
    Image7: TImage;
    rectItemLogout: TRectangle;
    Image8: TImage;
    Label7: TLabel;
    Image9: TImage;
    imgAba2: TImage;
    Image11: TImage;
    procedure imgAba1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvCardapioItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure btnCancelarClick(Sender: TObject);
    procedure rectItemConfigClick(Sender: TObject);
    procedure rectItemLogoutClick(Sender: TObject);
    procedure lvPedidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnProdutosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rectFiltroDataClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure rectFiltroStatusClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
  private
    cmbFiltroData, cmbFiltroStatus: TCustomCombobox;

    procedure MudarAba(img: TImage);
    procedure SetupAbas;
    procedure AddPedido(id_pedido: integer; dt_pedido, fone, endereco,
                        status: string; vl_total: double);
    procedure ListarPedidos(dt, status: string);
    function ImagemStatus(status: string): TBitmap;
    procedure AddCategoria(id_categoria: integer; descricao: string);
    procedure ListarCategorias;

    {$IFDEF MSWINDOWS}
    procedure FiltroDataClick(Sender: TObject);
    {$ELSE}
    procedure FiltroDataClick(Sender: TObject; const PointF: TPointF);
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    procedure FiltroStatusClick(Sender: TObject);
    {$ELSE}
    procedure FiltroStatusClick(Sender: TObject; const PointF: TPointF);
    {$ENDIF}



    procedure SetupCombobox;
    procedure TerminateListarPedido(Sender: TObject);
    procedure TerminateListarCategoria(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}
{$R *.iPhone.fmx IOS}

uses UnitConfiguracoes, UnitPedidoDetalhe, UnitCategoria, UnitCategoriaProd;

function TFrmPrincipal.ImagemStatus(status: string): TBitmap;
begin
    if (status = 'A') then
        Result := imgAberto.Bitmap
    else if (status = 'C') then
        Result := imgCancelado.Bitmap
    else if (status = 'E') then
        Result := ImgEntrega.Bitmap
    else
        Result := ImgFinalizado.Bitmap;
end;

procedure TFrmPrincipal.AddPedido(id_pedido: integer;
                                  dt_pedido, fone, endereco, status: string;
                                  vl_total: double);
var
    item: TListViewItem;
begin
    item := lvPedidos.Items.Add;
    item.Height := 110;

    TListItemText(item.Objects.FindDrawable('txtPedido')).Text := 'Pedido ' + id_pedido.ToString;
    TListItemText(item.Objects.FindDrawable('txtData')).Text := dt_pedido;
    TListItemText(item.Objects.FindDrawable('txtFone')).Text := fone;
    TListItemText(item.Objects.FindDrawable('txtEndereco')).Text := endereco;
    TListItemText(item.Objects.FindDrawable('txtValor')).Text := FormatFloat('R$ #,##0.00', vl_total);

    TListItemImage(item.Objects.FindDrawable('imgPedido')).Bitmap := imgPedido.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgData')).Bitmap := imgData.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgFone')).Bitmap := imgFone.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgEndereco')).Bitmap := imgEndereco.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgValor')).Bitmap := imgValor.Bitmap;

    TListItemImage(item.Objects.FindDrawable('imgStatus')).Bitmap := ImagemStatus(status);
end;

procedure TFrmPrincipal.btnCancelarClick(Sender: TObject);
begin
    lytMenuCardapio.Visible := false;
end;

procedure TFrmPrincipal.btnFiltrarClick(Sender: TObject);
begin
    //showmessage('Filtrar por: ' + rectFiltroData.TagString + ', ' +
    //                             rectFiltroStatus.TagString);
    ListarPedidos('', '');
end;

procedure TFrmPrincipal.btnProdutosClick(Sender: TObject);
begin
    if NOT Assigned(FrmCategoriaProd) then
        Application.CreateForm(TFrmCategoriaProd, FrmCategoriaProd);

    lytMenuCardapio.Visible := false;
    FrmCategoriaProd.Show;
end;

procedure TFrmPrincipal.AddCategoria(id_categoria: integer; descricao: string);
var
    item: TListViewItem;
begin
    item := lvCardapio.Items.Add;
    item.Height := 50;
    item.Tag := id_categoria;

    TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := descricao;
    TListItemImage(item.Objects.FindDrawable('imgMenu')).Bitmap := imgMenu.Bitmap;
    TListItemImage(item.Objects.FindDrawable('imgMais')).Bitmap := imgMais.Bitmap;
end;

procedure TFrmPrincipal.TerminateListarPedido(Sender: TObject);
begin
    lvPedidos.EndUpdate;
    TLoading.Hide;

    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;

procedure TFrmPrincipal.TerminateListarCategoria(Sender: TObject);
begin
    lvCardapio.EndUpdate;
    TLoading.Hide;

    if Sender is TThread then
        if Assigned(TThread(Sender).FatalException) then
        begin
            showmessage(Exception(TThread(sender).FatalException).Message);
            exit;
        end;
end;


procedure TFrmPrincipal.ListarPedidos(dt, status: string);
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, 'Carregando...'); // Thread Principal..
    lvPedidos.BeginUpdate;
    lvPedidos.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    begin
        //sleep(3000);

        TThread.Synchronize(TThread.CurrentThread, procedure
        var
            i: integer;
        begin
            for i := 1 to 10 do
                AddPedido(i, '15/03/2024 - 21:33h', '(11) 99999-9999', 'Av. Brasil, 1500', 'A', i * 9.90);
        end);

    end);

    t.OnTerminate := TerminateListarPedido;
    t.Start;
end;

procedure TFrmPrincipal.lvCardapioItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
    if ItemObject <> nil then
        if ItemObject.Name = 'imgMenu' then
        begin
            lytMenuCardapio.Visible := true;
            exit;
        end;

    // Abre cadastro das categorias/menu
    if NOT Assigned(FrmCategoria) then
        application.CreateForm(TFrmCategoria, FrmCategoria);

    FrmCategoria.Show;
end;

procedure TFrmPrincipal.lvPedidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
    if NOT Assigned(FrmPedidoDetalhe) then
        application.CreateForm(TFrmPedidoDetalhe, FrmPedidoDetalhe);

    FrmPedidoDetalhe.Show;
end;


procedure TFrmPrincipal.ListarCategorias;
var
    t: TThread;
begin
    TLoading.Show(FrmPrincipal, 'Carregando...'); // Thread Principal..
    lvCardapio.BeginUpdate;
    lvCardapio.Items.Clear;

    t := TThread.CreateAnonymousThread(procedure
    begin
        //sleep(3000);

        TThread.Synchronize(TThread.CurrentThread, procedure
        var
            i: integer;
        begin
            AddCategoria(1, 'Destaques');
            AddCategoria(2, 'Promo��es');
            AddCategoria(3, 'Sandu�ches');
            AddCategoria(4, 'Bebidas');
            AddCategoria(5, 'Sobremesas');
        end);

    end);

    t.OnTerminate := TerminateListarCategoria;
    t.Start;
end;


procedure TFrmPrincipal.MudarAba(img: TImage);
begin
    imgAba1.Opacity := 0.5;
    imgAba2.Opacity := 0.5;
    imgAba3.Opacity := 0.5;
    img.Opacity := 1;

    TAnimator.AnimateFloat(rectIndicador, 'Position.x',
                           img.position.x, 0.2, TAnimationType.InOut,
                           TInterpolationType.Circular);

    TabControl.GotoVisibleTab(img.Tag); // Tag contem o indice da aba

    if img.Tag = 1 then
        ListarCategorias;
end;

procedure TFrmPrincipal.rectFiltroDataClick(Sender: TObject);
begin
    cmbFiltroData.ShowMenu;
end;

procedure TFrmPrincipal.rectFiltroStatusClick(Sender: TObject);
begin
    cmbFiltroStatus.ShowMenu;
end;

procedure TFrmPrincipal.rectItemConfigClick(Sender: TObject);
begin
    if NOT Assigned(FrmConfiguracoes) then
        Application.CreateForm(TFrmConfiguracoes, FrmConfiguracoes);

    FrmConfiguracoes.Show;
end;

procedure TFrmPrincipal.rectItemLogoutClick(Sender: TObject);
begin
    showmessage('Fazer logout');
end;

procedure TFrmPrincipal.SetupAbas;
begin
    rectIndicador.Width := imgAba1.Width;

    if TabControl.TabIndex = 0 then
        rectIndicador.Position.X := imgAba1.Position.x
    else if TabControl.TabIndex = 1 then
        rectIndicador.Position.X := imgAba2.Position.x
    else
        rectIndicador.Position.X := imgAba3.Position.x;
end;

{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.FiltroDataClick(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.FiltroDataClick(Sender: TObject; const PointF: TPointF);
{$ENDIF}
begin
    cmbFiltroData.HideMenu;

    if cmbFiltroData.CodItem <> 'Limpar Filtro' then
    begin
        rectFiltroData.TagString := cmbFiltroData.CodItem; // Pedidos Hoje, Pedidos Ontem...
        lblFiltroData.Text := cmbFiltroData.DescrItem;
    end
    else
    begin
        rectFiltroData.TagString := '';
        lblFiltroData.Text := 'Filtrar por data';
    end;
end;

{$IFDEF MSWINDOWS}
procedure TFrmPrincipal.FiltroStatusClick(Sender: TObject);
{$ELSE}
procedure TFrmPrincipal.FiltroStatusClick(Sender: TObject; const PointF: TPointF);
{$ENDIF}
begin
    cmbFiltroStatus.HideMenu;

    if cmbFiltroStatus.CodItem <> 'Limpar Filtro' then
    begin
        rectFiltroStatus.TagString := cmbFiltroStatus.CodItem;
        lblFiltroStatus.Text := cmbFiltroStatus.DescrItem;
    end
    else
    begin
        rectFiltroStatus.TagString := '';
        lblFiltroStatus.Text := 'Filtrar por status';
    end;
end;

procedure TFrmPrincipal.SetupCombobox;
begin
    cmbFiltroData := TCustomCombobox.Create(FrmPrincipal);
    cmbFiltroData.TitleMenuText := 'Filtro por Data';
    cmbFiltroData.SubTitleMenuText := 'Escolha uma das op��es abaixo:';

    cmbFiltroData.BackgroundColor := $FFFFFFFF;
    cmbFiltroData.ItemBackgroundColor := $FFE84F3D;
    cmbFiltroData.ItemFontColor := $FFFFFFFF;

    cmbFiltroData.OnClick := FiltroDataClick;

    cmbFiltroData.AddItem('Pedidos Hoje', 'Pedidos Hoje');
    cmbFiltroData.AddItem('Pedidos Ontem', 'Pedidos Ontem');
    cmbFiltroData.AddItem('�ltimos 7 dias', '�ltimos 7 dias');
    cmbFiltroData.AddItem('�ltimos 30 dias', '�ltimos 30 dias');
    cmbFiltroData.AddItem('Limpar Filtro', 'Limpar Filtro');

    //------

    cmbFiltroStatus := TCustomCombobox.Create(FrmPrincipal);
    cmbFiltroStatus.TitleMenuText := 'Filtro por Status';
    cmbFiltroStatus.SubTitleMenuText := 'Escolha uma das op��es abaixo:';

    cmbFiltroStatus.BackgroundColor := $FFFFFFFF;
    cmbFiltroStatus.ItemBackgroundColor := $FFE84F3D;
    cmbFiltroStatus.ItemFontColor := $FFFFFFFF;

    cmbFiltroStatus.OnClick := FiltroStatusClick;

    cmbFiltroStatus.AddItem('A', 'Aberto');
    cmbFiltroStatus.AddItem('C', 'Cancelado');
    cmbFiltroStatus.AddItem('E', 'Entrega');
    cmbFiltroStatus.AddItem('F', 'Finalizado');
    cmbFiltroStatus.AddItem('Limpar Filtro', 'Limpar Filtro');


end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    SetupCombobox;
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
    cmbFiltroData.DisposeOf;
    cmbFiltroStatus.DisposeOf;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
    SetupAbas;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    SetupAbas;
    MudarAba(imgAba1);
    ListarPedidos('', '');
end;

procedure TFrmPrincipal.imgAba1Click(Sender: TObject);
begin
    MudarAba(TImage(Sender));
end;

end.

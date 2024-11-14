unit UnitCategoriaProdCad;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  FMX.DialogService;

type
  TFrmCategoriaProdCad = class(TForm)
    rectToolBar: TRectangle;
    lblTitulo: TLabel;
    imgFechar: TImage;
    imgSalvar: TImage;
    Label6: TLabel;
    edtCategoria: TEdit;
    imgExcluir: TImage;
    Image1: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    ComboBox1: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
    procedure imgExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCategoriaProdCad: TFrmCategoriaProdCad;

implementation

{$R *.fmx}

procedure TFrmCategoriaProdCad.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmCategoriaProdCad := nil;
end;

procedure TFrmCategoriaProdCad.imgExcluirClick(Sender: TObject);
begin
    TDialogService.MessageDialog('Deseja excluir o produto?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
     procedure(const AResult: TModalResult)
     begin
        if AResult = mrYes then
        begin
            try
                showmessage('Excluir o produto');
            finally

            end;
        end;
     end);
end;

procedure TFrmCategoriaProdCad.imgFecharClick(Sender: TObject);
begin
    close;
end;

end.

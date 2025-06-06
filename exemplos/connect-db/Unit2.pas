unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  FluentOrm.Db.QuerySql, FluentOrm.Db.ResultDataSet, FluentOrm.Db.QueryBuilder;

type

  TPerfilUsuario = class
  private
    FId: Int64;
    FNome: String;
  public
    property Id: Int64 read FId write FId;
    property Nome: String read FNome write FNome;
  end;

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  Data.DB;

{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
var
  Drs: IResultDataSet;
begin

  var Perfil := TQueryBuilder.New(nil)
    .From('PERFIL_USUARIO','PU')
    .OrderBy('NOME')
    .GetResultDataSet.First.GetSingleResult(TPerfilUsuario) as TPerfilUsuario;


  TQueryBuilder.New(nil)
    .From('USUARIO','U')
    .Join('PERFIL_USUARIO','PU','PU.ID = U.ID_PERFIL')
    .OrderBy('NOME')
    .Select('U.*,PU.NOME AS NOME_PERFIL,')
    .GetResultDataSet.ForEach(procedure(const AFields: TFields)
      begin

      end);

end;

end.

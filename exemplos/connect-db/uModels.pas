unit uModels;

interface

uses FluentOrm.Orm.Mappings;

type

  [Entity]
  [Table('USUARIO')]
  TUsuario = class
  private
    FId: Int64;
    FNome: String;
  public
    [Column('ID')]
    property Id: Int64 read FId write FId;
    [Column('NOME')]
    property Nome: String read FNome write FNome;
  end;

implementation

end.

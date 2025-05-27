unit FluentOrm.Db.SqlMappings;

interface

uses
  System.Classes;

type

  SqlColumn = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(AName: String);
    property Name: String read FName write FName;
  end;

implementation

{ SqlColumn }

constructor SqlColumn.Create(AName: String);
begin
  FName := AName;
end;

end.

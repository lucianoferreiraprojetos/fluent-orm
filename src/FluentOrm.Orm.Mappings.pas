unit FluentOrm.Orm.Mappings;

interface

uses
  System.Classes;

type

  Entity = class(TCustomAttribute)
  end;

  Table = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(AName: String);
  public
    property Name: String read FName write FName;
  end;

  Sequence = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(AName: String);
  public
    property Name: String read FName write FName;
  end;

  AbstractColumn = class abstract (TCustomAttribute)
  private
    FName: String;
    constructor Create(AName: String);
  public
    property Name: String read FName write FName;
  end;

  TColumnOption = (optNoInsert,optNoUpdate,optPk,optUnique);

  TColumnOptions = set of TColumnOption;

  Column = class(AbstractColumn)
  private
    FOptions: TColumnOptions;
  public
    constructor Create(AName: String); overload;
    constructor Create(AName: String; AOptions: TColumnOptions); overload;
    property Options: TColumnOptions read FOptions write FOptions;
  end;

  TJoinColumnOption = (optLazy,optManyToOne,optOneToOne,optOneToMany,optManyToMany);

  TJoinColumnOptions = set of TJoinColumnOption;

  JoinColumn = class(AbstractColumn)
  private
    FOptions: TJoinColumnOptions;
  public
    constructor Create(AName: String; AOptions: TJoinColumnOptions); overload;
    property Options: TJoinColumnOptions read FOptions write FOptions;
  end;

implementation

{ Table }

constructor Table.Create(AName: String);
begin
  FName := AName;
end;

{ AbstractColumn }

constructor AbstractColumn.Create(AName: String);
begin
  FName := AName;
end;

{ Sequence }

constructor Sequence.Create(AName: String);
begin
  FName := AName;
end;

{ Column }

constructor Column.Create(AName: String; AOptions: TColumnOptions);
begin
  FName := AName;
  FOptions := AOptions;
end;

constructor Column.Create(AName: String);
begin
  FName := AName;
end;

{ JoinColumn }

constructor JoinColumn.Create(AName: String; AOptions: TJoinColumnOptions);
begin
  FName := AName;
  FOptions := AOptions;
end;

end.

unit FluentOrm.Db.UpdateBuilder;

interface

uses
  System.SysUtils, System.Generics.Collections, System.StrUtils,
  FluentOrm.Db.DbConnection, FluentOrm.Db.QuerySql;

type

  IUpdateBuilder = interface
    ['{6B07471B-8CC6-40BF-A334-18B8C77D5A04}']
    function Add(const AColumnName: String; const AValue: Variant): IUpdateBuilder;
    function AddWhere(const AColumnName: String; const AValue: Variant): IUpdateBuilder;
    procedure ExecInsert;
    procedure ExecUpdate;
  end;

  TUpdateBuilder = class(TInterfacedObject,IUpdateBuilder)
  private
    FDbConnection: TDbConnection;
    FTableName: String;
    FValues: TDictionary<String,Variant>;
    FWhereList: TDictionary<String,Variant>;
    constructor Create(ADbConnection: TDbConnection; ATableName: String);
    destructor Destroy; override;
  public
    function Add(const AColumnName: String; const AValue: Variant): IUpdateBuilder;
    function AddWhere(const AColumnName: String; const AValue: Variant): IUpdateBuilder;
    procedure ExecInsert;
    procedure ExecUpdate;
  public
    class function New(ADbConnection: TDbConnection; ATableName: String): IUpdateBuilder;
  end;

implementation

{ TUpdateBuilder }

function TUpdateBuilder.Add(const AColumnName: String;
  const AValue: Variant): IUpdateBuilder;
begin
  Result := Self;
  FValues.Add(AColumnName,AValue);
end;

function TUpdateBuilder.AddWhere(const AColumnName: String;
  const AValue: Variant): IUpdateBuilder;
begin
  Result := Self;
  FWhereList.Add(AColumnName,AValue);
end;

constructor TUpdateBuilder.Create(ADbConnection: TDbConnection;
  ATableName: String);
begin
  FDbConnection := ADbConnection;
  FTableName := ATableName;
  FValues := TDictionary<String,Variant>.Create;
  FWhereList := TDictionary<String,Variant>.Create;
end;

destructor TUpdateBuilder.Destroy;
begin
  FreeAndNil(FValues);
  FreeAndNil(FWhereList);
  inherited;
end;

procedure TUpdateBuilder.ExecInsert;
var
  Columns: String;
  Params: String;
  Qry: IQuerySql;
begin

  for var LVal in FValues do
  begin
    Columns := Columns + IfThen(Columns.IsEmpty,'',',') + LVal.Key;
    Params := Params + IfThen(Params.IsEmpty,'',',') + ':' + LVal.Key;
  end;

  Qry := TQuerySql.New(FDbConnection)
    .AddSQL(Format('INSERT INTO %s (%s) VALUES (%s)',[FTableName,Columns,Params]));

  for var Param in FValues do
    Qry.SetParam(Param.Key,Param.Value);

  Qry.ExecSQL;
end;

procedure TUpdateBuilder.ExecUpdate;
var
  SetColumns: String;
  WhereConcat: String;
  Qry: IQuerySql;
begin

  for var LVal in FValues do
    SetColumns := SetColumns + IfThen(SetColumns.IsEmpty,'',',') + LVal.Key + ' = :' + LVal.Key;

  for var Where in FWhereList do
  begin
    WhereConcat := WhereConcat +
      IfThen(WhereConcat.IsEmpty,'',' AND ') + '(' + Where.Key + ' = :' + Where.Key + ')';
  end;

  if not WhereConcat.IsEmpty then
    WhereConcat := 'WHERE ' + WhereConcat;

  Qry := TQuerySql.New(FDbConnection)
    .AddSQL(Format('UPDATE %s SET %s %s',[FTableName,SetColumns,WhereConcat]));

  for var Param in FValues do
    Qry.SetParam(Param.Key,Param.Value);

  for var Param in FWhereList do
    Qry.SetParam(Param.Key,Param.Value);

  Qry.ExecSQL;
end;

class function TUpdateBuilder.New(ADbConnection: TDbConnection;
  ATableName: String): IUpdateBuilder;
begin
  Result := Self.Create(ADbConnection,ATableName);
end;
end.

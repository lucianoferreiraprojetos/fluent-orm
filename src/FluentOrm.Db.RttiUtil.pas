unit FluentOrm.Db.RttiUtil;

interface

uses
  System.Classes,
  Data.DB, System.Rtti, System.TypInfo, FluentOrm.Db.SqlMappings,
  System.Generics.Collections;

type

  TRttiPropertyHelper = class Helper for TRttiProperty
  public
    function HasSqlColumn: Boolean;
    function GetSqlColumn: SqlColumn;
  end;

  TRttiUtil = class
  public
    class function GetObjectFrom(const AFields: TFields; AClazz: TClass): TObject;
  end;

implementation

uses
  System.SysUtils, System.StrUtils;

{ TRttiUtil }

class function TRttiUtil.GetObjectFrom(const AFields: TFields;
  AClazz: TClass): TObject;
var
  rCtx: TRttiContext;
  rTyp: TRttiType;
  rPrp: TRttiProperty;
  cFld: TField;
  cAtt: TCustomAttribute;
  ColName: String;
begin
  Result := TClass(AClazz).Create;
  rCtx := TRttiContext.Create;
  try
    rTyp := rCtx.GetType(AClazz.ClassInfo);
    for cFld in AFields do
    begin
      if cFld.IsNull then
        Continue;
      for rPrp in rTyp.GetProperties do
      begin
        ColName := StringReplace(cFld.FieldName,'_','',[rfReplaceAll]);
        if ((rPrp.HasSqlColumn) and SameText(cFld.FieldName,rPrp.GetSqlColumn.Name)) or
           SameText(rPrp.Name,ColName) then
        begin
          if (rPrp.PropertyType.TypeKind = tkFloat) and (rPrp.PropertyType.Name = 'TDateTime') then
            rPrp.SetValue(Pointer(Result),TValue.From<TDateTime>(cFld.AsDateTime))
          else if (rPrp.PropertyType.TypeKind = tkEnumeration) and (rPrp.PropertyType.Name = 'Boolean') then
            rPrp.SetValue(Pointer(Result),TValue.FromVariant(cFld.AsBoolean))
          else
            rPrp.SetValue(Pointer(Result),TValue.FromVariant(cFld.Value));
          Break;
        end;
      end;
    end;
  finally
    rCtx.Free;
  end;
end;

{ TRttiPropertyHelper }

function TRttiPropertyHelper.GetSqlColumn: SqlColumn;
begin
  Result := GetAttribute(SqlColumn) as SqlColumn;
end;

function TRttiPropertyHelper.HasSqlColumn: Boolean;
begin
  Result := HasAttribute(SqlColumn);
end;

end.

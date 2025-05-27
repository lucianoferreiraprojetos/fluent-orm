unit FluentOrm.Orm.RttiEntityUtil;

interface

uses
  System.Rtti, System.TypInfo, FluentOrm.Orm.Mappings;

type
  TRttiEntityUtil = class
  public
    class function GetTableName(AClazz: TClass): String;
    class function GetSequenceName(AClazz: TClass): String;
  end;

implementation

{ TRttiEntityUtil }

class function TRttiEntityUtil.GetSequenceName(AClazz: TClass): String;
var
  rCtx: TRttiContext;
  rTyp: TRttiType;
  cAtt: TCustomAttribute;
begin
  rCtx := TRttiContext.Create;
  try
    rTyp := rCtx.GetType(AClazz);
    for cAtt in rTyp.GetAttributes do
    begin
      if cAtt is Sequence then
        Exit(Sequence(cAtt).Name);
    end;
  finally
    rCtx.Free;
  end;
end;

class function TRttiEntityUtil.GetTableName(AClazz: TClass): String;
var
  rCtx: TRttiContext;
  rTyp: TRttiType;
  cAtt: TCustomAttribute;
begin
  rCtx := TRttiContext.Create;
  try
    rTyp := rCtx.GetType(AClazz);
    for cAtt in rTyp.GetAttributes do
    begin
      if cAtt is Table then
        Exit(Table(cAtt).Name);
    end;
  finally
    rCtx.Free;
  end;
end;

end.

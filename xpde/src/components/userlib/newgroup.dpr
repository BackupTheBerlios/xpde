program newgroup;

uses
  QForms,
  uNewGroup in 'uNewGroup.pas' {NewGroups},
  uGroupPropeties in 'uGroupPropeties.pas' {GrpPropeties};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNewGroups, NewGroups);
  Application.CreateForm(TGrpPropeties, GrpPropeties);
  Application.Run;
end.

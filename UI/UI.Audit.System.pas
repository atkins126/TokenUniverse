unit UI.Audit.System;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,  Vcl.Menus,
  Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, VclEx.ListView,
  UI.Prototypes.Forms, UI.Prototypes.AuditFrame, NtUtils.Lsa.Audit;

type
  TDialogSystemAudit = class(TChildForm)
    FrameAudit: TFrameAudit;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure SetSystemAudit(const NewAudit: TArray<TAuditPolicyEntry>);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  NtUtils, NtUiLib.Errors;

{$R *.dfm}

{ TDialogSystemAudit }

constructor TDialogSystemAudit.Create;
begin
  inherited CreateChild(AOwner, cfmDesktop);
end;

procedure TDialogSystemAudit.FormCreate;
begin
  FrameAudit.OnApplyClick := SetSystemAudit;
  FrameAudit.LoadForSystem;
end;

procedure TDialogSystemAudit.FormKeyPress;
begin
  if Key = #27 then
    Close;
end;

procedure TDialogSystemAudit.SetSystemAudit;
begin
  try
    LsaxSetSystemAudit(NewAudit).RaiseOnError;
  finally
    FrameAudit.LoadForSystem;
  end;
end;

end.

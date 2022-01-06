object DialogRestrictToken: TDialogRestrictToken
  Left = 0
  Top = 0
  Caption = 'Create Restricted Token'
  ClientHeight = 462
  ClientWidth = 398
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 340
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonOK: TButton
    Left = 238
    Top = 429
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 319
    Top = 429
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = DoCloseForm
  end
  object PageControl1: TPageControl
    Left = 4
    Top = 6
    Width = 390
    Height = 403
    ActivePage = TabSheetSidDisable
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabSheetSidDisable: TTabSheet
      Caption = 'SIDs to disable'
      inline GroupsDisableFrame: TFrameGroups
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 376
        Height = 369
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        inherited VST: TVirtualStringTreeEx
          Width = 376
          Height = 369
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        end
      end
    end
    object TabSheetSidRestict: TTabSheet
      Caption = 'SIDs to restrict'
      ImageIndex = 1
      object CheckBoxWriteOnly: TCheckBox
        Left = 3
        Top = 355
        Width = 217
        Height = 17
        Hint = 
          'Restricting SIDs are always considered when evaluating write acc' +
          'ess. Also consider them when evaluating read and execute access.' +
          #13#10#13#10'Note: unchecking this item results in a less restrictive tok' +
          'en since the checks against the list above will take effect ONLY' +
          ' on attempts to perform write access. Such a token is also calle' +
          'd a "write-restricted token".'
        Anchors = [akLeft, akBottom]
        Caption = 'Restrict read && execute access'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
      object ButtonAddSID: TButton
        Left = 301
        Top = 343
        Width = 78
        Height = 25
        Hint = 'Add a new restricted SID that is not present in the list.'
        Anchors = [akRight, akBottom]
        Caption = 'Add SID'
        ImageIndex = 1
        ImageMargins.Left = 3
        ImageMargins.Top = 1
        Images = FormMain.SmallIcons
        TabOrder = 1
        OnClick = ButtonAddSIDClick
      end
      object CheckBoxUsual: TCheckBox
        Left = 3
        Top = 338
        Width = 217
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'Restrict write access'
        Checked = True
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 2
      end
      inline GroupsRestrictFrame: TFrameGroups
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 376
        Height = 331
        Margins.Bottom = 41
        Align = alClient
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        inherited VST: TVirtualStringTreeEx
          Width = 376
          Height = 331
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        end
      end
    end
    object TabSheetPrivDelete: TTabSheet
      Caption = 'Privileges to delete'
      ImageIndex = 2
      object CheckBoxDisableMaxPriv: TCheckBox
        Left = 6
        Top = 4
        Width = 373
        Height = 17
        Hint = 
          'Ignore the list below and delete all the privileges except `SeCh' +
          'angeNotifyPrivilege`.'
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Delete maximum privileges'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      inline PrivilegesFrame: TFramePrivileges
        AlignWithMargins = True
        Left = 3
        Top = 26
        Width = 376
        Height = 346
        Margins.Top = 26
        Align = alClient
        TabOrder = 1
        inherited VST: TVirtualStringTreeEx
          Width = 376
          Height = 346
          TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        end
      end
    end
  end
  object CheckBoxLUA: TCheckBox
    Left = 14
    Top = 415
    Width = 120
    Height = 15
    Hint = 
      'Disable administrative SIDs and delete some privileges as UAC do' +
      'es.'
    Anchors = [akLeft, akBottom]
    Caption = 'LUA token'
    TabOrder = 3
  end
  object CheckBoxSandboxInert: TCheckBox
    Left = 14
    Top = 436
    Width = 120
    Height = 17
    Hint = 
      'Does not check AppLocker rules or apply Software Restriction Pol' +
      'icies for the process with this token.'#13#10#13#10'This action might requ' +
      'ire SeTcbPrivilege to take effect.'
    Anchors = [akLeft, akBottom]
    Caption = 'Sandbox inert'
    TabOrder = 4
  end
end

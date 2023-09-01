object FrmMain: TFrmMain
  Left = 192
  Top = 107
  AlphaBlendValue = 10
  BorderStyle = bsDialog
  Caption = 'SnapShooter'
  ClientHeight = 48
  ClientWidth = 107
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 16
    Top = 8
    Width = 75
    Height = 25
    Caption = '&Salir'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object PopupMenu1: TPopupMenu
    Top = 16
    object Exit1: TMenuItem
      Caption = '&Salir'
      OnClick = BitBtn1Click
    end
  end
end

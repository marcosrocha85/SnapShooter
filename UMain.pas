unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ClipBrd, StdCtrls, ExtCtrls, Buttons, Menus, ShellAPI, jpeg;

const
  WM_ICONMESSAGE = WM_USER;

type
  TFrmMain = class(TForm)
    BitBtn1: TBitBtn;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    lHWND: Boolean;
    Bitmap: TBitmap;
    procedure CreateBitmapHelper;
    procedure InitializeTrayIcon;
    procedure IconTray(var Msg: TMessage); message WM_ICONMESSAGE;
    procedure SetFormPosition;
    function RemoveSpecialChars(const AString: String): String;
  public
    { Public declarations }
    nid: TNotifyIconData;
    procedure WndProc(var Msg: TMessage); override;
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

{ TFrmMain }

procedure TFrmMain.WndProc(var Msg: TMessage);
var
  JPG: TJPEGImage;
begin
  inherited;
  if not lHWND then
  begin
    Exit;
  end;

  if GetClipboardViewer <> Handle then
  begin
    SetClipboardViewer(Handle);
  end;

  if (Msg.Msg <> WM_DRAWCLIPBOARD) or (not Clipboard.HasFormat(CF_BITMAP)) then
  begin
    Exit;
  end;

  if not DirectoryExists('Pictures') then
  begin
    CreateDir('Pictures');
  end;

  Bitmap.LoadFromClipBoardFormat(CF_BITMAP, ClipBoard.GetAsHandle(CF_BITMAP), 0);
  JPG := TJPEGImage.Create;
  JPG.Assign(Bitmap);
  JPG.PixelFormat := jf24Bit;
  JPG.CompressionQuality := 80;
  JPG.Compress;
  JPG.SaveToFile(ExtractFileDir(Application.ExeName) + '\Pictures\' +
    RemoveSpecialChars(DateTimeToStr(Now)) + '.jpg');
  FreeAndNil(JPG);
  Clipboard.Clear;
end;

procedure TFrmMain.CreateBitmapHelper;
begin
  Bitmap := TBitmap.Create;
  lHWND := True;
  Clipboard.Clear;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  lHWND := False;
  FreeAndNil(Bitmap);
end;

procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.IconTray(var Msg: TMessage);
var
  Pt: TPoint;
begin
  if Msg.lParam = WM_RBUTTONDOWN then
  begin
    GetCursorPos(Pt);
    PopupMenu1.Popup(Pt.x, Pt.y);
  end;
end;

procedure TFrmMain.InitializeTrayIcon;
begin
  Icon.Handle := LoadIcon(HInstance, 'MAINICON');
  nid.cbSize := SizeOf(nid);
  nid.Wnd := Handle;
  nid.uID := 1;
  nid.uCallbackMessage := WM_ICONMESSAGE;
  nid.hIcon := Icon.Handle;
  nid.szTip := 'SnapShooter';
  nid.uFlags := NIF_MESSAGE or
                NIF_ICON or
                NIF_TIP;
  Shell_NotifyIcon(NIM_ADD, @nid);
end;

function TFrmMain.RemoveSpecialChars(const AString: String): String;
const
  Chars: Array of Char = [' ', ':', '/'];
var
  Index: Integer;
begin
  Result := AString;
  for Index := Low(Chars) to High(Chars) do
  begin
    Result := StringReplace(Result, Chars[Index], '', [rfReplaceAll]);
  end;
end;

procedure TFrmMain.SetFormPosition;
begin
  Left := Monitor.Width - Width;
  Top  := Monitor.Height - Height - 30;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  InitializeTrayIcon;
  CreateBitmapHelper;
  SetFormPosition;
end;

end.



unit CheckHASH;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  shellapi,
  Vcl.ExtCtrls, Vcl.WinXCtrls, Vcl.ButtonGroup, Vcl.ExtDlgs, Vcl.ComCtrls,
  Vcl.ToolWin, System.Actions, Vcl.ActnList,
  Vcl.StdActns, System.IOUtils, IdHashMessageDigest, idHash, Vcl.Menus,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Buttons;
// System.Skia, Vcl.Skia,

type
  TfrmMain = class(TForm)
    btnCheckHash: TButton;
    edtChooseHashString: TEdit;
    rdgrHash: TRadioGroup;
    FileOpenMD5String: TFileOpenDialog;
    lblStringaHash: TLinkLabel;
    lblFile: TLinkLabel;
    FileOpen: TFileOpenDialog;
    edtChooseFile: TEdit;
    SpeedButton1: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Esci1: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure edtChooseHashStringDblClick(Sender: TObject);
    procedure edtChooseHashStringClick(Sender: TObject);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure edtChooseHashStringChange(Sender: TObject);
    procedure edtChooseFileDblClick(Sender: TObject);
    procedure btnCheckHashClick(Sender: TObject);
    procedure edtChooseFileChange(Sender: TObject);
    procedure edtChooseFileKeyPress(Sender: TObject; var Key: Char);
    procedure edtChooseHashStringKeyPress(Sender: TObject; var Key: Char);
    procedure Esci1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);



  private

    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses CheckHASH.Forms.ThanksDelphi;

{$R *.dfm}

function MD5(const fileName: string): string;
var
  idmd5: TIdHashMessageDigest5;
  fs: TFileStream;

begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(fileName, fmOpenRead or fmShareDenyWrite);
  try
    result := UpperCase(idmd5.HashStreamAsHex(fs))
  finally
    fs.Free;
    idmd5.Free;
  end;
end;

procedure TfrmMain.btnCheckHashClick(Sender: TObject);
begin

  if FileOpen.filename = EmptyStr then
  begin
    btnCheckHash.Enabled := false;
    btnCheckHash.Caption := 'Working...';
    MessageBox(Handle, 'Select file to compute Hash...',
      'Check-Hash', MB_ICONWARNING or MB_OK);
    btnCheckHash.Enabled := true;
    btnCheckHash.Caption := 'Compute &Hash'
  end
  else if (FileOpenMD5String.fileName = EmptyStr) and (edtChooseHashString.Text = '') then
  begin
    btnCheckHash.Enabled := false;
    btnCheckHash.Caption := 'Working...';
    MessageBox(Handle, 'Insert Hash string', 'Check-Hash',
      MB_ICONWARNING or MB_OK);
    btnCheckHash.Enabled := true;
    btnCheckHash.Caption := 'Compute &Hash'
  end

  else
  begin
    btnCheckHash.Enabled := false;
    btnCheckHash.Caption := 'Working...';
    if MD5(FileOpen.fileName) = Trim(edtChooseHashString.Text) then
    begin
      MessageBox(Handle, pchar('File ' + ExtractFileName(FileOpen.fileName) +
        ' is OK.'), 'Check-Hash', MB_ICONINFORMATION or MB_OK);
      btnCheckHash.Enabled := true;
      btnCheckHash.Caption := 'Compute &Hash';
      edtChooseFile.Text := 'Double click here to choose file...';
      edtChooseHashString.Text := EmptyStr;
      FileOpenMD5String.FileName := EmptyStr;
      FileOpen.FileName := EmptyStr
    end
    // ShowMessage('Il file ' + ExtractFileName(FileOpen.fileName) + ' è integro.')
    else
    begin
      MessageBox(Handle, pchar('File ' + ExtractFileName(FileOpen.fileName) +
        ' is unhealthy or corrupt.'), 'Check-Hash',
        MB_ICONEXCLAMATION or MB_OK);
      btnCheckHash.Enabled := true;
      btnCheckHash.Caption := 'Compute &Hash';
      // ShowMessage('Il file ' + ExtractFileName(FileOpen.fileName) + ' NON è integro o corrotto.')
        edtChooseFile.Text := 'Double click here to choose file...';
      edtChooseHashString.Text := EmptyStr;
      FileOpenMD5String.FileName := EmptyStr;
      FileOpen.FileName := EmptyStr
    end
  end;
end;

procedure TfrmMain.edtChooseFileChange(Sender: TObject);
begin
  if Length(edtChooseFile.Text) = 0 then
  begin
    edtChooseFile.Color := clWindow;
    edtChooseFile.Text :=
      'Double click here to choose file...';

  end;

end;

procedure TfrmMain.edtChooseFileDblClick(Sender: TObject);
begin

  if FileOpen.Execute then
  begin
    edtChooseFile.Text := ExtractFileName(FileOpen.fileName);
    edtChooseFile.Color := clLime
  end;
end;

procedure TfrmMain.edtChooseFileKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    Application.Terminate
end;

procedure TfrmMain.edtChooseHashStringChange(Sender: TObject);
begin
  if Length(edtChooseHashString.Text) = 0 then
  begin
   // edtChooseHashString.Text :=
     // 'Write Hash string or double click here to choose file';
    lblStringaHash.Caption := 'Hash string:';
    edtChooseHashString.Color := clWindow;

  end;

end;

procedure TfrmMain.edtChooseHashStringClick(Sender: TObject);
begin
  edtChooseHashString.SelectAll
end;

procedure TfrmMain.edtChooseHashStringDblClick(Sender: TObject);

begin
  if FileOpenMD5String.Execute then
  begin
    for var line in TFile.GetLinesEnumerator(FileOpenMD5String.fileName) do
    begin
      lblStringaHash.Caption := 'Hash string (' +
        ExtractFileName(FileOpenMD5String.fileName) + '):';
      edtChooseHashString.Text := UpperCase(line);
      edtChooseHashString.Color := clWebLime;
    end;
  end;
end;

procedure TfrmMain.edtChooseHashStringKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(27) then
    Application.Terminate
end;

procedure TfrmMain.Esci1Click(Sender: TObject);
begin
Application.Terminate
end;

procedure TfrmMain.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  var
  ThanksDelphi := TForm1.Create(nil);
  ThanksDelphi.ShowModal;
  ThanksDelphi.Free
end;

procedure TfrmMain.FormShow(Sender: TObject);

begin

  rdgrHash.Buttons[1].Enabled := false;
  rdgrHash.Buttons[2].Enabled := false;

end;

procedure TfrmMain.Help1Click(Sender: TObject);
  var Indirizzo: array [0 .. 255] of Char;
begin
  StrPCopy(Indirizzo, 'https://github.com/neonshyn/Check-Hash');
  ShellExecute(Application.Handle, 'open', Indirizzo, nil, nil, SW_NORMAL)
end;

//procedure TfrmMain.test1Click(Sender: TObject);
//begin
//Application.terminate
//end;

end.

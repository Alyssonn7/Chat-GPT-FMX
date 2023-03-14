unit uPrincipal;

interface

uses

  Skia, Skia.FMX,

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, System.Net.HttpClientComponent,
  FMX.Layouts, System.JSON, System.Net.HttpClient, System.Net.URLClient, FMX.Ani;


type
  TForm1 = class(TForm)
    Edit1: TEdit;
    btnPesquisar: TButton;
    Memo1: TMemo;
    SkLabel1: TSkLabel;
    Layout1: TLayout;
    FloatAnimation1: TFloatAnimation;
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    function AskChatGPT(aQuestion: string):string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  aApiKey: string = '';
  // aqui voc� precisa colocar sua chave secreta dentro das '' que e gerada nesse link:https://platform.openai.com/account/api-keys

implementation

{$R *.fmx}


{ TForm1 }

function TForm1.AskChatGPT(aQuestion: string): string;
var
  _HttpClient: THTTPClient;
  _String:  string;
  _JSonValue: TJSONValue;
  _JSonArray: TJSONArray;
  _JSonString: TJSONString;
  _Response: IHTTPResponse;
  _PostData: string;
  _PostDataStream: TStringStream;
begin
  _PostData := '{' +
    '"model": "text-davinci-003",' +
    '"prompt": "' + aQuestion + '",' +
    '"max_tokens": 2048,' +
    '"temperature": 0' +
    '}';
  _PostDataStream := TStringStream.Create(_PostData);
  try
      _PostDataStream.Position := 0;
      _HttpClient := THTTPClient.Create;
      try
        _HttpClient.CustomHeaders['Authorization'] := 'Bearer ' + aApiKey;
        _HttpClient.CustomHeaders['Content-Type'] := 'application/json';

        _Response := _HttpClient.Post('https://api.openai.com/v1/completions', _PostDataStream);
        if _Response.StatusCode = 200 then
          begin
            _String     := _Response.ContentAsString;
            _JSonValue  := TJSONObject.ParseJSONValue(_String);
            _JSonValue  := _JSonValue.GetValue<TJSONValue>('choices');
            if _JSonValue is TJSONArray then
            begin
              _JSonArray    := _JSonValue as TJSONArray;
              _JSonString   := _JSonArray.Items[0].GetValue<TJSONString>('text');
              Result    := _JSonString.Value;
            end;
          End
        else
          begin
            Result  := 'HTTP response code: ' + _Response.StatusCode.ToString;
          end;
      finally
        _HttpClient.Free;
      end;
  finally
    _PostDataStream.Free;
  end;
end;

procedure TForm1.btnPesquisarClick(Sender: TObject);
begin
  Memo1.ClearContent;
  Memo1.Lines.Add(AskChatGPT(Edit1.Text));
end;

end.

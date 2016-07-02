unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sockets, ExtCtrls, Grids;

type
  TForm2 = class(TForm)
    TcpServer1: TTcpServer;
    btStart: TButton;
    btStop: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    StringGrid1: TStringGrid;
    procedure TcpServer1Accept(Sender: TObject; ClientSocket: TCustomIpClient);
    procedure btStopClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btStartClick(Sender: TObject);
begin
    btStart.Enabled := false;
    btStop.Enabled := true;

    TCPServer1.Active := true;
    Memo1.Lines.Add(DateTimeToStr(Now) + ': Сервер запущен.');
    Timer1.Interval  := 10000;
end;

procedure TForm2.btStopClick(Sender: TObject);
begin
    btStart.Enabled := true;
    btStop.Enabled := false;

    TCPServer1.Active := false;
    Memo1.Lines.Add(DateTimeToStr(Now) + ': Сервер остановлен.');
    Timer1.Interval := 0;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
    btStart.Enabled := true;
    btStop.Enabled := false;

//    apiwrite scoreboard 1,team1,0:05

    StringGrid1.Cells[0, 0] := 'Время';
    StringGrid1.Cells[1, 0] := 'Команда';
    StringGrid1.Cells[2, 0] := 'Тип модуля';
    StringGrid1.Cells[3, 0] := 'Номер модуля';
    StringGrid1.Cells[4, 0] := 'Поле вывода';
    StringGrid1.Cells[5, 0] := 'Текст сообщения';
    

    Show;
end;

procedure TForm2.TcpServer1Accept(Sender: TObject;
  ClientSocket: TCustomIpClient);
var
    s:string;
    vbCommand, vbModuleType, vbModuleNumber, vbOutputField, vbMessage: string;
    i: integer;
    nw: boolean;
begin
    //Для удобства присвоим перемнной s полученое сообщение
    s   :=  ClientSocket.receiveln;
    //Обработка полученного сообщения
    while s <> '' do begin
        nw := false;
        Memo1.Lines.Add(TimeToStr(Now) + ': ' + s);

        vbCommand := copy(s, 1, pos(' ', s) - 1);
        delete(s, 1, pos(' ', s));

        vbModuleType := copy(s, 1, pos(' ', s) - 1);
        delete(s, 1, pos(' ', s));

        vbModuleNumber := copy(s, 1, pos(',', s) - 1);
        delete(s, 1, pos(',', s));

        vbOutputField := copy(s, 1, pos(',', s) - 1);
        delete(s, 1, pos(',', s));

        vbMessage := s;

        with StringGrid1 do
        begin
            Cells[0, 1] := TimeToStr(Now);
            Cells[1, 1] := vbCommand;
            Cells[2, 1] := vbModuleType;
            Cells[3, 1] := vbModuleNumber;
            Cells[4, 1] := vbOutputField;
            Cells[5, 1] := vbMessage;
        end;
        s:=ClientSocket.receiveln;
    end;
end;

end.

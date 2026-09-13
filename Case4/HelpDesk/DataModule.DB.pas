unit DataModule.DB;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TDBModule = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
  private
    procedure ConfigureConnection;
  public
    procedure DataModuleCreate(Sender: TObject);
    function GetTicketsAsJson: string;
    function AddTicket(const AClientName, AEmail, ASubject, ADescription: string): Integer;
  end;

var
  DBModule: TDBModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.JSON, FireDAC.Stan.Param;

procedure TDBModule.ConfigureConnection;
begin
  FDConnection.LoginPrompt := False;
  FDConnection.Params.Clear;
  FDConnection.Params.DriverID := 'MSSQL';
  FDConnection.Params.Add('Server=localhost');
  FDConnection.Params.Add('Database=HelpDesk');
  FDConnection.Params.Add('OSAuthent=Yes');
  FDConnection.Params.Add('CharacterSet=UTF8');
end;

procedure TDBModule.DataModuleCreate(Sender: TObject);
begin
  ConfigureConnection;
  if not FDConnection.Connected then
    FDConnection.Connected := True;
end;

function TDBModule.GetTicketsAsJson: string;
var
  Q: TFDQuery;
  Arr: TJSONArray;
  Obj: TJSONObject;
begin
  Arr := TJSONArray.Create;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDConnection;
    Q.SQL.Text :=
      'SELECT TOP 100 TicketID, ClientName, Email, Subject, Description, Status, CreatedAt ' +
      'FROM dbo.Tickets ORDER BY TicketID DESC';
    Q.Open;
    while not Q.Eof do
    begin
      Obj := TJSONObject.Create;
      Obj.AddPair('ticketId', TJSONNumber.Create(Q.FieldByName('TicketID').AsInteger));
      Obj.AddPair('clientName', Q.FieldByName('ClientName').AsString);
      Obj.AddPair('email', Q.FieldByName('Email').AsString);
      Obj.AddPair('subject', Q.FieldByName('Subject').AsString);
      Obj.AddPair('description', Q.FieldByName('Description').AsString);
      Obj.AddPair('status', Q.FieldByName('Status').AsString);
      Obj.AddPair('createdAt', Q.FieldByName('CreatedAt').AsString);
      Arr.AddElement(Obj);
      Q.Next;
    end;
    Result := Arr.ToJSON;
  finally
    Q.Free;
    Arr.Free;
  end;
end;

function TDBModule.AddTicket(const AClientName, AEmail, ASubject,
  ADescription: string): Integer;
var
  Q: TFDQuery;
begin
  Result := -1;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := FDConnection;
    Q.SQL.Text :=
      'INSERT INTO dbo.Tickets (ClientName, Email, Subject, Description, Status) ' +
      'VALUES (:ClientName, :Email, :Subject, :Description, N''New''); ' +
      'SELECT CAST(SCOPE_IDENTITY() AS INT) AS NewID;';
    Q.ParamByName('ClientName').AsString := AClientName;
    Q.ParamByName('Email').AsString := AEmail;
    Q.ParamByName('Subject').AsString := ASubject;
    Q.ParamByName('Description').AsString := ADescription;
    Q.Open;
    Result := Q.FieldByName('NewID').AsInteger;
  finally
    Q.Free;
  end;
end;

end.
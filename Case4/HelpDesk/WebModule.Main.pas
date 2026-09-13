unit WebModule.Main;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TMainWebModule = class(TWebModule)
    DefaultHandler: TWebActionItem;
    TicketsHandler: TWebActionItem;
    TicketCreateHandler: TWebActionItem;
    procedure DefaultHandlerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure TicketsHandlerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure TicketCreateHandlerAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
  private
    function MainPageHtml: string;
    function EscapeHtml(const S: string): string;
    function JsonValue(const AName: string; Request: TWebRequest): string;
  public
  end;

var
  WebModuleClass: TComponentClass = TMainWebModule;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses
  System.JSON, DataModule.DB;

procedure TMainWebModule.WebModuleCreate(Sender: TObject);
begin
  Actions.Clear;

  with Actions.Add do
  begin
    Name := 'DefaultHandler';
    PathInfo := '/';
    Default := True;
    OnAction := DefaultHandlerAction;
  end;

  with Actions.Add do
  begin
    Name := 'TicketsHandler';
    PathInfo := '/api/tickets';
    MethodType := mtGet;
    OnAction := TicketsHandlerAction;
  end;

  with Actions.Add do
  begin
    Name := 'TicketCreateHandler';
    PathInfo := '/api/tickets/create';
    MethodType := mtPost;
    OnAction := TicketCreateHandlerAction;
  end;
end;

function TMainWebModule.EscapeHtml(const S: string): string;
begin
  Result := S.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')
             .Replace('"', '&quot;').Replace('''', '&#39;');
end;

function TMainWebModule.JsonValue(const AName: string; Request: TWebRequest): string;
var
  Json: TJSONObject;
  Val: TJSONValue;
begin
  Result := '';
  Json := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;
  try
    if Assigned(Json) then
    begin
      Val := Json.GetValue(AName);
      if Assigned(Val) then
        Result := Val.Value;
    end;
  finally
    Json.Free;
  end;
end;

function TMainWebModule.MainPageHtml: string;
begin
  Result :=
    '<!doctype html>' +
    '<html lang="en"><head><meta charset="utf-8">' +
    '<meta name="viewport" content="width=device-width, initial-scale=1">' +
    '<title>SupportDesk Web</title>' +
    '<style>' +
    'body{font-family:Segoe UI,Arial,sans-serif;background:#f5f7fb;margin:0;color:#1d2433}' +
    '.wrap{max-width:980px;margin:0 auto;padding:32px}' +
    '.card{background:#fff;border-radius:14px;box-shadow:0 8px 28px rgba(25,42,70,.08);padding:24px;margin-bottom:22px}' +
    'h1,h2{margin-top:0}.grid{display:grid;grid-template-columns:1fr 1fr;gap:18px}' +
    'input,textarea,button{width:100%;padding:12px;border-radius:10px;border:1px solid #ccd4e0;box-sizing:border-box;font:inherit}' +
    'textarea{min-height:120px;resize:vertical} button{background:#2457d6;color:#fff;border:none;font-weight:600;cursor:pointer}' +
    'table{width:100%;border-collapse:collapse} th,td{padding:10px;border-bottom:1px solid #e7edf5;text-align:left;vertical-align:top}' +
    '.muted{color:#63708a;font-size:14px}.ok{color:#16794c;font-weight:600}.tag{display:inline-block;padding:4px 8px;border-radius:999px;background:#edf3ff;color:#2457d6;font-size:12px;font-weight:700}' +
    '@media(max-width:800px){.grid{grid-template-columns:1fr}}' +
    '</style></head><body><div class="wrap">' +
    '<div class="card"><h1>SupportDesk Web</h1>' +
    '<p class="muted">A demo web application built with Delphi 10.2 + WebBroker + IIS + MS SQL Server.</p></div>' +
    '<div class="grid">' +
    '<div class="card"><h2>New ticket</h2>' +
    '<form id="ticketForm">' +
    '<p><input id="clientName" placeholder="Client name" required></p>' +
    '<p><input id="email" type="email" placeholder="E-mail" required></p>' +
    '<p><input id="subject" placeholder="Subject" required></p>' +
    '<p><textarea id="description" placeholder="Problem description" required></textarea></p>' +
    '<p><button type="submit">Submit</button></p>' +
    '<div id="msg" class="muted"></div></form></div>' +
    '<div class="card"><h2>Purpose</h2>' +
    '<p>The system lets users register support requests, stores them in SQL Server, and displays the latest tickets in the browser.</p>' +
    '<p><span class="tag">GET /api/tickets</span> &nbsp; <span class="tag">POST /api/tickets/create</span></p></div>' +
    '</div>' +
    '<div class="card"><h2>Latest tickets</h2><div id="tickets">Loading...</div></div>' +
    '</div>' +
    '<script>' +
    'async function loadTickets(){const r=await fetch("api/tickets");const d=await r.json();' +
    'let h="<table><thead><tr><th>ID</th><th>Client</th><th>Subject</th><th>Status</th><th>Date</th></tr></thead><tbody>";' +
    'for(const x of d){h+=`<tr><td>${x.ticketId}</td><td>${x.clientName}<br><span class="muted">${x.email}</span></td><td>${x.subject}<br><span class="muted">${x.description}</span></td><td>${x.status}</td><td>${x.createdAt}</td></tr>`;}' +
    'h+="</tbody></table>";document.getElementById("tickets").innerHTML=h;}' +
    'document.getElementById("ticketForm").addEventListener("submit", async (e)=>{e.preventDefault();' +
    'const payload={clientName:clientName.value,email:email.value,subject:subject.value,description:description.value};' +
    'const r=await fetch("api/tickets/create",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(payload)});' +
    'const d=await r.json();msg.innerHTML=r.ok?`<span class="ok">Ticket #${d.ticketId} created</span>`:d.error; if(r.ok){ticketForm.reset();loadTickets();}});' +
    'loadTickets();' +
    '</script></body></html>';
end;

procedure TMainWebModule.DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'text/html; charset=utf-8';
  Response.Content := MainPageHtml;
  Handled := True;
end;

procedure TMainWebModule.TicketsHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'application/json; charset=utf-8';
  Response.Content := DBModule.GetTicketsAsJson;
  Handled := True;
end;

procedure TMainWebModule.TicketCreateHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ClientName, Email, Subject, Description: string;
  NewID: Integer;
begin
  ClientName := Trim(JsonValue('clientName', Request));
  Email := Trim(JsonValue('email', Request));
  Subject := Trim(JsonValue('subject', Request));
  Description := Trim(JsonValue('description', Request));

  if (ClientName = '') or (Email = '') or (Subject = '') or (Description = '') then
  begin
    Response.StatusCode := 400;
    Response.ContentType := 'application/json; charset=utf-8';
    Response.Content := '{"error":"All fields are required"}';
    Handled := True;
    Exit;
  end;

  NewID := DBModule.AddTicket(ClientName, Email, Subject, Description);
  Response.ContentType := 'application/json; charset=utf-8';
  Response.Content := Format('{"ticketId":%d}', [NewID]);
  Handled := True;
end;

end.
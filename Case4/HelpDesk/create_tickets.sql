USE master;
GO

IF DB_ID(N'HelpDesk') IS NULL
  CREATE DATABASE HelpDesk;
GO

USE HelpDesk;
GO

IF OBJECT_ID(N'dbo.Tickets', N'U') IS NOT NULL
  DROP TABLE dbo.Tickets;
GO

CREATE TABLE dbo.Tickets (
    TicketID     INT IDENTITY(1,1) PRIMARY KEY,
    ClientName   NVARCHAR(120) NOT NULL,
    Email        NVARCHAR(120) NOT NULL,
    Subject      NVARCHAR(200) NOT NULL,
    Description  NVARCHAR(MAX) NOT NULL,
    Status       NVARCHAR(30) NOT NULL CONSTRAINT DF_Tickets_Status DEFAULT (N'New'),
    CreatedAt    DATETIME2 NOT NULL CONSTRAINT DF_Tickets_CreatedAt DEFAULT (SYSDATETIME())
);
GO

INSERT INTO dbo.Tickets (ClientName, Email, Subject, Description, Status)
VALUES
(N'Ivan Petrov',   N'ivan@example.com',  N'VPN is not working', N'After the Windows update the VPN client fails to connect.', N'New'),
(N'Maria Smirnova', N'maria@example.com', N'Password reset',     N'Need access to the corporate portal.',                    N'In progress');
GO
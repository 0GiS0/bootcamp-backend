﻿CREATE TABLE [dbo].[Cliente]
(
	[Id] INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[Nombre] VARCHAR(50) NOT NULL,
	[Apellidos] VARCHAR(75) NOT NULL,
	[Movil] VARCHAR(12) NOT NULL,
	[Email] VARCHAR(100) NOT NULL,
)
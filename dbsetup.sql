CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'UNIQUE_STRING_HERE';

GO;

CREATE DATABASE SCOPED CREDENTIAL BlobCredential
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sv=SAS_TOKEN_HERE';

GO;

CREATE EXTERNAL DATA SOURCE AzureBlob
WITH ( 
    TYPE       = BLOB_STORAGE,
    LOCATION   = 'INPUT_CONTAINER_URL_HERE',
    CREDENTIAL = BlobCredential
);

GO;

CREATE TABLE MyData (
    ID int,
    VALUE nvarchar(400)
);

GO;

CREATE PROCEDURE LoadData
AS
BEGIN

DELETE FROM [dbo].[MyData];

BULK INSERT [dbo].[MyData]
FROM 'input.csv'
WITH ( 
    DATA_SOURCE = 'AzureBlob',
    FORMAT      = 'CSV',
    FIRSTROW    = 2
);

END
-- Crete user for webapp managed identity and grant rights
CREATE USER [$(WebAppName)] FROM EXTERNAL PROVIDER
ALTER ROLE db_datareader ADD MEMBER [$(WebAppName)]
ALTER ROLE db_datawriter ADD MEMBER [$(WebAppName)]
-- Crete user for webapp managed identity and grant rights to current DB
CREATE USER [$(webSiteName)] FROM EXTERNAL PROVIDER
ALTER ROLE db_datareader ADD MEMBER [$(webSiteName)]
ALTER ROLE db_datawriter ADD MEMBER [$(webSiteName)]
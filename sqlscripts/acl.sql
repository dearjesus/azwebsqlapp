-- Crete user for webapp managed identity and grant rights
CREATE USER [${{ steps.deploy.outputs.webSiteName }}] FROM EXTERNAL PROVIDER
ALTER ROLE db_datareader ADD MEMBER [${{ steps.deploy.outputs.webSiteName }}]
ALTER ROLE db_datawriter ADD MEMBER [${{ steps.deploy.outputs.webSiteName }}]
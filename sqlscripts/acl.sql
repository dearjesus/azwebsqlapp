-- Crete user for webapp managed identity and grant rights
CREATE USER [$(webSiteName)] FROM EXTERNAL PROVIDER
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales TO [$(webSiteName)];

-- Never allow updates on this column
DENY UPDATE ON Sales(AppUserId) TO [$(webSiteName)];
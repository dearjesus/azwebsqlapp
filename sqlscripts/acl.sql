-- Create Table
CREATE TABLE Sales (
    OrderId int,
    AppUserId int,
    Product varchar(10),
    Qty int
);

-- Populate with data
INSERT Sales VALUES
    (1, 1, 'Valve', 5),
    (2, 1, 'Wheel', 2),
    (3, 1, 'Valve', 4),
    (4, 2, 'Bracket', 2),
    (5, 2, 'Wheel', 5),
    (6, 2, 'Seat', 5);

-- Crete user for webapp managed identity and grant rights
CREATE USER [$(webSiteName)] FROM EXTERNAL PROVIDER
GRANT SELECT, INSERT, UPDATE, DELETE ON Sales TO [$(webSiteName)];

-- Never allow updates on this column
DENY UPDATE ON Sales(AppUserId) TO [$(webSiteName)];

-- Create a new schema and predicate function, which will use the application user ID stored in SESSION_CONTEXT() to filter rows.
CREATE SCHEMA Security;
GO
  
CREATE FUNCTION Security.fn_securitypredicate(@AppUserId int)
    RETURNS TABLE
    WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_securitypredicate_result
    WHERE
        DATABASE_PRINCIPAL_ID() = DATABASE_PRINCIPAL_ID('AppUser')
        AND CAST(SESSION_CONTEXT(N'UserId') AS int) = @AppUserId;
GO

-- Create a security policy that adds this function as a filter predicate and a block predicate on Sales.
CREATE SECURITY POLICY Security.SalesFilter
    ADD FILTER PREDICATE Security.fn_securitypredicate(AppUserId)
        ON dbo.Sales,
    ADD BLOCK PREDICATE Security.fn_securitypredicate(AppUserId)
        ON dbo.Sales AFTER INSERT
    WITH (STATE = ON);
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
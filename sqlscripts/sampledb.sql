-- Step 1: Create the Customer Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    UPN NVARCHAR(255)  -- This column stores the User Principal Name of the owner of the row
);
GO

-- Step 2: Insert Sample Data
INSERT INTO Customers (CustomerID, CustomerName, UPN)
VALUES (1, 'Customer A', $(user1upn)),
       (2, 'Customer B', $(user1upn)),
       (3, 'Customer C', $(user2upn)),
       (4, 'Customer D', $(user2upn));
GO

-- Step 3: Create a Filter Function for RLS
CREATE FUNCTION dbo.fn_securitypredicate(@UserUPN AS NVARCHAR(255))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS Result
    WHERE @UserUPN = SESSION_CONTEXT(N'UserUPN'); -- Compare row UPN with session UPN
GO

-- Step 4: Create a Security Policy for Row-Level Security
CREATE SECURITY POLICY CustomerSecurityPolicy
    ADD FILTER PREDICATE dbo.fn_securitypredicate(UPN)
    ON dbo.Customers
    WITH (STATE = ON);
GO
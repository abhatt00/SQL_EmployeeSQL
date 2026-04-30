USE [EmployeeSQL];
GO

SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME
;


SELECT
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE
;


SELECT
    t.name      AS TABLE_NAME,
    i.name      AS INDEX_NAME,
    i.type_desc AS INDEX_TYPE
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE t.is_ms_shipped = 0
  AND i.name IS NOT NULL
ORDER BY t.name, i.name
;
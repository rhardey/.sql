set pagesize 1000

--
-- The following script will produce the PLAN_TABLE.  It is normally located here:
--
-- $ORACLE_HOME/rdbms/admin
--
-- @utlxplan_11g.sql
--

DELETE
FROM	PLAN_TABLE
WHERE	STATEMENT_ID = 'RyanHardey1'
/

EXPLAIN PLAN SET STATEMENT_ID = 'RyanHardey1'
FOR
@explain_plan_qry
/

select * from table(dbms_xplan.display)
/


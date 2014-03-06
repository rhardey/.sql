--
-- Script to show a table's foreign keys
--
--	Usage: Qtable_fk <p1> <p2>
--
-- Where p1 is the user name
-- and p2 is the table name.
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var tablename varchar2(30)
var cursorout refcursor

begin
   :userid := upper('&1');
   :tablename := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         SELECT c1.owner,
                c1.constraint_name,
                cols.column_name,
                c1.status,
                c1.last_change,
                c1.validated
         FROM   all_constraints c1,
                all_cons_columns cols
         WHERE  c1.table_name = :tablename
         AND    c1.constraint_type = 'P' -- primary key
         AND    cols.constraint_name = c1.constraint_name
         ORDER BY
            c1.constraint_name,
            cols.position;
   else
      open :cursorout for
         SELECT c1.constraint_name,
                cols.column_name,
                c1.status,
                c1.last_change,
                c1.validated
         FROM   all_constraints c1,
                all_cons_columns cols
         WHERE c1.owner = :userid
         AND c1.table_name = :tablename
         AND c1.constraint_type = 'P' -- primary key
         AND cols.constraint_name = c1.constraint_name
         AND cols.owner = :userid
         ORDER BY
            c1.constraint_name,
            cols.position;
   end if;
end;
/

column column_name format a30
print cursorout

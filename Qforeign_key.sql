--
-- Script to show a foreign key's properties
--
--	Usage: Qforeign_key <p1> <p2>
--
-- Where p1 is the user name
-- and p2 is the constraint name.
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var constraintname varchar2(30)
var cursorout refcursor

begin
   :userid := upper('&1');
   :constraintname := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         SELECT  c1.owner,
                 c1.r_constraint_name,
                 c1.table_name,
                 cols.column_name,
                 c1.delete_rule,
                 c1.status,
                 c1.validated
         FROM    all_constraints c1,
                 all_cons_columns cols
         WHERE   c1.constraint_name = :constraintname
                 AND
                 c1.constraint_type = 'R' -- foreign key
                 AND
                 cols.constraint_name = c1.constraint_name
         ORDER BY
                 c1.constraint_name,
                 cols.position;
   else
      open :cursorout for
         SELECT  c1.r_constraint_name,
                 c1.table_name,
                 cols.column_name,
                 c1.delete_rule,
                 c1.status,
                 c1.validated
         FROM    all_constraints c1,
                 all_cons_columns cols
         WHERE   c1.owner = :userid
                 AND
                 c1.constraint_name = :constraintname
                 AND
                 c1.constraint_type = 'R' -- foreign key
                 AND
                 cols.owner = :userid
                 AND
                 cols.constraint_name = c1.constraint_name
         ORDER BY
                 c1.constraint_name,
                 cols.position;
   end if;
end;
/

column column_name format a30
print cursorout

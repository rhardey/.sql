--
-- Script to show tables with names like input parameter
--
--	Usage: Qtable_name_like <p1> <p2>
--
-- Where PARM is the table name of interest, or part thereof.
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var tablename varchar2(30)
var cursorout refcursor

column owner format a10

begin
   :userid := upper('&1');
   :tablename := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         SELECT	c.owner,
            c.constraint_name,
            DECODE(	c.constraint_type,
               'C', 'CHECK constraint',
               'P', 'Primary Key',
               'R', 'Foreign Key',
               'U', 'Unique Const.',
               'V', 'With Check Option',
               'Other: '||c.constraint_type ) type,
            c.status,
            c.last_change,
            c.deferrable,
            c.deferred,
            c.validated
         FROM	all_constraints c
         WHERE	c.table_name = :tablename
         ORDER BY
            owner,
            type;

   else
      open :cursorout for
         SELECT	c.constraint_name,
            DECODE(	c.constraint_type,
               'C', 'CHECK constraint',
               'P', 'Primary Key',
               'R', 'Foreign Key',
               'U', 'Unique Const.',
               'V', 'With Check Option',
               'Other: '||c.constraint_type ) type,
            c.status,
            c.last_change,
            c.deferrable,
            c.deferred,
            c.validated
         FROM	all_constraints c
         WHERE	c.owner = :userid
            AND
            c.table_name = :tablename
         ORDER BY
            type;
   end if;
end;
/

print cursorout

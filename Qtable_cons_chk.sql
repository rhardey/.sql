--
-- Script to show table's check constraint properties
--
--	Usage: Qtable_cons_chk <p1> <p2>
--
-- where p1 is the username or 'ALL',
-- p2 is the table name
--

-- We don't want to see the substitutions displayed.
set pagesize 32
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
		c.search_condition,
		c.constraint_name,
		c.status,
		c.last_change,
		c.deferrable,
		c.deferred,
		c.validated
	 FROM	all_constraints c
         WHERE	c.table_name = :tablename
	 AND	c.constraint_type = 'C'
         ORDER BY
            owner,
            constraint_name;

   else
      open :cursorout for
         SELECT	c.constraint_name,
		c.search_condition,
		c.status,
		c.last_change,
		c.deferrable,
		c.deferred,
		c.validated
         FROM	all_constraints c
         WHERE	c.owner = :userid
	 AND	c.table_name = :tablename
	 AND	c.constraint_type = 'C'
         ORDER BY
            constraint_name;
   end if;
end;
/

print cursorout

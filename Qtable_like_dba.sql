--
-- Script to show tables with names like input parameter
--
--	Usage: Qtable_name_like <p1> <p2>
--
-- Where PARM is the table name of interest, or part thereof.
--

-- We don't want to see the substitutions displayed.
set verify off

column owner format a12

var userid varchar2(30)
var tablename varchar2(30)
var cursorout refcursor

begin
   :userid := upper('&1');
   :tablename := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select owner,
                table_name
         from   dba_tables
         where  table_name like '%'||:tablename||'%'
         order by owner, table_name;
   else
      open :cursorout for
         select table_name
         from   dba_tables
         where  owner = :userid
         and    table_name like '%'||:tablename||'%'
         order by table_name;
   end if;
end;
/

print cursorout

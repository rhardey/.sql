--
-- Script to query Oracle data dictionary table
--
--	Usage: Qdict <p1>
--
-- Where PARM is the string to query for in the TABLE_NAME field.
--

-- We don't want to see the substitutions displayed.
set verify off

var tablename varchar2(30)
var cursorout refcursor

column table_name format a30
column comments format a90

begin
   :tablename := upper('&1');

   open :cursorout for
      select table_name
            ,comments
      from   dictionary
      where  table_name like '%'||:tablename||'%'
      order by table_name;
end;
/

print cursorout

--
-- Script to show tables with names like input parameter
--
--   Usage: Qtable_name_like <p1> <p2>
--
-- Where PARM is the table name of interest, or part thereof.
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var colname varchar2(30)
var cursorout refcursor

set long 1000
column owner format a30
column table_name format a36
column column_name format a36
column data_default format a20
column type format a15

begin
   :userid := upper('&1');
   :colname := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select owner,
                table_name,
                column_name,
                data_type||decode(data_type, 'DATE', '', '('||to_char(data_length)||')') type,
                data_default
         from   all_tab_columns
         where  column_name like '%'||:colname||'%'
         and    owner not in ('SYS','SYSTEM')
         order by owner,table_name,column_name;
   else
      open :cursorout for
         select table_name,
                column_name,
                data_type||decode(data_type, 'DATE', '', '('||to_char(data_length)||')') type,
                data_default
         from   all_tab_columns
         where  owner = :userid
         and    column_name like '%'||:colname||'%'
         order by table_name,column_name;
   end if;
end;
/

print cursorout

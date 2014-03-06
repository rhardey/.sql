set feedback off
set pagesize 0
set serverout on size 1000000
set verify off
ACCEPT in_owner PROMPT "Enter the owner of the trigger source you would like to extract -->"
-- comment out the following line when all source for a schema is required
ACCEPT in_trigger PROMPT "Enter the name of the trigger source you would like to extract -->"
spool dump_trg.sql
begin dbms_output.put_line('set long 100000');end; -- should get all of the trigger body
/
begin dbms_output.put_line('set linesize 264');end; -- this should get most lines that would otherwise wrap
/
begin dbms_output.put_line('column trigger_body format a260');end; -- this should get most lines that would otherwise wrap
/
select 
       'spool '||lower(trigger_name)||'.trg'
       ||chr(10)||chr(13)
       ||'select trigger_body from all_triggers where owner = '''||owner
       ||''' and trigger_name = '''||trigger_name||''';'
       ||chr(10)||chr(13)
       ||'spool off'
       ||chr(13)||chr(10)
       ||'ho u:\bin\trim.bat '
       ||lower(trigger_name)||'.trg'
from dba_triggers
where owner = upper('&&in_owner')
and trigger_name = upper('&&in_trigger')
order by owner,trigger_name
/
spool off

@dump_trg.sql

set feedback on
set pagesize 40
set linesize 132
set verify on

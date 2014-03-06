set feedback off
set pagesize 0
set serverout on size 1000000
set verify off
set termout off

-- this should get most lines that would otherwise wrap
set linesize 512

spool dump_src.sql
select  -- For objects where case is not important in their names.
       'spool '||lower(object_name)||'.'||decode(object_type,'FUNCTION','fun','PROCEDURE','prc','PACKAGE','pks','PACKAGE BODY','pkb', 'TYPE', 'typ')
       ||chr(13)||chr(10)
       ||'select decode(line, 1, ''create or replace '', '''')||text from dba_source where owner = '''||owner
       ||''' and name = '''||object_name
       ||''' and type = '''||object_type
       ||''' order by line;'
       ||chr(13)||chr(10)
       ||'exec dbms_output.put_line(''/'')'
       ||chr(13)||chr(10)
       ||chr(13)||chr(10)
       ||'exec dbms_output.put_line(''show error'')'
       ||chr(13)||chr(10)
       ||'spool off'
       ||chr(13)||chr(10)
       ||'ho \bin\trim.bat '
       ||lower(object_name)||'.'||decode(object_type,'FUNCTION','fun','PROCEDURE','prc','PACKAGE','pks','PACKAGE BODY','pkb', 'TYPE', 'typ')
from dba_objects
where owner = upper('&1')
and object_name = nvl(upper('&2'),object_name)
and object_type in ('FUNCTION','PROCEDURE','PACKAGE','PACKAGE BODY', 'TYPE')
union
select -- For objects where case is important in their names.
       'spool '||lower(object_name)||'.'||decode(object_type,'FUNCTION','fun','PROCEDURE','prc','PACKAGE','pks','PACKAGE BODY','pkb', 'TYPE', 'typ')
       ||chr(13)||chr(10)
       ||'select decode(line, 1, ''create or replace '', '''')||text from dba_source where owner = '''||owner
       ||''' and name = '''||object_name
       ||''' and type = '''||object_type
       ||''' order by line;'
       ||chr(13)||chr(10)
       ||'exec dbms_output.put_line(''/'')'
       ||chr(13)||chr(10)
       ||chr(13)||chr(10)
       ||'exec dbms_output.put_line(''show error'')'
       ||chr(13)||chr(10)
       ||'spool off'
       ||chr(13)||chr(10)
       ||'ho \bin\trim.bat '
       ||object_name||'.'||decode(object_type,'FUNCTION','fun','PROCEDURE','prc','PACKAGE','pks','PACKAGE BODY','pkb', 'TYPE', 'typ')
from dba_objects
where owner = upper('&1')
and object_name = nvl('&2',object_name)
and object_type in ('FUNCTION','PROCEDURE','PACKAGE','PACKAGE BODY', 'TYPE')
/
spool off

@dump_src.sql

ho del dump_src.sql

set termout on
set feedback on
set pagesize 40
set linesize 160
set verify on

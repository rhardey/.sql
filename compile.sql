PROMPT
PROMPT ==============================================
PROMPT Script to compile all invalid database objects
PROMPT ==============================================
PROMPT
PROMPT This script is a stripped down version of Chet's compiler.
PROMPT To compile the required objects, cut and paste into sqlplus.
PROMPT
 
set heading off
set feedback off

select 
'PROMPT Compiling '||object_type||' '||object_name||chr(10)||
'alter '||
decode(object_type, 'PACKAGE BODY','PACKAGE', 'TYPE BODY','TYPE',object_type)||
' '||object_name||' compile '||
decode (object_type, 'PACKAGE BODY', 'body',NULL)||';'
from user_objects
where status = 'INVALID'
;

SELECT 'Number of Invalid Objects found:'||COUNT(*)||chr(10)||' '
from user_objects
where status = 'INVALID'
;
set feedback on

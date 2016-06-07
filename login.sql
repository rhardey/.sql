-- Plugins are soooooo slow!
--define _editor = "gvim --noplugin"
define _editor = "gvim"

--define userdesc='not connected'
--define dbinstdesc=''
--define mysessionid=''
--column userinst new_value userdesc
--column dbinst new_value dbinstdesc
--column mysessionid new_value mysessiondesc

set numwidth 9
set linesize 160
set long 1000
set pagesize 400
set serveroutput on size unlimited

set time on 

--set termout off
--select lower(user) userinst from dual;
-- START old method, pre-Oracle 9.2
--select substr(global_name, 0, decode(instr(global_name, '.'), 0, length(global_name), instr(global_name, '.') - 1)) dbinst from global_name;
-- END old method, pre-Oracle 9.2
-- START new method, post-Oracle 9.2
--select upper('&_CONNECT_IDENTIFIER') dbinst from dual;
-- END new method, post-Oracle 9.2
--set termout on
--SELECT trim(userenv('sessionid')) mysessionid from dual;

--set editfile "%TEMP%\ora.&&dbinstdesc..&&mysessiondesc..sql"
set editfile "%TEMP%\orainst.sql"
alter session set NLS_DATE_FORMAT = 'YYYYMMDD HH24:MI:SS';
--alter session set PLSQL_WARNINGS='ENABLE:ALL'; -- Turn on compiler warnings.
--set sqlprompt '&&userdesc@&&dbinstdesc> '
SET SQLPROMPT "_user'@'_connect_identifier> "

set feedback on

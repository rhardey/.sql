-- session.sql - displays all connected sessions
set echo off;
set termout on;
set linesize 132;
set pagesize 60;
set newpage 0;

select rpad(c.name||':',11)||rpad(' current logons='||
          (to_number(b.sessions_current)),20)||'cumulative logons='||
          rpad(substr(a.value,1,10),10)||'highwater mark='||
          b.sessions_highwater Information
from   v$sysstat a,
       v$license b,
       v$database c
where  a.name = 'logons cumulative';

define dbinstdesc=''
column dbinst new_value dbinstdesc
select substr(global_name, 0, decode(instr(global_name, '.'), 0, length(global_name), instr(global_name, '.') - 1)) dbinst from global_name;
ttitle "&&dbinstdesc Database|UNIX/Oracle Sessions";

set heading off;
select 'Sessions on database '||substr(name,1,8)
from   v$database;

set heading on;
select substr(a.spid,1,9) pid,
       substr(b.sid,1,5) sid,
       b.audsid,
       substr(b.serial#,1,5) ser#,
       substr(b.machine,1,32) box,
       substr(b.username,1,10) username,
--     b.server,
       substr(b.osuser,1,16) os_user,
       substr(b.program,1,30) program
from   v$session b,
       v$process a
where  b.paddr = a.addr
and    type='USER'
order by spid;

ttitle off;

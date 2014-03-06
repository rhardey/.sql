--
-- Script to show DBMS jobs with names like input parameter.
--
--	Usage: Qjob_like <p1> <p2>
--
-- Where PARM is the table name of interest, or part thereof.
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var executable varchar2(30)
var cursorout refcursor

column job format 999
column schema_user format a10
column interval format a35
column what format a80

begin
   :userid := upper('&1');
   :executable := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select schema_user,
                job,
                interval,
                what
         from   dba_jobs
         where  what like '%'||:executable||'%'
         order by schema_user, what;
   else
      open :cursorout for
         select job,
                interval,
                what
         from   dba_jobs
         where  schema_user = :userid
         and    what like '%'||:executable||'%'
         order by what;
   end if;
end;
/

print cursorout

--
-- Script to show which concurrent job calls the procedure of interest
--
--	Usage: Qwhich_conc_job <p1>
--
-- Where PARM is the object name, or part thereof, of interest.
--

-- We don't want to see the substitutions displayed.
set verify off

var partial_obj_name varchar2(30)
var cursorout refcursor

column conc_pid format 99999999
column conc_job format a30
column description format a30
column executable format a50

begin
   :partial_obj_name := upper('&1');

   open :cursorout for
      select cp.concurrent_program_id conc_pid
            ,cpl.user_concurrent_program_name conc_job
            ,nvl(cpl.description, el.description) description
            ,upper(e.execution_file_name) executable
      from applsys.fnd_concurrent_programs cp
          ,applsys.fnd_concurrent_programs_tl cpl
          ,applsys.fnd_executables e
          ,applsys.fnd_executables_tl el
      where upper(e.execution_file_name) like '%'||:partial_obj_name||'%'
      and cp.application_id = e.application_id
      and cp.executable_id = e.executable_id
      and e.executable_id = el.executable_id
      and cp.concurrent_program_id = cpl.concurrent_program_id
      and cpl.language = userenv('lang')
      and el.language = userenv('lang')
      order by conc_job, executable;
end;
/

print cursorout

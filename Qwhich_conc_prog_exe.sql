--
-- Script to show which procedure is called by the concurrent job of interest
--
--	Usage: Qconc_job_proc <p1>
--
-- Where PARM is the object name, or part thereof, of interest.
--

-- We don't want to see the substitutions displayed.
set verify off

column conc_job format a30
column description format a30
column executable format a35
column prog format a30

select cpl.user_concurrent_program_name conc_job
      ,nvl(cpl.description, el.description) description
      ,cp.concurrent_program_name prog
      ,cp.execution_method_code
      ,upper(e.execution_file_name) executable
from applsys.fnd_concurrent_programs cp
    ,applsys.fnd_concurrent_programs_tl cpl
    ,applsys.fnd_executables e
    ,applsys.fnd_executables_tl el
where (
         upper(cpl.user_concurrent_program_name) like '%'||upper('&1')||'%'
         or
         upper(nvl(cpl.description, el.description)) like '%'||upper('&1')||'%'
      )
and cp.executable_id = e.executable_id
and e.executable_id = el.executable_id
and cp.concurrent_program_id = cpl.concurrent_program_id
and cpl.language = 'US'
and el.language = 'US'
order by conc_job, executable
/

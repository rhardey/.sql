column conc_prog_name format a20
column executable format a45
column module format a20

SELECT request_id
      ,prog.CONCURRENT_PROGRAM_name conc_prog_name
      ,execname.execution_file_name|| execname.subroutine_name executable
      ,req.REQUESTED_START_DATE
      ,req.actual_start_date
      ,ses.sid
      ,ses.serial#
      ,ses.module
from applsys.fnd_concurrent_requests req
    ,v$session ses
    ,v$process proc
    ,applsys.fnd_concurrent_programs prog
    ,applsys.fnd_executables execname
where 1=1
and req.oracle_process_id=proc.spid(+)
and proc.addr = ses.paddr(+)
and req.concurrent_program_id = prog.concurrent_program_id
and req.program_application_id = prog.application_id
--- and prog.application_id = execname.application_id
and prog.executable_application_id = execname.application_id
and prog.executable_id=execname.executable_id
--and req.REQUESTED_START_DATE > trunc(sysdate,'mi')
--and req.actual_start_date is not null
AND req.PHASE_CODE='R'
AND req.STATUS_CODE='R'
--and prog.CONCURRENT_PROGRAM_name = 'BCOA_INTERFACE'
order by req.REQUESTED_START_DATE
/

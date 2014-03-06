--
-- Script to show which jobs are part of request set
--
--	Usage: Qwhich_jobs_for_request_set <p1>
--
-- Where <p1> is like the concurrent request name.
--

-- We don't want to see the substitutions displayed.
set verify off

var partial_obj_name varchar2(240)
var cursorout refcursor

column req_id heading 'REQ|ID' format 999999
column conc_pid heading 'CONC|PID' format 999999
column user_request_set_name format a45
column stage_name format a20
column conc_job format a45

begin
   :partial_obj_name := '&1';

   open :cursorout for
      select rst.request_set_id req_id
            ,rst.user_request_set_name
            ,s.stage_name
            ,cp.concurrent_program_id conc_pid
            ,cpl.user_concurrent_program_name conc_job
        from applsys.fnd_request_sets_tl rst
            ,applsys.fnd_request_set_programs rsp
            ,applsys.fnd_request_set_stages s
            ,applsys.fnd_concurrent_programs cp
            ,applsys.fnd_concurrent_programs_tl cpl
       where rst.request_set_id = rsp.request_set_id
         and rsp.concurrent_program_id = cp.concurrent_program_id
         and cp.concurrent_program_id = cpl.concurrent_program_id
         and rsp.request_set_stage_id = s.request_set_stage_id
         and rst.language = userenv('lang')
         and cpl.language = userenv('lang')
         and rst.user_request_set_name like '%'||:partial_obj_name||'%'
       order by rst.user_request_set_name
               ,s.display_sequence
               ,cpl.user_concurrent_program_name
         ;
end;
/

print cursorout

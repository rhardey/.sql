--
-- Script to show which request set a concurrent job is part of.
--
--	Usage: Qwhich_request_set_uses <p1>
--
-- Where <p1> is the concurrent program ID
--

-- We don't want to see the substitutions displayed.
set verify off

var conc_prog_id varchar2(30)
var cursorout refcursor

column req_id format 99999999
column user_request_set_name format a30
column description format a70

begin
   :conc_prog_id := &1;

   open :cursorout for
      select rst.request_set_id req_id
            ,rst.user_request_set_name
            ,rst.description
        from applsys.fnd_request_sets_tl rst
            ,applsys.fnd_request_set_programs rsp
       where rst.request_set_id = rsp.request_set_id
         and rsp.concurrent_program_id = :conc_prog_id
         and rst.language = userenv('lang');
end;
/

print cursorout

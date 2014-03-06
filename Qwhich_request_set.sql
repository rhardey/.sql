--
-- Script to find request sets that match the partial name entered.
--
--	Usage: Qwhich_request_set <p1>
--
-- Where <p1> is the partial name.
--

-- We don't want to see the substitutions displayed.
set verify off

var partial_obj_name varchar2(240)
var cursorout refcursor

column req_id format 99999999
column user_request_set_name format a30
column description format a70

begin
   :partial_obj_name := upper('&1');

   open :cursorout for
      select rst.request_set_id req_id
           ,rst.user_request_set_name
           ,rst.description
      from applsys.fnd_request_sets_tl rst
         ,applsys.fnd_request_set_programs rsp
      where rst.request_set_id = rsp.request_set_id
        and upper(rst.user_request_set_name) like '%'||:partial_obj_name||'%'
        and rst.language = userenv('lang');
end;
/

print cursorout

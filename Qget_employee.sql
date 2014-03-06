--
-- Script to retrieve Oracle HR employee data given a person ID.
--
--	Usage: Qget_employee <p1>
--
-- Where PARM is the person ID.
--

-- We don't want to see the substitutions displayed.
set verify off

var person_id varchar2(30)
var cursorout refcursor

column employee_number format a15
column full_name format a50
column business_group_id heading "Bus. Group ID"
column effective_start_date heading "Eff. Start Date"
column effective_end_date heading "Eff. End Date"

begin
   :person_id := &1;

   open :cursorout for
      SELECT person_id, employee_number, full_name, business_group_id, p.effective_start_date, p.effective_end_date
      FROM per_all_people_f p
      WHERE TRUNC(SYSDATE) BETWEEN p.effective_start_date AND p.effective_end_date
      AND p.person_id = :person_id;
end;
/

print cursorout

--
-- Script to show sequences with names like input parameter
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var sequencename varchar2(30)
var cursorout refcursor

column sequence_owner format a20
column sequence_name format a36
column last_number format '999999999999999999999999999999'
column min_value format '999999999999999999999999999999'
column max_value format '999999999999999999999999999999'

begin
   :userid := upper('&1');
   :sequencename := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select sequence_owner,
                sequence_name,
                last_number,
                min_value,
                max_value
         from   dba_sequences
         where  sequence_name like '%'||:sequencename||'%';
   else
      open :cursorout for
         select sequence_name,
                last_number,
                min_value,
                max_value
         from   dba_sequences
         where  sequence_owner = :userid
         and    sequence_name like '%'||:sequencename||'%';
   end if;
end;
/

print cursorout

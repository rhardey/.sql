--
-- Script to show last sql performed in a given session.
--
-- Usage: @Qsession_last_sql <SID>
--
-- where SID is from v$session.
--

-- We don't want to see the substitutions displayed.
set verify off
column sql_text format a80

select s.username, s.sid, t.sql_text
  from v$session s, v$sql t
 where s.sql_address =t.address
   and s.sql_hash_value =t.hash_value
   and s.sid = &1
/

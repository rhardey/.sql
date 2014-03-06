set verify off
column sequence_id heading 'Seq|ID'
column SUBROUTINE_NAME format a20
column program_name format a10 heading 'Prog|Name'
column MESSAGE_CODE format a14
column severity format 9 heading Sev
column message format a50
column CREATE_USER format a10

select SEQUENCE_ID
      ,PROGRAM_NAME
      ,SUBROUTINE_NAME
      ,MESSAGE_CODE
      ,SEVERITY
      ,MESSAGE
      --,CREATE_USER
from xxbcf_application_log
where creation_date > trunc(sysdate, 'HH')
and create_user = 'RHARDEY'
and sequence_id > &1
/
set verify on

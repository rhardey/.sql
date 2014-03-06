column USERNAME format a20
column MODULE format a40
column ACTION format a20

select username||'('||sid||','||serial#||')' username,
       module,
       action
from v$session
where module like '&1%'
union
select username||'('||sid||','||serial#||')' username,
       module,
       action
from v$session
where module like upper('&1%')
/

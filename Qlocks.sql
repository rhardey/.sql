SELECT b.sid,
       OSUSER, 
       b.username, 
       c.sid sid, 
       c.owner object_owner, 
       c.OBJECT, 
       b.lockwait, 
       a.sql_text,
       a.piece
FROM   v$sqltext a, 
       v$session b, 
       v$access c
WHERE  a.address=b.sql_address 
AND    c.OBJECT = 'SPC_REP_OFIN_INT' 
AND    a.hash_value = b.sql_hash_value 
AND    b.sid = c.sid 
AND    c.owner NOT IN ('SYS','SYSTEM')
order by a.piece

select a.addr,a.kaddr,a.sid,a.type,a.id1,a.id2,a.lmode,a.request,a.ctime,a.block,
       decode(a.type,'TM',(select object_name from all_objects where object_id = a.id1), '??') object
from v$lock a
where a.sid in (170)

SELECT *
from V$LOCKED_OBJECT x
where x.session_id = 189

select (select username from v$session where sid=a.sid) blocker,
        a.sid,
        ' is blocking ',
        (select username from v$session where sid=b.sid) blockee,
        b.sid
from v$lock a, v$lock b
where a.block = 1
and b.request > 0
and a.id1 = b.id1
and a.id2 = b.id2
and a.sid = 170

-- transaction = (rbs,slot,seq)
select username,
       v$lock.sid,
       trunc(id1/power(2,16)) rbs,
       bitand(id1,to_number('ffff','xxxx'))+0 slot,
       id2 seq,
       lmode,
       request
from v$lock, v$session
where v$lock.type = 'TX'
and v$lock.sid = v$session.sid
and v$session.sid = 170



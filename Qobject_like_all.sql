--
-- Script to show objects with names like input parameter
--

-- We don't want to see the substitutions displayed.
set verify off

column owner format a12
column object_name format a30
column object_type format a16

var userid varchar2(30)
var objectname varchar2(30)
var cursorout refcursor

begin
   :userid := upper('&1');
   :objectname := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select owner,
                object_name,
                object_type,
                last_ddl_time,
                status
         from   all_objects
         where  object_name like '%'||:objectname||'%'
         order by owner, object_type, object_name
         ;
   else
      open :cursorout for
         select object_name,
                object_type,
                last_ddl_time,
                status
         from   all_objects
         where  owner = :userid
         and    object_name like '%'||:objectname||'%'
         order by object_type, object_name
         ;
   end if;
end;
/

print cursorout

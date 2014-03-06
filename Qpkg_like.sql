--
-- Script to show objects with names like input parameter
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var objectname varchar2(30)
var cursorout refcursor

column owner format a16
column object_type format a20
column package format a35

begin
   :userid := upper('&1');
   :objectname := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select owner,
                object_type,
                object_name package,
                last_ddl_time,
                status
         from   dba_objects
         where  object_name like '%'||:objectname||'%'
         and    object_type IN ('PACKAGE', 'PACKAGE BODY')
         order by object_name, object_type;
   else
      open :cursorout for
         select object_type,
                object_name package,
                last_ddl_time,
                status
         from   dba_objects
         where  owner = :userid
         and    object_name like '%'||:objectname||'%'
         and    object_type IN ('PACKAGE', 'PACKAGE BODY')
         order by object_name, object_type;
   end if;
end;
/

print cursorout

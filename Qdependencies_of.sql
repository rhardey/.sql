--
-- Script to show dependencies on a given object.
--
--	Usage: Qdependencies_for <userid> <objname>
--
--

-- We don't want to see the substitutions displayed.
set verify off

column owner format a20
column name format a60
column type format a20

var userid varchar2(32)
var objname varchar2(64)
var cursorout refcursor


begin
   :userid := upper('&1');
   :objname := upper('&2');

   open :cursorout for
      select distinct
             owner
            ,name
            ,type
      from   dba_dependencies
      where  referenced_name = :objname
      and    referenced_owner = :userid
      order by owner,type,name;
end;
/

print cursorout

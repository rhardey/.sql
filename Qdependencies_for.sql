--
-- Script to show objects the input object depends on.
--
--	Usage: Qdependencies_for <userid> <objname>
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(32)
var objname varchar2(30)
var cursorout refcursor

begin
   :userid := upper('&1');
   :objname := upper('&2');

   open :cursorout for
      select referenced_owner ref_owner
            ,referenced_name ref_name
            ,referenced_type ref_type
      from   all_dependencies
      where  name = :objname
        and  owner = :userid
      order by ref_owner,ref_name;
end;
/

print cursorout

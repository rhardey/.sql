--
-- Script to show synonyms with names like input parameter
--
--	Usage: @Qsynonym_like <userid> <synonymname>
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var synonymname varchar2(30)
var cursorout refcursor

column owner format a20
column synonym_name format a30
column table_owner format a20
column table_name format a36
column db_link format a30

begin
   :userid := upper('&1');
   :synonymname := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select owner,
                synonym_name,
                table_owner,
                table_name,
                db_link
         from   all_synonyms
         where  synonym_name like '%'||:synonymname||'%'
         order by
                owner,
                synonym_name,
                table_owner,
                table_name;
   else
      open :cursorout for
         select synonym_name,
                table_owner,
                table_name,
                db_link
         from   all_synonyms
         where  owner = :userid
         and    synonym_name like '%'||:synonymname||'%'
         order by
                synonym_name,
                table_owner,
                table_name;
   end if;
end;
/

column owner format a15
column table_owner format a15
column db_link format a35
print cursorout

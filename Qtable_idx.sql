--
-- Script to show a table's indexes
--
--	Usage: Qtable_idx <p1> <p2>
--
-- Where p1 is the user name
-- and p2 is the table name.
--

-- We don't want to see the substitutions displayed.
set verify off

var userid varchar2(30)
var tablename varchar2(30)
var cursorout refcursor


begin
   :userid := upper('&1');
   :tablename := upper('&2');

   if :userid = 'ALL'
   then
      open :cursorout for
         select ai.table_owner,
                ai.index_name,
                aic.column_name,
                ai.index_type type,
                DECODE( ai.uniqueness, 'UNIQUE', 'Y', 'NONUNIQUE', 'N', 'O' ) uniqueness,
                ai.status
         from	 all_indexes ai,
                all_ind_columns aic
         where  aic.table_owner = ai.table_owner
                and
                ai.table_name = :tablename
                and
                aic.index_name = ai.index_name
         order by
                ai.table_owner,
                ai.index_name,
                aic.column_position;
   else
      open :cursorout for
         select ai.index_name,
                aic.column_name,
                ai.index_type type,
                DECODE( ai.uniqueness, 'UNIQUE', 'Y', 'NONUNIQUE', 'N', 'O' ) uniqueness,
                ai.status
         from	 all_indexes ai,
                all_ind_columns aic
         where  ai.table_owner = :userid
                and
                aic.table_owner = :userid
                and
                ai.table_name = :tablename
                and
                aic.index_name = ai.index_name
         order by
                ai.index_name,
                aic.column_position;
   end if;

end;
/

column column_name format a30
column index_type format a12

print cursorout

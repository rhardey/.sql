--
-- Query for the rowid of the blocked row or rows.
--
-- Usage: @Qblocked_row <blocked SID>

select do.object_name
      ,row_wait_obj#
      ,row_wait_file#
      ,row_wait_block#
      ,row_wait_row#
      ,dbms_rowid.rowid_create ( 1, row_wait_obj#, row_wait_file#, row_wait_block#, row_wait_row# ) row_id
  from v$session s
      ,dba_objects do
 where sid = &1
   and s.row_wait_obj# = do.object_id
/

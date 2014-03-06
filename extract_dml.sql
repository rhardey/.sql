set feedback off
set pagesize 0
set linesize 4000
set verify off
spool extract_recs.sql
declare
   ----
   -- This little piece of code will hopefully generate insert statements for a
   -- table, passed in as the first parameter.
   --
   -- TODO: Implement a WHERE clause, support more data types.
   ----

   v_owner all_tab_cols.owner%type := upper('&1');
   v_table_name all_tab_cols.table_name%type := upper('&2');
   v_where_clause varchar2(32767) := '&3';

   v_columns varchar2(32767) := '';
   v_values varchar2(32767) := '';

   v_insert_script varchar2(512) := 'ins_'||lower(v_table_name)||'.sql';


   cursor c_dml
   is
      select lower(c.column_name) column_name
            ,c.data_type
        from all_tab_cols c
       where c.owner = v_owner
         and c.table_name = v_table_name
         and c.virtual_column != 'YES'
       order by c.column_id;

   function quote(p_string varchar2)
   return varchar2
   is
   begin
      return ''''||replace(p_string, '''','''''')||'''';
   end;

   function write_number(p_col_name varchar2)
   return varchar2
   is
   begin
      return 'nvl(to_char('||p_col_name||'), ''null'')';
   end;

   function write_date(p_col_name varchar2)
   return varchar2
   is
   begin
      return 'decode('||p_col_name||', null, ''null'', '||quote('to_date(''')||'||'||
         'to_char('||p_col_name||', '||quote('yyyymmdd hh24:mi:ss')||')'
         ||'||'||quote(''', ')||quote('yyyymmdd hh24:mi:ss')||quote(')')||')';
   end;

   function write_string(p_col_name varchar2)
   return varchar2
   is
   begin
      return quote('''')||'||'||'replace('||p_col_name||', '||quote('''')||', '||quote('''''')||')||'||quote('''')||'';
   end;

begin

   dbms_output.put_line('spool '||v_insert_script);

   dbms_output.put_line('select ');
   dbms_output.put_line('''insert into '||lower(v_table_name));

   for rec in c_dml
   loop
      declare
         v_column_value varchar2(32767) := '';
      begin
         --dbms_output.put_line('Column name: '||rec.column_name||', type: '||rec.data_type);

         case rec.data_type
         when 'NUMBER' then v_column_value := write_number(rec.column_name);
         when 'DATE' then v_column_value := write_date(rec.column_name);
         when 'VARCHAR2' then v_column_value := write_string(rec.column_name);
         when 'CHAR' then v_column_value := write_string(rec.column_name);
         else raise_application_error(-20001, 'Unhandled data type: '||rec.data_type);
         end case;

         if c_dml%rowcount = 1
         then
            v_columns := '('||rec.column_name;
            v_values := v_column_value;
         else
            v_columns := v_columns||', '||rec.column_name;
            v_values := v_values||'||'', ''||'||chr(10)||v_column_value;
         end if;

      end;

   end loop;

   dbms_output.put_line(v_columns||')');
   dbms_output.put_line('values (''||'||v_values||'||'');''');
   dbms_output.put_line('from '||v_owner||'.'||v_table_name);
   if v_where_clause is not null
   then
      dbms_output.put_line(v_where_clause);
   end if;
   dbms_output.put_line('/');

   dbms_output.put_line('spool off');
   dbms_output.put_line('ho \bin\trim.bat '||v_insert_script);

end;
/
spool off
@extract_recs
@login

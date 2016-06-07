set feedback off
set pagesize 0
set linesize 4000
set verify off
set trimspool on
spool extract_recs.sql
declare
   ----
   -- This little piece of code will hopefully generate insert statements for a
   -- table.
   --
   -- Usage: @extract_dml <owner> <table name> <"quoted" where clause> <comma separated list of column names to exclude>
   ----

   -- Table type to hold each line.
   type line_type is table of varchar2(255) index by binary_integer;

   t_col_lines line_type;
   t_val_lines line_type;

   v_owner all_tab_cols.owner%type := upper('&1');
   v_table_name all_tab_cols.table_name%type := upper('&2');
   v_where_clause varchar2(32767) := trim('&3');
   v_exclude_columns varchar2(32767) := upper(translate(',&4,', ', ', ','));

   v_insert_script varchar2(512) := 'ins_'||lower(v_table_name)||'.sql';


   cursor c_dml
   is
      select lower(c.column_name) column_name
            ,c.data_type
        from all_tab_cols c
       where c.owner = v_owner
         and c.table_name = v_table_name
         and c.virtual_column != 'YES'
         and instr(v_exclude_columns, ','||c.column_name||',') = 0
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

   procedure output(t_lines line_type)
   is
   begin
      for i in 1..t_lines.last
      loop
         dbms_output.put_line(t_lines(i));
      end loop;
   end;

   procedure output_quoted(t_lines line_type)
   is
   begin
      for i in 1..t_lines.last
      loop
         dbms_output.put_line(quote(t_lines(i))||'||');
      end loop;
   end;

begin

   dbms_output.put_line('set trimspool on');
   dbms_output.put_line('spool '||v_insert_script);

   dbms_output.put_line('select ');
   dbms_output.put_line('''insert into '||lower(v_owner)||'.'||lower(v_table_name)||'''||');

   for rec in c_dml
   loop
      declare
         v_column_value varchar2(32767) := '';
      begin
         --dbms_output.put_line('Column name: '||rec.column_name||', type: '||rec.data_type);

         case rec.data_type
         when 'NUMBER' then v_column_value := write_number(rec.column_name);
         --when 'NUMBER' then null;
         when 'DATE' then v_column_value := write_date(rec.column_name);
         --when 'DATE' then null;
         when 'VARCHAR2' then v_column_value := write_string(rec.column_name);
         when 'CHAR' then v_column_value := write_string(rec.column_name);
         else raise_application_error(-20001, 'Unhandled data type: '||rec.data_type);
         end case;

         if v_column_value is not null
         then
            if t_col_lines.count = 0
            then
               t_col_lines(1) := rec.column_name;
               t_val_lines(1) := v_column_value;
            else
               t_col_lines(t_col_lines.last+1) := ', '||rec.column_name;
               t_val_lines(t_val_lines.last+1) := '||'', ''||'||chr(10)||v_column_value;
            end if;
         end if;

      end;

   end loop;

   -- Output column list
   dbms_output.put_line(quote('(')||'||');
   output_quoted(t_col_lines);
   dbms_output.put_line(''') values (''||');

   -- Output values list
   output(t_val_lines);
   dbms_output.put_line('||'');''');

   -- From clause
   dbms_output.put_line('from '||v_owner||'.'||v_table_name);

   -- Where clause
   if v_where_clause is not null
   then
      dbms_output.put_line('where ');
      dbms_output.put_line(v_where_clause);
   end if;
   dbms_output.put_line('/');

   dbms_output.put_line('spool off');

end;
/
spool off
@extract_recs
@login

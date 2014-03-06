REM Author: Steve Watts, Oct 2001
REM E-mail: Steve.Watts@reuters.com
REM -----------------------------------------------
REM  List all sessions with their SQL statements
REM -----------------------------------------------

SET    PAGES   0       - 
       NEWP    0       - 
       LINES   132     - 
       TERM    Off     - 
       HEAD    Off 

Col     X Form a132 

SPOOL  all_session.log 

TTitle  T Skip 2 

Select  ' ' x 
,       Lpad( 'SADDR', 24, ' ')||' : '||V$Session.SADDR x 
,       Lpad( '_', 43, '_') x 
,       Lpad( 'SID', 24, ' ')||' : '||V$Session.SID x 
,       Lpad( 'SERIAL#', 24, ' ')||' : '||V$Session.SERIAL# x 
,       Lpad( 'AUDSID', 24, ' ')||' : '||V$Session.AUDSID x 
,       Lpad( 'PADDR', 24, ' ')||' : '||V$Session.PADDR x 
,       Lpad( 'USER#', 24, ' ')||' : '||V$Session.USER# x 
,       Lpad( 'USERNAME', 24, ' ')||' : '||V$Session.USERNAME x 
,       Lpad( 'COMMAND', 24, ' ')||' : '||V$Session.COMMAND x 
,       Lpad( 'TADDR', 24, ' ')||' : '||V$Session.TADDR x 
,       Lpad( 'LOCKWAIT', 24, ' ')||' : '||V$Session.LOCKWAIT x 
,       Lpad( 'STATUS', 24, ' ')||' : '||V$Session.STATUS x 
,       Lpad( 'SERVER', 24, ' ')||' : '||V$Session.SERVER x 
,       Lpad( 'SCHEMA#', 24, ' ')||' : '||V$Session.SCHEMA# x 
,       Lpad( 'SCHEMANAME', 24, ' ')||' : '||V$Session.SCHEMANAME x 
,       Lpad( 'OSUSER', 24, ' ')||' : '||V$Session.OSUSER x 
,       Lpad( 'Client Process', 24, ' ')||' : '||V$Session.PROCESS x 
,       Lpad( 'Server Process', 24, ' ')||' : '||V$Process.Spid x 
,       Lpad( 'MACHINE', 24, ' ')||' : '||V$Session.MACHINE x 
,       Lpad( 'TERMINAL', 24, ' ')||' : '||V$Session.TERMINAL x 
,       Lpad( 'PROGRAM', 24, ' ')||' : '||V$Session.PROGRAM x 
,       Lpad( 'TYPE', 24, ' ')||' : '||V$Session.TYPE x 
,       Lpad( 'SQL_ADDRESS', 24, ' ')||' : '||V$Session.SQL_ADDRESS x 
,       Lpad( 'SQL_HASH_VALUE', 24, ' ')||' : '||V$Session.SQL_HASH_VALUE x 
,       Lpad( 'PREV_SQL_ADDR', 24, ' ')||' : '||V$Session.PREV_SQL_ADDR x 
,       Lpad( 'PREV_HASH_VALUE', 24, ' ')||' : '||V$Session.PREV_HASH_VALUE x 
,       Lpad( 'MODULE', 24, ' ')||' : '||V$Session.MODULE x 
,       Lpad( 'MODULE_HASH', 24, ' ')||' : '||V$Session.MODULE_HASH x 
,       Lpad( 'ACTION', 24, ' ')||' : '||V$Session.ACTION x 
,       Lpad( 'ACTION_HASH', 24, ' ')||' : '||V$Session.ACTION_HASH x 
,       Lpad( 'CLIENT_INFO', 24, ' ')||' : '||V$Session.CLIENT_INFO x 
,       Lpad( 'FIXED_TABLE_SEQUENCE', 24, ' ')||' : '||V$Session.FIXED_TABLE_SEQUENCE x 
,       Lpad( 'ROW_WAIT_OBJ#', 24, ' ')||' : '||V$Session.ROW_WAIT_OBJ# x 
,       Lpad( 'ROW_WAIT_FILE#', 24, ' ')||' : '||V$Session.ROW_WAIT_FILE# x 
,       Lpad( 'ROW_WAIT_BLOCK#', 24, ' ')||' : '||V$Session.ROW_WAIT_BLOCK# x 
,       Lpad( 'ROW_WAIT_ROW#', 24, ' ')||' : '||V$Session.ROW_WAIT_ROW# x 
,       Lpad( 'LOGON_TIME', 24, ' ')||' : '||To_Char( V$Session.LOGON_TIME, 'DD Mon YYYY hh24:mi:ss') x 
,       Lpad( 'LAST_CALL_ET', 24, ' ')||' : '||V$Session.LAST_CALL_ET x 
,       Lpad( 'SQL FIRST_LOAD_TIME', 24, ' ')||' : '||V$SqlArea.FIRST_LOAD_TIME x 
,       Lpad( 'SQL', 24, ' ')||' : '||V$SqlArea.Sql_Text x 
From 
        V$SqlArea 
,       V$Process 
,       V$Session 
Where 
        V$Process.Addr          = V$Session.Paddr(+) 
And     Nvl( V$Session.Sql_Address, 'FFFFFFFF') = V$SqlArea.Address(+) 
And     Nvl( V$Session.SERIAL#, 0)              > 1 
/ 


SPOOL OFF
TTITLE OFF

SET PAGES 24 LINESIZE 80 TRIMS ON ECHO OFF VERIFY ON FEEDBACK ON

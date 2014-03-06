PACKAGE BODY Sync_App_Util IS

    CURSOR cr_data_table ( v_table_name IN VARCHAR2 ) IS
        SELECT *
        FROM   data_tables
        WHERE  table_name = v_table_name;

    CURSOR cr_data_node ( v_local_node VARCHAR2,
                          v_node_code VARCHAR2 ) IS
        SELECT *
        FROM   data_nodes
        WHERE  ( v_local_node IS NULL OR local_node_ind = v_local_node)
          AND  ( v_node_code IS NULL  OR short_name = v_node_code );

    g_current_data_node_id      NUMBER := NULL;
    g_current_node_code         VARCHAR2(20) := NULL;

FUNCTION Current_Node_Id RETURN NUMBER IS
BEGIN
    RETURN g_current_data_node_id;
END;

FUNCTION Current_Node_Code RETURN VARCHAR2 IS
BEGIN
    RETURN g_current_node_Code;
END;

FUNCTION ID_For_Node_Code ( v_node_code IN VARCHAR2 ) RETURN NUMBER IS
    v_result  NUMBER;
BEGIN
    FOR rec IN cr_data_node ( NULL, v_node_code ) LOOP
        v_result := rec.id;
    END LOOP;
    RETURN v_result;
END;

FUNCTION Is_Table_Synced ( v_table_name IN VARCHAR2 ) RETURN BOOLEAN IS

    v_active_ind   CHAR;
    v_sync_type    VARCHAR2(20);
BEGIN

    FOR rec IN cr_data_table ( v_table_name ) LOOP
        v_active_ind := rec.active_iNd;
        v_sync_type  := rec.sync_type;
    END LOOP;

    RETURN  (( v_active_ind = 'Y' ) AND (v_sync_type IN ('M','B')));

END;

FUNCTION Column_Value ( v_input IN VARCHAR2 ) RETURN VARCHAR2 IS
    v_result     VARCHAR2(32000);
BEGIN
     IF ( v_input IS NULL ) THEN
         v_result := 'NULL';
     ELSE
         v_result :=  ''''||REPLACE ( v_input, '''','''''')||'''';
     END IF;

     RETURN v_result;
END;

FUNCTION Column_Value ( v_input IN NUMBER ) RETURN VARCHAR2 IS
    v_result     VARCHAR2(32000);
BEGIN
     IF ( v_input IS NULL ) THEN
         v_result := 'NULL';
     ELSE
         v_result :=  TO_CHAR(v_input);
     END IF;

     RETURN v_result;
END;

FUNCTION Column_Value ( v_input IN DATE ) RETURN VARCHAR2 IS
    v_result     VARCHAR2(32000);
BEGIN
     IF ( v_input IS NULL ) THEN
         v_result := 'NULL';
     ELSE
         v_result :=  'TO_DATE( '''||TO_CHAR(v_input,'DD-MON-YYYY HH24:MI:SS')||


                       ''',''DD-MON-YYYY HH24:MI:SS'')';
     END IF;

     RETURN v_result;
END;

FUNCTION Comparison_Op ( v_input IN VARCHAR2 ) RETURN VARCHAR2 IS
BEGIN

    IF ( v_input IS NULL ) THEN
        RETURN ' IS ';
    ELSE
        RETURN ' = ';
    END IF;

END;

FUNCTION get_transaction_id RETURN VARCHAR2 IS
    CURSOR cr_trans_id IS
        SELECT t.xidusn||'.'||t.xidslot||'.'||t.xidsqn trans_id
        FROM   v$session s, v$transaction t
        WHERE  s.audsid = userenv('SESSIONID')
          AND  s.taddr = t.addr;

    v_result     VARCHAR2(200);
BEGIN

    FOR rec IN cr_trans_id LOOP
        v_result := rec.trans_id;
    END LOOP;

    IF ( v_result IS NULL ) THEN
        RAISE NO_DATA_FOUND;
    END IF;

    RETURN v_result;
END;

PROCEDURE Insert_DML_Stmt ( v_table_name IN VARCHAR2,
                            v_operation IN VARCHAR2,
                            v_status IN VARCHAR2,
                            v_trn_id IN NUMBER,
                            v_dnd_id IN NUMBER,
                            v_statement IN VARCHAR2 ) IS

    v_dte_id   NUMBER;
    v_trans_id VARCHAR2(60);
BEGIN

    FOR rec IN cr_data_table ( v_table_name ) LOOP
        v_dte_id := rec.id;
    END LOOP;

    v_trans_id := get_transaction_id;

    INSERT INTO DML_STATEMENTS (
        id,
        status,
        operation,
        sql_statement, trans_identifier,
        dnd_id,
        dte_id,
        trn_id,
        create_date,
        create_user
    )
    VALUES (
        sync_trans_seq.NEXTVAL,
        v_status,
        v_operation,
        v_statement,
        v_trans_id,
        v_dnd_id,
        v_dte_id,
        v_trn_id,
        SYSDATE,
        USER
    );

END;

PROCEDURE Insert_DML_Stmt ( v_table_name IN VARCHAR2,
                            v_operation IN VARCHAR2,
                            v_statement IN VARCHAR2 ) IS

    v_dte_id   NUMBER;
    v_dnd_id   NUMBER;
    v_trans_id VARCHAR2(60);
BEGIN

    v_dnd_id  := g_current_data_node_id;

    Insert_DML_Stmt ( v_table_name,
                      v_operation,
                      'CAPTURED',
                      NULL,
                      v_dnd_id,
                      v_statement );
/*
    FOR rec IN cr_data_table ( v_table_name ) LOOP
        v_dte_id := rec.id;
    END LOOP;

    v_dnd_id  := g_current_data_node_id;

    v_trans_id := get_transaction_id;

    INSERT INTO DML_STATEMENTS (
        id, status,
        operation, sql_statement, trans_identifier,
        dnd_id, dte_id,
        create_date, create_user
    )
    VALUES ( sync_trans_seq.NEXTVAL, 'CAPTURED',
             v_operation, v_statement, v_trans_id,
             v_dnd_id, v_dte_id,
             SYSDATE, USER
    );
*/
END;


BEGIN

    FOR rec IN cr_data_node ('Y', NULL ) LOOP
        g_current_data_node_id := rec.id;
        g_current_node_code := rec.short_name;
    END LOOP;

END Sync_App_Util;
/

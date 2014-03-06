                                                                                                    
PROMPT                                                                                              
PROMPT Sync Control After Insert trigger on TEST_SYNC_TABLE                                         
PROMPT                                                                                              
                                                                                                    
CREATE OR REPLACE TRIGGER TEST_SYNC_TABLE_AI_SC                                                     
AFTER INSERT ON TEST_SYNC_TABLE                                                                     
FOR EACH ROW                                                                                        
DECLARE                                                                                             
    r_data_record    TEST_SYNC_TABLE%ROWTYPE;                                                       
BEGIN                                                                                               
    IF ( USER <> 'SYNC_CTL_TEST' ) THEN                                                             
                                                                                                    
        r_data_record.col_vc2 := :NEW.col_vc2;                                                      
                                                                                                    
        SYNC_CTL_TEST.Sync_SQL_Capture.ins_test_sync_table ( :new.ROWID, r_data_record );           
                                                                                                    
    END IF;                                                                                         
END;                                                                                                
/                                                                                                   
                                                                                                    
PROMPT                                                                                              
PROMPT Sync Control After Update trigger on TEST_SYNC_TABLE                                         
PROMPT                                                                                              
                                                                                                    
CREATE OR REPLACE TRIGGER TEST_SYNC_TABLE_AU_SC                                                     
AFTER UPDATE ON TEST_SYNC_TABLE                                                                     
FOR EACH ROW                                                                                        
DECLARE                                                                                             
    r_old_data_record    TEST_SYNC_TABLE%ROWTYPE;                                                   
    r_new_data_record    TEST_SYNC_TABLE%ROWTYPE;                                                   
    v_col_list       VARCHAR2(32000);                                                               
BEGIN                                                                                               
    IF ( USER <> 'SYNC_CTL_TEST' ) THEN                                                             
                                                                                                    
        r_old_data_record.col_vc2 := :OLD.col_vc2;                                                  
                                                                                                    
        IF ( UPDATING ('col_vc2') ) THEN                                                            
            v_col_list := v_col_list || '"col_vc2"';                                                
        END IF;                                                                                     
        r_new_data_record.col_vc2 := :new.col_vc2;                                                  
                                                                                                    
        SYNC_CTL_TEST.Sync_SQL_Capture.upd_test_sync_table ( :new.ROWID, v_col_list, r_old_data_reco
rd,                                                                                                 
                                   r_new_data_record );                                             
                                                                                                    
    END IF;                                                                                         
END;                                                                                                
/                                                                                                   
                                                                                                    
PROMPT                                                                                              
PROMPT Sync Control After Delete trigger on TEST_SYNC_TABLE                                         
PROMPT                                                                                              
                                                                                                    
CREATE OR REPLACE TRIGGER TEST_SYNC_TABLE_AD_SC                                                     
AFTER DELETE ON TEST_SYNC_TABLE                                                                     
FOR EACH ROW                                                                                        
DECLARE                                                                                             
    r_data_record    TEST_SYNC_TABLE%ROWTYPE;                                                       
BEGIN                                                                                               
    IF ( USER <> 'SYNC_CTL_TEST' ) THEN                                                             
                                                                                                    
        r_data_record.col_vc2 := :OLD.col_vc2;                                                      
                                                                                                    
        SYNC_CTL_TEST.Sync_SQL_Capture.del_test_sync_table ( r_data_record );                       
                                                                                                    
    END IF;                                                                                         
END;                                                                                                
/                                                                                                   

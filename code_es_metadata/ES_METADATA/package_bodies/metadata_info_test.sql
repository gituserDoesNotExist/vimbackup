CREATE OR REPLACE PACKAGE BODY ES_METADATA.METADATA_INFO_TEST AS
    
    result varchar2(10000) := '';
    
    PROCEDURE test_autocomplete_proc_package AS
    BEGIN
        result := metadata_info.extract_autocompletion_info('FOOD_DAO.');
        
        ut.expect(result).to_equal('CREATE_LEBENSMITTEL(T_LEBENSMITTEL) : NUMBER');
    end test_autocomplete_proc_package;

    procedure test_autocompl_proc_sys_pack is
    begin
        result := metadata_info.extract_autocompletion_info('DBMS_OUTPUT.');
        
        ut.expect(result).to_equal('DISABLE() : void;ENABLE(BUFFER_SIZE) : void;GET_LINE(LINE,STATUS) : void;GET_LINES(LINES,LINES,NUMLINES,NUMLINES) : VARCHAR2;GET_LINES(LINES,LINES,NUMLINES,NUMLINES) : VARCHAR2;NEW_LINE() : VARCHAR2;PUT(A) : VARCHAR2;PUT_LINE(A) : VARCHAR2');
    end;

    procedure test_autocomplete_obj_types is
    begin
        result := metadata_info.extract_autocompletion_info('BASE_ENTITY.');
        
        ut.expect(result).to_equal('CREATED_AT;ENTITY_ID;LAST_MODIFIED;BASE_ENTITY(P_ID) : void;EQUALS(OTHER_ENTITY) : void');
    end;
    
    procedure test_autocomplete_procedures is
    begin
        result := metadata_info.extract_autocompletion_info('TEST_RUNNER.');
        
        ut.expect(result).to_equal('TEST_RUNNER() : void');
    end;
    
    procedure test_autocomplete_tables is
    begin
        result := metadata_info.extract_autocompletion_info('VITAMINE.');
        
        ut.expect(result).to_equal('FOOD_ID;VITAMIN_K;VITAMIN_E;VITAMIN_D;VITAMIN_C;VITAMIN_B12;VITAMIN_B6;VITAMIN_B2;VITAMIN_B1;VITAMIN_A_BETACAROTIN;VITAMIN_A_RETINOL;LAST_MODIFIED;CREATED_AT;ID');
    end;


    procedure test_autocomplete_dbobj_name is
    begin
        result := metadata_info.extract_autocompletion_info('BASE_E');
        
        ut.expect(result).to_equal('BASE_ENTITY');
    end;



end metadata_info_test;
/

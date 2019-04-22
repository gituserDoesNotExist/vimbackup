CREATE OR REPLACE PACKAGE BODY ES_METADATA.METADATA_INFO_TEST AS
    
    result varchar2(10000) := '';
    
    PROCEDURE test_autocomplete_proc_package AS
    BEGIN
        result := metadata_info.extract_autocompletion_info('FOOD_DAO.');
        
        ut.expect(result).to_equal('FOOD_DAO.CREATE_LEBENSMITTEL(T_LEBENSMITTEL) : NUMBER');
    end test_autocomplete_proc_package;

    procedure test_autocompl_proc_sys_pack is
    begin
        result := metadata_info.extract_autocompletion_info('DBMS_OUTPUT.');
        
        ut.expect(result).to_equal('DBMS_OUTPUT.DISABLE() : void;DBMS_OUTPUT.ENABLE(BUFFER_SIZE) : void;DBMS_OUTPUT.GET_LINE(LINE,STATUS) : void;DBMS_OUTPUT.GET_LINES(LINES,LINES,NUMLINES,NUMLINES) : VARCHAR2;DBMS_OUTPUT.GET_LINES(LINES,LINES,NUMLINES,NUMLINES) : VARCHAR2;DBMS_OUTPUT.NEW_LINE() : VARCHAR2;DBMS_OUTPUT.PUT(A) : VARCHAR2;DBMS_OUTPUT.PUT_LINE(A) : VARCHAR2');
    end;

    procedure test_autocomplete_obj_types is
    begin
        result := metadata_info.extract_autocompletion_info('BASE_ENTITY.');
        
        ut.expect(result).to_equal('BASE_ENTITY.CREATED_AT;BASE_ENTITY.ENTITY_ID;BASE_ENTITY.LAST_MODIFIED;BASE_ENTITY.BASE_ENTITY(P_ID) : OBJECT;BASE_ENTITY.EQUALS(OTHER_ENTITY) : PL/SQL BOOLEAN');
    end;
    
    procedure autocomplete_objtypes_case_ins is
    begin
        result := metadata_info.extract_autocompletion_info('base');
        
        ut.expect(result).to_equal('BASE_ENTITY');
    end;
    
    procedure test_autocomplete_procedures is
    begin
        result := metadata_info.extract_autocompletion_info('TEST_RUNNER.');
        
        ut.expect(result).to_equal('TEST_RUNNER() : void');
    end;
    
    procedure test_autocomplete_tables is
    begin
        result := metadata_info.extract_autocompletion_info('VITAMINE.');
        
        ut.expect(result).to_equal('VITAMINE.FOOD_ID;VITAMINE.VITAMIN_K;VITAMINE.VITAMIN_E;VITAMINE.VITAMIN_D;VITAMINE.VITAMIN_C;VITAMINE.VITAMIN_B12;VITAMINE.VITAMIN_B6;VITAMINE.VITAMIN_B2;VITAMINE.VITAMIN_B1;VITAMINE.VITAMIN_A_BETACAROTIN;VITAMINE.VITAMIN_A_RETINOL;VITAMINE.LAST_MODIFIED;VITAMINE.CREATED_AT;VITAMINE.ID');
    end;


    procedure test_autocomplete_dbobj_name is
    begin
        result := metadata_info.extract_autocompletion_info('BASE_E');
        
        ut.expect(result).to_equal('BASE_ENTITY');
    end;



end metadata_info_test;
/

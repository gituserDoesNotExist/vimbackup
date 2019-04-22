CREATE OR REPLACE PACKAGE BODY ES_METADATA.METADATA_INFO_TEST AS
    
    result varchar2(10000) := '';
    
    PROCEDURE test_autocomplete_proc_package AS
    BEGIN
        result := metadata_info.extract_autocompletion_info('TEST_PACKAGE.');
        
        ut.expect(result).to_equal('TEST_PACKAGE.CREATE_LEBENSMITTEL(T_LEBENSMITTEL=>VARCHAR2) : NUMBER');
    end test_autocomplete_proc_package;

    procedure test_autocompl_proc_sys_pack is
    begin
        result := metadata_info.extract_autocompletion_info('DBMS_OUTPUT.');
        
        ut.expect(result).to_equal('DBMS_OUTPUT.DISABLE() : ;DBMS_OUTPUT.ENABLE(BUFFER_SIZE=>NUMBER) : ;DBMS_OUTPUT.GET_LINE(LINE=>VARCHAR2,STATUS=>NUMBER) : ;DBMS_OUTPUT.GET_LINES(LINES=>PL/SQL TABLE,LINES=>VARRAY,NUMLINES=>NUMBER,NUMLINES=>NUMBER) : ;DBMS_OUTPUT.GET_LINES(LINES=>PL/SQL TABLE,LINES=>VARRAY,NUMLINES=>NUMBER,NUMLINES=>NUMBER) : ;DBMS_OUTPUT.NEW_LINE() : ;DBMS_OUTPUT.PUT(A=>VARCHAR2) : ;DBMS_OUTPUT.PUT_LINE(A=>VARCHAR2) : ');
    end;

    procedure autocomplete_obj_type_notexist is
    begin
        result := metadata_info.extract_autocompletion_info('BASE_ENTITY_NOT_EXISTING.');
        
        ut.expect(result).to_equal('');
    end;
    
    procedure autocomplete_obj_type is
    begin
        result := metadata_info.extract_autocompletion_info('TEST_TYPE.');
        
        ut.expect(result).to_equal('TEST_TYPE.CREATED_AT;TEST_TYPE.ENTITY_ID;TEST_TYPE.LAST_MODIFIED;TEST_TYPE.FUNCTION_SOME_ARGS(OTHER_ENTITY=>OBJECT,SOMEARG=>PL/SQL BOOLEAN,OTHERARG=>VARCHAR2,NEXTARG=>NUMBER) : PL/SQL BOOLEAN;TEST_TYPE.FUNC_NO_ARGS() : VARCHAR2;TEST_TYPE.PROC_NO_ARGS() : ');
    end;
    
    
    procedure autocomplete_objtypes_case_ins is
    begin
        result := metadata_info.extract_autocompletion_info('base');
        
        ut.expect(result).to_equal('BASE_ENTITY');
    end;
    
    procedure test_autocomplete_procedures is
    begin
        result := metadata_info.extract_autocompletion_info('TEST_PROCEDURE');
        
        ut.expect(result).to_equal('TEST_PROCEDURE(PARAM1=>VARCHAR2) : ');
    end;
    
    procedure test_autocomplete_functions  is
    begin
        result := metadata_info.extract_autocompletion_info('ES_METADATA.TEST_FUNCTION');
        
        ut.expect(result).to_equal('TEST_FUNCTION(PARAM1=>VARCHAR2,PARAM2=>VARCHAR2) : VARCHAR2');
    end;

    procedure autocomplete_function_noschema is
    begin
        result := metadata_info.extract_autocompletion_info('TEST_FUNCTION');
        
        ut.expect(result).to_equal('TEST_FUNCTION(N_ID=>NUMBER) : NUMBER;TEST_FUNCTION(PARAM1=>VARCHAR2,PARAM2=>VARCHAR2) : NUMBER');
    end;

    
    procedure test_autocomplete_tables is
    begin
        result := metadata_info.extract_autocompletion_info('VITAMINE.');
        
        ut.expect(result).to_equal('VITAMINE.FOOD_ID;VITAMINE.VITAMIN_K;VITAMINE.VITAMIN_E;VITAMINE.VITAMIN_D;VITAMINE.VITAMIN_C;VITAMINE.VITAMIN_B12;VITAMINE.VITAMIN_B6;VITAMINE.VITAMIN_B2;VITAMINE.VITAMIN_B1;VITAMINE.VITAMIN_A_BETACAROTIN;VITAMINE.VITAMIN_A_RETINOL;VITAMINE.LAST_MODIFIED;VITAMINE.CREATED_AT;VITAMINE.ID');
    end;

    procedure autocompletetables_onlymatchng is
    begin
        result := metadata_info.extract_autocompletion_info('VITAMINE.VITAMIN_A');
        
        ut.expect(result).to_equal('VITAMINE.VITAMIN_A_BETACAROTIN;VITAMINE.VITAMIN_A_RETINOL');
    end;


    procedure autocomplete_test_caching is
    begin
            result := metadata_info.extract_autocompletion_info('MINERAL');
            ut.expect(result).to_equal('MINERALSTOFF;MINERALSTOFFE');    

            result := metadata_info.extract_autocompletion_info('BASE');
            ut.expect(result).to_equal('BASE_ENTITY');    
    end;

    procedure autocomplete_only_schema as
    begin
        result := metadata_info.extract_autocompletion_info('ES_METADATA.');
        
        ut.expect(result).to_equal('METADATA_INFO;METADATA_INFO_TEST;METAINFO_TEST_LONG_RUN;TEST_FUNCTION;TEST_PACKAGE;TEST_PROCEDURE;TEST_RUNNER;TEST_TYPE;USER_INPUT_ANALYZER;USER_INPUT_ANALYZER_TEST');
    end;
    

    procedure test_autocomplete_dbobj_name is
    begin
        result := metadata_info.extract_autocompletion_info('VIT');
        
        ut.expect(result).to_equal('VITAMIN;VITAMINE');
    end;
    

    


end metadata_info_test;
/

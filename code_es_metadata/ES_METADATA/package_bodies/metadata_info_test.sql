CREATE OR REPLACE PACKAGE BODY ES_METADATA.METADATA_INFO_TEST AS
    
    PROCEDURE test_autocomplete_proc_package AS
    BEGIN
        metadata_info.extract_autocompletion_info('FOOD_DAO.');
    end test_autocomplete_proc_package;

    procedure test_autocompl_proc_sys_pack is
    begin
        metadata_info.extract_autocompletion_info('DBMS_OUTPUT.');
    end;


    procedure test_autocomplete_obj_types is
    begin
        metadata_info.extract_autocompletion_info('BASE_ENTITY.');
    end;
    
    procedure test_autocomplete_procedures is
    begin
        metadata_info.extract_autocompletion_info('TEST_RUNNER.');
    end;
    
    procedure test_autocomplete_tables is
    begin
        metadata_info.extract_autocompletion_info('VITAMINE.');
    end;


    procedure test_autocomplete_dbobj_name is
    begin
        metadata_info.extract_autocompletion_info('BASE_E');
    end;



end metadata_info_test;
/

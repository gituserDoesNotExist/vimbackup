CREATE OR REPLACE PACKAGE BODY ES_METADATA.USER_INPUT_ANALYZER_TEST AS

    extracted_dbobj VARCHAR2(30);
    extracted_schema VARCHAR2(30);
    extracted_attr VARCHAR2(30);
    contains_attr boolean;
--################################ test extract dbobj start##########################################
     --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName.Attr_ReturnsDbObjName)
    procedure extr_all_sch_dbobj_attr  AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject.attr';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('dietplan');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('someobject');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('attr');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END;
    --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName._ReturnsDbObjName)
    procedure extr_all_sch_dbobj_dot  AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject.';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('dietplan');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('someobject');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END;
    --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName_ReturnsDbObjName)
    procedure extr_all_sch_dbobj  AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('dietplan');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('someobject');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END;
    --%test(testExtractDbObjName_UserInputIs_Schema._ReturnsDbObjName)
    procedure extr_all_schema_dot  AS
        v_user_input VARCHAR2(30) := 'dietplan.';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('dietplan');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END;
    --%test(testExtractDbObjName_UserInputIs_Schema_ReturnsDbObjName)
    procedure extr_all_schema  AS
        v_user_input VARCHAR2(30) := 'dietplan';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('dietplan');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END;
    --%test(testExtractDbObjName_UserInputIs_DbObj.attr_ReturnsDbObjName)
    procedure extr_all_dbobj_attr  AS
        v_user_input VARCHAR2(30) := 'someobject.attr';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('someobject');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('attr');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END;
    --%test(testExtractDbObjName_UserInputIs_DbObj._ReturnsDbObjName)
    procedure extr_all_dbobj_dot  AS
        v_user_input VARCHAR2(30) := 'someobject.';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('someobject');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END;
    --%test(testExtractDbObjName_UserInputIs_DbObj_ReturnsDbObjName)
    procedure extr_all_dbobj  AS
        v_user_input VARCHAR2(30) := 'someobject';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('someobject');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END;
    --%test(testExtractDbObjName_UserInputIsEmpty_ReturnsDbObjName)
    procedure extr_all_no_input  AS
        v_user_input VARCHAR2(30) := '';
    BEGIN
        extracted_schema := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(extracted_schema).to_equal('');

        extracted_dbobj := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(extracted_dbobj).to_equal('');
        
        extracted_attr := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(extracted_attr).to_equal('');
        
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END;
--################################ test extract dbobj end##########################################

  



END user_input_analyzer_test;
/

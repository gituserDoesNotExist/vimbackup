CREATE OR REPLACE PACKAGE BODY ES_METADATA.USER_INPUT_ANALYZER_TEST AS

    result VARCHAR2(30);

    PROCEDURE extract_schema_name AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject';
    BEGIN
        result := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(result).to_equal('dietplan');
    END extract_schema_name;

    PROCEDURE extract_schema_name_no_schema AS
        v_user_input VARCHAR2(30) := 'someobject';
    BEGIN
        result := user_input_analyzer.extract_schema_name(v_user_input);
        ut3.ut.expect(result).to_be_null();
    END extract_schema_name_no_schema;

    PROCEDURE extract_dbobj_name AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject';
    BEGIN
        result := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(result).to_equal('someobject');
    END extract_dbobj_name;

    PROCEDURE extract_dbobj_name_no_schema IS
        v_user_input VARCHAR2(30) := 'someobject';
    BEGIN
        result := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(result).to_equal('someobject');
    END extract_dbobj_name_no_schema;

    procedure extract_dbobj_name_attr 
    IS
        v_user_input VARCHAR2(30) := 'someobject.attr';
    BEGIN
        result := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(result).to_equal('someobject');
    END extract_dbobj_name_attr;


    PROCEDURE extract_attr_or_method AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject.someattr';
    BEGIN
        result := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(result).to_equal('someattr');
    END extract_attr_or_method;

    procedure extract_attrormethod_no_schema as
        v_user_input VARCHAR2(30) := 'someobject.someattr';
    BEGIN
        result := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(result).to_equal('someattr');
    END extract_attrormethod_no_schema;

    procedure extract_attrormethod_only_dot as
        v_user_input VARCHAR2(30) := 'someobject.';
    BEGIN
        result := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(result).to_equal('');
    END extract_attrormethod_only_dot ;

    procedure extract_attr_only_dbobj_name as
        v_user_input VARCHAR2(30) := 'someobject';
    BEGIN
        result := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(result).to_equal('');
    END extract_attr_only_dbobj_name;


    PROCEDURE contains_attrormethodpart AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END contains_attrormethodpart;

    PROCEDURE contains_attrpart_only_dot AS
        v_user_input VARCHAR2(30) := 'dietplan.';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END contains_attrpart_only_dot;



END user_input_analyzer_test;
/

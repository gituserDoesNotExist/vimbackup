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
    
    procedure extract_dbobj_name_all AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject.attr';
    BEGIN
        result := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(result).to_equal('someobject');
    END;
    
    procedure extract_dbobj_name_onlyschema  AS
        v_user_input VARCHAR2(30) := 'dietplan.';
    BEGIN
        result := user_input_analyzer.extract_dbobj_name(v_user_input);
        ut3.ut.expect(result).to_equal('');
    END extract_dbobj_name_onlyschema;

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

    procedure extract_attr_only_schemadbobj is
        v_user_input VARCHAR2(30) := 'sys.someobjectpart';
    BEGIN
        result := user_input_analyzer.extract_attr_or_method(v_user_input);
        ut3.ut.expect(result).to_equal('');
    END extract_attr_only_schemadbobj;


    PROCEDURE contains_attrpart_schmea_db AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END contains_attrpart_schmea_db;

    PROCEDURE contains_attrpart_db_attr AS
        v_user_input VARCHAR2(30) := 'someobject.attr';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END contains_attrpart_db_attr;

    PROCEDURE contains_attrpart_schma_db_att AS
        v_user_input VARCHAR2(30) := 'dietplan.someobject.attr';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END contains_attrpart_schma_db_att;


    PROCEDURE contains_attrpart_only_dot AS
        v_user_input VARCHAR2(30) := 'dbobj.';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_true();
    END contains_attrpart_only_dot;


    procedure contns_attrormethod_onlyschema as
        v_user_input VARCHAR2(30) := 'dietplan.';
        contains_attr boolean;
    BEGIN
        contains_attr := user_input_analyzer.contains_attr_or_method_part(v_user_input);
        ut3.ut.expect(contains_attr).to_be_false();
    END contns_attrormethod_onlyschema;




END user_input_analyzer_test;
/

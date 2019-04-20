CREATE OR REPLACE PACKAGE BODY ES_METADATA.USER_INPUT_PARSER_TEST AS

  result varchar2(30);

  procedure test_extract_schema_name AS
  v_user_input varchar2(30) := 'dietplan.someobject';
  BEGIN
    result := user_input_parser.extract_schema_name(v_user_input);
    UT3.ut.expect(result).to_equal('dietplan');
    UT3.ut.expect(v_user_input).to_equal('dietplan.someobject');
  END test_extract_schema_name;

  procedure test_extract_dbobj_name AS
      v_user_input varchar2(30) := 'dietplan.someobject';
  BEGIN
    result := user_input_parser.extract_dbobj_name(v_user_input);
    
    UT3.ut.expect(result).to_equal('someobject');
  END test_extract_dbobj_name;

  procedure test_extract_attr_or_method AS
      v_user_input varchar2(30) := 'dietplan.someobject.someattr';
  BEGIN
    result := user_input_parser.extract_dbobj_name(v_user_input);
    
    UT3.ut.expect(result).to_equal('someattr');
  END test_extract_attr_or_method;

  procedure test_contains_attrormethodpart AS
      v_user_input varchar2(30) := 'dietplan.someobject';
  BEGIN
    result := user_input_parser.extract_dbobj_name(v_user_input);
    
    UT3.ut.expect(result).to_be_true();
  END test_contains_attrormethodpart;

END USER_INPUT_PARSER_TEST;
/

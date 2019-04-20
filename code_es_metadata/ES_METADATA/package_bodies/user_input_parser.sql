CREATE OR REPLACE PACKAGE BODY ES_METADATA.USER_INPUT_PARSER AS

  function extract_schema_name(v_user_input varchar2) return varchar2 AS
  BEGIN
    return regexp_replace(v_user_input,'([a-zA-Z]*)\.[a-zA-Z]*\','\1');
  END extract_schema_name;

  function extract_dbobj_name(v_user_input varchar2) return varchar2 AS
  BEGIN
    -- TODO: Implementation required for function USER_INPUT_PARSER.extract_dbobj_name
    RETURN NULL;
  END extract_dbobj_name;

  function extract_attr_or_method(v_user_input varchar2) return varchar2 AS
  BEGIN
    -- TODO: Implementation required for function USER_INPUT_PARSER.extract_attr_or_method
    RETURN NULL;
  END extract_attr_or_method;

  function contains_attr_or_method_part(v_user_input varchar2) return boolean AS
  BEGIN
    -- TODO: Implementation required for function USER_INPUT_PARSER.contains_attr_or_method_part
    RETURN NULL;
  END contains_attr_or_method_part;

END USER_INPUT_PARSER;
/

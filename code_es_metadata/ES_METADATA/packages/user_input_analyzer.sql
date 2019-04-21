CREATE OR REPLACE PACKAGE ES_METADATA.USER_INPUT_ANALYZER AS 

    function extract_schema_name(v_user_input varchar2) return varchar2;
    
    function extract_dbobj_name(v_user_input varchar2) return varchar2;
    
    function extract_attr_or_method(v_user_input varchar2) return varchar2;
    
    function contains_attr_or_method_part(v_user_input varchar2) return boolean;

END USER_INPUT_ANALYZER;
/

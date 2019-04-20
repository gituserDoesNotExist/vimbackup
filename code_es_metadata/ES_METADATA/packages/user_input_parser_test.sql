CREATE OR REPLACE PACKAGE ES_METADATA.USER_INPUT_PARSER_TEST AS 

    --%suite(test for user input parser)
    
    --%test(extractSchemaName_UserInputContainsSchemaName_ReturnsSchemaName)
    procedure test_extract_schema_name;
    
    --%test(extractSchemaName_UserInputDoesNotContainSchemaName_ReturnsEmptyString)
    procedure test_extract_schema_name_2;
    
    
    --%test
    procedure test_extract_dbobj_name;
    
    --%test
    procedure test_extract_attr_or_method;
    
    --%test
    procedure test_contains_attrormethodpart;


END USER_INPUT_PARSER_TEST;
/

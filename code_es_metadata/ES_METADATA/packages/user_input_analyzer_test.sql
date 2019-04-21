CREATE OR REPLACE PACKAGE ES_METADATA.USER_INPUT_ANALYZER_TEST AS 

    --%suite(test for user input parser)
    
    --%test(extractSchemaName_UserInputContainsSchemaName_ReturnsSchemaName)
    procedure extract_schema_name;
    
    --%test(extractSchemaName_UserInputDoesNotContainSchemaName_ReturnsEmptyString)
    procedure extract_schema_name_no_schema;
       
    --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName_ReturnsDbObjName)
    procedure extract_dbobj_name;

    --%test(testExtractDbObjName_UserInputIs_DbObjName_ReturnsDbObjName)
    procedure extract_dbobj_name_no_schema;

    --%test(testExtractDbObjName_UserInputIs_DbObjName.Attr_ReturnsDbObjName)
    procedure extract_dbobj_name_attr;
    
    --%test(testExtractAttrOrMethod_UserInputIs_Schema.DbObjName.Attr_ReturnsAttr)
    procedure extract_attr_or_method;
    
    --%test(testExtractAttrOrMethod_UserInputIs_DbObjName.Attr_ReturnsAttr)
    procedure extract_attrormethod_no_schema;

    --%test(testExtractAttrOrMethod_UserInputIs_DbObjName._ReturnsAttr)
    procedure extract_attrormethod_only_dot;
 
    --%test(testExtractAttrOrMethod_UserInputIs_DbObjName_DoesNotContainAttr_ReturnsNull)
    procedure extract_attr_only_dbobj_name;
    
    
    --%test(testContainsAttrOrMethodPart_UserInputIs_DbObjName.Attr_ReturnsTrue)
    procedure contains_attrormethodpart;

    --%test(testContainsAttrOrMethodPart_UserInputIs_DbObjName._ReturnsTrue)
    procedure contains_attrpart_only_dot;


END USER_INPUT_ANALYZER_TEST;
/

CREATE OR REPLACE PACKAGE ES_METADATA.USER_INPUT_ANALYZER_TEST AS 

    --%suite(test for user input parser)

    --usecases: schema.dbobj.attr or schema.dbobj. or schema.dbobj or schema. or schema
    --          dbobj.attr or dbobj. or dbobj
    --          no input
    --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName.Attr_ReturnsDbObjName)
    procedure extr_all_sch_dbobj_attr;
    --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName._ReturnsDbObjName)
    procedure extr_all_sch_dbobj_dot;
    --%test(testExtractDbObjName_UserInputIs_Schema.DbObjName_ReturnsDbObjName)
    procedure extr_all_sch_dbobj;
    --%test(testExtractDbObjName_UserInputIs_Schema._ReturnsDbObjName)
    procedure extr_all_schema_dot;
    --%test(testExtractDbObjName_UserInputIs_Schema_ReturnsDbObjName)
    procedure extr_all_schema;
    --%test(testExtractDbObjName_UserInputIs_DbObj.attr_ReturnsDbObjName)
    procedure extr_all_dbobj_attr;
    --%test(testExtractDbObjName_UserInputIs_DbObj._ReturnsDbObjName)
    procedure extr_all_dbobj_dot;
    --%test(testExtractDbObjName_UserInputIs_DbObj_ReturnsDbObjName)
    procedure extr_all_dbobj;
    --%test(testExtractDbObjName_UserInputIsEmpty_ReturnsDbObjName)
    procedure extr_all_no_input;


END USER_INPUT_ANALYZER_TEST;
/

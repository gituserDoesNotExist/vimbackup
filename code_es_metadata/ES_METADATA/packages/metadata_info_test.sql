CREATE OR REPLACE PACKAGE ES_METADATA.METADATA_INFO_TEST AS 

    --%suite(test whether metadata is retrieved correctly)
    
    --%test(test autocomplete procedures of package)
    procedure test_autocomplete_proc_package;
    
    --%test(test autocomplete procedures of package from other user)
    procedure test_autocompl_proc_sys_pack;
 
    --%test(test autocomplete object types - dbobj contains procedure with no arguments and function with no arguments)
    procedure autocomplete_obj_type;
  
    --%test(test autocomplete object types - dbobj does not exist)
    procedure autocomplete_obj_type_notexist;
 
    --%test(test autocomplete object types. is not case sensitive)
    procedure autocomplete_objtypes_case_ins;
 
     --%test(test autocomplete procedures)
    procedure test_autocomplete_procedures;

    --%test(test autocomplete functions)
    procedure test_autocomplete_functions;

    --%test(test autocomplete functions - no schema name given - returns function names from all schemas)
    procedure autocomplete_function_noschema;

   --%test(test autocomplete tables)
    procedure test_autocomplete_tables;

    --%test(test autocomplete tables - only matching)
    procedure autocompletetables_onlymatchng;

    --%test(test autocomplete - caching)
    procedure autocomplete_test_caching;


    --%test(test autocomplete - only schema name)
    procedure autocomplete_only_schema;


   --%test(test: returns matching dbobject-names for given string containing part of dbobject)
    procedure test_autocomplete_dbobj_name;


 

END METADATA_INFO_TEST;
/

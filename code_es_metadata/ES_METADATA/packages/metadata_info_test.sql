CREATE OR REPLACE PACKAGE ES_METADATA.METADATA_INFO_TEST AS 

    --%suite(test whether metadata is retrieved correctly)
    
    --%test(test autocomplete procedures of package)
    procedure test_autocomplete_proc_package;
    
    --%test(test autocomplete procedures of package from other user)
    procedure test_autocompl_proc_sys_pack;
 
    --%test(test autocomplete object types)
    procedure test_autocomplete_obj_types;
 
    --%test(test autocomplete object types. is not case sensitive)
    procedure autocomplete_objtypes_case_ins;
 
 
    --%test(test autocomplete procedures)
    procedure test_autocomplete_procedures;

   --%test(test autocomplete tables of other users)
    procedure test_autocomplete_tables;



   --%test(test: returns matching dbobject-names for given string containing part of dbobject)
    procedure test_autocomplete_dbobj_name;

 
 

END METADATA_INFO_TEST;
/

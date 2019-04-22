CREATE OR REPLACE PACKAGE ES_METADATA.METAINFO_TEST_LONG_RUN AS 
    
    --%suite(long running tests)
  
    --%test(test: returns matching dbobject-names for given string containing part of dbobject)
    procedure autocomplete_dbobj_name_sysobj;

 

END METAINFO_TEST_LONG_RUN;
/

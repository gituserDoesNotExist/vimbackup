CREATE OR REPLACE PROCEDURE ES_METADATA.TEST_RUNNER AS 
BEGIN
    ut.run('METADATA_INFO_TEST.test_find_dependent_objects');
    
    --ut.run('METAINFO_TEST_LONG_RUN');
    
    ut.run('USER_INPUT_ANALYZER_TEST');
END TEST_RUNNER;
/

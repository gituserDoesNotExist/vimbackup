CREATE OR REPLACE TYPE ES_METADATA.TEST_TYPE AS OBJECT (
    entity_id       INTEGER,
    created_at      TIMESTAMP,
    last_modified   TIMESTAMP,
    MEMBER FUNCTION function_some_args (
           other_entity test_type,
           somearg boolean,
           otherarg varchar2,
           nextarg integer
       ) RETURN BOOLEAN,
    member procedure proc_no_args,
    member function func_no_args return varchar2
) NOT FINAL;
/

CREATE OR REPLACE PACKAGE ES_METADATA.METADATA_INFO AS 

    function EXTRACT_AUTOCOMPLETION_INFO(p_user_input in varchar2) return varchar2;

    function find_dependent_objects(p_dbobj_to_name in varchar2) return varchar2;

END metadata_info;
/

CREATE OR REPLACE PACKAGE ES_METADATA.METADATA_INFO AS 

    function EXTRACT_AUTOCOMPLETION_INFO(v_user_input in varchar2) return varchar2;


END metadata_info;
/

CREATE OR REPLACE PACKAGE BODY ES_METADATA.METADATA_INFO AS

    TYPE string_list IS TABLE OF VARCHAR2(700);
    cached_dbobj_name varchar2(30);
    cached_obj_type_names string_list := string_list();


    function get_objtypes_matching_name(p_dbobj_name varchar2) return string_list
    is
        obj_types string_list;
    begin
        if p_dbobj_name = cached_dbobj_name then
            return cached_obj_type_names;
        end if;
        SELECT object_type BULK COLLECT INTO obj_types FROM sys.all_objects WHERE upper(object_name) = upper(p_dbobj_name);
        return obj_types;
    end;

    function is_dbobj_a_function_or_proc(p_dbobj_name varchar2) return boolean
    is
        obj_types string_list;
        obj_type varchar2(30);
    begin
        obj_types := get_objtypes_matching_name(p_dbobj_name);
        if obj_types is empty then
            return false;
        end if;
        obj_type :=obj_types(1);
        return obj_type like 'FUNCTION%' or obj_type like 'PROC%';
    end;

    function is_dbobj_a_table(p_dbobj_name varchar2) return boolean
    is
        tbl_name varchar2(30);
    begin 
        SELECT table_name INTO tbl_name FROM all_tables WHERE upper(table_name) = upper(p_dbobj_name);
        return tbl_name IS NOT NULL;
    EXCEPTION
        WHEN no_data_found THEN
            return false;
    end;

    procedure prepend_dbobject_name(t_all_metadata in out string_list, dbobj_name varchar2)
    is
        tmp varchar2(500);
    begin
        for idx in 1..t_all_metadata.count loop
            tmp := concat(dbobj_name,'.');
            tmp := concat(tmp,t_all_metadata(idx));
            t_all_metadata(idx) := tmp;
        end loop;
    end;    
    
    FUNCTION should_search_for_dbobj_name (p_user_input VARCHAR2) RETURN BOOLEAN 
    IS
        search_for_dbobj_name boolean;
        dbobj_name varchar2(30);
    BEGIN
        dbobj_name := user_input_analyzer.extract_dbobj_name(p_user_input);
        search_for_dbobj_name := not is_dbobj_a_function_or_proc(dbobj_name);
        search_for_dbobj_name := search_for_dbobj_name and not user_input_analyzer.contains_attr_or_method_part(p_user_input);
        return search_for_dbobj_name;
    END should_search_for_dbobj_name;

   
    function build_pack_or_objtype_procname(p_dbobj_name varchar2,p_current_proc_name varchar2) return varchar2
    is
        procname_plus_arguments varchar2(1000);
    begin
        with original_result(myposition,argumentname,datatype) as (
            SELECT position,argument_name,data_type FROM all_arguments 
            WHERE package_name = upper(p_dbobj_name) AND object_name = upper(p_current_proc_name)
        )
        select 
        p_current_proc_name || '(' 
        || listagg(case when argumentname is not null and argumentname<> 'SELF' then argumentname || '=>' || datatype end,',') within group (order by myposition)
        || ') : ' 
        || (select datatype from original_result where myposition = 0) as concatenatedshit into procname_plus_arguments
        from original_result group by 1;
        
        return procname_plus_arguments;
        
    exception when no_data_found THEN
        dbms_output.put_line('no arguments found for ' || p_current_proc_name);
        return p_current_proc_name || '() : ';
    end;

    function build_func_or_proc_with_args(p_dbobj_name varchar2,p_schema_name varchar2) return varchar2
    is
        proc_name_plus_args varchar2(1000);
    begin
         with original_result(myposition,argumentname,datatype,myowner) as (
            select position,argument_name,data_type,owner from all_arguments where object_name = upper(p_dbobj_name) 
            and owner like case when p_schema_name is null then '%' else p_schema_name end
        )
        select listagg(res_per_owner,';') within group (order by 1) into proc_name_plus_args 
        from (
            select p_dbobj_name || '(' 
            || listagg(case when argumentname is not null then argumentname || '=>' || datatype end,',') within group (order by myposition) || ') : ' 
            || (select datatype from original_result where argumentname is null and rownum = 1) as res_per_owner
            from original_result group by myowner);
        return proc_name_plus_args;
    end;
    

    FUNCTION search_for_dbobj_name (p_schema_name varchar2,p_part_dbobj_name VARCHAR2) RETURN string_list 
    IS
        all_metadata string_list := string_list();
    BEGIN
        WITH all_matching_dbobj_names AS (
            SELECT type_name AS dbobjname FROM all_types WHERE owner like case when p_schema_name is null then '%' else p_schema_name end and type_name LIKE concat(p_part_dbobj_name,'%')
            UNION
            SELECT object_name AS dbobjname FROM all_procedures where owner like case when p_schema_name is null then '%' else p_schema_name end and object_name LIKE concat(p_part_dbobj_name,'%')
            UNION
            SELECT table_name as dbobjname FROM all_tables WHERE owner like case when p_schema_name is null then '%' else p_schema_name end and table_name like concat(upper(p_part_dbobj_name),'%')
        )
        SELECT dbobjname BULK COLLECT INTO all_metadata FROM all_matching_dbobj_names;
    
        RETURN all_metadata;
    END search_for_dbobj_name;

    function search_for_func_or_proc(p_dbobj_name varchar2,p_schema_name varchar2) return string_list
    is
        obj_types string_list;
        all_metadata string_list := string_list();
        proc_name_plus_args varchar2(1000);
    begin
        obj_types := get_objtypes_matching_name(p_dbobj_name);
        IF obj_types(1) LIKE 'FUNCTION' OR obj_types(1) like 'PROCEDURE' THEN
            proc_name_plus_args := build_func_or_proc_with_args(p_dbobj_name,p_schema_name);
            all_metadata.extend;
            all_metadata(all_metadata.last) := proc_name_plus_args;
        end if;
        return all_metadata;
    end;

    function search_for_table_cols(p_dbobj_name varchar2) return string_list
    is
        tbl_columns string_list;
    begin
        SELECT p_dbobj_name || '.' || column_name BULK COLLECT INTO tbl_columns FROM all_tab_cols WHERE upper(table_name) = upper(p_dbobj_name);
        return tbl_columns;
    end;

    FUNCTION search_packobjtype_attrmethods (p_dbobj_name VARCHAR2) RETURN string_list IS
        procedures string_list := string_list();
        obj_types string_list := string_list();
        all_metadata string_list := string_list();
        tmp_proc_plus_arguments VARCHAR2(1000) := '';
        current_proc_name VARCHAR2(30);
    BEGIN
        SELECT object_type BULK COLLECT INTO obj_types FROM sys.all_objects WHERE upper(object_name) = upper(p_dbobj_name);
        
        if obj_types is empty then
            return string_list();
        end if;
        
        IF obj_types(1) LIKE 'TYPE%' THEN
            SELECT attr_name BULK COLLECT INTO all_metadata FROM all_type_attrs WHERE upper(type_name) = upper(p_dbobj_name);
            SELECT procedure_name BULK COLLECT INTO procedures FROM all_procedures WHERE upper(object_type) = 'TYPE' AND object_name = upper(p_dbobj_name);

            FOR proc_idx IN 1..procedures.count LOOP
                current_proc_name := procedures(proc_idx);        
                all_metadata.extend;
                all_metadata(all_metadata.last) := build_pack_or_objtype_procname(p_dbobj_name,current_proc_name);
            END LOOP;

        ELSIF obj_types(1) LIKE 'PACKAGE%' THEN
            SELECT procedure_name BULK COLLECT INTO procedures FROM all_procedures 
            WHERE object_type = 'PACKAGE' AND object_name = upper(p_dbobj_name) AND procedure_name IS NOT NULL;

            FOR proc_idx IN 1..procedures.count LOOP
                current_proc_name := procedures(proc_idx);
                all_metadata.extend;
                all_metadata(all_metadata.last) := build_pack_or_objtype_procname(p_dbobj_name,current_proc_name);
            END LOOP;
        
        END IF;
        prepend_dbobject_name(all_metadata,p_dbobj_name);
        RETURN all_metadata;
    END search_packobjtype_attrmethods;

    function list_to_semicolon_sep_str(t_all_metadata string_list) return varchar2 
    is
        resultstring VARCHAR2(32000) := '';    
        length_res_string integer;
    begin
         FOR idx IN 1..t_all_metadata.count LOOP
            --you do not need that many results...
            length_res_string := length(resultstring);
            if length_res_string > 5000 then
                return resultstring;
            end if;
            IF idx != 1 THEN
                resultstring := concat(resultstring, ';');
            END IF;
            resultstring := concat(resultstring, t_all_metadata(idx));
        END LOOP;
        RETURN resultstring;
    end list_to_semicolon_sep_str;

    function filter_matching_items(p_all_metadata string_list, p_attr_or_method varchar2) return string_list
    is
        current_item varchar2(2000);
        matching_items string_list := string_list();
    begin
        for idx in 1..p_all_metadata.count loop
            current_item := p_all_metadata(idx) ;
            if current_item like '%' || p_attr_or_method || '%' then
                matching_items.extend;
                matching_items(matching_items.last) := current_item;
            end if;
        end loop;
        return matching_items;
    end;


    function extract_autocompletion_info(p_user_input IN VARCHAR2) return varchar2
    IS
        dbobj_name varchar2(30);
        attr_or_method varchar2(30);
        schema_name varchar2(30);
        all_metadata string_list;
    BEGIN
        schema_name := upper(user_input_analyzer.extract_schema_name(p_user_input));
        dbobj_name := upper(user_input_analyzer.extract_dbobj_name(p_user_input));
        IF should_search_for_dbobj_name(p_user_input) THEN
            all_metadata := search_for_dbobj_name(schema_name,dbobj_name);
        ELSIF is_dbobj_a_function_or_proc(dbobj_name) then
            all_metadata := search_for_func_or_proc(dbobj_name,schema_name);
        elsif is_dbobj_a_table(dbobj_name) then
            all_metadata := search_for_table_cols(dbobj_name);
        else
            all_metadata := search_packobjtype_attrmethods(dbobj_name);
       END IF;   
       attr_or_method := user_input_analyzer.extract_attr_or_method(p_user_input);
       return list_to_semicolon_sep_str(filter_matching_items(all_metadata,attr_or_method));    
    END extract_autocompletion_info;
    
    
    --###################################################################################################
    function find_dependent_objects(p_dbobj_to_name in varchar2) return varchar2 
    is
        type_of_object_to_rename varchar2(30);
        dependent_objects string_list := string_list();
        dependent_objects_string varchar2(2000);
    begin
        SELECT object_type bulk collect into dependent_objects from SYS.all_procedures where object_name = upper(p_dbobj_to_name) and rownum = 1;
     
        select name bulk collect into dependent_objects from all_dependencies where referenced_name = upper(p_dbobj_to_name) and name <> upper(p_dbobj_to_name);    

        --remove duplicates
        dependent_objects := dependent_objects MULTISET UNION DISTINCT dependent_objects;
    
        for idx in 1..dependent_objects.count loop
            dependent_objects_string := concat(dependent_objects_string,dependent_objects(idx));
            if idx != dependent_objects.count then
                dependent_objects_string := concat(dependent_objects_string,';');
            end if;
        end loop;
        return dependent_objects_string;
    end;
    
    

END metadata_info;
/

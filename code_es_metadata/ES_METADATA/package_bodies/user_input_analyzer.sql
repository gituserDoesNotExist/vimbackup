CREATE OR REPLACE PACKAGE BODY ES_METADATA.USER_INPUT_ANALYZER AS

    TYPE string_list IS VARRAY(3) OF VARCHAR2(30);

    function is_schema_in_db(schema_name varchar2) return boolean
    is
        v_extracted_schema varchar2(30);
    begin
        SELECT username INTO v_extracted_schema FROM sys.all_users WHERE upper(username) = upper(schema_name);
        return v_extracted_schema is not null;
    EXCEPTION when no_data_found then
        --if nothing is found, the given schema_name is not a schema!
        --dbms_output.put_line('there is no schema named ' || schema_name);
        return false;
    end is_schema_in_db;

    function is_user_input_ended_by_dot(p_user_input varchar2) return boolean
    is
    begin
        return REGEXP_LIKE(p_user_input,'.*\.$','i');
    end;
    

    function remove_last_char_from_str(v_str varchar2) return varchar2
    is
        n_str_length integer := length(v_str);
    begin
        return substr(v_str,1,n_str_length-1);
    end remove_last_char_from_str;

    FUNCTION convert_user_input_to_list (v_user_input VARCHAR2) RETURN string_list 
    IS
        v_parts_user_input dbms_utility.lname_array;
        v_tablength BINARY_INTEGER;
        v_user_input_with_commas VARCHAR2(30) := replace(v_user_input, '.', ',');
        v_extracted_schema VARCHAR2(30);
        t_result string_list := string_list();
    BEGIN
        if is_user_input_ended_by_dot(v_user_input) then
            v_user_input_with_commas := remove_last_char_from_str(v_user_input_with_commas);
        end if;
        sys.dbms_utility.comma_to_table(list => v_user_input_with_commas, tablen => v_tablength, tab => v_parts_user_input);

        FOR idx IN 1..v_tablength LOOP 
            t_result.extend;
            t_result(idx) := v_parts_user_input(idx);
        END LOOP;

        return t_result;
    END convert_user_input_to_list;

    FUNCTION extract_schema_name (v_user_input VARCHAR2) RETURN VARCHAR2
    is
        v_extracted_schema VARCHAR2(30);
        v_parts_user_input string_list;
        v_schema_name_from_user VARCHAR2(30);
    BEGIN
        v_parts_user_input := convert_user_input_to_list(v_user_input);
        --if schema is given, then it is the first part of the string!
        v_schema_name_from_user  := v_parts_user_input(1);
        IF is_schema_in_db(v_schema_name_from_user) then 
            RETURN v_schema_name_from_user;
        END IF;
        RETURN NULL;
    END extract_schema_name;

    FUNCTION extract_dbobj_name (v_user_input VARCHAR2) RETURN VARCHAR2
    AS
        v_parts_user_input string_list;    
        v_current_part varchar2(30);
    BEGIN
        v_parts_user_input := convert_user_input_to_list(v_user_input);
        --if the first part of user input is a schema, then the second part is the dbobj_name, otherwise the first part is the dbobj_name
        if is_schema_in_db(v_parts_user_input(1)) then
            return v_parts_user_input(2);
        end if;
        return v_parts_user_input(1);
    END extract_dbobj_name;

    FUNCTION extract_attr_or_method (v_user_input VARCHAR2) RETURN VARCHAR2
    AS
        v_parts_user_input string_list;    
        v_current_part varchar2(30);    
    BEGIN
        if is_user_input_ended_by_dot(v_user_input) then
            return '';
        end if;
        v_parts_user_input := convert_user_input_to_list(v_user_input);
        --if first part is schema, then third part is attr, otherwise second part, unless user specifies only dbobj name, then there is not second part    
        if is_schema_in_db(v_parts_user_input(1)) and v_parts_user_input.last = 3 then
            return v_parts_user_input(3);
        end if;
        if v_parts_user_input.last > 1 then
            return v_parts_user_input(2);
        end if;
        return null;
    END extract_attr_or_method;

    FUNCTION contains_attr_or_method_part (v_user_input VARCHAR2) RETURN BOOLEAN AS
        attr_or_method varchar2(30);
    BEGIN
        return is_user_input_ended_by_dot(v_user_input) or extract_attr_or_method(v_user_input) is not null;
    END contains_attr_or_method_part;

END user_input_analyzer;
/

set serveroutput on;

declare
    object_to_rename varchar2(30) := '&1';

    type string_list is table of varchar2(30);
    type_of_object_to_rename varchar2(30);
    dependent_objects string_list := string_list();
    dependent_objects_string varchar2(2000);
begin
    SELECT object_type into type_of_object_to_rename from SYS.user_procedures where object_name = upper(object_to_rename) and procedure_name is not null;
    -- we want to know who is using FOOD_DAO     
    select name bulk collect into dependent_objects from user_dependencies where referenced_name = upper(OBJECT_TO_RENAME) and name <> upper(object_to_rename);    

    --remove duplicates
    dependent_objects := dependent_objects MULTISET UNION DISTINCT dependent_objects;
    for idx in 1..dependent_objects.count loop
        dependent_objects_string := concat(dependent_objects_string,dependent_objects(idx));
        if idx != dependent_objects.count then
            dependent_objects_string := concat(dependent_objects_string,';');
        end if;
    end loop;
    dbms_output.put_line(dependent_objects_string);

end;

SET SERVEROUTPUT ON;

DECLARE
    TYPE string_list IS
        TABLE OF VARCHAR2(1000);
    errormessages                 string_list := string_list();
    concatenated_error_messages   varchar2(4000) := '';
BEGIN
    SELECT replace(name || '(line: ' || line || '): ' || text,chr(10),' ') BULK COLLECT INTO errormessages FROM dba_errors WHERE owner = 'DIETPLAN';

    FOR idx IN 1..errormessages.count LOOP
        concatenated_error_messages := concat(concatenated_error_messages, errormessages(idx));
        IF idx != errormessages.count THEN
            concatenated_error_messages := concat(concatenated_error_messages, '_NEWMESSAGE_');
        END IF;
    END LOOP;
    dbms_output.put_line('Errors during compilation:' || concatenated_error_messages);

END;






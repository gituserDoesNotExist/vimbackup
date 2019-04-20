declare
	dbobjectname varchar2(30) := '&1';
begin
	es_metadata.metadata_info.extract_autocompletion_info(dbobjectname);
end;

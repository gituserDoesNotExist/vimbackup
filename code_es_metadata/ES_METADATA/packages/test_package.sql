CREATE OR REPLACE PACKAGE ES_METADATA.TEST_PACKAGE AS

    -- Gibt die ID des angelegten Lebensmittels zurueck
    FUNCTION create_lebensmittel (
        t_lebensmittel IN OUT varchar2
    ) RETURN integer;

END TEST_PACKAGE;
/

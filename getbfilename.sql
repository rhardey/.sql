SET SERVEROUTPUT ON

DECLARE
   Lob_loc         BFILE;
   DirAlias_name   VARCHAR2(30);
   File_name       VARCHAR2(40);
BEGIN
   SELECT doc INTO Lob_loc FROM rpt_doc WHERE doc_ID = &docid;
   DBMS_LOB.FILEGETNAME(Lob_loc, DirAlias_name, File_name);
   DBMS_OUTPUT.PUT_LINE(File_name);
END;
/

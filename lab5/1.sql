--1
SELECT tablespace_name FROM dba_tablespaces;

--2
alter session set "_ORACLE_SCRIPT"=true;

CREATE TABLESPACE VFS_QDATA
DATAFILE 'VFS.dbf'
SIZE 10M REUSE
AUTOEXTEND ON
NEXT 5M
MAXSIZE 20M;

ALTER TABLESPACE VFS_QDATA OFFLINE;

ALTER TABLESPACE VFS_QDATA ONLINE;

CREATE USER VFS
DEFAULT TABLESPACE VFS_QDATA
IDENTIFIED BY 123;

select * from dba_users;

GRANT CONNECT TO VFS;
GRANT CREATE TABLE TO VFS;
GRANT DROP ANY TABLE TO VFS;
GRANT FLASHBACK ANY TABLE TO VFS;

ALTER USER VFS QUOTA 2M ON VFS_QDATA;
--зайти под vfs
CREATE TABLE VFS_T1(
  id INTEGER,
  name VARCHAR2(20)
)

INSERT INTO VFS_T1 VALUES (1, 'sdjnv');
INSERT INTO VFS_T1 VALUES (2, 'dfmbd');
INSERT INTO VFS_T1 VALUES (3, 'mvnsdkv');

--3
SELECT segment_name, segment_type
FROM dba_segments
WHERE tablespace_name = 'VFS_QDATA';

--4
SELECT segment_name, segment_type, tablespace_name
FROM dba_segments
WHERE segment_name = 'VFS_T1';

--5
SELECT segment_name, segment_type, tablespace_name
FROM dba_segments
WHERE segment_name <> 'VFS_T1';

--6
DROP TABLE VFS_T1;

--7
SELECT segment_name, segment_type
FROM dba_segments
WHERE tablespace_name = 'VFS_QDATA';

SELECT segment_name, segment_type, tablespace_name
FROM dba_segments
WHERE segment_name = 'VFS_T1';

SELECT * FROM USER_RECYCLEBIN;

--8
FLASHBACK TABLE VFS_T1 TO BEFORE DROP;
SELECT * FROM VFS_T1;
--9
DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 10000 LOOP
        INSERT INTO VFS_T1 (id, name)
        VALUES (v_counter, 'value');
        v_counter := v_counter + 1;
    END LOOP;
    COMMIT;
END;

--10
SELECT COUNT(*) AS num_extents,
       SUM(blocks) AS total_blocks,
       SUM(blocks * (SELECT value FROM v$parameter WHERE name = 'db_block_size')) / 1024 AS total_bytes
FROM dba_extents
WHERE segment_name = 'VFS_T1';

--11
SELECT * FROM dba_extents;

SELECT Ora_RowSCN FROM VFS_T1;

--16
ALTER DATABASE DATAFILE 'VFS.dbf' OFFLINE DROP;
DROP TABLESPACE VFS_QDATA INCLUDING CONTENTS AND DATAFILES;

DROP USER VFS;
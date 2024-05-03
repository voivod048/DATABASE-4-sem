--1
CREATE TABLESPACE TS_VISOTSKI
DATAFILE 'TS_VISOTSKI.dbf'
SIZE 7M REUSE
AUTOEXTEND ON
NEXT 5M
MAXSIZE 30M;
--2
CREATE TEMPORARY TABLESPACE TS_VISOTSKI_TEMP
TEMPFILE 'TS_VISOTSKI_TEMP.dbf'
SIZE 5M REUSE
AUTOEXTEND ON
NEXT 3M
MAXSIZE 20M;
--3
SELECT TABLESPACE_NAME FROM DBA_DATA_FILES;
--4
SELECT TABLESPACE_NAME, FILE_NAME FROM DBA_DATA_FILES;
--5
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
CREATE ROLE RL_VISOTSKICORE;
GRANT CREATE SESSION TO RL_VISOTSKICORE;
GRANT CREATE TABLE, ALTER ANY TABLE, DROP ANY TABLE TO RL_VISOTSKICORE;
GRANT CREATE PROCEDURE, ALTER ANY PROCEDURE, DROP ANY PROCEDURE, EXECUTE ANY PROCEDURE TO RL_VISOTSKICORE;
GRANT CREATE VIEW, DROP ANY VIEW TO RL_VISOTSKICORE;
--6
SELECT * FROM DBA_ROLES WHERE ROLE = 'RL_VISOTSKICORE';
--7
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_VISOTSKICORE';
--8
CREATE PROFILE PF_VISOTSKICORE LIMIT
    FAILED_LOGIN_ATTEMPTS 3
    PASSWORD_LIFE_TIME 60
    PASSWORD_REUSE_TIME 365
    PASSWORD_REUSE_MAX 5
    PASSWORD_LOCK_TIME 1
    PASSWORD_GRACE_TIME 7;
--9
SELECT * FROM DBA_PROFILES;
--10
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_VISOTSKICORE';
--11
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';
--12
CREATE USER VISOTSKICORE
IDENTIFIED BY 123
DEFAULT TABLESPACE TS_VISOTSKI
TEMPORARY TABLESPACE TS_VISOTSKI_TEMP
PROFILE PF_VISOTSKICORE
ACCOUNT UNLOCK CONTAINER = ALL;
PASSWORD EXPIRE;
GRANT RL_VISOTSKICORE TO VISOTSKICORE;
--15, 17
CREATE TABLE VIS_T(
    Name VARCHAR(20)
);
INSERT INTO VIS_T(Name) VALUES ('Fyodor');
SELECT * FROM VIS_T;
--16
ALTER USER VISOTSKICORE QUOTA 2M ON TS_VISOTSKI;
--18
ALTER TABLESPACE TS_VISOTSKI OFFLINE;
--19
SELECT * FROM VIS_T;
--20
ALTER TABLESPACE TS_VISOTSKI ONLINE;
SELECT * FROM VIS_T;

DROP TABLE VIS_T;

DROP USER VISOTSKICORE CASCADE;
DROP PROFILE PF_VISOTSKICORE;
DROP ROLE RL_VISOTSKICORE;
DROP TABLESPACE TS_VISOTSKI;
DROP TABLESPACE TS_VISOTSKI_TEMP;
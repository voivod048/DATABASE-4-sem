--1, 2
SHOW PARAMETER SPFILE;

--3
--делаем, далее проверяем:
CREATE PFILE = 'VFS_PFILE.ORA' FROM SPFILE;

--4
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME = 'open_cursors';

--5
--shutdown
CREATE SPFILE FROM PFILE = 'C:\app\maleyok2\product\21c\dbhomeXE\database\VFS_PFILE.ORA';
--startup

--7
ALTER SYSTEM SET OPEN_CURSORS = 300 SCOPE = SPFILE;

--8
SELECT name
FROM v$controlfile;

--9
-- Создание нового управляющего файла(уже создан, C:\app\maleyok2\product\21c\oradata\XE\lab6)
ALTER DATABASE BACKUP CONTROLFILE TO TRACE;
--shutdown
--изменяем параметр в спфайле
--стартап
SELECT value
FROM v$diag_info
WHERE name = 'Diag Trace';

--10
SELECT * FROM V$PASSWORDFILE_INFO;

--12
SELECT name, value
FROM v$diag_info
WHERE name IN ('Diag Trace', 'Diag Alert', 'Diag Alert Trace');

--13
--C:\app\maleyok2\product\21c\diag\rdbms\xe\xe\alert
--найти в файле строку Completed: ALTER DATABASE BACKUP CONTROLFILE TO TRACE

--14
SELECT value
FROM v$diag_info
WHERE name = 'Diag Trace';
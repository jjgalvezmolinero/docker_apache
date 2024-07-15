CREATE USER user1 IDENTIFIED BY password1;
GRANT CONNECT, RESOURCE, DBA TO user1;
ALTER USER user1 DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

CREATE USER user2 IDENTIFIED BY password2;
GRANT CONNECT, RESOURCE, DBA TO user2;
ALTER USER user2 DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

CREATE USER user3 IDENTIFIED BY password3;
GRANT CONNECT, RESOURCE, DBA TO user3;
ALTER USER user3 DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;

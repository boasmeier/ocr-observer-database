use mysql;
select * from user;
select * from user where User like 'HSLU%';
create user ocrobserveruser IDENTIFIED by '+Observer22';
grant all privileges on ocr_observer.* to 'ocrobserveruser';
flush privileges;

#drop table yai_annotator_test.user;
#drop table yai_annotator.user;
use mysql;
drop database if exists rspec_dev;
drop database if exists rspec_test;
delete from user where User = 'rspec_dev';
delete from user where User = 'rspec_test';
drop database if exists rspec_dev;
drop database if exists rspec_test;
create database rspec_test;
create database rspec_dev;
grant all privileges on rspec_dev.* to 'rspec_dev'@'localhost' identified by 'rspec_dev';
grant all privileges on rspec_test.* to 'rspec_test'@'localhost' identified by 'rspec_test';

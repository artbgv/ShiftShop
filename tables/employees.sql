create table shop.employees(
    id serial  primary key,
    f          varchar(50),
	i          varchar(50),
	o          varchar(50),
    position   varchar(100),
    manager_id integer,
    shop_id    integer
);
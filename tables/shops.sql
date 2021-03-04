create table shop.shops(
    id         serial primary key,
    name 	   varchar(100),
    manager_id integer,
    address    varchar(500)
);
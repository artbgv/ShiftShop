create table shop.products(
    id       		 serial primary key,
    group_id         integer,
    price            money,
    quantity_type_id integer,
    name			 varchar
);
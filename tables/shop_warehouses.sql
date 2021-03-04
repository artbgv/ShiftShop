create table shop.shop_warehouses(
    id         serial primary key,
    shop_id    integer,
    product_id integer,
    quantity   numeric
);
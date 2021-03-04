create table shop.orders(
    id          serial primary key,
    shop_id     integer,
    total_sum   numeric(12, 2),
    datetime    timestamp,
    employee_id integer
);
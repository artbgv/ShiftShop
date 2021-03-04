create table shop.discounts(
    id         serial primary key,
    type_id    integer,
    product_id integer,
    group_id   integer,
    date_from  timestamp,
    date_to    timestamp,
    percent    double precision,
    fixed_sum  numeric(12, 2)
);
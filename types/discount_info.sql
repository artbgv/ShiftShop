create type discount_info as (
    id         integer,
    date_from  timestamp,
    date_to    timestamp,
    product_id integer,
    group_id   integer,
    percent    double precision,
    fixed_sum  numeric(12, 5)
);
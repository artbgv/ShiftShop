create table shop.product_groups(
    id              serial primary key,
    group_name      varchar,
    parent_group_id integer
);
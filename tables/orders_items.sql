create table shop.orders_items(
    id               serial primary key,
    order_id         integer,
    product_id       integer,
    quantity         numeric,
    quantity_type_id integer,
    discount 		 numeric,
    total_amount 	 numeric
);
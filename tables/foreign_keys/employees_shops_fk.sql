alter table employees
add constraint employees_shops_fk foreign key (shop_id)
references shops (id);

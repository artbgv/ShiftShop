create or replace procedure new_product(
    p_name          in varchar,
    p_price         in numeric,
    p_min_price     in numeric,
    p_group         in integer,
    p_quantity_type in integer
) as
$$
begin
    insert into shop.products(
        group_id,
        price,
        quantity_type_id,
        name,
        min_price
    ) values (
        p_group,
        p_price,
        p_quantity_type,
        p_name,
        p_min_price
    );

end;
$$ language plpgsql
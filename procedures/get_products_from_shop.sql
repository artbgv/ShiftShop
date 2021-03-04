create or replace procedure get_products_from_shop(
    p_shop_id     in    integer,
    p_products_id inout integer[],
    p_quantities  inout double precision[]
)
as
$$
begin
    select array_agg(se.product_id),
           array_agg(se.quantity)
      into p_products_id,
           p_quantities
      from shop.shops_warehouse se
     where se.shop_id = p_shop_id;
end;
$$ language plpgsql;
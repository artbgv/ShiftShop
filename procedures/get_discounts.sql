create or replace procedure get_discounts(
    p_date_from in    timestamp,
    p_date_to   in    timestamp,
    p_discounts inout discount_info[]
) as $$
begin
    select array_agg(
               (d.id, d.date_from, d.date_to, d.product_id, d.group_id, d.percent, d.fixed_sum)::discount_info
           )
      into p_discounts
      from shop.discounts d
     where d.date_from between p_date_from and p_date_to
        or d.date_to   between p_date_from and p_date_to;
end;
$$ language plpgsql
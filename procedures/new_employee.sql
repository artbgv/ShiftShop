create or replace procedure new_employee(
    p_f        in varchar,
    p_i        in varchar,
    p_o        in varchar,
    p_position in varchar,
    p_manager  in integer,
    p_shop     in integer
) as
$$
begin
    insert into shop.employees(
        f,
        i,
        o,
        position,
        manager_id,
        shop_id
    ) values (
        p_f,
        p_i,
        p_o,
        p_position,
        p_manager,
        p_shop
    );

end;
$$ language plpgsql
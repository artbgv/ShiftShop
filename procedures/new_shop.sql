create or replace procedure new_shop(
    p_name    in varchar,
    p_manager in integer,
    p_address in varchar
) as
$$
begin
    insert into shop.shops(
        id,
        name,
        manager_id,
        address
    ) values (
        default,
        p_name,
        p_manager,
        p_address
    );

end;
$$ language plpgsql
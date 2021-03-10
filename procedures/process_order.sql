create or replace procedure process_order(
    p_order_info in order_info
) as
$$
declare
    v_order_id           integer; -- id платежа
    v_product_id         integer; -- id текущего товара
    v_price              numeric; -- цена за единицу текущего товара
    v_min_price          numeric; -- минимальная цена за единицу текущего товара
    v_quantity           numeric; -- количество текущего товара
    v_available_quantity numeric; -- доступное количество текущего товара на складе
    v_quantity_type_id   integer; -- id типа измерения текущего товара
    v_quantity_type_str  varchar; -- название типа измерения текущего товара
    v_total_sum          numeric; -- итоговая сумма платежа
    v_cur_product_price  numeric; -- итоговая стоимость за единицу товара
    v_cur_total_sum      numeric; -- итоговая сумма позиции чека
    v_cur_discount       numeric; -- скидка за единицу товара
begin
    v_order_id = nextval('shop.orders_id_seq');
    insert into orders (
        id, 
        shop_id, 
        total_sum, 
        datetime, 
        employee_id
    ) values (
        v_order_id, 
        p_order_info.shop_id, 
        null, 
        now(), 
        p_order_info.employee_id
    );

    v_total_sum = 0;

    -- проверим наличие всех товаров на складе магазина
    for i in 1..cardinality(p_order_info.order_items) loop
        v_product_id = p_order_info.order_items[i].product_id;
        v_quantity   = p_order_info.order_items[i].quantity;
        -- вариант для рефакторинга - вытащить все одним селектом (без цикла)
        select se.quantity,
               p.price,
               p.min_price,
               qt.id,
               qt.type
          into v_available_quantity,
               v_price,
               v_min_price,
               v_quantity_type_id,
               v_quantity_type_str
          from shop_warehouses se,
               products        p,
               quantity_types  qt
         where se.shop_id    = p_order_info.shop_id
           and se.product_id = v_product_id
           and p.id          = v_product_id
           and qt.id         = p.quantity_type_id;

        if v_quantity_type_str = 'штуки' and round(v_quantity) - v_quantity != 0 then
            raise exception 'Недопустимое значение количетсва для данного товара';
        end if;
        if v_quantity > v_available_quantity then
            raise exception 'На складе магазина нет товара в таком количестве';
        end if;

        -- обновим количество товара на складе
        update shop_warehouses
           set quantity = quantity - v_quantity
         where shop_id = p_order_info.shop_id
           and product_id = v_product_id;

        -- расчитаем скидку за единицу товара
        v_cur_discount = 0; -- здесь нужно будет вызвать функцию для расчета скидки

        -- расчитаем стоимость единицы товара
        v_cur_product_price = v_price - v_cur_discount;

        -- проверим, что цена за единицу товара не оказалась меньше минимальной
        if v_cur_product_price < v_min_price then
            v_cur_product_price = v_min_price;
            v_cur_discount      = v_price - v_min_price;
        end if;

        v_cur_total_sum = v_cur_product_price * v_quantity;
        v_total_sum     = v_total_sum + v_cur_total_sum;

        -- добавляем позицию чека в orders_items
        insert into orders_items (
            order_id,
            product_id,
            quantity,
            quantity_type_id,
            discount,
            total_amount
        ) values (
            v_order_id,
            v_product_id,
            v_quantity,
            v_quantity_type_id,
            v_cur_discount * v_quantity,
            v_cur_total_sum
        );
    end loop;

    update orders
       set total_sum = v_total_sum
     where id = v_order_id;
end;
$$ language plpgsql
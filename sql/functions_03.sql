-- Calcular total (calculate_total_sales)
DECLARE
  total NUMERIC;
BEGIN
  SELECT SUM(o.total)
  INTO total
  FROM orders o;

  IF total IS NULL THEN
    total := 0;
  END IF;

  RETURN total;
END;

-- Atualizar status do pedido (update_order_status) via order_id e status
BEGIN
  UPDATE orders
  SET status = p_status
  WHERE id = p_order_id;
END;

-- Atualizar o total do pedido (update_order_total) via order_id
UPDATE orders
SET total = (
    SELECT SUM(quantity * unit_price)
    FROM order_items
    WHERE order_id = orders.id
);

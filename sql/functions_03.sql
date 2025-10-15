-- Calcular total (calculate_total_sales)
CREATE OR REPLACE FUNCTION public.calculate_total_sales()
RETURNS NUMERIC AS $$
DECLARE
  total_sales NUMERIC;
BEGIN
  SELECT SUM(o.total)
  INTO total_sales
  FROM public.orders AS o;

  IF total_sales IS NULL THEN
    total_sales := 0;
  END IF;

  RETURN total_sales;
END;
$$ LANGUAGE plpgsql;

-- Atualizar status do pedido (update_order_status) via order_id e status
CREATE OR REPLACE FUNCTION public.update_order_status(
    p_order_id UUID,
    p_status public.order_status
)
RETURNS VOID AS $$
BEGIN
  UPDATE public.orders
  SET status = p_status
  WHERE id = p_order_id;
END;
$$ LANGUAGE plpgsql;

-- Atualizar o total do pedido (update_order_total) via order_id
UPDATE orders
SET total = (
    SELECT SUM(quantity * unit_price)
    FROM order_items
    WHERE order_id = orders.id
);

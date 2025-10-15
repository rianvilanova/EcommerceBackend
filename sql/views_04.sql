-- Total gasto por cliente
CREATE OR REPLACE VIEW public.customer_total AS
SELECT
  c.id AS customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  c.address AS customer_address,
  SUM(o.total) AS total_spent,
  COUNT(o.id) AS total_orders,
  MAX(o.created_at) AS last_order_date
FROM public.customers c
LEFT JOIN public.orders o ON o.customer_id = c.id
GROUP BY c.id, c.first_name, c.last_name, c.address
ORDER BY total_spent DESC;  


-- Produtos mais vendidos
CREATE OR REPLACE VIEW public.top_products AS
SELECT
  p.id AS product_id,
  p.name AS product_name,
  COALESCE(SUM(oi.quantity), 0) AS total_quantity_sold,
  COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM public.products p
LEFT JOIN public.order_items oi ON oi.product_id = p.id
LEFT JOIN public.orders o ON o.id = oi.order_id
WHERE o.status IS NULL OR o.status <> 'Cancelado'
GROUP BY p.id, p.name
ORDER BY total_quantity_sold DESC;


-- Detalhes completos dos pedidos
CREATE OR REPLACE VIEW public.view_order_details AS
SELECT
  o.id AS order_id,
  o.created_at AS order_date,
  o.status AS order_status,
  o.total AS order_total,

  c.id AS customer_id,
  c.first_name || ' ' || c.last_name AS customer_name,
  c.address AS customer_address,

  p.id AS product_id,
  p.name AS product_name,
  p.description AS product_description,
  p.price AS product_price,

  oi.quantity AS product_quantity,
  oi.unit_price AS product_unit_price,

  (oi.quantity * oi.unit_price) AS total_item
  
FROM public.orders o
JOIN public.customers c ON c.id = o.customer_id
JOIN public.order_items oi ON oi.order_id = o.id
JOIN public.products p ON p.id = oi.product_id;
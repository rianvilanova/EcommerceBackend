-- Total gasto por cliente
CREATE OR REPLACE VIEW customer_total AS
SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    COALESCE(SUM(oi.quantity * oi.unit_price),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id, c.first_name, c.last_name;

-- Produtos mais vendidos
CREATE OR REPLACE VIEW top_products AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.id, p.name
ORDER BY total_sold DESC;

-- Detalhes completos dos pedidos
CREATE OR REPLACE VIEW order_details AS
SELECT
  o.id AS order_id,
  o.status,
  o.total,
  o.created_at AS order_created_at,
  c.id AS customer_id,
  c.first_name,
  c.last_name,
  p.id AS product_id,
  p.name AS product_name,
  oi.quantity,
  oi.unit_price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id;

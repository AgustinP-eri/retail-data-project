-- Creacion de Tablas
-- Tabla productos
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);

-- Tabla clientes
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(1),
    birthdate DATE,
    city VARCHAR(100),
    signup_date DATE
);

-- Tabla tiendas
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    manager VARCHAR(100)
);

-- Tabla ventas
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity INT,
    payment_method VARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Tabla inventario
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    product_id INT,
    store_id INT,
    stock INT,
    last_updated DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);


-- CONSULTAS
--¿Cuántas ventas se hicieron por mes?

SELECT
    DATE_TRUNC('month', sale_date) AS mes,
    SUM(p.price * s.quantity) AS ventas_totales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 1;
--¿Cuál es el ticket promedio por tienda?

SELECT
    s.store_id,
    st.name AS store_name,
    ROUND(SUM(p.price * s.quantity)::numeric / COUNT(DISTINCT s.sale_id), 2) AS ticket_promedio
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN stores st ON s.store_id = st.store_id
GROUP BY s.store_id, st.name
ORDER BY ticket_promedio DESC;

--¿Cuáles son los productos más vendidos por categoría?

SELECT category AS Categoria , SUM(quantity) AS Cantidad_Vendida
FROM products p
INNER JOIN sales s
ON  p.product_id = s.sale_id
GROUP BY category;

-- Ganancia bruta por producto

SELECT
    p.product_id,
    p.name AS product_name,
    SUM((p.price - p.cost) * s.quantity) AS gross_profit
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY gross_profit DESC;


-- Cuantos clientes nuevos se registraron por mes?
SELECT
    DATE_TRUNC('month', signup_date) AS month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY month
ORDER BY month;

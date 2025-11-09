-- Insertar usuarios de ejemplo
INSERT INTO app.users (username, email, password_hash, full_name) VALUES
    ('john_doe', 'john@example.com', crypt('password123', gen_salt('bf')), 'John Doe'),
    ('jane_smith', 'jane@example.com', crypt('password123', gen_salt('bf')), 'Jane Smith'),
    ('bob_wilson', 'bob@example.com', crypt('password123', gen_salt('bf')), 'Bob Wilson')
ON CONFLICT (username) DO NOTHING;

-- Insertar productos de ejemplo
INSERT INTO app.products (name, description, price, stock, category, sku) VALUES
    ('Laptop Dell XPS 15', 'High-performance laptop for professionals', 1299.99, 50, 'Electronics', 'DELL-XPS-15'),
    ('iPhone 14 Pro', 'Latest Apple smartphone', 999.99, 100, 'Electronics', 'IPHONE-14-PRO'),
    ('Sony WH-1000XM5', 'Premium noise-cancelling headphones', 349.99, 75, 'Electronics', 'SONY-WH1000XM5'),
    ('MacBook Pro M2', '14-inch MacBook with M2 chip', 1999.99, 30, 'Electronics', 'MBP-M2-14'),
    ('Samsung Galaxy S23', 'Flagship Android smartphone', 799.99, 120, 'Electronics', 'GALAXY-S23'),
    ('iPad Air', 'Versatile tablet for work and play', 599.99, 80, 'Electronics', 'IPAD-AIR-5'),
    ('Logitech MX Master 3', 'Advanced wireless mouse', 99.99, 200, 'Accessories', 'LOGITECH-MX3'),
    ('Mechanical Keyboard', 'RGB gaming keyboard', 149.99, 150, 'Accessories', 'MECH-KB-001'),
    ('USB-C Hub', '7-in-1 USB-C adapter', 49.99, 300, 'Accessories', 'USBC-HUB-7IN1'),
    ('Portable SSD 1TB', 'Fast external storage', 129.99, 100, 'Storage', 'SSD-1TB-PORT')
ON CONFLICT (sku) DO NOTHING;

-- Insertar órdenes de ejemplo
DO $$
DECLARE
    user1_id UUID;
    user2_id UUID;
    product1_id UUID;
    product2_id UUID;
    product3_id UUID;
    order1_id UUID;
    order2_id UUID;
BEGIN
    -- Obtener IDs de usuarios
    SELECT id INTO user1_id FROM app.users WHERE username = 'john_doe';
    SELECT id INTO user2_id FROM app.users WHERE username = 'jane_smith';
    
    -- Obtener IDs de productos
    SELECT id INTO product1_id FROM app.products WHERE sku = 'DELL-XPS-15';
    SELECT id INTO product2_id FROM app.products WHERE sku = 'IPHONE-14-PRO';
    SELECT id INTO product3_id FROM app.products WHERE sku = 'SONY-WH1000XM5';
    
    -- Crear órdenes
    INSERT INTO app.orders (id, user_id, order_number, status, total_amount)
    VALUES 
        (uuid_generate_v4(), user1_id, app.generate_order_number(), 'completed', 1649.98),
        (uuid_generate_v4(), user2_id, app.generate_order_number(), 'processing', 999.99)
    RETURNING id INTO order1_id;
    
    SELECT id INTO order1_id FROM app.orders WHERE user_id = user1_id ORDER BY created_at DESC LIMIT 1;
    SELECT id INTO order2_id FROM app.orders WHERE user_id = user2_id ORDER BY created_at DESC LIMIT 1;
    
    -- Insertar items de orden
    INSERT INTO app.order_items (order_id, product_id, quantity, unit_price)
    VALUES 
        (order1_id, product1_id, 1, 1299.99),
        (order1_id, product3_id, 1, 349.99),
        (order2_id, product2_id, 1, 999.99);
END $$;
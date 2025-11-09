-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION app.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON app.users
    FOR EACH ROW
    EXECUTE FUNCTION app.update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON app.products
    FOR EACH ROW
    EXECUTE FUNCTION app.update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON app.orders
    FOR EACH ROW
    EXECUTE FUNCTION app.update_updated_at_column();

-- Función de auditoría
CREATE OR REPLACE FUNCTION audit.log_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit.audit_log (table_name, operation, new_data)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit.audit_log (table_name, operation, old_data, new_data)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit.audit_log (table_name, operation, old_data)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD));
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Triggers de auditoría
CREATE TRIGGER audit_users
    AFTER INSERT OR UPDATE OR DELETE ON app.users
    FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

CREATE TRIGGER audit_products
    AFTER INSERT OR UPDATE OR DELETE ON app.products
    FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

CREATE TRIGGER audit_orders
    AFTER INSERT OR UPDATE OR DELETE ON app.orders
    FOR EACH ROW EXECUTE FUNCTION audit.log_changes();

-- Función para generar número de orden
CREATE OR REPLACE FUNCTION app.generate_order_number()
RETURNS VARCHAR AS $$
DECLARE
    new_number VARCHAR;
BEGIN
    new_number := 'ORD-' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || 
                  LPAD(NEXTVAL('app.order_number_seq')::TEXT, 6, '0');
    RETURN new_number;
END;
$$ LANGUAGE plpgsql;

-- Secuencia para números de orden
CREATE SEQUENCE IF NOT EXISTS app.order_number_seq START 1;

-- Vista para analytics
CREATE OR REPLACE VIEW analytics.sales_summary AS
SELECT 
    DATE_TRUNC('day', o.created_at) as date,
    COUNT(DISTINCT o.id) as total_orders,
    SUM(o.total_amount) as total_revenue,
    AVG(o.total_amount) as average_order_value,
    COUNT(DISTINCT o.user_id) as unique_customers
FROM app.orders o
WHERE o.status = 'completed'
GROUP BY DATE_TRUNC('day', o.created_at)
ORDER BY date DESC;

-- Vista de productos más vendidos
CREATE OR REPLACE VIEW analytics.top_products AS
SELECT 
    p.id,
    p.name,
    p.category,
    COUNT(oi.id) as times_ordered,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.subtotal) as total_revenue
FROM app.products p
JOIN app.order_items oi ON p.id = oi.product_id
JOIN app.orders o ON oi.order_id = o.id
WHERE o.status = 'completed'
GROUP BY p.id, p.name, p.category
ORDER BY total_revenue DESC;
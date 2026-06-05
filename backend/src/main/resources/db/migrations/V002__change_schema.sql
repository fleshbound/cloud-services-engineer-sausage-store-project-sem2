DROP table IF EXISTS order_product;

ALTER TABLE product ADD PRIMARY KEY (id);
ALTER TABLE product ADD COLUMN price DOUBLE PRECISION;
ALTER TABLE orders ADD PRIMARY KEY (id);
ALTER TABLE orders ADD COLUMN date_created DATE;

CREATE TABLE order_product (
    order_id BIGINT,
    product_id BIGINT,
    quantity INTEGER,
    
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

DROP TABLE IF EXISTS product_info;
DROP TABLE IF EXISTS orders_date;

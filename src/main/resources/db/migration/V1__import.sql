CREATE TABLE CUSTOMER
(
    id        INT          NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NULL,
    active    INT          NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE PRODUCT
(
    id          INT            NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100)   NOT NULL,
    description VARCHAR(255) NULL,
    price       DECIMAL(10, 2) NOT NULL,
    active      INT            NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE SALE
(
    id           INT            NOT NULL AUTO_INCREMENT,
    sale_date    DATETIME       NOT NULL,
    customer_id  INT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status       VARCHAR(20)    NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER (id)
);

CREATE TABLE SALE_ITEM
(
    id         INT            NOT NULL AUTO_INCREMENT,
    sale_id    INT            NOT NULL,
    product_id INT            NOT NULL,
    quantity   INT            NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    discount   DECIMAL(10, 2) NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (sale_id) REFERENCES SALE (id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT (id)
);

CREATE TABLE SALE_PAYMENT
(
    id           INT            NOT NULL AUTO_INCREMENT,
    sale_id      INT            NOT NULL,
    payment_type VARCHAR(20)    NOT NULL,
    paid_amount  DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME       NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (sale_id) REFERENCES SALE (id)
);

INSERT INTO CUSTOMER (full_name, email, active)
VALUES ('John Doe', 'john.doe@email.com', 1),
       ('Jane Smith', 'jane.smith@email.com', 1),
       ('Alice Johnson', 'alice.j@email.com', 1),
       ('Bob Brown', 'bob.b@email.com', 1),
       ('Charlie Black', 'charlie.b@email.com', 1);

INSERT INTO PRODUCT (name, description, price, active)
VALUES ('Laptop', 'High performance laptop', 2500.00, 1),
       ('Smartphone', 'Latest model smartphone', 1800.00, 1),
       ('Headphones', 'Noise cancelling headphones', 350.00, 1),
       ('Monitor', '27 inch 4K monitor', 1200.00, 1),
       ('Keyboard', 'Mechanical keyboard', 400.00, 1);

-- 50 vendas
INSERT INTO SALE (sale_date, customer_id, total_amount, status)
VALUES ('2024-06-01 10:00:00', 1, 2500.00, 'COMPLETED'),
       ('2024-06-01 11:00:00', 2, 1800.00, 'COMPLETED'),
       ('2024-06-01 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-01 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-01 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-02 10:00:00', 1, 2200.00, 'COMPLETED'),
       ('2024-06-02 11:00:00', 2, 1550.00, 'COMPLETED'),
       ('2024-06-02 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-02 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-02 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-03 10:00:00', 1, 2500.00, 'COMPLETED'),
       ('2024-06-03 11:00:00', 2, 1800.00, 'COMPLETED'),
       ('2024-06-03 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-03 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-03 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-04 10:00:00', 1, 2200.00, 'COMPLETED'),
       ('2024-06-04 11:00:00', 2, 1550.00, 'COMPLETED'),
       ('2024-06-04 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-04 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-04 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-05 10:00:00', 1, 2500.00, 'COMPLETED'),
       ('2024-06-05 11:00:00', 2, 1800.00, 'COMPLETED'),
       ('2024-06-05 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-05 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-05 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-06 10:00:00', 1, 2200.00, 'COMPLETED'),
       ('2024-06-06 11:00:00', 2, 1550.00, 'COMPLETED'),
       ('2024-06-06 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-06 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-06 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-07 10:00:00', 1, 2500.00, 'COMPLETED'),
       ('2024-06-07 11:00:00', 2, 1800.00, 'COMPLETED'),
       ('2024-06-07 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-07 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-07 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-08 10:00:00', 1, 2200.00, 'COMPLETED'),
       ('2024-06-08 11:00:00', 2, 1550.00, 'COMPLETED'),
       ('2024-06-08 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-08 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-08 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-09 10:00:00', 1, 2500.00, 'COMPLETED'),
       ('2024-06-09 11:00:00', 2, 1800.00, 'COMPLETED'),
       ('2024-06-09 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-09 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-09 14:00:00', 5, 400.00, 'COMPLETED'),
       ('2024-06-10 10:00:00', 1, 2200.00, 'COMPLETED'),
       ('2024-06-10 11:00:00', 2, 1550.00, 'COMPLETED'),
       ('2024-06-10 12:00:00', 3, 350.00, 'COMPLETED'),
       ('2024-06-10 13:00:00', 4, 1200.00, 'COMPLETED'),
       ('2024-06-10 14:00:00', 5, 400.00, 'COMPLETED');

-- 50 itens de venda (assumindo que o id da venda começa em 1 e vai até 50)
INSERT INTO SALE_ITEM (sale_id, product_id, quantity, unit_price, discount)
VALUES (1, 1, 1, 2500.00, 0.00),
       (2, 2, 1, 1800.00, 0.00),
       (3, 3, 1, 350.00, 0.00),
       (4, 4, 1, 1200.00, 0.00),
       (5, 5, 1, 400.00, 0.00),
       (6, 1, 1, 2200.00, 300.00),
       (7, 2, 1, 1550.00, 250.00),
       (8, 3, 1, 350.00, 0.00),
       (9, 4, 1, 1200.00, 0.00),
       (10, 5, 1, 400.00, 0.00),
       (11, 1, 1, 2500.00, 0.00),
       (12, 2, 1, 1800.00, 0.00),
       (13, 3, 1, 350.00, 0.00),
       (14, 4, 1, 1200.00, 0.00),
       (15, 5, 1, 400.00, 0.00),
       (16, 1, 1, 2200.00, 300.00),
       (17, 2, 1, 1550.00, 250.00),
       (18, 3, 1, 350.00, 0.00),
       (19, 4, 1, 1200.00, 0.00),
       (20, 5, 1, 400.00, 0.00),
       (21, 1, 1, 2500.00, 0.00),
       (22, 2, 1, 1800.00, 0.00),
       (23, 3, 1, 350.00, 0.00),
       (24, 4, 1, 1200.00, 0.00),
       (25, 5, 1, 400.00, 0.00),
       (26, 1, 1, 2200.00, 300.00),
       (27, 2, 1, 1550.00, 250.00),
       (28, 3, 1, 350.00, 0.00),
       (29, 4, 1, 1200.00, 0.00),
       (30, 5, 1, 400.00, 0.00),
       (31, 1, 1, 2500.00, 0.00),
       (32, 2, 1, 1800.00, 0.00),
       (33, 3, 1, 350.00, 0.00),
       (34, 4, 1, 1200.00, 0.00),
       (35, 5, 1, 400.00, 0.00),
       (36, 1, 1, 2200.00, 300.00),
       (37, 2, 1, 1550.00, 250.00),
       (38, 3, 1, 350.00, 0.00),
       (39, 4, 1, 1200.00, 0.00),
       (40, 5, 1, 400.00, 0.00),
       (41, 1, 1, 2500.00, 0.00),
       (42, 2, 1, 1800.00, 0.00),
       (43, 3, 1, 350.00, 0.00),
       (44, 4, 1, 1200.00, 0.00),
       (45, 5, 1, 400.00, 0.00),
       (46, 1, 1, 2200.00, 300.00),
       (47, 2, 1, 1550.00, 250.00),
       (48, 3, 1, 350.00, 0.00),
       (49, 4, 1, 1200.00, 0.00),
       (50, 5, 1, 400.00, 0.00);

-- 50 pagamentos
INSERT INTO SALE_PAYMENT (sale_id, payment_type, paid_amount, payment_date)
VALUES (1, 'CREDIT_CARD', 2500.00, '2024-06-01 10:05:00'),
       (2, 'CREDIT_CARD', 1800.00, '2024-06-01 11:05:00'),
       (3, 'CASH', 350.00, '2024-06-01 12:05:00'),
       (4, 'CREDIT_CARD', 1200.00, '2024-06-01 13:05:00'),
       (5, 'CASH', 400.00, '2024-06-01 14:05:00'),
       (6, 'CREDIT_CARD', 2200.00, '2024-06-02 10:05:00'),
       (7, 'CREDIT_CARD', 1550.00, '2024-06-02 11:05:00'),
       (8, 'CASH', 350.00, '2024-06-02 12:05:00'),
       (9, 'CREDIT_CARD', 1200.00, '2024-06-02 13:05:00'),
       (10, 'CASH', 400.00, '2024-06-02 14:05:00'),
       (11, 'CREDIT_CARD', 2500.00, '2024-06-03 10:05:00'),
       (12, 'CREDIT_CARD', 1800.00, '2024-06-03 11:05:00'),
       (13, 'CASH', 350.00, '2024-06-03 12:05:00'),
       (14, 'CREDIT_CARD', 1200.00, '2024-06-03 13:05:00'),
       (15, 'CASH', 400.00, '2024-06-03 14:05:00'),
       (16, 'CREDIT_CARD', 2200.00, '2024-06-04 10:05:00'),
       (17, 'CREDIT_CARD', 1550.00, '2024-06-04 11:05:00'),
       (18, 'CASH', 350.00, '2024-06-04 12:05:00'),
       (19, 'CREDIT_CARD', 1200.00, '2024-06-04 13:05:00'),
       (20, 'CASH', 400.00, '2024-06-04 14:05:00'),
       (21, 'CREDIT_CARD', 2500.00, '2024-06-05 10:05:00'),
       (22, 'CREDIT_CARD', 1800.00, '2024-06-05 11:05:00'),
       (23, 'CASH', 350.00, '2024-06-05 12:05:00'),
       (24, 'CREDIT_CARD', 1200.00, '2024-06-05 13:05:00'),
       (25, 'CASH', 400.00, '2024-06-05 14:05:00'),
       (26, 'CREDIT_CARD', 2200.00, '2024-06-06 10:05:00'),
       (27, 'CREDIT_CARD', 1550.00, '2024-06-06 11:05:00'),
       (28, 'CASH', 350.00, '2024-06-06 12:05:00'),
       (29, 'CREDIT_CARD', 1200.00, '2024-06-06 13:05:00'),
       (30, 'CASH', 400.00, '2024-06-06 14:05:00'),
       (31, 'CREDIT_CARD', 2500.00, '2024-06-07 10:05:00'),
       (32, 'CREDIT_CARD', 1800.00, '2024-06-07 11:05:00'),
       (33, 'CASH', 350.00, '2024-06-07 12:05:00'),
       (34, 'CREDIT_CARD', 1200.00, '2024-06-07 13:05:00'),
       (35, 'CASH', 400.00, '2024-06-07 14:05:00'),
       (36, 'CREDIT_CARD', 2200.00, '2024-06-08 10:05:00'),
       (37, 'CREDIT_CARD', 1550.00, '2024-06-08 11:05:00'),
       (38, 'CASH', 350.00, '2024-06-08 12:05:00'),
       (39, 'CREDIT_CARD', 1200.00, '2024-06-08 13:05:00'),
       (40, 'CASH', 400.00, '2024-06-08 14:05:00'),
       (41, 'CREDIT_CARD', 2500.00, '2024-06-09 10:05:00'),
       (42, 'CREDIT_CARD', 1800.00, '2024-06-09 11:05:00'),
       (43, 'CASH', 350.00, '2024-06-09 12:05:00'),
       (44, 'CREDIT_CARD', 1200.00, '2024-06-09 13:05:00'),
       (45, 'CASH', 400.00, '2024-06-09 14:05:00'),
       (46, 'CREDIT_CARD', 2200.00, '2024-06-10 10:05:00'),
       (47, 'CREDIT_CARD', 1550.00, '2024-06-10 11:05:00'),
       (48, 'CASH', 350.00, '2024-06-10 12:05:00'),
       (49, 'CREDIT_CARD', 1200.00, '2024-06-10 13:05:00'),
       (50, 'CASH', 400.00, '2024-06-10 14:05:00');




SELECT
    s.id AS id,
    s.total_amount AS totalAmount,
    s.status AS status,
    c.id AS customerId,
    c.full_name AS customerFullName,
    c.email AS customerEmail,
    c.active AS customerActive
FROM SALE s
         LEFT JOIN CUSTOMER c ON s.customer_id = c.id
ORDER BY s.id
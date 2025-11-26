SELECT
    s.id AS id,
    s.sale_date AS saleDate,
    c.id AS customerId,
    c.full_name AS customerFullName,
    c.email AS customerEmail,
    c.active AS customerActive,
    si.id AS saleItemId,
    si.quantity AS saleItemQuantity,
    si.unit_price AS saleItemUnitPrice,
    si.discount AS saleItemDiscount,
    p.id AS productId,
    p.name AS productName,
    p.description AS productDescription,
    p.price AS productPrice,
    p.active AS productActive,
    sp.id AS salePaymentId,
    sp.payment_type AS salePaymentPaymentType,
    sp.paid_amount AS salePaymentPaidAmount,
    sp.payment_date AS salePaymentPaymentDate,
    s.total_amount AS totalAmount,
    s.status AS status
FROM SALE s
         LEFT JOIN CUSTOMER c ON s.customer_id = c.id
         LEFT JOIN SALE_ITEM si ON si.sale_id = s.id
         LEFT JOIN PRODUCT p ON si.product_id = p.id
         LEFT JOIN SALE_PAYMENT sp ON sp.sale_id = s.id
WHERE 1=1
-- <#if customerId??>
AND c.id = :customerId
-- </#if>
-- <#if params??>
-- <#list params as item>
AND ${item} = :${item}
-- </#list>
-- </#if>
-- <#if filterId??>
AND s.id = :filterId
-- </#if>
-- <#if filterName??>
AND c.full_name like :filterName
-- </#if>
ORDER BY s.id, si.id, sp.id

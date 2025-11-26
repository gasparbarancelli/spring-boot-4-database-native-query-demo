package com.grupopan.demo.nativequery;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record SaleFullResult(
        int id,
        LocalDateTime saleDate,
        int customerId,
        String customerFullName,
        String customerEmail,
        int customerActive,
        int saleItemId,
        int saleItemQuantity,
        BigDecimal saleItemUnitPrice,
        BigDecimal saleItemDiscount,
        int productId,
        String productName,
        String productDescription,
        BigDecimal productPrice,
        int productActive,
        int salePaymentId,
        String salePaymentPaymentType,
        BigDecimal salePaymentPaidAmount,
        LocalDateTime salePaymentPaymentDate,
        BigDecimal totalAmount,
        String status
) {}

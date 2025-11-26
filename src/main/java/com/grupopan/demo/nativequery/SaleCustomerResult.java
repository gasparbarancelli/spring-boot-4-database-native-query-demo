package com.grupopan.demo.nativequery;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class SaleCustomerResult {

    private Integer id;
    private BigDecimal totalAmount;
    private String status;
    private Integer customerId;
    private String customerFullName;
    private String customerEmail;
    private Integer customerActive;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Integer customerId) {
        this.customerId = customerId;
    }

    public String getCustomerFullName() {
        return customerFullName;
    }

    public void setCustomerFullName(String customerFullName) {
        this.customerFullName = customerFullName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public Integer getCustomerActive() {
        return customerActive;
    }

    public void setCustomerActive(Integer customerActive) {
        this.customerActive = customerActive;
    }

}

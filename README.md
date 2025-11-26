# NativeQuery Project - Usage Example

## About the NativeQuery Library

The [spring-nativequery](https://github.com/gasparbarancelli/nativequery) library enables you to execute native SQL queries in Spring Boot projects in a simple, safe, and flexible way. It allows you to map query results directly to Java classes (DTOs or records) without the need for JPA entities, making data access more performant and decoupled.

Key features:
- **Automatic mapping**: Query results are converted to Java classes using compatible field names.
- **Parameterized queries**: Allows passing parameters to native queries safely, preventing SQL Injection.
- **Dynamic filters**: Supports flexible filters using annotations and filter objects.
- **Spring Data integration**: Supports pagination, sorting, and JdbcTemplate usage.
- **External SQL files as template engines**: SQL files are treated as template engines using Freemarker. This means you can add conditionals, loops, and other logic directly in your SQL files, making queries highly dynamic and maintainable. Each Freemarker command is placed inside SQL comments (e.g., `-- <#if ...>`), so the SQL remains valid and readable even outside the application. This approach allows you to:
  - Write flexible queries that adapt to input parameters.
  - Keep your SQL files clean and versionable.
  - Use advanced logic without breaking SQL compatibility.

In this project example, NativeQuery is used to:
- Retrieve complete and aggregated sales by customer.
- Use dynamic filters and parameters in native queries.
- Map results directly to DTOs and Java records, without JPA entities.

---

# NativeQuery Project - Usage Example

This project demonstrates how to use the [nativequery](https://github.com/gasparbarancelli/nativequery) library in a Spring Boot application to perform native SQL queries and map results directly to Java classes.

## Project Structure

```
src/
  main/
    java/
      com/grupopan/demo/nativequery/
        NativequeryApplication.java
        SaleCustomerResult.java
        SaleFullResult.java
        SalesController.java
        SalesFilter.java
        SalesNativeQuery.java
    resources/
      application.properties
      db/migration/V1__import.sql
      nativeQuery/findSales.sql
      nativeQuery/findSalesCustomers.sql
```

## Code Examples

### NativequeryApplication.java
```java
package com.grupopan.demo.nativequery;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.web.config.EnableSpringDataWebSupport;

// Main Spring Boot application class
@SpringBootApplication
@EnableSpringDataWebSupport(pageSerializationMode = EnableSpringDataWebSupport.PageSerializationMode.VIA_DTO)
public class NativequeryApplication {
    // Main method to start the application
    public static void main(String[] args) {
        SpringApplication.run(NativequeryApplication.class, args);
    }
}
```

### SaleCustomerResult.java
```java
package com.grupopan.demo.nativequery;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// DTO for sales results by customer
public class SaleCustomerResult {
    private Integer id; // Sale ID
    private BigDecimal totalAmount; // Total sale amount
    private String status; // Sale status
    private Integer customerId; // Customer ID
    private String customerFullName; // Customer full name
    private String customerEmail; // Customer email
    private Integer customerActive; // Customer active status
    // getters and setters
}
```

### SaleFullResult.java
```java
package com.grupopan.demo.nativequery;

import java.math.BigDecimal;
import java.time.LocalDateTime;

// Record for complete sale result, including items, payments, and customer
public record SaleFullResult(
    int id, // Sale ID
    LocalDateTime saleDate, // Sale date
    int customerId, // Customer ID
    String customerFullName, // Customer full name
    String customerEmail, // Customer email
    int customerActive, // Customer active status
    int saleItemId, // Sale item ID
    int saleItemQuantity, // Item quantity
    BigDecimal saleItemUnitPrice, // Item unit price
    BigDecimal saleItemDiscount, // Item discount
    int productId, // Product ID
    String productName, // Product name
    String productDescription, // Product description
    BigDecimal productPrice, // Product price
    int productActive, // Product active status
    int salePaymentId, // Payment ID
    String salePaymentPaymentType, // Payment type
    BigDecimal salePaymentPaidAmount, // Paid amount
    LocalDateTime salePaymentPaymentDate, // Payment date
    BigDecimal totalAmount, // Total sale amount
    String status // Sale status
) {}
```

### SalesFilter.java
```java
package com.grupopan.demo.nativequery;

import io.github.gasparbarancelli.NativeQueryOperator;
import io.github.gasparbarancelli.NativeQueryParam;

// Filter for sales queries
public record SalesFilter(
        Number id, // Sale ID
        @NativeQueryParam(value = "name", operator = NativeQueryOperator.CONTAINING)
        String customerName // Customer name for search
) {
}
```

### SalesNativeQuery.java
```java
package com.grupopan.demo.nativequery;

import io.github.gasparbarancelli.NativeQuery;
import io.github.gasparbarancelli.NativeQueryParam;
import io.github.gasparbarancelli.NativeQueryUseJdbcTemplate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;

// Interface for native queries using the nativequery library
@Repository
public interface SalesNativeQuery extends NativeQuery {
    // Query sales by customer
    List<SaleCustomerResult> findSalesCustomers();
    // Paginated query of sales by customer
    Page<SaleCustomerResult> findSalesCustomers(Pageable pageable);
    // Query all sales
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales();
    // Query sales by customer ID
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales(@NativeQueryParam(value = "customerId") int customerId);
    // Query sales using filter
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales(@NativeQueryParam(value = "filter", addChildren = true) SalesFilter filter);
    // Dynamic query using parameter map
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales(Map<String, Object> params);
}
```

### SalesController.java
```java
package com.grupopan.demo.nativequery;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// REST controller for sales endpoints
@RestController
@RequestMapping("/sales")
public class SalesController {
    private final SalesNativeQuery salesNativeQuery; // Injects the query interface
    public SalesController(SalesNativeQuery salesNativeQuery) {
        this.salesNativeQuery = salesNativeQuery;
    }
    // Returns all sales
    @GetMapping
    public List<SaleFullResult> findSales() {
        return salesNativeQuery.findSales();
    }
    // Returns sales by customer ID
    @GetMapping("/customer/{customerId}")
    public List<SaleFullResult> findSalesByCustomerId(@PathVariable("customerId") int customerId) {
        return salesNativeQuery.findSales(customerId);
    }
    // Returns sales filtered
    @PostMapping("/filter")
    public List<SaleFullResult> findSalesByFilter(@RequestBody SalesFilter filter) {
        return salesNativeQuery.findSales(filter);
    }
    // Returns sales using dynamic parameters
    @GetMapping("/dynamic")
    public List<SaleFullResult> findDynamicSales() {
        Map<String, Object> map = new HashMap<>();
        map.put("p.id", 1);
        map.put("c.id", 1);
        return salesNativeQuery.findSales(map);
    }
    // Returns aggregated sales by customer
    @GetMapping("/customers")
    public List<SaleCustomerResult> findSalesCustomers() {
        return salesNativeQuery.findSalesCustomers();
    }
    // Returns paginated aggregated sales by customer
    @GetMapping("/customers/pageable")
    public Page<SaleCustomerResult> findSalesCustomersPageable(Pageable pageable) {
        return salesNativeQuery.findSalesCustomers(pageable);
    }
}
```

### application.properties
```properties
# Application and database configuration
spring.application.name=nativequery
native-query.package-scan=com.grupopan.demo.nativequery
spring.datasource.url=jdbc:mysql://localhost:3306/demo?useSSL=false&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=123456
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
```

### V1__import.sql
```sql
-- Main tables for sales domain
CREATE TABLE CUSTOMER (
    id        INT          NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email     VARCHAR(100) NULL,
    active    INT          NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE PRODUCT (
    id          INT            NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100)   NOT NULL,
    description VARCHAR(255) NULL,
    price       DECIMAL(10, 2) NOT NULL,
    active      INT            NOT NULL,
    PRIMARY KEY (id)
);
CREATE TABLE SALE (
    id           INT            NOT NULL AUTO_INCREMENT,
    sale_date    DATETIME       NOT NULL,
    customer_id  INT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status       VARCHAR(20)    NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER (id)
);
CREATE TABLE SALE_ITEM (
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
CREATE TABLE SALE_PAYMENT (
    id           INT            NOT NULL AUTO_INCREMENT,
    sale_id      INT            NOT NULL,
    payment_type VARCHAR(20)    NOT NULL,
    paid_amount  DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME       NOT NULL
);
```

### findSales.sql
```sql
-- Native query to fetch complete sales
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
```

### findSalesCustomers.sql
```sql
-- Native query to fetch aggregated sales by customer
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
```

### NativequeryApplicationTests.java
```java
package com.grupopan.demo.nativequery;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

// Application context test
@SpringBootTest
class NativequeryApplicationTests {
    @Test
    void contextLoads() {
        // Tests if the context loads correctly
    }
}
```

## Notes
- The SQL examples and query implementations can be adapted to your data model.
- The `nativequery` library makes it easy to map native query results directly to DTOs and Java records.

---
Example project for using the [nativequery](https://github.com/gasparbarancelli/nativequery) library in Spring Boot applications.

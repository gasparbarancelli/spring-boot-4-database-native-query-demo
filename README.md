# Projeto NativeQuery - Exemplo de Uso

Este projeto demonstra o uso da biblioteca [nativequery](https://github.com/gasparbarancelli/nativequery) em uma aplicação Spring Boot para realizar consultas nativas SQL e mapear resultados diretamente para classes Java.

## Estrutura do Projeto

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
      db/migration/V1__create_user_table.sql
      nativeQuery/findSales.sql
      nativeQuery/findSalesCustomers.sql
```

## Exemplos de Código

### NativequeryApplication.java
```java
package com.grupopan.demo.nativequery;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.web.config.EnableSpringDataWebSupport;

@SpringBootApplication
@EnableSpringDataWebSupport(pageSerializationMode = EnableSpringDataWebSupport.PageSerializationMode.VIA_DTO)
public class NativequeryApplication {
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

public class SaleCustomerResult {
    private Integer id;
    private BigDecimal totalAmount;
    private String status;
    private Integer customerId;
    private String customerFullName;
    private String customerEmail;
    private Integer customerActive;
    // getters e setters
}
```

### SaleFullResult.java
```java
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
```

### SalesFilter.java
```java
package com.grupopan.demo.nativequery;

import io.github.gasparbarancelli.NativeQueryOperator;
import io.github.gasparbarancelli.NativeQueryParam;

public record SalesFilter(
        Number id,
        @NativeQueryParam(value = "name", operator = NativeQueryOperator.CONTAINING)
        String customerName) {
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

public interface SalesNativeQuery extends NativeQuery {
    List<SaleCustomerResult> findSalesCustomers();
    Page<SaleCustomerResult> findSalesCustomers(Pageable pageable);
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales();
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales(@NativeQueryParam(value = "customerId") int customerId);
    @NativeQueryUseJdbcTemplate
    List<SaleFullResult> findSales(@NativeQueryParam(value = "filter", addChildren = true) SalesFilter filter);
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

@RestController
@RequestMapping("/sales")
public class SalesController {
    private final SalesNativeQuery salesNativeQuery;
    public SalesController(SalesNativeQuery salesNativeQuery) {
        this.salesNativeQuery = salesNativeQuery;
    }
    @GetMapping
    public List<SaleFullResult> findSales() {
        return salesNativeQuery.findSales();
    }
    @GetMapping("/customer/{customerId}")
    public List<SaleFullResult> findSalesByCustomerId(@PathVariable("customerId") int customerId) {
        return salesNativeQuery.findSales(customerId);
    }
    @PostMapping("/filter")
    public List<SaleFullResult> findSalesByFilter(@RequestBody SalesFilter filter) {
        return salesNativeQuery.findSales(filter);
    }
    @GetMapping("/dynamic")
    public List<SaleFullResult> findDynamicSales() {
        Map<String, Object> map = new HashMap<>();
        map.put("p.id", 1);
        map.put("c.id", 1);
        return salesNativeQuery.findSales(map);
    }
    @GetMapping("/customers")
    public List<SaleCustomerResult> findSalesCustomers() {
        return salesNativeQuery.findSalesCustomers();
    }
    @GetMapping("/customers/pageable")
    public Page<SaleCustomerResult> findSalesCustomersPageable(Pageable pageable) {
        return salesNativeQuery.findSalesCustomers(pageable);
    }
}
```

### application.properties
```properties
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

### V1__create_user_table.sql
```sql
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

@SpringBootTest
class NativequeryApplicationTests {
    @Test
    void contextLoads() {
    }
}
```

## Como Executar

1. Configure o banco de dados conforme o arquivo `application.properties`.
2. Execute as migrações do Flyway para criar as tabelas.
3. Inicie a aplicação com:
   ```sh
   ./mvnw spring-boot:run
   ```
4. Utilize os endpoints REST para testar as consultas nativas.

## Observações
- Os exemplos de SQL e implementação das queries podem ser adaptados conforme seu modelo de dados.
- O uso da biblioteca `nativequery` facilita o mapeamento direto dos resultados das queries nativas para DTOs e records Java.

---
Projeto de exemplo para uso da biblioteca [nativequery](https://github.com/gasparbarancelli/nativequery) em aplicações Spring Boot.


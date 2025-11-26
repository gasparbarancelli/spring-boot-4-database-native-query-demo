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
        return salesNativeQuery.findSalesByCustomerId(customerId);
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
    public Page<SaleCustomerResult> findSalesCustomersPageable(
            @RequestParam(value = "page", defaultValue = "0", required = false) int pageNumber,
            @RequestParam(value = "size", defaultValue = "5", required = false) int pageSize
    ) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize);
        return salesNativeQuery.findSalesCustomers(pageable);
    }

}

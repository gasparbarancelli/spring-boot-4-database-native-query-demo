package com.grupopan.demo.nativequery;

import io.github.gasparbarancelli.NativeQuery;
import io.github.gasparbarancelli.NativeQueryParam;
import io.github.gasparbarancelli.NativeQueryUseJdbcTemplate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
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

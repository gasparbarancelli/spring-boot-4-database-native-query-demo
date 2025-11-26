package com.grupopan.demo.nativequery;

import io.github.gasparbarancelli.NativeQueryOperator;
import io.github.gasparbarancelli.NativeQueryParam;

public record SalesFilter(
        Number id,
        @NativeQueryParam(value = "name", operator = NativeQueryOperator.CONTAINING)
        String customerName) {

}

package com.lab.reserve.config;

import com.lab.reserve.common.BusinessException;
import com.lab.reserve.util.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BusinessException.class)
    public Result<String> handleBusiness(BusinessException exception) {
        return Result.fail(exception.getMessage());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public Result<String> handleIllegalArgument(IllegalArgumentException exception) {
        return Result.fail(exception.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public Result<String> handleException(Exception exception) {
        logger.error("Unhandled request error", exception);
        return Result.fail("服务器处理失败，请检查服务日志");
    }
}

package com.udst.neon_chip_estore.controller;

import java.util.List;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.udst.neon_chip_estore.exception.BadRequestException;
import com.udst.neon_chip_estore.model.Order;
import com.udst.neon_chip_estore.model.OrderStatus;
import com.udst.neon_chip_estore.service.OrderService;

@RestController
@RequestMapping("/api/orders")
@Validated
public class OrderController {
    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping("/from-cart/{cartId}")
    public Order placeOrder(@PathVariable String cartId) {
        return orderService.placeOrderFromCart(cartId);
    }

    @GetMapping("/by-user/{userId}")
    public List<Order> listByUser(@PathVariable String userId) {
        return orderService.getOrdersByUser(userId);
    }

    @GetMapping("/{orderId}")
    public Order get(@PathVariable String orderId) {
        return orderService.getById(orderId);
    }

    @PatchMapping("/{orderId}/status/{status}")
    public Order updateStatus(@PathVariable String orderId, @PathVariable String status) {
        try {
            OrderStatus s = OrderStatus.valueOf(status.toUpperCase());
            return orderService.updateStatus(orderId, s);
        } catch (IllegalArgumentException ex) {
            throw new BadRequestException("Invalid status value: " + status);
        }
    }
}

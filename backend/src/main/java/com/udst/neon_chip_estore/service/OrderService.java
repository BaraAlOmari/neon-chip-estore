package com.udst.neon_chip_estore.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.udst.neon_chip_estore.exception.BadRequestException;
import com.udst.neon_chip_estore.exception.NotFoundException;
import com.udst.neon_chip_estore.model.Cart;
import com.udst.neon_chip_estore.model.CartItem;
import com.udst.neon_chip_estore.model.Order;
import com.udst.neon_chip_estore.model.OrderItem;
import com.udst.neon_chip_estore.model.OrderStatus;
import com.udst.neon_chip_estore.repository.CartRepository;
import com.udst.neon_chip_estore.repository.OrderRepository;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;
    private final CartService cartService;

    public OrderService(OrderRepository orderRepository, CartRepository cartRepository, CartService cartService) {
        this.orderRepository = orderRepository;
        this.cartRepository = cartRepository;
        this.cartService = cartService;
    }

    @Transactional
    public Order placeOrderFromCart(String cartId) {
        Cart cart = cartRepository.findById(cartId)
                .orElseThrow(() -> new NotFoundException("Cart not found: " + cartId));
        if (cart.getItems().isEmpty()) {
            throw new BadRequestException("Cart is empty");
        }
        List<OrderItem> items = cart.getItems().stream().map(this::toOrderItem).collect(Collectors.toList());
        BigDecimal total = items.stream()
                .map(i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        Order order = new Order();
        order.setUserId(cart.getUserId());
        order.setItems(items);
        order.setTotal(total);
        order.setStatus(OrderStatus.PENDING);
        Order saved = orderRepository.save(order);

        cart.getItems().clear();
        cartRepository.save(cart);
        return saved;
    }

    public List<Order> getOrdersByUser(String userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Order getById(String orderId) {
        return orderRepository.findById(orderId)
                .orElseThrow(() -> new NotFoundException("Order not found: " + orderId));
    }

    @Transactional
    public Order updateStatus(String orderId, OrderStatus status) {
        Order order = getById(orderId);
        order.setStatus(status);
        return orderRepository.save(order);
    }

    private OrderItem toOrderItem(CartItem ci) {
        OrderItem oi = new OrderItem();
        oi.setProductId(ci.getProductId());
        oi.setName(ci.getName());
        oi.setImageUrl(ci.getImageUrl());
        oi.setUnitPrice(ci.getUnitPrice());
        oi.setQuantity(ci.getQuantity());
        return oi;
    }
}


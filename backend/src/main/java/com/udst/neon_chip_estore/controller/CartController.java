package com.udst.neon_chip_estore.controller;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.udst.neon_chip_estore.model.Cart;
import com.udst.neon_chip_estore.service.CartService;

@RestController
@RequestMapping("/api/carts")
@CrossOrigin(origins = "*")
@Validated
public class CartController {
    private final CartService cartService;

    public CartController(CartService cartService) {
        this.cartService = cartService;
    }

    @GetMapping("/by-user/{userId}")
    public Cart getByUser(@PathVariable String userId) {
        Cart cart = cartService.getOrCreateCartByUser(userId);
        cart.setTotal(cartService.computeTotal(cart));
        return cart;
    }

    @GetMapping("/{cartId}")
    public Cart get(@PathVariable String cartId) {
        Cart cart = cartService.getCart(cartId);
        cart.setTotal(cartService.computeTotal(cart));
        return cart;
    }

    @PostMapping("/{cartId}/items")
    public Cart addItem(@PathVariable String cartId,
            @RequestParam String productId,
            @RequestParam int quantity) {
        Cart cart = cartService.addItem(cartId, productId, quantity);
        cart.setTotal(cartService.computeTotal(cart));
        return cart;
    }

    @PatchMapping("/{cartId}/items/{productId}")
    public Cart updateQuantity(@PathVariable String cartId,
            @PathVariable String productId,
            @RequestParam int quantity) {
        Cart cart = cartService.updateItemQuantity(cartId, productId, quantity);
        cart.setTotal(cartService.computeTotal(cart));
        return cart;
    }

    @DeleteMapping("/{cartId}/items/{productId}")
    public Cart removeItem(@PathVariable String cartId, @PathVariable String productId) {
        Cart cart = cartService.removeItem(cartId, productId);
        cart.setTotal(cartService.computeTotal(cart));
        return cart;
    }
}

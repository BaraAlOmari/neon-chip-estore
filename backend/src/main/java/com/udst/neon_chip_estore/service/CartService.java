package com.udst.neon_chip_estore.service;

import java.math.BigDecimal;
import java.util.Iterator;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.udst.neon_chip_estore.exception.BadRequestException;
import com.udst.neon_chip_estore.exception.NotFoundException;
import com.udst.neon_chip_estore.model.Cart;
import com.udst.neon_chip_estore.model.CartItem;
import com.udst.neon_chip_estore.model.Product;
import com.udst.neon_chip_estore.repository.CartRepository;
import com.udst.neon_chip_estore.repository.ProductRepository;

@Service
public class CartService {

    private final CartRepository cartRepository;
    private final ProductRepository productRepository;

    public CartService(CartRepository cartRepository, ProductRepository productRepository) {
        this.cartRepository = cartRepository;
        this.productRepository = productRepository;
    }

    public Cart getOrCreateCartByUser(String userId) {
        return cartRepository.findByUserId(userId).orElseGet(() -> {
            Cart c = new Cart();
            c.setUserId(userId);
            return cartRepository.save(c);
        });
    }

    public Cart getCart(String cartId) {
        return cartRepository.findById(cartId)
                .orElseThrow(() -> new NotFoundException("Cart not found: " + cartId));
    }

    @Transactional
    public Cart addItem(String cartId, String productId, int quantity) {
        if (quantity <= 0)
            throw new BadRequestException("Quantity must be positive");
        Cart cart = getCart(cartId);
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new NotFoundException("Product not found: " + productId));

        Optional<CartItem> existing = cart.getItems().stream()
                .filter(i -> i.getProductId().equals(productId))
                .findFirst();
        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            CartItem item = new CartItem();
            item.setProductId(product.getId());
            item.setName(product.getName());
            item.setImageUrl(product.getImageUrl());
            item.setUnitPrice(product.getPrice());
            item.setQuantity(quantity);
            cart.getItems().add(item);
        }
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart updateItemQuantity(String cartId, String productId, int quantity) {
        Cart cart = getCart(cartId);
        boolean found = false;
        for (CartItem item : cart.getItems()) {
            if (item.getProductId().equals(productId)) {
                found = true;
                if (quantity <= 0) {
                    // remove item if non-positive
                    removeItem(cartId, productId);
                    return getCart(cartId);
                }
                item.setQuantity(quantity);
            }
        }
        if (!found) {
            throw new NotFoundException("Item not in cart: " + productId);
        }
        return cartRepository.save(cart);
    }

    @Transactional
    public Cart removeItem(String cartId, String productId) {
        Cart cart = getCart(cartId);
        Iterator<CartItem> it = cart.getItems().iterator();
        boolean removed = false;
        while (it.hasNext()) {
            CartItem item = it.next();
            if (item.getProductId().equals(productId)) {
                it.remove();
                removed = true;
                break;
            }
        }
        if (!removed) {
            throw new NotFoundException("Item not in cart: " + productId);
        }
        return cartRepository.save(cart);
    }

    public BigDecimal computeTotal(Cart cart) {
        return cart.getItems().stream()
                .map(i -> i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    @Transactional
    public void clearCart(Cart cart) {
        cart.getItems().clear();
        cartRepository.save(cart);
    }
}

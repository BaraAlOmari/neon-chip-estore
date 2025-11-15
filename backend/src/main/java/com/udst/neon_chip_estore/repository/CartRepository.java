package com.udst.neon_chip_estore.repository;

import java.util.Optional;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.udst.neon_chip_estore.model.Cart;

public interface CartRepository extends MongoRepository<Cart, String> {
    Optional<Cart> findByUserId(String userId);
}


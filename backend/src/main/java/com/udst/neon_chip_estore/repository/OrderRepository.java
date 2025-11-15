package com.udst.neon_chip_estore.repository;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.udst.neon_chip_estore.model.Order;

public interface OrderRepository extends MongoRepository<Order, String> {
    List<Order> findByUserIdOrderByCreatedAtDesc(String userId);
}


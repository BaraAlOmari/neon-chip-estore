package com.udst.neon_chip_estore.repository;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.udst.neon_chip_estore.model.Product;

public interface ProductRepository extends MongoRepository<Product, String> {
}


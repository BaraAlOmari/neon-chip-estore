package com.udst.neon_chip_estore.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import com.udst.neon_chip_estore.exception.NotFoundException;
import com.udst.neon_chip_estore.model.Product;
import com.udst.neon_chip_estore.repository.ProductRepository;

@Service
public class ProductService {

    private final ProductRepository productRepository;
    private final MongoTemplate mongoTemplate;

    public ProductService(ProductRepository productRepository, MongoTemplate mongoTemplate) {
        this.productRepository = productRepository;
        this.mongoTemplate = mongoTemplate;
    }

    public Page<Product> search(String category, BigDecimal minPrice, BigDecimal maxPrice, String search, Pageable pageable) {
        Query query = new Query();
        Criteria criteria = new Criteria();
        boolean hasCrit = false;

        if (category != null && !category.isBlank()) {
            criteria = criteria.and("category").is(category);
            hasCrit = true;
        }
        if (minPrice != null) {
            criteria = hasCrit ? criteria.and("price").gte(minPrice) : Criteria.where("price").gte(minPrice);
            hasCrit = true;
        }
        if (maxPrice != null) {
            criteria = hasCrit ? criteria.and("price").lte(maxPrice) : Criteria.where("price").lte(maxPrice);
            hasCrit = true;
        }
        if (search != null && !search.isBlank()) {
            Criteria name = Criteria.where("name").regex(search, "i");
            Criteria desc = Criteria.where("description").regex(search, "i");
            Criteria or = new Criteria().orOperator(name, desc);
            if (hasCrit) {
                criteria = new Criteria().andOperator(criteria, or);
            } else {
                criteria = or;
            }
            hasCrit = true;
        }

        if (hasCrit) {
            query.addCriteria(criteria);
        }

        long total = mongoTemplate.count(Query.of(query).limit(-1).skip(-1), Product.class);
        query.with(pageable);
        List<Product> content = mongoTemplate.find(query, Product.class);
        return new PageImpl<>(content, pageable, total);
    }

    public Product getById(String id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Product not found: " + id));
    }

    public Product create(Product p) {
        p.setId(null);
        if (p.getPriceAfterDiscount() == null && p.getPrice() != null) {
            p.setPriceAfterDiscount(p.getPrice().multiply(new BigDecimal("0.7")));
        }
        return productRepository.save(p);
    }

    public Product update(String id, Product incoming) {
        Optional<Product> existingOpt = productRepository.findById(id);
        if (existingOpt.isEmpty()) {
            throw new NotFoundException("Product not found: " + id);
        }
        Product existing = existingOpt.get();
        existing.setName(incoming.getName());
        existing.setDescription(incoming.getDescription());
        existing.setImageUrl(incoming.getImageUrl());
        existing.setCategory(incoming.getCategory());
        existing.setPrice(incoming.getPrice());
        if (incoming.getPriceAfterDiscount() != null) {
            existing.setPriceAfterDiscount(incoming.getPriceAfterDiscount());
        } else if (incoming.getPrice() != null) {
            existing.setPriceAfterDiscount(incoming.getPrice().multiply(new BigDecimal("0.7")));
        }
        existing.setStock(incoming.getStock());
        return productRepository.save(existing);
    }

    public void delete(String id) {
        if (!productRepository.existsById(id)) {
            throw new NotFoundException("Product not found: " + id);
        }
        productRepository.deleteById(id);
    }
}

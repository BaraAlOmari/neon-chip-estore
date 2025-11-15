package com.udst.neon_chip_estore.controller;

import java.math.BigDecimal;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.udst.neon_chip_estore.model.Product;
import com.udst.neon_chip_estore.service.ProductService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/products")
@Validated
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public Page<Product> list(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) String search,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String sort) {

        Sort sortSpec = parseSort(sort);
        Pageable pageable = PageRequest.of(page, size, sortSpec);
        return productService.search(category, minPrice, maxPrice, search, pageable);
    }

    @GetMapping("/{id}")
    public Product get(@PathVariable String id) {
        return productService.getById(id);
    }

    @PostMapping
    public ResponseEntity<Product> create(@Valid @RequestBody Product req) {
        Product created = productService.create(req);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public Product update(@PathVariable String id, @Valid @RequestBody Product req) {
        return productService.update(id, req);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable String id) {
        productService.delete(id);
        return ResponseEntity.noContent().build();
    }

    private Sort parseSort(String sort) {
        if (sort == null || sort.isBlank()) {
            return Sort.by(Sort.Direction.ASC, "name");
        }
        String[] parts = sort.split(",");
        String property = parts[0].trim();
        if (property.isEmpty()) {
            property = "name";
        }
        Sort.Direction direction = Sort.Direction.ASC;
        if (parts.length > 1) {
            String dir = parts[1].trim().toLowerCase();
            if (dir.startsWith("desc")) {
                direction = Sort.Direction.DESC;
            }
        }
        return Sort.by(direction, property);
    }
}

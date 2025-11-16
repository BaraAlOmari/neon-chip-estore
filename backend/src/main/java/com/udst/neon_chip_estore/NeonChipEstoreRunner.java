package com.udst.neon_chip_estore;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import com.udst.neon_chip_estore.model.Product;
import com.udst.neon_chip_estore.repository.ProductRepository;

@Component
public class NeonChipEstoreRunner implements CommandLineRunner {

    private final ProductRepository productRepository;

    public NeonChipEstoreRunner(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public void run(String... args) {
        if (productRepository.count() > 0) {
            return;
        }

        List<Product> products = new ArrayList<>();

        Product p1 = new Product();
        p1.setName("AULA F75 Pro Wireless Mechanical Keyboard");
        p1.setDescription("AULA F75 Pro Wireless Mechanical Keyboard, Swappable Custom Keyboard with Knob,RGB Backlit,Pre-lubed Reaper Switches,Side Printed PBT Keycaps,2.4GHz/USB-C/BT5.0 Mechanical Gaming Keyboards");
        p1.setImageUrl("https://m.media-amazon.com/images/I/61MC8BK0w0L._AC_SL1500_.jpg");
        p1.setCategory("Keyboards");
        p1.setPrice(new BigDecimal("68.99"));
        p1.setStock(250);
        products.add(p1);

        Product p2 = new Product();
        p2.setName("Logitech G502 X Plus Wireless Gaming Mouse");
        p2.setDescription("Logitech G502 X Plus Wireless Gaming Mouse LIGHTSPEED Optical, LIGHTFORCE Switches, LIGHTSYNC RGB, HERO 25K Sensor for PC/Mac - Black");
        p2.setImageUrl("https://m.media-amazon.com/images/I/61A0MX5s2xL._AC_SX466_.jpg");
        p2.setCategory("Mice");
        p2.setPrice(new BigDecimal("129.99"));
        p2.setStock(60);
        products.add(p2);

        Product p3 = new Product();
        p3.setName("Corsair M65 Ultra");
        p3.setDescription("Corsair M65 RGB Ultra Tunable FPS Gaming Mouse Marksman 26,000 DPI Optical Sensor, Optical Switches, AXON Hyper-Processing Technology, Sensor Fusion Control, Tunable Weight System - Black");
        p3.setImageUrl("https://m.media-amazon.com/images/I/61lUrCmjygL._AC_SY879_.jpg");
        p3.setCategory("Mice");
        p3.setPrice(new BigDecimal("89.99"));
        p3.setStock(150);
        products.add(p3);

        Product p4 = new Product();
        p4.setName("Logitech G309");
        p4.setDescription("Logitech G309 Lightspeed Wireless Gaming Mouse, Lightweight, LIGHTFORCE Switches, Hero 25K Sensor, 300+ hr Battery, 6 Programmable Buttons, PC & Mac - White");
        p4.setImageUrl("https://m.media-amazon.com/images/I/513v6JKpbkL._AC_SX466_.jpg");
        p4.setCategory("Mice");
        p4.setPrice(new BigDecimal("49.99"));
        p4.setStock(110);
        products.add(p4);

        Product p5 = new Product();
        p5.setName("Corsair K55 RGB PRO");
        p5.setDescription("Corsair K55 RGB PRO Membrane Wired Gaming Keyboard – IP42 Dust and Spill-Resistant – 6 Macro Keys with Elgato Integration – iCUE Compatible – QWERTY NA – PC, Mac, Xbox – Black");
        p5.setImageUrl("https://m.media-amazon.com/images/I/81XDJ20fJ+L._SX522_.jpg");
        p5.setCategory("Keyboards");
        p5.setPrice(new BigDecimal("79.99"));
        p5.setStock(200);
        products.add(p5);

        Product p6 = new Product();
        p6.setName("HyperX Cloud III");
        p6.setDescription("HyperX Cloud III – Wired Gaming Headset, PC, PS5, Xbox Series X|S, Angled 53mm Drivers, DTS Spatial Audio, Memory Foam, Durable Frame, Ultra-Clear 10mm Mic, USB-C, USB-A, 3.5mm – Black");
        p6.setImageUrl("https://m.media-amazon.com/images/I/81dkzD4hxIL._AC_SX466_.jpg");
        p6.setCategory("Headsets & Microphones");
        p6.setPrice(new BigDecimal("129.99"));
        p6.setStock(60);
        products.add(p6);

        Product p7 = new Product();
        p7.setName("Sony WH-CH520");
        p7.setDescription("Sony WH-CH520 Wireless Headphones Bluetooth On-Ear Headset with Microphone and up to 50 Hours Battery Life with Quick Charging, Black");
        p7.setImageUrl("https://m.media-amazon.com/images/I/41lArSiD5hL._AC_SX466_.jpg");
        p7.setCategory("Headsets & Microphones");
        p7.setPrice(new BigDecimal("69.99"));
        p7.setStock(90);
        products.add(p7);

        Product p8 = new Product();
        p8.setName("Samsung 870 EVO SATA III SSD 1TB");
        p8.setDescription("Samsung 870 EVO SATA III SSD 1TB 2.5” Internal Solid State Drive, Upgrade PC or Laptop Memory and Storage for IT Pros, Creators, Everyday Users, MZ-77E1T0B/AM");
        p8.setImageUrl("https://m.media-amazon.com/images/I/911ujeCkGfL._AC_SX466_.jpg");
        p8.setCategory("Storage");
        p8.setPrice(new BigDecimal("99.99"));
        p8.setStock(220);
        products.add(p8);

        Product p9 = new Product();
        p9.setName("Corsair MM350 PRO");
        p9.setDescription("Corsair MM350 PRO Premium Spill-Proof Cloth Gaming Mouse Pad – Extended XL - Black");
        p9.setImageUrl("https://m.media-amazon.com/images/I/21wpUBC0a+L._AC_SX466_.jpg");
        p9.setCategory("Mouse Pads");
        p9.setPrice(new BigDecimal("39.99"));
        p9.setStock(175);
        products.add(p9);

        Product p10 = new Product();
        p10.setName("Logitech Mouse Pad");
        p10.setDescription("Logitech Mouse Pad - Studio Series, Computer Mouse Mat with Anti-Slip Rubber Base, Easy Gliding, Spill-Resistant Surface, Durable Materials, Portable, in a Fresh Modern Design, Graphite");
        p10.setImageUrl("https://m.media-amazon.com/images/I/81WQsjtppYL._AC_SX466_.jpg");
        p10.setCategory("Mouse Pads");
        p10.setPrice(new BigDecimal("9.99"));
        p10.setStock(80);
        products.add(p10);

        productRepository.saveAll(products);
    }
}

package com.udst.neon_chip_estore;

import java.math.BigDecimal;
import java.math.RoundingMode;
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

                products.add(new Product(
                                null,
                                "AULA F75 Pro Wireless Mechanical Keyboard",
                                "AULA F75 Pro Wireless Mechanical Keyboard, Swappable Custom Keyboard with Knob,RGB Backlit,Pre-lubed Reaper Switches,Side Printed PBT Keycaps,2.4GHz/USB-C/BT5.0 Mechanical Gaming Keyboards",
                                "https://m.media-amazon.com/images/I/61MC8BK0w0L._AC_SL1500_.jpg",
                                "Keyboards",
                                price("68.99"),
                                discount("68.99"),
                                250,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Logitech G502 X Plus Wireless Gaming Mouse",
                                "Logitech G502 X Plus Wireless Gaming Mouse LIGHTSPEED Optical, LIGHTFORCE Switches, LIGHTSYNC RGB, HERO 25K Sensor for PC/Mac - Black",
                                "https://m.media-amazon.com/images/I/61A0MX5s2xL._AC_SX466_.jpg",
                                "Mice",
                                price("129.99"),
                                discount("129.99"),
                                60,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Corsair M65 Ultra",
                                "Corsair M65 RGB Ultra Tunable FPS Gaming Mouse Marksman 26,000 DPI Optical Sensor, Optical Switches, AXON Hyper-Processing Technology, Sensor Fusion Control, Tunable Weight System - Black",
                                "https://m.media-amazon.com/images/I/61lUrCmjygL._AC_SY879_.jpg",
                                "Mice",
                                price("89.99"),
                                discount("89.99"),
                                150,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Logitech G309",
                                "Logitech G309 Lightspeed Wireless Gaming Mouse, Lightweight, LIGHTFORCE Switches, Hero 25K Sensor, 300+ hr Battery, 6 Programmable Buttons, PC & Mac - White",
                                "https://m.media-amazon.com/images/I/513v6JKpbkL._AC_SX466_.jpg",
                                "Mice",
                                price("49.99"),
                                discount("49.99"),
                                110,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Corsair K55 RGB PRO",
                                "Corsair K55 RGB PRO Membrane Wired Gaming Keyboard – IP42 Dust and Spill-Resistant – 6 Macro Keys with Elgato Integration – iCUE Compatible – QWERTY NA – PC, Mac, Xbox – Black",
                                "https://m.media-amazon.com/images/I/81XDJ20fJ+L._SX522_.jpg",
                                "Keyboards",
                                price("79.99"),
                                discount("79.99"),
                                200,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "HyperX Cloud III",
                                "HyperX Cloud III – Wired Gaming Headset, PC, PS5, Xbox Series X|S, Angled 53mm Drivers, DTS Spatial Audio, Memory Foam, Durable Frame, Ultra-Clear 10mm Mic, USB-C, USB-A, 3.5mm – Black",
                                "https://m.media-amazon.com/images/I/81dkzD4hxIL._AC_SX466_.jpg",
                                "Headsets & Microphones",
                                price("129.99"),
                                discount("129.99"),
                                60,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Sony WH-CH520",
                                "Sony WH-CH520 Wireless Headphones Bluetooth On-Ear Headset with Microphone and up to 50 Hours Battery Life with Quick Charging, Black",
                                "https://m.media-amazon.com/images/I/41lArSiD5hL._AC_SX466_.jpg",
                                "Headsets & Microphones",
                                price("69.99"),
                                discount("69.99"),
                                90,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Samsung 870 EVO SATA III SSD 1TB",
                                "Samsung 870 EVO SATA III SSD 1TB 2.5” Internal Solid State Drive, Upgrade PC or Laptop Memory and Storage for IT Pros, Creators, Everyday Users, MZ-77E1T0B/AM",
                                "https://m.media-amazon.com/images/I/911ujeCkGfL._AC_SX466_.jpg",
                                "Storage",
                                price("99.99"),
                                discount("99.99"),
                                220,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Corsair MM350 PRO",
                                "Corsair MM350 PRO Premium Spill-Proof Cloth Gaming Mouse Pad – Extended XL - Black",
                                "https://m.media-amazon.com/images/I/21wpUBC0a+L._AC_SX466_.jpg",
                                "Mouse Pads",
                                price("39.99"),
                                discount("39.99"),
                                175,
                                null,
                                null));

                products.add(new Product(
                                null,
                                "Logitech Mouse Pad",
                                "Logitech Mouse Pad - Studio Series, Computer Mouse Mat with Anti-Slip Rubber Base, Easy Gliding, Spill-Resistant Surface, Durable Materials, Portable, in a Fresh Modern Design, Graphite",
                                "https://m.media-amazon.com/images/I/81WQsjtppYL._AC_SX466_.jpg",
                                "Mouse Pads",
                                price("9.99"),
                                discount("9.99"),
                                80,
                                null,
                                null));

                productRepository.saveAll(products);
        }

        private static BigDecimal price(String value) {
                return new BigDecimal(value);
        }

        private static BigDecimal discount(String original) {
                return new BigDecimal(original)
                                .multiply(new BigDecimal("0.7"))
                                .setScale(2, RoundingMode.HALF_UP);
        }
}

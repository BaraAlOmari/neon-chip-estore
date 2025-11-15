package com.udst.neon_chip_estore.config;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.udst.neon_chip_estore.model.Product;
import com.udst.neon_chip_estore.repository.ProductRepository;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner seedProducts(ProductRepository repo) {
        return args -> {
            if (repo.count() == 0) {
                Product kbd = new Product();
                kbd.setName("Neon RGB Mechanical Keyboard K95");
                kbd.setDescription("Hot-swappable switches, per-key RGB, aluminum frame.");
                kbd.setCategory("Keyboards");
                kbd.setImageUrl("https://example.com/images/keyboard-k95.png");
                kbd.setPrice(new BigDecimal("149.99"));
                kbd.setStock(80);

                Product mouse = new Product();
                mouse.setName("Nebula Gaming Mouse G703");
                mouse.setDescription("26K DPI sensor, ultra-light, PrismGlow underglow.");
                mouse.setCategory("Mice");
                mouse.setImageUrl("https://example.com/images/mouse-g703.png");
                mouse.setPrice(new BigDecimal("69.99"));
                mouse.setStock(150);

                Product headset = new Product();
                headset.setName("Aurora RGB Headset HX-7");
                headset.setDescription("7.1 surround, detachable mic, soft memory foam.");
                headset.setCategory("Audio");
                headset.setImageUrl("https://example.com/images/headset-hx7.png");
                headset.setPrice(new BigDecimal("89.99"));
                headset.setStock(120);

                Product fans = new Product();
                fans.setName("Vortex 120mm RGB Fan (3-Pack)");
                fans.setDescription("Hydraulic bearing, daisy-chain ARGB with neon glow.");
                fans.setCategory("Cooling");
                fans.setImageUrl("https://example.com/images/fans-vortex-3pack.png");
                fans.setPrice(new BigDecimal("39.99"));
                fans.setStock(200);

                Product strip = new Product();
                strip.setName("Spectra LED Strip 2m");
                strip.setDescription("Addressable ARGB strip, adhesive backing, hub included.");
                strip.setCategory("Lighting");
                strip.setImageUrl("https://example.com/images/led-strip-2m.png");
                strip.setPrice(new BigDecimal("24.99"));
                strip.setStock(300);

                repo.saveAll(List.of(kbd, mouse, headset, fans, strip));
            }
        };
    }
}

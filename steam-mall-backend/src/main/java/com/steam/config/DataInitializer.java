package com.steam.config;

import com.steam.entity.User;
import com.steam.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // 查找 admin 账号
        User admin = userRepository.findByUsername("admin").orElse(null);

        if (admin != null && admin.getRole().equals("ADMIN")) {
            // 检查密码是否已加密（BCrypt 加密的密码以 $2a$ 开头）
            if (!admin.getPassword().startsWith("$2a$")) {
                // 密码是明文，需要加密
                admin.setPassword(passwordEncoder.encode("admin123"));
                userRepository.save(admin);
                System.out.println("✅ Admin password encrypted successfully!");
                System.out.println("   You can now login with: admin / admin123");
            }
        }
    }
}
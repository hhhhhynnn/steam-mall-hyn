package com.steam.service;

import com.steam.entity.User;
import com.steam.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthenticatedUserService {

    private final UserRepository userRepository;

    public Long getCurrentUserId(UserDetails userDetails) {
        if (userDetails == null) {
            throw new RuntimeException("请先登录");
        }

        User user = userRepository.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("用户不存在"));
        return user.getId();
    }
}

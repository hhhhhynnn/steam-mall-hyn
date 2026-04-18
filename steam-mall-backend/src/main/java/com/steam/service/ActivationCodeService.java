package com.steam.service;

import com.steam.entity.ActivationCode;
import com.steam.entity.UserGame;
import com.steam.repository.ActivationCodeRepository;
import com.steam.repository.UserGameRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class ActivationCodeService {

    private final ActivationCodeRepository activationCodeRepository;
    private final UserGameRepository userGameRepository;

    private static final String CHARSET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final SecureRandom RANDOM = new SecureRandom();

    /**
     * 生成激活码
     */
    @Transactional
    public ActivationCode generateCode(Long gameId, String gameName, Long orderId) {
        String code;
        do {
            code = generateRandomCode();
        } while (activationCodeRepository.existsByCode(code));

        ActivationCode activationCode = new ActivationCode();
        activationCode.setCode(code);
        activationCode.setGameId(gameId);
        activationCode.setGameName(gameName);
        activationCode.setOrderId(orderId);
        activationCode.setStatus(0);
        activationCode.setExpireTime(LocalDateTime.now().plusYears(10));

        return activationCodeRepository.save(activationCode);
    }

    /**
     * 激活激活码
     */
    @Transactional
    public ActivationCode activateCode(String code, Long userId) {
        ActivationCode activationCode = activationCodeRepository.findByCode(code)
                .orElseThrow(() -> new RuntimeException("激活码不存在"));

        if (activationCode.getStatus() != 0) {
            throw new RuntimeException("激活码已使用或已过期");
        }

        if (activationCode.getExpireTime() != null &&
                activationCode.getExpireTime().isBefore(LocalDateTime.now())) {
            activationCode.setStatus(2);
            activationCodeRepository.save(activationCode);
            throw new RuntimeException("激活码已过期");
        }

        // 检查用户是否已拥有该游戏
        boolean exists = userGameRepository.existsByUserIdAndGameId(userId, activationCode.getGameId());
        if (exists) {
            throw new RuntimeException("您已拥有该游戏");
        }

        // 添加到用户游戏库
        UserGame userGame = new UserGame();
        userGame.setUserId(userId);
        userGame.setGameId(activationCode.getGameId());
        userGame.setActivationCode(code);
        userGame.setIsActivated(1);
        userGame.setActivatedAt(LocalDateTime.now());
        userGameRepository.save(userGame);

        // 更新激活码状态
        activationCode.setStatus(1);
        activationCode.setUserId(userId);
        activationCode.setActivatedAt(LocalDateTime.now());
        activationCodeRepository.save(activationCode);

        // 删除已使用的激活码，防止二次使用
        activationCodeRepository.delete(activationCode);

        return activationCode;
    }

    /**
     * 验证激活码
     */
    public boolean validateCode(String code) {
        return activationCodeRepository.findByCode(code)
                .map(ac -> ac.getStatus() == 0 &&
                        (ac.getExpireTime() == null || ac.getExpireTime().isAfter(LocalDateTime.now())))
                .orElse(false);
    }

    /**
     * 生成随机激活码（格式：XXXX-XXXX-XXXX-XXXX）
     */
    private String generateRandomCode() {
        StringBuilder code = new StringBuilder();

        for (int i = 0; i < 16; i++) {
            if (i > 0 && i % 4 == 0) {
                code.append("-");
            }
            code.append(CHARSET.charAt(RANDOM.nextInt(CHARSET.length())));
        }

        return code.toString();
    }
}
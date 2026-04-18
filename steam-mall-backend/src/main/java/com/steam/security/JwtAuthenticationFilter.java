package com.steam.security;

import com.steam.config.JwtConfig;
import com.steam.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
@Slf4j
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final UserDetailsService userDetailsService;
    private final JwtConfig jwtConfig;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {
        final String authHeader = request.getHeader(jwtConfig.getHeader());
        String jwt = null;
        String username = null;

        if (!StringUtils.hasText(authHeader) || !authHeader.startsWith(jwtConfig.getPrefix())) {
            filterChain.doFilter(request, response);
            return;
        }

        // 提取 JWT Token
        jwt = authHeader.substring(jwtConfig.getPrefix().length());
        
        // 验证 JWT Token 格式，去除可能的空格
        if (StringUtils.hasText(jwt)) {
            jwt = jwt.trim();
        }
        
        // 如果 Token 为空或包含空格，跳过验证
        if (!StringUtils.hasText(jwt) || jwt.contains(" ")) {
            log.warn("Invalid JWT token format: {}", jwt);
            filterChain.doFilter(request, response);
            return;
        }
        
        try {
            username = jwtUtil.extractUsername(jwt);
        } catch (Exception e) {
            log.warn("Failed to parse JWT token: {}", e.getMessage());
            filterChain.doFilter(request, response);
            return;
        }

        if (StringUtils.hasText(username) && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);

            if (jwtUtil.validateToken(jwt, userDetails)) {
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities()
                );
                authToken.setDetails(
                        new WebAuthenticationDetailsSource().buildDetails(request)
                );
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }

        filterChain.doFilter(request, response);
    }
}

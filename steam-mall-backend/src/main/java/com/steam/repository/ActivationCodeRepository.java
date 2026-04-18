package com.steam.repository;

import com.steam.entity.ActivationCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ActivationCodeRepository extends JpaRepository<ActivationCode, Long> {
    Optional<ActivationCode> findByCode(String code);
    boolean existsByCode(String code);

    @Modifying
    @Query("DELETE FROM ActivationCode ac WHERE ac.status = 1")
    void deleteUsedCodes();
}
package com.steam.service;

import com.aliyun.oss.OSS;
import com.aliyun.oss.model.PutObjectRequest;
import com.steam.config.OssConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OssService {

    private final OSS ossClient;
    private final OssConfig ossConfig;

    private static final List<String> ALLOWED_IMAGE_TYPES = Arrays.asList(
            "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    );

    private static final List<String> ALLOWED_VIDEO_TYPES = Arrays.asList(
            "video/mp4", "video/avi", "video/mov", "video/mkv"
    );

    private static final long MAX_IMAGE_SIZE = 10 * 1024 * 1024; 
    private static final long MAX_VIDEO_SIZE = 100 * 1024 * 1024; 

    public String uploadImage(MultipartFile file) throws IOException {
        validateFile(file, ALLOWED_IMAGE_TYPES, MAX_IMAGE_SIZE);
        return uploadFile(file, "images/");
    }

    public String uploadVideo(MultipartFile file) throws IOException {
        validateFile(file, ALLOWED_VIDEO_TYPES, MAX_VIDEO_SIZE);
        return uploadFile(file, "videos/");
    }

    private String uploadFile(MultipartFile file, String folder) throws IOException {
        String originalFilename = file.getOriginalFilename();
        String extension = originalFilename != null ? 
                originalFilename.substring(originalFilename.lastIndexOf(".")) : "";
        String objectName = folder + UUID.randomUUID().toString() + extension;

        try (InputStream inputStream = new ByteArrayInputStream(file.getBytes())) {
            PutObjectRequest putObjectRequest = new PutObjectRequest(
                    ossConfig.getBucketName(), objectName, inputStream);
            ossClient.putObject(putObjectRequest);
        }

        return ossConfig.getBaseUrl() + "/" + objectName;
    }

    private void validateFile(MultipartFile file, List<String> allowedTypes, long maxSize) {
        String contentType = file.getContentType();
        if (contentType == null || !allowedTypes.contains(contentType.toLowerCase())) {
            throw new IllegalArgumentException("不支持的文件类型：" + contentType);
        }

        if (file.getSize() > maxSize) {
            throw new IllegalArgumentException("文件大小超过限制：" + maxSize / 1024 / 1024 + "MB");
        }
    }

    public void deleteFile(String fileUrl) {
        if (fileUrl != null && fileUrl.startsWith(ossConfig.getBaseUrl())) {
            String objectName = fileUrl.substring(ossConfig.getBaseUrl().length() + 1);
            ossClient.deleteObject(ossConfig.getBucketName(), objectName);
        }
    }
}

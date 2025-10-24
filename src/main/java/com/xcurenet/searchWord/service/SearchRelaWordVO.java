package com.xcurenet.searchWord.service;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class SearchRelaWordVO {

    private MultipartFile attach;
    private String encoding;
    private String searchWord;
}

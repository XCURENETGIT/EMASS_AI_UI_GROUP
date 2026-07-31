package com.xcurenet.admin.service;

import lombok.Data;

import java.util.Date;

@Data
public class AdminMfaVO {

    private String adminId;

    private String reqId;

    private Date validEndTime;

}

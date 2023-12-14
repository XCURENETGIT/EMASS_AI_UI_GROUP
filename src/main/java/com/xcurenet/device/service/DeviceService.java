package com.xcurenet.device.service;

import java.util.List;

public interface DeviceService {

	/**
	 * 수집 장비 목록 조회
	 *
	 * @return
	 */
	public List<DeviceVO> getCollectionDevice();
	
	/**
	 * 수집 장비 목록 조회
	 *
	 * @return
	 */
	public List<DeviceVO> getCollectionDevice(final String searchStr);

	/**
	 * 전체 장비 목록 조회
	 *
	 * @param searchStr
	 * @param offset
	 * @param limit
	 * @return
	 */
	public List<DeviceVO> getDeviceList(final String searchStr, final String deviceType, final int offset, final int limit);

	/**
	 * 특정 장비 상세 조회 (deviceSeq 검색)
	 *
	 * @param deviceSeq
	 * @return
	 */
	public DeviceVO getDeviceInfo(final String deviceSeq);

	/**
	 * 특정 장비 상세 조회 (deviceIp 검색)
	 *
	 * @param deviceIp
	 * @return
	 */
	public DeviceVO getDeviceByIp(final String deviceIp);

	/**
	 * 장비가 이미 존재하는지 여부
	 *
	 * @param device
	 * @return
	 */
	public boolean isDeviceIpExist(final DeviceVO device);

	/**
	 * 장비 등록
	 *
	 * @param device
	 * @return
	 */
	public int insertDevice(final DeviceVO device);

	/**
	 * 장비 수정
	 *
	 * @param device
	 * @return
	 */
	public int updateDevice(final DeviceVO device);

	/**
	 * 장비 삭제
	 *
	 * @param device
	 * @return
	 */
	public int deleteDevice(final DeviceVO device);

	/**
	 * 장비 호스트 키 업데이트
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceHostKey(final DeviceVO device);

	/**
	 * UACS 룰 최근 갱신 일자
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceRuTime(final DeviceVO device);

	/**
	 * UACS 룰 갱신 시도 일자
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceRtTime(final DeviceVO device);

	/**
	 * UACS 최종 갱신 유무
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceRStatus(final DeviceVO device);

	/**
	 * UACS 차단 메시지 최근 갱신 일자
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceMtTime(final DeviceVO device);

	/**
	 * UACS 차단 메시지 갱신 시도 일자
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceMuTime(final DeviceVO device);

	/**
	 * UACS 차단 메시지 최종 갱신 유무
	 *
	 * @param device
	 * @return
	 */
	public int updateDeviceMStatus(final DeviceVO device);

}

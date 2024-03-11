package com.xcurenet.emass.analysis.service;

import java.util.ArrayList;
import java.util.List;

import com.xcurenet.common.util.Common;
import com.xcurenet.emass.message.service.SolrEdcVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class UsageChartScheduler {

	public List<UsageChartSchedulerVO> getData(List<SolrEdcVO> edcList, String lastTime) {
		List<UsageChartSchedulerVO> list = new ChartArrayList<UsageChartSchedulerVO>();
		for (SolrEdcVO edc : edcList) {
			String time = new StringBuilder().append(edc.getCtime_yyyymmdd()).append(edc.getCtime_hh()).toString();
			UsageChartSchedulerVO vo = new UsageChartSchedulerVO();
			vo.setCtime(time);
			list.add(getUnitValue(edc, vo));
		}

		if (edcList == null | edcList.size() == 0) {
			UsageChartSchedulerVO vo = new UsageChartSchedulerVO();
			vo.setCtime(lastTime);
			list.add(getUnitValue(null, vo));

		}
		return list;
	}

	public class ChartArrayList<E> extends ArrayList<E> {

		private static final long serialVersionUID = 1L;

		@Override
		public boolean add(E objectList) {
			boolean add = true;
			if (objectList instanceof UsageChartSchedulerVO) {
				UsageChartSchedulerVO vo = (UsageChartSchedulerVO) objectList;
				for (int i = 0; i < this.size(); i++) {
					UsageChartSchedulerVO thisVo = (UsageChartSchedulerVO) this.get(i);
					if (thisVo.getCtime().equals(vo.getCtime())) {
						thisVo.setFileSize(thisVo.getFileSize() + vo.getFileSize());
						thisVo.setFtp(thisVo.getFtp() + vo.getFtp());
						thisVo.setInMail(thisVo.getInMail() + vo.getInMail());
						thisVo.setOutMail(thisVo.getOutMail() + vo.getOutMail());
						thisVo.setTotalSize(thisVo.getTotalSize() + vo.getTotalSize());
						add = false;
						break;
					}
				}

				if (add) {
					boolean isAdd = true;
					for (int i = 0; i < this.size(); i++) {
						UsageChartSchedulerVO thisVo = (UsageChartSchedulerVO) this.get(i);
						if (thisVo.getCtime().compareTo(vo.getCtime()) > 0) {
							super.add(i, objectList);
							isAdd = false;
							break;
						}
					}
					if (isAdd) {
						super.add(objectList);
					}
				}
			} else {
				return false;
			}

			return true;
		}
	}


	private UsageChartSchedulerVO getUnitValue(SolrEdcVO edcVO, UsageChartSchedulerVO vo) {
		if (edcVO == null) {
			vo.setOutMail(0);
			vo.setFileSize(0);
			vo.setFtp(0);
			vo.setTotalSize(0);
		} else {
			String firstServiceCode = edcVO.getSvc().substring(0, 1);
			String ThirdServiceCode = edcVO.getSvc().substring(0, 3);

			if (firstServiceCode.equals("W")) {
				vo.setOutMail(1);
			}

			if (firstServiceCode.equals("M") || ThirdServiceCode.equals("EMM")) {
				vo.setInMail(1);
			}

			List<Long> sizes = edcVO.getAttachsize();
			long value = 0;
			if (sizes == null) {
				value = 0;
			} else {
				for (Long size : sizes) {
					value += size;
				}
			}
			vo.setFileSize(value);

			if (ThirdServiceCode.equals("FFT")) {
				vo.setFtp(edcVO.getSize());
			}
			vo.setTotalSize(edcVO.getSize());
		}
		return vo;
	}

}

package com.samsung.im.ws.fim701;

public class ReturnVo
{
  private String totalCnt;
  private String maxCnt;
  private String totalPage;
  private String rtnCd;
  private String errMsg;

  public String getTotalCnt()
  {
    return this.totalCnt;
  }

  public void setTotalCnt(String totalCnt)
  {
    this.totalCnt = totalCnt;
  }

  public String getMaxCnt()
  {
    return this.maxCnt;
  }

  public void setMaxCnt(String maxCnt)
  {
    this.maxCnt = maxCnt;
  }

  public String getTotalPage()
  {
    return this.totalPage;
  }

  public void setTotalPage(String totalPage)
  {
    this.totalPage = totalPage;
  }

  public String getRtnCd()
  {
    return this.rtnCd;
  }

  public void setRtnCd(String rtnCd)
  {
    this.rtnCd = rtnCd;
  }

  public String getErrMsg()
  {
    return this.errMsg;
  }

  public void setErrMsg(String errMsg)
  {
    this.errMsg = errMsg;
  }
}
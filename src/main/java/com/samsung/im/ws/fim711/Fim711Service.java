package com.samsung.im.ws.fim711;

import javax.jws.WebParam;
import javax.jws.WebService;

@WebService
public abstract interface Fim711Service
{
  public abstract Fim711OutData processData(@WebParam(name="TABLE") Fim711InData paramFim711InData);
}
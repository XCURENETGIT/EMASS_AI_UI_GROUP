package com.samsung.im.ws.fim701;

import javax.jws.WebParam;
import javax.jws.WebService;

@WebService
public abstract interface Fim701Service
{
  public abstract Fim701OutData processData(@WebParam(name="TABLE") Fim701InData paramFim701InData);
}
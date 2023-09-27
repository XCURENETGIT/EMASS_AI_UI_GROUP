package com.samsung.im.ws.fim702;

import javax.jws.WebParam;
import javax.jws.WebService;

@WebService
public abstract interface Fim702Service
{
  public abstract Fim702OutData processData(@WebParam(name="TABLE") Fim702InData paramFim702InData);
}
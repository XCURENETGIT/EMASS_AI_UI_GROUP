package com.samsung.im.ws.fim712;

import javax.jws.WebParam;
import javax.jws.WebService;

@WebService
public abstract interface Fim712Service
{
  public abstract Fim712OutData processData(@WebParam(name="TABLE") Fim712InData paramFim712InData);
}
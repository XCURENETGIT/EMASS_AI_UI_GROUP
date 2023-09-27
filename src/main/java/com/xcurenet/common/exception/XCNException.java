package com.xcurenet.common.exception;

public class XCNException extends Exception
{
	/**
	 * Serialized Version ID
	 */
	private static final long serialVersionUID = -1610327590477971486L;

	protected String message = null;

	@Override
	public String getMessage ( )
	{
		return message;
	}

	public void setMessage ( String message )
	{
		this.message = message;
	}

	protected XCNException( )
	{
		super ( );
	}

	public XCNException ( String message )
	{
		this.message = message;
	}

}

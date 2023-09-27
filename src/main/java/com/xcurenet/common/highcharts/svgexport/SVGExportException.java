
package com.xcurenet.common.highcharts.svgexport;

/**
 *
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
public class SVGExportException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public SVGExportException(Throwable cause) {
		super(cause);
	}

	public SVGExportException(String message, Throwable cause) {
		super(message, cause);
	}

	public SVGExportException(String message) {
		super(message);
	}

	public SVGExportException() {
	}

}

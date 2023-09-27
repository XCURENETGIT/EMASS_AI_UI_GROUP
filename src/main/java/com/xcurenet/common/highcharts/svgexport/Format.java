
package com.xcurenet.common.highcharts.svgexport;

import org.apache.batik.transcoder.Transcoder;
import org.apache.batik.transcoder.image.JPEGTranscoder;
import org.apache.batik.transcoder.image.PNGTranscoder;
import org.apache.batik.transcoder.image.TIFFTranscoder;

/**
 *
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
public enum Format {
	JPEG("image/jpeg", "jpg", JPEGTranscoder.class), PNG("image/png", "png", PNGTranscoder.class), SVG("image/svg+xml", "svg", SVGTranscoder.class), TIFF("image/tiff", "tiff", TIFFTranscoder.class);

	private final String contentType, fileNameExtension;
	private final Class<? extends Transcoder> transcoder;

	private Format(String contentType, String fileNameExtension, Class<? extends Transcoder> transcoder) {
		this.contentType = contentType;
		this.fileNameExtension = fileNameExtension;
		this.transcoder = transcoder;
	}

	public String getContentType() {
		return contentType;
	}

	public String getFileNameExtension() {
		return fileNameExtension;
	}

	public Class<? extends Transcoder> getTranscoder() {
		return transcoder;
	}

	public Transcoder getTranscoderInstance() {
		try {
			return transcoder.newInstance();
		} catch (InstantiationException ex) {
			throw new SVGExportException(ex);
		} catch (IllegalAccessException ex) {
			throw new SVGExportException(ex);
		}
	}
}

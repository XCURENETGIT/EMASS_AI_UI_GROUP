package com.xcurenet.emass.message.component;

import java.io.IOException;
import java.io.InputStream;

public class AttachFile {

	public AttachFile(final String path, final String harPath) throws Exception {
	}

	private boolean fileExist() throws IOException {
		return true;
	}

	private boolean harFileExist() throws IOException {
		return false;
	}

	public boolean exist() throws IOException {
		return true;
	}

	public InputStream open() throws IOException {
		return null;
	}

	public boolean upload(String content) {
		return false;
	}
}

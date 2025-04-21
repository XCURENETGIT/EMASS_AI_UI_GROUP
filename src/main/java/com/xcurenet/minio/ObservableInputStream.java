package com.xcurenet.minio;

import lombok.extern.log4j.Log4j2;

import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

@Log4j2
public class ObservableInputStream extends FilterInputStream {
    private final Runnable onClose;

    public ObservableInputStream(InputStream in, Runnable onClose) {
        super(in);
        this.onClose = onClose;
    }

    @Override
    public void close() throws IOException {
        super.close();
        if (onClose != null) {
            onClose.run();
        }
    }
}
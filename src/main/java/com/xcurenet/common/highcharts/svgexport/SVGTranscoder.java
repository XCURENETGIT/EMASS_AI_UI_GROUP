
package com.xcurenet.common.highcharts.svgexport;

import org.apache.batik.transcoder.SVGAbstractTranscoder;

/**
 *
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
public class SVGTranscoder extends SVGAbstractTranscoder {
//
//    @Override
//    protected void transcode(Document document, String uri,
//            TranscoderOutput output) throws TranscoderException {
//        try {
//            super.transcode(document, uri, output);
//
//            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
//            Source xmlSource = new DOMSource(document);
//            Result outputTarget = new StreamResult(outputStream);
//            TransformerFactory.newInstance().newTransformer().
//                    transform(xmlSource, outputTarget);
//            InputStream inputStream;
//            inputStream = new ByteArrayInputStream(outputStream.toByteArray());
//
//            IOUtils.copy(inputStream, output.getOutputStream());
//        } catch (IOException ex) {
//            throw new SVGExportException(ex);
//        } catch (TransformerException ex) {
//            throw new SVGExportException(ex);
//        }
//    }

}

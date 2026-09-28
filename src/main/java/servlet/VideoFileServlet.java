package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class VideoFileServlet extends HttpServlet {

    private static final String VIDEO_DIRECTORY
            = "C:/ENM_FAD_VIDEO/videos";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String fileName
                = request.getParameter("file");

        if (fileName == null
                || fileName.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "File video mancante"
            );

            return;
        }


        /*
         * Evitiamo che venga passato un percorso
         * arbitrario al server.
         */
        if (fileName.contains("..")
                || fileName.contains("/")
                || fileName.contains("\\")) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Nome file non valido"
            );

            return;
        }

        Path videoPath
                = Paths.get(
                        VIDEO_DIRECTORY,
                        fileName
                );

        if (!Files.exists(videoPath)
                || !Files.isRegularFile(videoPath)) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Video non trovato"
            );

            return;
        }

        String contentType
                = Files.probeContentType(videoPath);

        if (contentType == null) {

            contentType
                    = "application/octet-stream";
        }

        response.setContentType(
                contentType
        );

        long fileLength
                = Files.size(videoPath);


        /*
         * ======================================================
         * RANGE REQUEST
         * ======================================================
         *
         * Il browser può richiedere soltanto una parte
         * del video.
         */
        String range
                = request.getHeader("Range");

        if (range == null
                || !range.startsWith("bytes=")) {

            response.setHeader(
                    "Content-Length",
                    String.valueOf(fileLength)
            );

            response.setHeader(
                    "Accept-Ranges",
                    "bytes"
            );

            try (
                    InputStream input
                    = Files.newInputStream(videoPath); OutputStream output
                    = response.getOutputStream()) {

                byte[] buffer
                        = new byte[8192];

                int bytesRead;

                while ((bytesRead
                        = input.read(buffer)) != -1) {

                    output.write(
                            buffer,
                            0,
                            bytesRead
                    );
                }
            }

            return;
        }


        /*
         * ======================================================
         * PARSING RANGE
         * ======================================================
         */
        String rangeValue
                = range.substring(
                        "bytes=".length()
                );

        String[] rangeParts
                = rangeValue.split("-");

        long start
                = Long.parseLong(
                        rangeParts[0]
                );

        long end
                = fileLength - 1;

        if (rangeParts.length > 1
                && !rangeParts[1].isBlank()) {

            end
                    = Long.parseLong(
                            rangeParts[1]
                    );
        }

        if (start < 0
                || start >= fileLength
                || end < start) {

            response.setStatus(
                    HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE
            );

            response.setHeader(
                    "Content-Range",
                    "bytes */" + fileLength
            );

            return;
        }

        if (end >= fileLength) {

            end
                    = fileLength - 1;
        }

        long contentLength
                = end - start + 1;

        response.setStatus(
                HttpServletResponse.SC_PARTIAL_CONTENT
        );

        response.setHeader(
                "Accept-Ranges",
                "bytes"
        );

        response.setHeader(
                "Content-Range",
                "bytes "
                + start
                + "-"
                + end
                + "/"
                + fileLength
        );

        response.setHeader(
                "Content-Length",
                String.valueOf(
                        contentLength
                )
        );


        /*
         * ======================================================
         * STREAM
         * ======================================================
         */
        try (
                InputStream input
                = Files.newInputStream(videoPath); OutputStream output
                = response.getOutputStream()) {

            input.skip(start);

            byte[] buffer
                    = new byte[8192];

            long remaining
                    = contentLength;

            while (remaining > 0) {

                int bytesRead
                        = input.read(
                                buffer,
                                0,
                                (int) Math.min(
                                        buffer.length,
                                        remaining
                                )
                        );

                if (bytesRead == -1) {
                    break;
                }

                output.write(
                        buffer,
                        0,
                        bytesRead
                );

                remaining
                        -= bytesRead;
            }
        }
    }
}

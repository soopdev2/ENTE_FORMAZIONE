package servlet;

import jakarta.servlet.ServletException;
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

    private static final String VIDEO_DIRECTORY = "C:/ENTE_VIDEO/videos";

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");

        if (fileName == null || fileName.isBlank()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "File video mancante");

            return;
        }

        if (!fileName.matches("[a-zA-Z0-9._-]+")) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Nome file non valido");

            return;
        }

        Path videoDirectory = Paths.get(
                VIDEO_DIRECTORY)
                .toAbsolutePath()
                .normalize();

        Path videoPath = videoDirectory
                .resolve(fileName)
                .normalize();

        if (!videoPath.startsWith(videoDirectory)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Percorso file non valido");

            return;
        }

        if (!Files.isRegularFile(videoPath)) {

            response.sendError(
                    404,
                    "Video non trovato: " + videoPath
            );

            return;
        }

        String contentType = Files.probeContentType(videoPath);

        if (contentType == null) {

            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);

        long fileLength = Files.size(videoPath);

        String range = request.getHeader("Range");

        if (range == null
                || !range.startsWith("bytes=")) {

            response.setStatus(
                    HttpServletResponse.SC_OK);

            response.setHeader(
                    "Accept-Ranges",
                    "bytes");

            response.setHeader(
                    "Content-Length",
                    String.valueOf(fileLength));

            streamFile(
                    videoPath,
                    0,
                    fileLength,
                    response);

            return;
        }

        String rangeValue = range.substring("bytes=".length());

        if (rangeValue.contains(",")) {

            response.setStatus(
                    HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);

            response.setHeader(
                    "Content-Range",
                    "bytes */" + fileLength);

            return;
        }

        String[] rangeParts = rangeValue.split("-", -1);

        if (rangeParts.length != 2) {

            response.setStatus(
                    HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);

            response.setHeader(
                    "Content-Range",
                    "bytes */" + fileLength);

            return;
        }

        long start;

        long end;

        try {

            if (!rangeParts[0].isBlank()) {

                start = Long.parseLong(
                        rangeParts[0]);

                if (!rangeParts[1].isBlank()) {

                    end = Long.parseLong(
                            rangeParts[1]);

                } else {

                    end = fileLength - 1;
                }

            } else {

                long suffixLength = Long.parseLong(rangeParts[1]);

                if (suffixLength <= 0) {

                    response.setStatus(
                            HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);

                    response.setHeader(
                            "Content-Range",
                            "bytes */" + fileLength);

                    return;
                }

                if (suffixLength > fileLength) {

                    suffixLength = fileLength;
                }

                start = fileLength - suffixLength;

                end = fileLength - 1;
            }

        } catch (NumberFormatException e) {

            response.setStatus(
                    HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);

            response.setHeader(
                    "Content-Range",
                    "bytes */" + fileLength);

            return;
        }

        if (fileLength <= 0
                || start < 0
                || start >= fileLength
                || end < start) {

            response.setStatus(
                    HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);

            response.setHeader(
                    "Content-Range",
                    "bytes */" + fileLength);

            return;
        }

        if (end >= fileLength) {

            end = fileLength - 1;
        }

        long contentLength = end - start + 1;

        response.setStatus(
                HttpServletResponse.SC_PARTIAL_CONTENT);

        response.setHeader(
                "Accept-Ranges",
                "bytes");

        response.setHeader(
                "Content-Range",
                "bytes "
                + start
                + "-"
                + end
                + "/"
                + fileLength);

        response.setHeader(
                "Content-Length",
                String.valueOf(contentLength));

        streamFile(
                videoPath,
                start,
                contentLength,
                response);
    }

    private void streamFile(
            Path videoPath,
            long start,
            long length,
            HttpServletResponse response)
            throws IOException {

        try (
                InputStream input = Files.newInputStream(videoPath); OutputStream output = response.getOutputStream()) {

            long remainingToSkip = start;

            while (remainingToSkip > 0) {

                long skipped = input.skip(remainingToSkip);

                if (skipped > 0) {

                    remainingToSkip -= skipped;

                } else {

                    if (input.read() == -1) {
                        return;
                    }

                    remainingToSkip--;
                }
            }

            byte[] buffer = new byte[8192];

            long remaining = length;

            while (remaining > 0) {

                int bytesToRead = (int) Math.min(
                        buffer.length,
                        remaining);

                int bytesRead = input.read(
                        buffer,
                        0,
                        bytesToRead);

                if (bytesRead == -1) {
                    break;
                }

                output.write(
                        buffer,
                        0,
                        bytesRead);

                remaining -= bytesRead;
            }

            output.flush();
        }
    }
}

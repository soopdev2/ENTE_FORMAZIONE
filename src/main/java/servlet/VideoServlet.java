/**
 *
 * @author Aldo
 */
package servlet;

import entity.Video;
import service.VideoService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import java.io.IOException;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 500L * 1024 * 1024,
        maxRequestSize = 500L * 1024 * 1024
)

public class VideoServlet extends HttpServlet {

    private static final String VIDEO_DIRECTORY
            = "C:/ENTE_VIDEO/videos";

    private final VideoService videoService
            = new VideoService();

    protected void processRequest(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action
                = request.getParameter("action");

        if (action == null
                || action.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Action mancante"
            );

            return;
        }

        try {

            switch (action) {

                case "create":
                    createVideo(
                            request,
                            response
                    );
                    break;

                case "get":
                    getVideo(
                            request,
                            response
                    );
                    break;

                case "list":
                    getAllVideos(
                            request,
                            response
                    );
                    break;

                case "listByModulo":
                    getVideoModulo(
                            request,
                            response
                    );
                    break;

                case "update":
                    updateVideo(
                            request,
                            response
                    );
                    break;

                case "delete":
                    deleteVideo(
                            request,
                            response
                    );
                    break;

                case "activate":
                    activateVideo(
                            request,
                            response
                    );
                    break;

                case "deactivate":
                    deactivateVideo(
                            request,
                            response
                    );
                    break;

                default:

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Action non valida"
                    );
            }

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage()
            );

        } catch (ServletException | IOException e) {

            getServletContext().log(
                    "Errore VideoServlet",
                    e
            );

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Errore interno del server"
            );
        }
    }

    private void createVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException, ServletException {

        Long moduloId
                = parseLong(
                        request.getParameter("moduloId"),
                        "ID modulo obbligatorio"
                );

        String titolo
                = request.getParameter("titolo");

        String descrizione
                = request.getParameter("descrizione");

        Integer ordine
                = parseInteger(
                        request.getParameter("ordine"),
                        "Ordine obbligatorio"
                );

        Part videoPart
                = request.getPart("video");

        if (videoPart == null
                || videoPart.getSize() <= 0) {

            throw new IllegalArgumentException(
                    "File video obbligatorio"
            );
        }

        String contentType
                = videoPart.getContentType();

        if (contentType == null
                || !contentType.startsWith("video/")) {

            throw new IllegalArgumentException(
                    "Il file selezionato non è un video"
            );
        }

        String nomeOriginale
                = Paths.get(
                        videoPart.getSubmittedFileName()
                )
                        .getFileName()
                        .toString();

        String estensione = "";

        int ultimoPunto
                = nomeOriginale.lastIndexOf(".");

        if (ultimoPunto > 0) {

            estensione
                    = nomeOriginale.substring(
                            ultimoPunto
                    );
        }

        String nomeFile
                = UUID.randomUUID()
                        .toString()
                + estensione;

        Path cartellaVideo
                = Paths.get(
                        VIDEO_DIRECTORY
                );

        Files.createDirectories(
                cartellaVideo
        );

        Path fileDestinazione
                = cartellaVideo.resolve(
                        nomeFile
                );

        videoPart.write(
                fileDestinazione.toString()
        );

        Long durataSecondi
                = videoService.getDurataVideo(
                        fileDestinazione
                );

        String filePath
                = "/videos/"
                + nomeFile;

        Video video
                = videoService.creaVideo(
                        moduloId,
                        titolo,
                        descrizione,
                        filePath,
                        durataSecondi,
                        ordine
                );

        response.sendRedirect(
                "VideoServlet?action=listByModulo"
                + "&moduloId="
                + video.getModulo().getId()
        );
    }

    private void getVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID video obbligatorio"
                );

        Video video
                = videoService.getVideo(id);

        request.setAttribute(
                "video",
                video
        );

        // --> JSP
        request.getRequestDispatcher(
                "/page/admin/video/dettaglio.jsp"
        ).forward(
                request,
                response
        );
    }

    private void getAllVideos(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Video> video
                = videoService.getAllVideos();

        request.setAttribute(
                "video",
                video
        );

        // --> JSP
        request.getRequestDispatcher(
                "/page/admin/video/lista.jsp"
        ).forward(
                request,
                response
        );
    }

    private void getVideoModulo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Long moduloId
                = parseLong(
                        request.getParameter("moduloId"),
                        "ID modulo obbligatorio"
                );

        List<Video> video
                = videoService.getVideoModulo(
                        moduloId
                );

        request.setAttribute(
                "video",
                video
        );

        request.setAttribute(
                "moduloId",
                moduloId
        );

        // --> JSP
        request.getRequestDispatcher(
                "/page/admin/video/lista.jsp"
        ).forward(
                request,
                response
        );
    }

    private void updateVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long videoId
                = parseLong(
                        request.getParameter("id"),
                        "ID video obbligatorio"
                );

        Long moduloId
                = parseLong(
                        request.getParameter("moduloId"),
                        "ID modulo obbligatorio"
                );

        String titolo
                = request.getParameter("titolo");

        String descrizione
                = request.getParameter("descrizione");

        String filePath
                = request.getParameter("filePath");

        Long durataSecondi
                = parseLong(
                        request.getParameter("durataSecondi"),
                        "Durata video obbligatoria"
                );

        Integer ordine
                = parseInteger(
                        request.getParameter("ordine"),
                        "Ordine obbligatorio"
                );

        Video video
                = videoService.aggiornaVideo(
                        videoId,
                        moduloId,
                        titolo,
                        descrizione,
                        filePath,
                        durataSecondi,
                        ordine
                );

        response.sendRedirect(
                "VideoServlet?action=get&id="
                + video.getId()
        );
    }

    private void deleteVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID video obbligatorio"
                );

        Video video
                = videoService.getVideo(id);

        Long moduloId
                = video.getModulo().getId();

        videoService.deleteVideo(id);

        response.sendRedirect(
                "VideoServlet?action=listByModulo"
                + "&moduloId="
                + moduloId
        );
    }

    private void activateVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID video obbligatorio"
                );

        Video video
                = videoService.attivaVideo(id);

        response.sendRedirect(
                "VideoServlet?action=get&id="
                + video.getId()
        );
    }

    private void deactivateVideo(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Long id
                = parseLong(
                        request.getParameter("id"),
                        "ID video obbligatorio"
                );

        Video video
                = videoService.disattivaVideo(id);

        response.sendRedirect(
                "VideoServlet?action=get&id="
                + video.getId()
        );
    }

    private Long parseLong(
            String value,
            String message) {

        if (value == null
                || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    message
            );
        }

        try {

            return Long.valueOf(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Valore numerico non valido"
            );
        }
    }

    private Integer parseInteger(
            String value,
            String message) {

        if (value == null
                || value.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    message
            );
        }

        try {

            return Integer.valueOf(
                    value.trim()
            );

        } catch (NumberFormatException e) {

            throw new IllegalArgumentException(
                    "Valore numerico non valido"
            );
        }
    }

   
// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

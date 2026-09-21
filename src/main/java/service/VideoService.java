package service;

import entity.Modulo;
import entity.Video;
import repositories.VideoRepository;

import java.time.LocalDateTime;
import java.util.List;
import repositories.ModuloRepository;

/**
 *
 * @author Aldo
 */
public class VideoService {

    private final VideoRepository videoRepository;
    private final ModuloRepository moduloRepository;

    public VideoService() {

        this.videoRepository
                = new VideoRepository();

        this.moduloRepository
                = new ModuloRepository();
    }

    public Video creaVideo(
            Long moduloId,
            String titolo,
            String descrizione,
            String filePath,
            Long durataSecondi,
            Integer ordine) {

        Modulo modulo = getModulo(moduloId);

        validaDatiVideo(
                titolo,
                filePath,
                durataSecondi,
                ordine
        );

        Video video = new Video();

        video.setTitolo(
                titolo.trim()
        );

        video.setDescrizione(
                descrizione != null
                        ? descrizione.trim()
                        : null
        );

        video.setFilePath(
                filePath.trim()
        );

        video.setDurataSecondi(
                durataSecondi
        );

        video.setOrdine(
                ordine
        );

        video.setAttivo(true);

        video.setDataCreazione(
                LocalDateTime.now()
        );

        video.setModulo(
                modulo
        );

        return videoRepository.save(video);
    }

    public Video aggiornaVideo(
            Long videoId,
            Long moduloId,
            String titolo,
            String descrizione,
            String filePath,
            Long durataSecondi,
            Integer ordine) {

        Video video = getVideo(videoId);

        Modulo modulo = getModulo(moduloId);

        validaDatiVideo(
                titolo,
                filePath,
                durataSecondi,
                ordine
        );

        video.setTitolo(
                titolo.trim()
        );

        video.setDescrizione(
                descrizione != null
                        ? descrizione.trim()
                        : null
        );

        video.setFilePath(
                filePath.trim()
        );

        video.setDurataSecondi(
                durataSecondi
        );

        video.setOrdine(
                ordine
        );

        video.setModulo(
                modulo
        );

        return videoRepository.save(video);
    }

    public Video getVideo(Long videoId) {

        if (videoId == null) {

            throw new IllegalArgumentException(
                    "ID video obbligatorio"
            );
        }

        return videoRepository.findById(videoId)
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Video non trovato"
                        )
                );
    }

    public List<Video> getAllVideos() {

        return videoRepository.findAll();
    }

    public List<Video> getActiveVideos() {

        return videoRepository.findAllActive();
    }

    public List<Video> getVideoModulo(
            Long moduloId) {

        getModulo(moduloId);

        return videoRepository.findByModulo(
                moduloId
        );
    }

    public List<Video> getVideoAttiviModulo(
            Long moduloId) {

        getModulo(moduloId);

        return videoRepository.findActiveByModulo(
                moduloId
        );
    }

    public void deleteVideo(Long videoId) {

        Video video = getVideo(videoId);

        videoRepository.delete(
                video
        );
    }

    public Video disattivaVideo(
            Long videoId) {

        Video video = getVideo(videoId);

        video.setAttivo(false);

        return videoRepository.save(
                video
        );
    }

    public Video attivaVideo(
            Long videoId) {

        Video video = getVideo(videoId);

        video.setAttivo(true);

        return videoRepository.save(
                video
        );
    }

    private Modulo getModulo(
            Long moduloId) {

        if (moduloId == null) {

            throw new IllegalArgumentException(
                    "ID modulo obbligatorio"
            );
        }

        Modulo modulo
                = moduloRepository.findById(
                        moduloId
                );

        if (modulo == null) {

            throw new IllegalArgumentException(
                    "Modulo non trovato"
            );
        }

        return modulo;
    }

    private void validaDatiVideo(
            String titolo,
            String filePath,
            Long durataSecondi,
            Integer ordine) {

        if (titolo == null
                || titolo.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Il titolo è obbligatorio"
            );
        }

        if (filePath == null
                || filePath.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Il percorso del video è obbligatorio"
            );
        }

        if (durataSecondi == null
                || durataSecondi <= 0) {

            throw new IllegalArgumentException(
                    "La durata deve essere maggiore di zero"
            );
        }

        if (ordine == null
                || ordine <= 0) {

            throw new IllegalArgumentException(
                    "L'ordine deve essere maggiore di zero"
            );
        }
    }
}

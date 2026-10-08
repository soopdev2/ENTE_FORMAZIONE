package service;

import Utility.JpaUtil;
import entity.SessioneVideo;
import entity.StatoVideo;
import entity.User;
import entity.UserVideo;
import entity.Video;
import jakarta.persistence.EntityManager;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import repositories.UserVideoRepository;
import repositories.UserRepository;
import repositories.VideoRepository;
import repositories.SessioneVideoRepository;

/**
 *
 * @author Aldo
 */
public class UserVideoService {

    private final UserVideoRepository userVideoRepository;
    private final UserRepository userRepository;
    private final VideoRepository videoRepository;
    private final SessioneVideoRepository sessioneVideoRepository;
    private final UserCorsoService userCorsoService;

    public UserVideoService() {

        this.userVideoRepository
                = new UserVideoRepository();

        this.userRepository
                = new UserRepository();

        this.videoRepository
                = new VideoRepository();

        this.sessioneVideoRepository
                = new SessioneVideoRepository();

        this.userCorsoService
                = new UserCorsoService();
    }

    public UserVideo assegnaVideo(
            Long userId,
            Long videoId) {

        User user = getUser(userId);

        if (user == null) {

            throw new IllegalArgumentException(
                    "Utente non trovato"
            );
        }

        Video video = getVideo(videoId);

        verificaAccessoCorso(
                userId,
                video
        );

        Optional<UserVideo> esistente
                = userVideoRepository.findByUserAndVideo(
                        userId,
                        videoId
                );

        if (esistente.isPresent()) {

            return esistente.get();
        }

        UserVideo userVideo = new UserVideo();

        userVideo.setUser(user);

        userVideo.setVideo(video);

        userVideo.setStato(
                StatoVideo.DA_GUARDARE
        );

        userVideo.setSecondiGuardati(
                0L
        );

        userVideo.setUltimaPosizione(
                0L
        );

        userVideo.setPercentuale(
                0.0
        );

        return userVideoRepository.save(
                userVideo
        );
    }

    public void assegnaModulo(
            Long userId,
            Long moduloId) {

        getUser(userId);

        if (moduloId == null) {

            throw new IllegalArgumentException(
                    "ID modulo obbligatorio"
            );
        }

        List<Video> video
                = videoRepository.findActiveByModulo(
                        moduloId
                );

        for (Video v : video) {

            assegnaVideo(
                    userId,
                    v.getId()
            );
        }
    }

    public UserVideo getUserVideo(
            Long userId,
            Long videoId) {

        return userVideoRepository
                .findByUserAndVideo(
                        userId,
                        videoId
                )
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Video non assegnato all'utente"
                        )
                );
    }

    public List<UserVideo> getUserVideos(
            Long userId) {

        User user = getUser(userId);

        if (user == null) {

            throw new IllegalArgumentException(
                    "Utente non trovato"
            );
        }

        return userVideoRepository.findByUser(
                userId
        );
    }

    public List<UserVideo> getVideoUsers(
            Long videoId) {

        getVideo(videoId);

        return userVideoRepository.findByVideo(
                videoId
        );
    }

    public boolean isVideoSbloccato(
            Long userId,
            Long videoId) {

        UserVideo userVideo
                = getUserVideo(
                        userId,
                        videoId
                );

        Video video
                = userVideo.getVideo();

        if (video == null) {

            return false;
        }

        verificaAccessoCorso(
                userId,
                video
        );

        if (!Boolean.TRUE.equals(
                video.getAttivo()
        )) {

            return false;
        }

        Optional<Video> precedente
                = videoRepository.findPrecedente(
                        video
                );

        if (precedente.isEmpty()) {

            return true;
        }

        Optional<UserVideo> progressoPrecedente
                = userVideoRepository.findByUserAndVideo(
                        userId,
                        precedente.get().getId()
                );

        if (progressoPrecedente.isEmpty()) {

            return false;
        }

        return progressoPrecedente.get()
                .getStato()
                == StatoVideo.COMPLETATO;
    }

    public UserVideo iniziaVideo(
            Long userId,
            Long videoId,
            Long posizione) {

        if (posizione == null || posizione < 0) {

            throw new IllegalArgumentException(
                    "Posizione non valida"
            );
        }

        UserVideo userVideo
                = getUserVideo(
                        userId,
                        videoId
                );

        if (!isVideoSbloccato(
                userId,
                videoId
        )) {

            throw new IllegalStateException(
                    "Il video non è ancora sbloccato"
            );
        }

        if (userVideo.getStato()
                == StatoVideo.COMPLETATO) {

            return userVideo;
        }

        Optional<SessioneVideo> sessioneAperta
                = sessioneVideoRepository
                        .findSessioneAperta(
                                userVideo.getId()
                        );

        if (sessioneAperta.isPresent()) {

            throw new IllegalStateException(
                    "Esiste già una sessione aperta"
            );
        }

        userVideo.setStato(
                StatoVideo.IN_CORSO
        );

        userVideo.setUltimaPosizione(
                posizione
        );

        userVideo.setUltimaVisualizzazione(
                LocalDateTime.now()
        );

        UserVideo salvato
                = userVideoRepository.save(
                        userVideo
                );

        /*
         * Nuova sessione.
         */
        SessioneVideo sessione
                = new SessioneVideo();

        sessione.setUserVideo(
                salvato
        );

        sessione.setInizio(
                LocalDateTime.now()
        );

        sessione.setPosizioneIniziale(
                posizione
        );

        sessione.setSecondiGuardati(
                0L
        );

        sessioneVideoRepository.save(
                sessione
        );

        return salvato;
    }

    public UserVideo aggiornaSessione(
            Long userId,
            Long videoId,
            Long posizione) {

        if (posizione == null || posizione < 0) {

            throw new IllegalArgumentException(
                    "Posizione non valida"
            );
        }

        UserVideo userVideo
                = getUserVideo(
                        userId,
                        videoId
                );

        if (userVideo.getStato()
                == StatoVideo.COMPLETATO) {

            return userVideo;
        }

        Optional<SessioneVideo> optionalSessione
                = sessioneVideoRepository
                        .findSessioneAperta(
                                userVideo.getId()
                        );

        if (optionalSessione.isEmpty()) {

            throw new IllegalStateException(
                    "Nessuna sessione di visione aperta"
            );
        }

        userVideo.setUltimaPosizione(
                posizione
        );

        userVideo.setUltimaVisualizzazione(
                LocalDateTime.now()
        );

        return userVideoRepository.save(
                userVideo
        );
    }

    public UserVideo mettiInPausa(
            Long userId,
            Long videoId,
            Long posizione) {

        if (posizione == null || posizione < 0) {

            throw new IllegalArgumentException(
                    "Posizione non valida"
            );
        }

        EntityManager em
                = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            UserVideo userVideo
                    = em.createQuery(
                            "SELECT uv FROM UserVideo uv "
                            + "JOIN FETCH uv.video v "
                            + "JOIN FETCH v.modulo m "
                            + "JOIN FETCH m.corso "
                            + "WHERE uv.user.id = :userId "
                            + "AND uv.video.id = :videoId",
                            UserVideo.class
                    )
                            .setParameter(
                                    "userId",
                                    userId
                            )
                            .setParameter(
                                    "videoId",
                                    videoId
                            )
                            .getResultStream()
                            .findFirst()
                            .orElseThrow(
                                    () -> new IllegalArgumentException(
                                            "Video non assegnato all'utente"
                                    )
                            );

            Optional<SessioneVideo> optionalSessione
                    = em.createQuery(
                            "SELECT s FROM SessioneVideo s "
                            + "WHERE s.userVideo.id = :userVideoId "
                            + "AND s.fine IS NULL "
                            + "ORDER BY s.inizio DESC",
                            SessioneVideo.class
                    )
                            .setParameter(
                                    "userVideoId",
                                    userVideo.getId()
                            )
                            .setMaxResults(1)
                            .getResultStream()
                            .findFirst();

            if (optionalSessione.isEmpty()) {

                userVideo.setUltimaPosizione(
                        posizione
                );

                UserVideo result
                        = em.merge(userVideo);

                em.getTransaction().commit();

                return result;
            }

            SessioneVideo sessione
                    = optionalSessione.get();

            LocalDateTime fine
                    = LocalDateTime.now();

            sessione.setFine(fine);

            sessione.setPosizioneFinale(
                    posizione
            );

            long secondi
                    = calcolaSecondi(
                            sessione.getInizio(),
                            fine
                    );

            sessione.setSecondiGuardati(
                    secondi
            );

            em.merge(sessione);

            long totale
                    = userVideo.getSecondiGuardati()
                    + secondi;

            Video video
                    = userVideo.getVideo();

            totale = Math.min(
                    totale,
                    video.getDurataSecondi()
            );

            userVideo.setSecondiGuardati(
                    totale
            );

            userVideo.setUltimaPosizione(
                    posizione
            );

            userVideo.setUltimaVisualizzazione(
                    fine
            );

            aggiornaPercentuale(
                    userVideo
            );

            if (totale >= video.getDurataSecondi()) {

                userVideo.setStato(
                        StatoVideo.COMPLETATO
                );

                userVideo.setDataCompletamento(
                        fine
                );

            } else {

                userVideo.setStato(
                        StatoVideo.IN_CORSO
                );
            }

            UserVideo result
                    = em.merge(userVideo);

            em.getTransaction().commit();

            return result;

        } catch (Exception e) {

            if (em.getTransaction().isActive()) {

                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            em.close();
        }
    }

    public UserVideo completaVideo(
            Long userId,
            Long videoId,
            Long posizione) {

        if (posizione == null || posizione < 0) {

            throw new IllegalArgumentException(
                    "Posizione non valida"
            );
        }

        EntityManager em
                = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            UserVideo userVideo
                    = em.createQuery(
                            "SELECT uv FROM UserVideo uv "
                            + "JOIN FETCH uv.video v "
                            + "JOIN FETCH v.modulo m "
                            + "JOIN FETCH m.corso "
                            + "WHERE uv.user.id = :userId "
                            + "AND uv.video.id = :videoId",
                            UserVideo.class
                    )
                            .setParameter(
                                    "userId",
                                    userId
                            )
                            .setParameter(
                                    "videoId",
                                    videoId
                            )
                            .getResultStream()
                            .findFirst()
                            .orElseThrow(
                                    () -> new IllegalArgumentException(
                                            "Video non assegnato all'utente"
                                    )
                            );

            Video video
                    = userVideo.getVideo();

            if (!isVideoSbloccato(
                    userId,
                    videoId
            )) {

                throw new IllegalStateException(
                        "Il video non è ancora sbloccato"
                );
            }

            if (video.getDurataSecondi() == null
                    || video.getDurataSecondi() <= 0) {

                throw new IllegalStateException(
                        "Durata video non valida"
                );
            }

            if (posizione < video.getDurataSecondi()) {

                throw new IllegalStateException(
                        "Il video non è ancora terminato"
                );
            }

            Optional<SessioneVideo> optionalSessione
                    = em.createQuery(
                            "SELECT s FROM SessioneVideo s "
                            + "WHERE s.userVideo.id = :userVideoId "
                            + "AND s.fine IS NULL "
                            + "ORDER BY s.inizio DESC",
                            SessioneVideo.class
                    )
                            .setParameter(
                                    "userVideoId",
                                    userVideo.getId()
                            )
                            .setMaxResults(1)
                            .getResultStream()
                            .findFirst();

            if (optionalSessione.isPresent()) {

                SessioneVideo sessione
                        = optionalSessione.get();

                LocalDateTime fine
                        = LocalDateTime.now();

                sessione.setFine(
                        fine
                );

                sessione.setPosizioneFinale(
                        video.getDurataSecondi()
                );

                long secondi
                        = calcolaSecondi(
                                sessione.getInizio(),
                                fine
                        );

                sessione.setSecondiGuardati(
                        secondi
                );

                em.merge(sessione);
            }

            LocalDateTime completamento
                    = LocalDateTime.now();

            userVideo.setSecondiGuardati(
                    video.getDurataSecondi()
            );

            userVideo.setUltimaPosizione(
                    video.getDurataSecondi()
            );

            userVideo.setPercentuale(
                    100.0
            );

            userVideo.setStato(
                    StatoVideo.COMPLETATO
            );

            userVideo.setUltimaVisualizzazione(
                    completamento
            );

            userVideo.setDataCompletamento(
                    completamento
            );

            UserVideo result
                    = em.merge(userVideo);

            em.getTransaction().commit();

            return result;

        } catch (IllegalStateException e) {

            if (em.getTransaction().isActive()) {

                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            em.close();
        }
    }

    private void aggiornaPercentuale(
            UserVideo userVideo) {

        Video video
                = userVideo.getVideo();

        if (video.getDurataSecondi() == null
                || video.getDurataSecondi() <= 0) {

            userVideo.setPercentuale(
                    0.0
            );

            return;
        }

        double percentuale
                = (userVideo.getSecondiGuardati()
                * 100.0)
                / video.getDurataSecondi();

        percentuale
                = Math.min(
                        100.0,
                        Math.max(
                                0.0,
                                percentuale
                        )
                );

        userVideo.setPercentuale(
                percentuale
        );
    }

    private long calcolaSecondi(
            LocalDateTime inizio,
            LocalDateTime fine) {

        if (inizio == null || fine == null) {

            return 0L;
        }

        long secondi
                = Duration.between(
                        inizio,
                        fine
                ).getSeconds();

        return Math.max(
                0L,
                secondi
        );
    }

    private User getUser(
            Long userId) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "ID utente obbligatorio"
            );
        }

        return userRepository.findById(
                userId
        );
    }

    private Video getVideo(
            Long videoId) {

        if (videoId == null) {

            throw new IllegalArgumentException(
                    "ID video obbligatorio"
            );
        }

        return videoRepository
                .findById(videoId)
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Video non trovato"
                        )
                );
    }

    private void verificaAccessoCorso(
            Long userId,
            Video video) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "ID utente obbligatorio"
            );
        }

        if (video == null
                || video.getModulo() == null
                || video.getModulo().getCorso() == null) {

            throw new IllegalStateException(
                    "Il video non è associato correttamente a un corso"
            );
        }

        Long corsoId
                = video.getModulo()
                        .getCorso()
                        .getId();

        if (userCorsoService.getUserCorso(
                userId,
                corsoId
        ) == null) {

            throw new IllegalStateException(
                    "L'utente non è assegnato al corso"
            );
        }
    }
}

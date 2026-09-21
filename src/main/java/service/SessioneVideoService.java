/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Aldo
 */
package service;

import entity.SessioneVideo;
import entity.UserVideo;
import jakarta.persistence.EntityManager;
import repositories.SessioneVideoRepository;
import repositories.UserVideoRepository;

import java.time.LocalDateTime;

import java.util.Optional;

public class SessioneVideoService {

    private final SessioneVideoRepository sessioneRepository;
    private final UserVideoRepository userVideoRepository;

    public SessioneVideoService() {

        this.sessioneRepository
                = new SessioneVideoRepository();

        this.userVideoRepository
                = new UserVideoRepository();
    }

    //nuova visione di sessione
    public SessioneVideo iniziaSessione(
            Long userVideoId,
            Long posizione) {

        if (userVideoId == null) {
            throw new IllegalArgumentException(
                    "ID UserVideo obbligatorio"
            );
        }

        if (posizione == null || posizione < 0) {
            throw new IllegalArgumentException(
                    "Posizione non valida"
            );
        }

        UserVideo userVideo
                = userVideoRepository.findById(userVideoId)
                        .orElseThrow(()
                                -> new IllegalArgumentException(
                                "UserVideo non trovato"
                        )
                        );

        //controllo sessione aperta presente
        Optional<SessioneVideo> aperta
                = sessioneRepository.findSessioneAperta(
                        userVideoId
                );

        if (aperta.isPresent()) {
            throw new IllegalStateException(
                    "Esiste già una sessione di visione aperta"
            );
        }

        SessioneVideo sessione
                = new SessioneVideo();

        sessione.setUserVideo(userVideo);

        sessione.setInizio(
                LocalDateTime.now()
        );

        sessione.setPosizioneIniziale(
                posizione
        );

        sessione.setSecondiGuardati(0L);

        return sessioneRepository.save(sessione);
    }

    // chiude sessione in corso
    public SessioneVideo chiudiSessione(
            Long userVideoId,
            Long posizioneFinale,
            Long secondiGuardati) {

        if (userVideoId == null) {
            throw new IllegalArgumentException(
                    "ID UserVideo obbligatorio"
            );
        }

        if (posizioneFinale == null
                || posizioneFinale < 0) {

            throw new IllegalArgumentException(
                    "Posizione finale non valida"
            );
        }

        if (secondiGuardati == null
                || secondiGuardati < 0) {

            throw new IllegalArgumentException(
                    "Tempo guardato non valido"
            );
        }

        SessioneVideo sessione
                = sessioneRepository
                        .findSessioneAperta(userVideoId)
                        .orElseThrow(()
                                -> new IllegalStateException(
                                "Nessuna sessione aperta"
                        )
                        );

        sessione.setFine(
                LocalDateTime.now()
        );

        sessione.setPosizioneFinale(
                posizioneFinale
        );

        sessione.setSecondiGuardati(
                secondiGuardati
        );

        return sessioneRepository.save(sessione);
    }

    //recupera sessione aperta
    public Optional<SessioneVideo> getSessioneAperta(
            Long userVideoId) {

        if (userVideoId == null) {
            throw new IllegalArgumentException(
                    "ID UserVideo obbligatorio"
            );
        }

        return sessioneRepository.findSessioneAperta(
                userVideoId
        );
    }

    public SessioneVideo save(
            EntityManager em,
            SessioneVideo sessione) {

        return em.merge(sessione);
    }

    public UserVideo save(
            EntityManager em,
            UserVideo userVideo) {

        return em.merge(userVideo);
    }

}

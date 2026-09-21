package service;

import entity.Corso;
import entity.Modulo;
import entity.User;
import entity.UserCorso;
import entity.UserVideo;
import entity.Video;
import entity.StatoVideo;
import repositories.CorsoRepository;
import repositories.ModuloRepository;
import repositories.UserCorsoRepository;
import repositories.UserRepository;
import repositories.UserVideoRepository;
import repositories.VideoRepository;

import java.util.List;

public class UserCorsoService {

    private final UserCorsoRepository userCorsoRepository;
    private final UserRepository userRepository;
    private final CorsoRepository corsoRepository;

    private final ModuloRepository moduloRepository;
    private final VideoRepository videoRepository;
    private final UserVideoRepository userVideoRepository;

    public UserCorsoService() {

        this.userCorsoRepository
                = new UserCorsoRepository();

        this.userRepository
                = new UserRepository();

        this.corsoRepository
                = new CorsoRepository();

        this.moduloRepository
                = new ModuloRepository();

        this.videoRepository
                = new VideoRepository();

        this.userVideoRepository
                = new UserVideoRepository();
    }

    public void assegnaCorso(
            Long userId,
            Long corsoId
    ) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "ID utente obbligatorio"
            );
        }

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }

        User user
                = userRepository.findById(userId);

        if (user == null) {

            throw new IllegalArgumentException(
                    "Utente non trovato"
            );
        }

        Corso corso
                = corsoRepository.findById(corsoId);

        if (corso == null) {

            throw new IllegalArgumentException(
                    "Corso non trovato"
            );
        }

        if (!Boolean.TRUE.equals(corso.getAttivo())) {

            throw new IllegalStateException(
                    "Non è possibile assegnare un corso disattivato"
            );
        }

        UserCorso esistente
                = userCorsoRepository.findByUserAndCorso(
                        userId,
                        corsoId
                );

        if (esistente != null) {

            throw new IllegalStateException(
                    "Il corso è già assegnato a questo utente"
            );
        }

        UserCorso userCorso
                = new UserCorso();

        userCorso.setUser(user);

        userCorso.setCorso(corso);

        userCorsoRepository.save(userCorso);

        List<Modulo> moduli
                = moduloRepository.findByCorso(corsoId);

        for (Modulo modulo : moduli) {

            if (!Boolean.TRUE.equals(modulo.getAttivo())) {
                continue;
            }

            List<Video> video
                    = videoRepository.findActiveByModulo(
                            modulo.getId()
                    );

            for (Video v : video) {

                if (userVideoRepository.findByUserAndVideo(
                        userId,
                        v.getId()
                ).isPresent()) {

                    continue;
                }

                UserVideo userVideo
                        = new UserVideo();

                userVideo.setUser(user);

                userVideo.setVideo(v);

                userVideo.setStato(
                        StatoVideo.DA_GUARDARE
                );

                userVideo.setSecondiGuardati(0L);

                userVideo.setUltimaPosizione(0L);

                userVideo.setPercentuale(0.0);

                userVideoRepository.save(userVideo);
            }
        }
    }

    public UserCorso getUserCorso(Long id) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "ID assegnazione obbligatorio"
            );
        }

        return userCorsoRepository.findById(id);
    }

    public UserCorso getUserCorso(
            Long userId,
            Long corsoId
    ) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "ID utente obbligatorio"
            );
        }

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }

        return userCorsoRepository.findByUserAndCorso(
                userId,
                corsoId
        );
    }

    public List<UserCorso> getCorsiUtente(
            Long userId
    ) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "ID utente obbligatorio"
            );
        }

        return userCorsoRepository.findByUser(
                userId
        );
    }

    public List<UserCorso> getUtentiCorso(
            Long corsoId
    ) {

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }

        return userCorsoRepository.findByCorso(
                corsoId
        );
    }

    public void rimuoviAssegnazione(
            Long userId,
            Long corsoId
    ) {

        if (userId == null) {

            throw new IllegalArgumentException(
                    "ID utente obbligatorio"
            );
        }

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }

        UserCorso userCorso
                = userCorsoRepository.findByUserAndCorso(
                        userId,
                        corsoId
                );

        if (userCorso == null) {

            throw new IllegalArgumentException(
                    "Assegnazione non trovata"
            );
        }

        userCorsoRepository.delete(
                userCorso
        );
    }

    public void aggiornaUserCorso(
            Long id,
            entity.StatoCorso stato,
            Double percentuale
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "ID assegnazione obbligatorio"
            );
        }

        UserCorso userCorso
                = userCorsoRepository.findById(id);

        if (userCorso == null) {

            throw new IllegalArgumentException(
                    "Assegnazione non trovata"
            );
        }

        if (stato == null) {

            throw new IllegalArgumentException(
                    "Stato obbligatorio"
            );
        }

        if (percentuale == null
                || percentuale < 0
                || percentuale > 100) {

            throw new IllegalArgumentException(
                    "Percentuale non valida"
            );
        }

        userCorso.setStato(stato);

        userCorso.setPercentuale(percentuale);

        userCorsoRepository.update(
                userCorso
        );
    }
}

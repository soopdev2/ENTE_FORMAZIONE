package service;

import entity.Corso;
import repositories.CorsoRepository;

import java.util.List;

public class CorsoService {

    private final CorsoRepository corsoRepository;


    public CorsoService() {

        this.corsoRepository =
                new CorsoRepository();
    }


    public Long creaCorso(
            String titolo,
            String descrizione
    ) {

        if (titolo == null
                || titolo.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Il titolo del corso è obbligatorio"
            );
        }


        Corso corso = new Corso();


        corso.setTitolo(
                titolo.trim()
        );


        corso.setDescrizione(
                descrizione != null
                        ? descrizione.trim()
                        : null
        );


        corso.setAttivo(true);


        corsoRepository.save(corso);


        return corso.getId();
    }


    public Corso getCorso(Long id) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }


        return corsoRepository.findById(id);
    }


    public List<Corso> getAllCorsi() {

        return corsoRepository.findAll();
    }


    public List<Corso> getCorsiAttivi() {

        return corsoRepository.findAttivi();
    }


    public void aggiornaCorso(
            Long id,
            String titolo,
            String descrizione
    ) {

        if (id == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }


        if (titolo == null
                || titolo.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Il titolo del corso è obbligatorio"
            );
        }


        Corso corso =
                corsoRepository.findById(id);


        if (corso == null) {

            throw new IllegalArgumentException(
                    "Corso non trovato"
            );
        }


        corso.setTitolo(
                titolo.trim()
        );


        corso.setDescrizione(
                descrizione != null
                        ? descrizione.trim()
                        : null
        );


        corsoRepository.update(corso);
    }


    public void disattivaCorso(Long id) {

        Corso corso =
                getCorso(id);


        if (corso == null) {

            throw new IllegalArgumentException(
                    "Corso non trovato"
            );
        }


        corso.setAttivo(false);


        corsoRepository.update(corso);
    }


    public void attivaCorso(Long id) {

        Corso corso =
                getCorso(id);


        if (corso == null) {

            throw new IllegalArgumentException(
                    "Corso non trovato"
            );
        }


        corso.setAttivo(true);


        corsoRepository.update(corso);
    }
}
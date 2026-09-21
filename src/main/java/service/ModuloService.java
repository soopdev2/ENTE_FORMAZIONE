package service;

import entity.Corso;
import entity.Modulo;

import java.util.List;
import repositories.CorsoRepository;

import repositories.ModuloRepository;
/**
 *
 * @author Aldo
 */
public class ModuloService {

    private final ModuloRepository moduloRepository;
    private final CorsoRepository corsoRepository;

    public ModuloService() {

        this.moduloRepository = new ModuloRepository();
        this.corsoRepository = new CorsoRepository();
    }

    public Modulo creaModulo(
            String titolo,
            String descrizione,
            Long corsoId
    ) {

        validaTitolo(titolo);

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "Il corso è obbligatorio"
            );
        }

        Corso corso
                = corsoRepository.findById(corsoId);

        if (corso == null) {

            throw new IllegalArgumentException(
                    "Corso non trovato"
            );
        }

        Modulo modulo = new Modulo();

        modulo.setTitolo(
                titolo.trim()
        );

        modulo.setDescrizione(
                descrizione != null
                        ? descrizione.trim()
                        : null
        );

        modulo.setAttivo(true);

        modulo.setCorso(corso);

        return moduloRepository.save(modulo);
    }

    public Modulo aggiornaModulo(
            Long moduloId,
            String titolo,
            String descrizione,
            Long corsoId
    ) {

        Modulo modulo
                = getModulo(moduloId);

        if (modulo == null) {

            throw new IllegalArgumentException(
                    "Modulo non trovato"
            );
        }

        validaTitolo(titolo);

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "Il corso è obbligatorio"
            );
        }

        Corso corso
                = corsoRepository.findById(corsoId);

        if (corso == null) {

            throw new IllegalArgumentException(
                    "Corso non trovato"
            );
        }

        modulo.setTitolo(
                titolo.trim()
        );

        modulo.setDescrizione(
                descrizione != null
                        ? descrizione.trim()
                        : null
        );

        modulo.setCorso(corso);

        return moduloRepository.save(modulo);
    }

    public Modulo getModulo(Long moduloId) {

        if (moduloId == null) {

            throw new IllegalArgumentException(
                    "ID modulo obbligatorio"
            );
        }

        return moduloRepository.findById(
                moduloId
        );
    }

    public List<Modulo> getAllModuli() {

        return moduloRepository.findAll();
    }

    public List<Modulo> getModuliAttivi() {

        return moduloRepository.findAllActive();
    }

    public List<Modulo> getModuliCorso(
            Long corsoId
    ) {

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }

        return moduloRepository.findByCorso(
                corsoId
        );
    }

    public List<Modulo> getModuliAttiviCorso(
            Long corsoId
    ) {

        if (corsoId == null) {

            throw new IllegalArgumentException(
                    "ID corso obbligatorio"
            );
        }

        return moduloRepository.findActiveByCorso(
                corsoId
        );
    }

    public Modulo disattivaModulo(
            Long moduloId
    ) {

        Modulo modulo
                = getModulo(moduloId);

        if (modulo == null) {

            throw new IllegalArgumentException(
                    "Modulo non trovato"
            );
        }

        modulo.setAttivo(false);

        return moduloRepository.save(
                modulo
        );
    }

    public Modulo attivaModulo(
            Long moduloId
    ) {

        Modulo modulo
                = getModulo(moduloId);

        if (modulo == null) {

            throw new IllegalArgumentException(
                    "Modulo non trovato"
            );
        }

        modulo.setAttivo(true);

        return moduloRepository.save(
                modulo
        );
    }

    private void validaTitolo(
            String titolo
    ) {

        if (titolo == null
                || titolo.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Il titolo del modulo è obbligatorio"
            );
        }
    }
}

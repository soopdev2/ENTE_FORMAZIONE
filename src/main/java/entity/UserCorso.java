package entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(
    name = "user_corso",
    uniqueConstraints = {
        @UniqueConstraint(
            columnNames = {"user_id", "corso_id"}
        )
    }
)
public class UserCorso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
        name = "user_id",
        nullable = false
    )
    private User user;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(
        name = "corso_id",
        nullable = false
    )
    private Corso corso;

    @Column(
        name = "data_assegnazione",
        nullable = false
    )
    private LocalDateTime dataAssegnazione;


    @Enumerated(EnumType.STRING)
    @Column(
        nullable = false,
        length = 30
    )
    
    private StatoCorso stato;


    @Column(
        nullable = false
    )
    private Double percentuale = 0.0;


    @Column(
        name = "data_completamento"
    )
    private LocalDateTime dataCompletamento;


    public UserCorso() {
    }


    @PrePersist
    protected void onCreate() {

        if (dataAssegnazione == null) {

            dataAssegnazione =
                    LocalDateTime.now();
        }

        if (stato == null) {

            stato = StatoCorso.ASSEGNATO;
        }

        if (percentuale == null) {

            percentuale = 0.0;
        }
    }


    public Long getId() {

        return id;
    }


    public void setId(Long id) {

        this.id = id;
    }


    public User getUser() {

        return user;
    }


    public void setUser(User user) {

        this.user = user;
    }


    public Corso getCorso() {

        return corso;
    }


    public void setCorso(Corso corso) {

        this.corso = corso;
    }


    public LocalDateTime getDataAssegnazione() {

        return dataAssegnazione;
    }


    public void setDataAssegnazione(
            LocalDateTime dataAssegnazione
    ) {

        this.dataAssegnazione =
                dataAssegnazione;
    }


    public StatoCorso getStato() {

        return stato;
    }


    public void setStato(
            StatoCorso stato
    ) {

        this.stato = stato;
    }


    public Double getPercentuale() {

        return percentuale;
    }


    public void setPercentuale(
            Double percentuale
    ) {

        this.percentuale = percentuale;
    }


    public LocalDateTime getDataCompletamento() {

        return dataCompletamento;
    }


    public void setDataCompletamento(
            LocalDateTime dataCompletamento
    ) {

        this.dataCompletamento =
                dataCompletamento;
    }
}
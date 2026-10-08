/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 *
 * @author Aldo
 */
@Entity
@Table(
        name = "user_video",
        uniqueConstraints = {
            @UniqueConstraint(columnNames = {"user_id", "video_id"})
        }
)
public class UserVideo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "video_id", nullable = false)
    private Video video;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatoVideo stato = StatoVideo.DA_GUARDARE;

    @Column(nullable = false)
    private Long secondiGuardati = 0L;

    @Column(nullable = false)
    private Long ultimaPosizione = 0L;

    @Column(nullable = false)
    private Double percentuale = 0.0;

    private LocalDateTime ultimaVisualizzazione;

    private LocalDateTime dataCompletamento;

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

    public Video getVideo() {
        return video;
    }

    public void setVideo(Video video) {
        this.video = video;
    }

    public StatoVideo getStato() {
        return stato;
    }

    public void setStato(StatoVideo stato) {
        this.stato = stato;
    }

    public Long getSecondiGuardati() {
        return secondiGuardati;
    }

    public void setSecondiGuardati(Long secondiGuardati) {
        this.secondiGuardati = secondiGuardati;
    }

    public Long getUltimaPosizione() {
        return ultimaPosizione;
    }

    public void setUltimaPosizione(Long ultimaPosizione) {
        this.ultimaPosizione = ultimaPosizione;
    }

    public Double getPercentuale() {
        return percentuale;
    }

    public void setPercentuale(Double percentuale) {
        this.percentuale = percentuale;
    }

    public LocalDateTime getUltimaVisualizzazione() {
        return ultimaVisualizzazione;
    }

    public void setUltimaVisualizzazione(LocalDateTime ultimaVisualizzazione) {
        this.ultimaVisualizzazione = ultimaVisualizzazione;
    }

    public LocalDateTime getDataCompletamento() {
        return dataCompletamento;
    }

    public void setDataCompletamento(LocalDateTime dataCompletamento) {
        this.dataCompletamento = dataCompletamento;
    }

}

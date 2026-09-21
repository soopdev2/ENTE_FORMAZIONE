/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import jakarta.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

/**
 *
 * @author Aldo
 */


@Entity
@Table(name = "sessione_video")
public class SessioneVideo implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_video_id", nullable = false)
    private UserVideo userVideo;

    @Column(nullable = false)
    private LocalDateTime inizio;

    private LocalDateTime fine;

    @Column(nullable = false)
    private Long secondiGuardati = 0L;

    @Column(nullable = false)
    private Long posizioneIniziale = 0L;

    private Long posizioneFinale;


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }


    public UserVideo getUserVideo() {
        return userVideo;
    }

    public void setUserVideo(UserVideo userVideo) {
        this.userVideo = userVideo;
    }


    public LocalDateTime getInizio() {
        return inizio;
    }

    public void setInizio(LocalDateTime inizio) {
        this.inizio = inizio;
    }


    public LocalDateTime getFine() {
        return fine;
    }

    public void setFine(LocalDateTime fine) {
        this.fine = fine;
    }


    public Long getSecondiGuardati() {
        return secondiGuardati;
    }

    public void setSecondiGuardati(Long secondiGuardati) {
        this.secondiGuardati = secondiGuardati;
    }


    public Long getPosizioneIniziale() {
        return posizioneIniziale;
    }

    public void setPosizioneIniziale(Long posizioneIniziale) {
        this.posizioneIniziale = posizioneIniziale;
    }


    public Long getPosizioneFinale() {
        return posizioneFinale;
    }

    public void setPosizioneFinale(Long posizioneFinale) {
        this.posizioneFinale = posizioneFinale;
    }
}

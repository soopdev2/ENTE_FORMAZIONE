/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author Aldo
 */
package service;

import entity.UserVideo;
import entity.Video;
import repositories.UserVideoRepository;
import repositories.VideoRepository;

import java.util.List;

public class AdminVideoStatsService {

    private final UserVideoRepository userVideoRepository;
    private final VideoRepository videoRepository;

    public AdminVideoStatsService() {

        this.userVideoRepository
                = new UserVideoRepository();

        this.videoRepository
                = new VideoRepository();
    }

    public long getTotaleUtenti(Long videoId) {

        getVideo(videoId);

        return userVideoRepository.countByVideo(
                videoId
        );
    }

    public long getUtentiCompletati(Long videoId) {

        getVideo(videoId);

        return userVideoRepository.countCompletedByVideo(
                videoId
        );
    }

    public long getUtentiInCorso(Long videoId) {

        getVideo(videoId);

        return userVideoRepository.countInProgressByVideo(
                videoId
        );
    }

    public long getUtentiDaGuardare(Long videoId) {

        getVideo(videoId);

        return userVideoRepository.countNotStartedByVideo(
                videoId
        );
    }

    public List<UserVideo> getUtentiVideo(
            Long videoId) {

        getVideo(videoId);

        return userVideoRepository.findByVideo(
                videoId
        );
    }

    public Video getVideo(Long videoId) {

        if (videoId == null) {

            throw new IllegalArgumentException(
                    "ID video obbligatorio"
            );
        }

        return videoRepository
                .findById(videoId)
                .orElseThrow(()
                        -> new IllegalArgumentException(
                        "Video non trovato"
                )
                );
    }
}

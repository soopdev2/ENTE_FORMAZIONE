/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package repositories;

import entity.SessioneVideo;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import Utility.JpaUtil;

import java.util.List;
import java.util.Optional;

/**
 *
 * @author Aldo
 */


public class SessioneVideoRepository {


    public SessioneVideo save(SessioneVideo sessione) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            SessioneVideo result =
                    em.merge(sessione);

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


    public Optional<SessioneVideo> findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            SessioneVideo sessione =
                    em.find(SessioneVideo.class, id);

            return Optional.ofNullable(sessione);

        } finally {

            em.close();
        }
    }


    public List<SessioneVideo> findByUserVideo(
            Long userVideoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<SessioneVideo> query =
                    em.createQuery(
                        "SELECT s FROM SessioneVideo s "
                        + "WHERE s.userVideo.id = :userVideoId "
                        + "ORDER BY s.inizio ASC",
                        SessioneVideo.class
                    );

            query.setParameter(
                    "userVideoId",
                    userVideoId
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }


    public Optional<SessioneVideo> findSessioneAperta(
            Long userVideoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<SessioneVideo> query =
                    em.createQuery(
                        "SELECT s FROM SessioneVideo s "
                        + "WHERE s.userVideo.id = :userVideoId "
                        + "AND s.fine IS NULL "
                        + "ORDER BY s.inizio DESC",
                        SessioneVideo.class
                    );

            query.setParameter(
                    "userVideoId",
                    userVideoId
            );

            List<SessioneVideo> result =
                    query.setMaxResults(1)
                         .getResultList();

            if (result.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(result.get(0));

        } finally {

            em.close();
        }
    }
}

package repositories;

import Utility.JpaUtil;
import entity.StatoVideo;
import entity.UserVideo;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

/**
 *
 * @author Aldo
 */
public class UserVideoRepository {

    public UserVideo save(UserVideo userVideo) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            UserVideo result = em.merge(userVideo);

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

    public Optional<UserVideo> findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserVideo> query = em.createQuery(
                    "SELECT uv "
                    + "FROM UserVideo uv "
                    + "JOIN FETCH uv.video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE uv.id = :id",
                    UserVideo.class
            );

            query.setParameter("id", id);

            List<UserVideo> result =
                    query.getResultList();

            if (result.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(result.get(0));

        } finally {

            em.close();
        }
    }

    public Optional<UserVideo> findByUserAndVideo(
            Long userId,
            Long videoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserVideo> query = em.createQuery(
                    "SELECT uv "
                    + "FROM UserVideo uv "
                    + "JOIN FETCH uv.video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE uv.user.id = :userId "
                    + "AND uv.video.id = :videoId",
                    UserVideo.class
            );

            query.setParameter(
                    "userId",
                    userId
            );

            query.setParameter(
                    "videoId",
                    videoId
            );

            List<UserVideo> result =
                    query.getResultList();

            if (result.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(result.get(0));

        } finally {

            em.close();
        }
    }

    public List<UserVideo> findByUser(
            Long userId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserVideo> query = em.createQuery(
                    "SELECT uv "
                    + "FROM UserVideo uv "
                    + "JOIN FETCH uv.video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE uv.user.id = :userId "
                    + "ORDER BY v.ordine ASC",
                    UserVideo.class
            );

            query.setParameter(
                    "userId",
                    userId
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public List<UserVideo> findByVideo(
            Long videoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserVideo> query = em.createQuery(
                    "SELECT uv "
                    + "FROM UserVideo uv "
                    + "JOIN FETCH uv.user "
                    + "JOIN FETCH uv.video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE uv.video.id = :videoId",
                    UserVideo.class
            );

            query.setParameter(
                    "videoId",
                    videoId
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public long countByVideo(
            Long videoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(uv) "
                    + "FROM UserVideo uv "
                    + "WHERE uv.video.id = :videoId",
                    Long.class
            );

            query.setParameter(
                    "videoId",
                    videoId
            );

            return query.getSingleResult();

        } finally {

            em.close();
        }
    }

    public long countCompletedByVideo(
            Long videoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(uv) "
                    + "FROM UserVideo uv "
                    + "WHERE uv.video.id = :videoId "
                    + "AND uv.stato = :stato",
                    Long.class
            );

            query.setParameter(
                    "videoId",
                    videoId
            );

            query.setParameter(
                    "stato",
                    StatoVideo.COMPLETATO
            );

            return query.getSingleResult();

        } finally {

            em.close();
        }
    }

    public long countInProgressByVideo(
            Long videoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(uv) "
                    + "FROM UserVideo uv "
                    + "WHERE uv.video.id = :videoId "
                    + "AND uv.stato = :stato",
                    Long.class
            );

            query.setParameter(
                    "videoId",
                    videoId
            );

            query.setParameter(
                    "stato",
                    StatoVideo.IN_CORSO
            );

            return query.getSingleResult();
        }

        finally {

            em.close();
        }
    }

    public long countNotStartedByVideo(
            Long videoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Long> query = em.createQuery(
                    "SELECT COUNT(uv) "
                    + "FROM UserVideo uv "
                    + "WHERE uv.video.id = :videoId "
                    + "AND uv.stato = :stato",
                    Long.class
            );

            query.setParameter(
                    "videoId",
                    videoId
            );

            query.setParameter(
                    "stato",
                    StatoVideo.DA_GUARDARE
            );

            return query.getSingleResult();

        } finally {

            em.close();
        }
    }
}

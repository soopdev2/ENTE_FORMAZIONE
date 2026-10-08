package repositories;

import entity.Video;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;
import Utility.JpaUtil;

public class VideoRepository {

    public Video save(Video video) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            Video result = em.merge(video);

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

    public Optional<Video> findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            List<Video> risultati = em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE v.id = :id",
                    Video.class
            )
                    .setParameter("id", id)
                    .getResultList();

            if (risultati.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(risultati.get(0));

        } finally {

            em.close();
        }
    }

    public List<Video> findAll() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            return em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "ORDER BY v.dataCreazione DESC",
                    Video.class
            ).getResultList();

        } finally {

            em.close();
        }
    }

    public List<Video> findAllActive() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Video> query = em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE v.attivo = true "
                    + "ORDER BY v.dataCreazione DESC",
                    Video.class
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public void delete(Video video) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            Video managedVideo = em.merge(video);

            em.remove(managedVideo);

            em.getTransaction().commit();

        } catch (Exception e) {

            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }

            throw e;

        } finally {

            em.close();
        }
    }

    public List<Video> findByModulo(Long moduloId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            return em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE v.modulo.id = :moduloId "
                    + "ORDER BY v.ordine ASC",
                    Video.class
            )
                    .setParameter("moduloId", moduloId)
                    .getResultList();

        } finally {

            em.close();
        }
    }

    public List<Video> findActiveByModulo(Long moduloId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Video> query = em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE v.modulo.id = :moduloId "
                    + "AND v.attivo = true "
                    + "ORDER BY v.ordine ASC",
                    Video.class
            );

            query.setParameter("moduloId", moduloId);

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public Optional<Video> findPrecedente(Video video) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Video> query = em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE v.modulo.id = :moduloId "
                    + "AND v.ordine < :ordine "
                    + "ORDER BY v.ordine DESC",
                    Video.class
            );

            query.setParameter(
                    "moduloId",
                    video.getModulo().getId()
            );

            query.setParameter(
                    "ordine",
                    video.getOrdine()
            );

            List<Video> result = query
                    .setMaxResults(1)
                    .getResultList();

            if (result.isEmpty()) {
                return Optional.empty();
            }

            return Optional.of(result.get(0));

        } finally {

            em.close();
        }
    }

    public Optional<Video> findSuccessivo(Video video) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Video> query = em.createQuery(
                    "SELECT v "
                    + "FROM Video v "
                    + "JOIN FETCH v.modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE v.modulo.id = :moduloId "
                    + "AND v.ordine > :ordine "
                    + "AND v.attivo = true "
                    + "ORDER BY v.ordine ASC",
                    Video.class
            );

            query.setParameter(
                    "moduloId",
                    video.getModulo().getId()
            );

            query.setParameter(
                    "ordine",
                    video.getOrdine()
            );

            List<Video> result = query
                    .setMaxResults(1)
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

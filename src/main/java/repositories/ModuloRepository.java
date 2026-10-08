package repositories;

import entity.Modulo;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import Utility.JpaUtil;

import java.util.List;

/**
 *
 * @author Aldo
 */
public class ModuloRepository {

    public Modulo save(Modulo modulo) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            Modulo result = em.merge(modulo);

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

    public Modulo findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Modulo> query = em.createQuery(
                    "SELECT m FROM Modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE m.id = :id",
                    Modulo.class
            );

            query.setParameter("id", id);

            List<Modulo> risultati
                    = query.getResultList();

            return risultati.isEmpty()
                    ? null
                    : risultati.get(0);

        } finally {

            em.close();
        }
    }

    public List<Modulo> findAll() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Modulo> query = em.createQuery(
                    "SELECT DISTINCT m FROM Modulo m "
                    + "JOIN FETCH m.corso "
                    + "LEFT JOIN FETCH m.video "
                    + "ORDER BY m.id ASC",
                    Modulo.class
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public List<Modulo> findAllActive() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Modulo> query = em.createQuery(
                    "SELECT m FROM Modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE m.attivo = true "
                    + "ORDER BY m.id ASC",
                    Modulo.class
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public List<Modulo> findByCorso(Long corsoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Modulo> query = em.createQuery(
                    "SELECT m FROM Modulo m "
                    + "JOIN FETCH m.corso "
                    + "WHERE m.corso.id = :corsoId "
                    + "ORDER BY m.id ASC",
                    Modulo.class
            );

            query.setParameter(
                    "corsoId",
                    corsoId
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public List<Modulo> findActiveByCorso(Long corsoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Modulo> query = em.createQuery(
                    "SELECT DISTINCT m "
                    + "FROM Modulo m "
                    + "JOIN FETCH m.corso "
                    + "LEFT JOIN FETCH m.video "
                    + "WHERE m.corso.id = :corsoId "
                    + "AND m.attivo = true "
                    + "ORDER BY m.id ASC",
                    Modulo.class
            );

            query.setParameter(
                    "corsoId",
                    corsoId
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public List<Modulo> findByCorsoWithVideo(Long corsoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Modulo> query = em.createQuery(
                    "SELECT DISTINCT m "
                    + "FROM Modulo m "
                    + "LEFT JOIN FETCH m.video "
                    + "WHERE m.corso.id = :corsoId "
                    + "ORDER BY m.id ASC",
                    Modulo.class
            );

            query.setParameter("corsoId", corsoId);

            return query.getResultList();

        } finally {

            em.close();
        }
    }

}

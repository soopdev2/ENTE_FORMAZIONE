package repositories;

import Utility.JpaUtil;
import entity.Corso;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;

public class CorsoRepository {

    public void save(Corso corso) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            em.persist(corso);

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

    public Corso findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Corso> query = em.createQuery(
                    "SELECT c FROM Corso c "
                    + "LEFT JOIN FETCH c.moduli "
                    + "WHERE c.id = :id",
                    Corso.class
            );

            query.setParameter("id", id);

            List<Corso> risultati = query.getResultList();

            return risultati.isEmpty()
                    ? null
                    : risultati.get(0);

        } finally {

            em.close();
        }
    }

    public List<Corso> findAll() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Corso> query = em.createQuery(
                    "SELECT DISTINCT c FROM Corso c "
                    + "LEFT JOIN FETCH c.moduli "
                    + "ORDER BY c.id ASC",
                    Corso.class
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public List<Corso> findAttivi() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<Corso> query = em.createQuery(
                    "SELECT DISTINCT c FROM Corso c "
                    + "LEFT JOIN FETCH c.moduli "
                    + "WHERE c.attivo = true "
                    + "ORDER BY c.id ASC",
                    Corso.class
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public void update(Corso corso) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            em.merge(corso);

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
}

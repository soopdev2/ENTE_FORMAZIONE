package repositories;

import Utility.JpaUtil;
import entity.UserCorso;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List;

public class UserCorsoRepository {

    public void save(UserCorso userCorso) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            em.persist(userCorso);

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

    public UserCorso findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserCorso> query
                    = em.createQuery(
                            "SELECT uc FROM UserCorso uc "
                            + "JOIN FETCH uc.user "
                            + "JOIN FETCH uc.corso "
                            + "WHERE uc.id = :id",
                            UserCorso.class
                    );

            query.setParameter("id", id);

            List<UserCorso> risultati
                    = query.getResultList();

            return risultati.isEmpty()
                    ? null
                    : risultati.get(0);

        } finally {

            em.close();
        }
    }

    public UserCorso findByUserAndCorso(
            Long userId,
            Long corsoId
    ) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserCorso> query
                    = em.createQuery(
                            "SELECT uc FROM UserCorso uc "
                            + "JOIN FETCH uc.user "
                            + "JOIN FETCH uc.corso "
                            + "WHERE uc.user.id = :userId "
                            + "AND uc.corso.id = :corsoId",
                            UserCorso.class
                    );

            query.setParameter(
                    "userId",
                    userId
            );

            query.setParameter(
                    "corsoId",
                    corsoId
            );

            List<UserCorso> risultati
                    = query.getResultList();

            return risultati.isEmpty()
                    ? null
                    : risultati.get(0);

        } finally {

            em.close();
        }
    }

    public List<UserCorso> findByUser(Long userId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserCorso> query
                    = em.createQuery(
                            "SELECT uc FROM UserCorso uc "
                            + "JOIN FETCH uc.corso "
                            + "WHERE uc.user.id = :userId "
                            + "ORDER BY uc.id ASC",
                            UserCorso.class
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

    public List<UserCorso> findByCorso(Long corsoId) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<UserCorso> query
                    = em.createQuery(
                            "SELECT uc FROM UserCorso uc "
                            + "JOIN FETCH uc.user "
                            + "WHERE uc.corso.id = :corsoId "
                            + "ORDER BY uc.id ASC",
                            UserCorso.class
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

    public void update(UserCorso userCorso) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            em.merge(userCorso);

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

    public void delete(UserCorso userCorso) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            UserCorso managed
                    = em.merge(userCorso);

            em.remove(managed);

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

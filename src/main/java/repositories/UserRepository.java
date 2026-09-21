/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package repositories;

import entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import Utility.JpaUtil;

import java.util.List;

/**
 *
 * @author Aldo
 */

public class UserRepository {

    public User save(User user) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            User result = em.merge(user);

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

    public User findById(Long id) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            User user = em.find(User.class, id);

            return user;

        } finally {

            em.close();
        }
    }

    public List<User> findAll() {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u",
                    User.class
            );

            return query.getResultList();

        } finally {

            em.close();
        }
    }

    public void delete(User user) {

        EntityManager em = JpaUtil.getEntityManager();

        try {

            em.getTransaction().begin();

            User managedUser = em.merge(user);

            em.remove(managedUser);

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

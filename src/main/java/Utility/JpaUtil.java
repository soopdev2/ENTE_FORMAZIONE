/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utility;

import entity.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 *
 * @author Salvatore
 */
public class JpaUtil {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("enm_fad_video");

    public static EntityManager getEntityManager() {

        return emf.createEntityManager();
    }

    public static void close() {

        emf.close();
    }

    public static void CallDb() {

        EntityManager em = JpaUtil.getEntityManager();
        User user = em.find(User.class, 1L);
        System.out.println("utente " + user.getId());

    }
}

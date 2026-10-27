//package entity;
//
//import jakarta.persistence.EntityManager;
//import jakarta.persistence.EntityManagerFactory;
//import jakarta.persistence.Persistence;
//import java.util.List;
//import org.mindrot.jbcrypt.BCrypt;
//
//public class AuthenticationService {
//
//    public static int authenticate(String username, String enteredPassword) {
//        EntityManagerFactory emf = null;
//        EntityManager em = null;
//        try {
//            emf = Persistence.createEntityManagerFactory("enm_fad_video");
//            em = emf.createEntityManager();
//
//            jakarta.persistence.TypedQuery<User> query = em.createQuery(
//                    "SELECT u FROM User u WHERE u.username = :username", User.class).setParameter("username", username);
//
//            query.setParameter("username", username);
//            query.setMaxResults(1);
//            List<User> resultList = query.getResultList();
//
//            if (!resultList.isEmpty()) {
//                User user = resultList.get(0);
//                String hashedPasswordFromDatabase = user.getPassword();
//                boolean isPasswordValid = BCrypt.checkpw(enteredPassword, hashedPasswordFromDatabase);
//                if (isPasswordValid) {
//                    return user.getRuolo().getId();
//
//                }
//            }
//        } catch (Exception e) {
//            //logfile.severe(estraiEccezione(e));
//            e.printStackTrace();
//        } finally {
//            em.close();
//            emf.close();
//        }
//        return -1;
//    }
//
//    public static boolean isPasswordValid(String username, String enteredPassword) {
//        EntityManagerFactory emf = null;
//        EntityManager em = null;
//        try {
//            emf = Persistence.createEntityManagerFactory("enm_fad_video");
//            em = emf.createEntityManager();
//
//            jakarta.persistence.TypedQuery<User> query = em.createQuery(
//                    "SELECT u FROM User u WHERE u.username = :username", User.class).setParameter("username", username);
//
//            query.setParameter("username", username);
//            query.setMaxResults(1);
//            List<User> resultList = query.getResultList();
//
//            if (!resultList.isEmpty()) {
//                User user = resultList.get(0);
//                String hashedPasswordFromDatabase = user.getPassword();
//
//                return BCrypt.checkpw(enteredPassword, hashedPasswordFromDatabase);
//            }
//        } catch (Exception e) {
//            //logfile.severe(estraiEccezione(e));
//            e.printStackTrace();
//        } finally {
//            em.close();
//            emf.close();
//        }
//
//        return false;
//    }
//
//    public static User getUserByUsername(String username) {
//        EntityManagerFactory emf = null;
//        EntityManager em = null;
//        try {
//            emf = Persistence.createEntityManagerFactory("enm_fad_video");
//            em = emf.createEntityManager();
//            jakarta.persistence.TypedQuery<User> query = em.createQuery(
//                    "SELECT u FROM User u WHERE u.username = :username", User.class).setParameter("username", username);
//
//            query.setParameter("username", username);
//            query.setMaxResults(1);
//            List<User> resultList = query.getResultList();
//
//            if (!resultList.isEmpty()) {
//                return resultList.get(0);
//
//            }
//        } catch (Exception e) {
//            //logfile.severe(estraiEccezione(e));
//            e.printStackTrace();
//        } finally {
//            em.close();
//            emf.close();
//        }
//
//        return null;
//    }
//}
package entity;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;
import java.util.Date;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public class AuthenticationService {

    private static EntityManagerFactory createFactory() {
        return Persistence.createEntityManagerFactory("enm_fad_video");
    }

    // AUTENTICAZIONE
    public static int authenticate(String username, String enteredPassword) {
        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = createFactory();
            em = emf.createEntityManager();

            List<User> risultati = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username",
                    User.class)
                    .setParameter("username", username)
                    .setMaxResults(1)
                    .getResultList();

            if (!risultati.isEmpty()) {
                User user = risultati.get(0);

                if (BCrypt.checkpw(enteredPassword, user.getPassword())) {
                    return user.getRuolo().getId();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }

        return -1;
    }

    public static boolean isPasswordValid(
            String username,
            String enteredPassword) {

        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = createFactory();
            em = emf.createEntityManager();

            List<User> risultati = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username",
                    User.class)
                    .setParameter("username", username)
                    .setMaxResults(1)
                    .getResultList();

            if (!risultati.isEmpty()) {
                return BCrypt.checkpw(
                        enteredPassword,
                        risultati.get(0).getPassword()
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }

        return false;
    }

    public static User getUserByUsername(String username) {
        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = createFactory();
            em = emf.createEntityManager();

            List<User> risultati = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username",
                    User.class)
                    .setParameter("username", username)
                    .setMaxResults(1)
                    .getResultList();

            return risultati.isEmpty() ? null : risultati.get(0);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    // RECUPERO UTENTE TRAMITE EMAIL
    public static User getUserByEmail(String email) {
        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = createFactory();
            em = emf.createEntityManager();

            List<User> risultati = em.createQuery(
                    "SELECT u FROM User u WHERE LOWER(u.email) = :email",
                    User.class)
                    .setParameter("email", email.trim().toLowerCase())
                    .setMaxResults(1)
                    .getResultList();

            return risultati.isEmpty() ? null : risultati.get(0);

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    // SALVA HASH DEL TOKEN E SCADENZA
    public static boolean salvaTokenRecupero(
            Long userId,
            String tokenHash,
            Date scadenza) {

        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = createFactory();
            em = emf.createEntityManager();

            EntityTransaction tx = em.getTransaction();
            tx.begin();

            int aggiornati = em.createQuery(
                    "UPDATE User u "
                    + "SET u.resetPasswordToken = :token, "
                    + "u.resetPasswordExpiry = :scadenza "
                    + "WHERE u.id = :id")
                    .setParameter("token", tokenHash)
                    .setParameter("scadenza", scadenza)
                    .setParameter("id", userId)
                    .executeUpdate();

            tx.commit();
            return aggiornati == 1;

        } catch (Exception e) {
            if (em != null
                    && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    // VERIFICA TOKEN E REIMPOSTA PASSWORD
    public static boolean reimpostaPassword(
            String tokenHash,
            String nuovaPassword) {

        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = createFactory();
            em = emf.createEntityManager();

            EntityTransaction tx = em.getTransaction();
            tx.begin();

            List<User> risultati = em.createQuery(
                    "SELECT u FROM User u "
                    + "WHERE u.resetPasswordToken = :token "
                    + "AND u.resetPasswordExpiry > :adesso",
                    User.class)
                    .setParameter("token", tokenHash)
                    .setParameter("adesso", new Date())
                    .setMaxResults(1)
                    .getResultList();

            if (risultati.isEmpty()) {
                tx.rollback();
                return false;
            }

            User user = risultati.get(0);

            user.setPassword(
                    BCrypt.hashpw(nuovaPassword, BCrypt.gensalt())
            );

            user.setResetPasswordToken(null);
            user.setResetPasswordExpiry(null);
            user.setResetPasswordDate(null);

            em.merge(user);
            tx.commit();

            return true;

        } catch (Exception e) {
            if (em != null
                    && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    public static boolean usernameDisponibile(String username) {
        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();

            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM User u "
                    + "WHERE LOWER(u.username) = :username",
                    Long.class)
                    .setParameter("username", username.trim().toLowerCase())
                    .getSingleResult();

            return count == 0;

        } catch (Exception e) {
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    public static boolean registraUtentePubblico(User user) {
        EntityManagerFactory emf = null;
        EntityManager em = null;
        EntityTransaction tx = null;

        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();
            tx = em.getTransaction();
            tx.begin();

            String email = user.getEmail().trim().toLowerCase();

            Long emailCount = em.createQuery(
                    "SELECT COUNT(u) FROM User u "
                    + "WHERE LOWER(u.email) = :email",
                    Long.class)
                    .setParameter("email", email)
                    .getSingleResult();

            Long usernameCount = em.createQuery(
                    "SELECT COUNT(u) FROM User u "
                    + "WHERE LOWER(u.username) = :username",
                    Long.class)
                    .setParameter("username", user.getUsername().trim().toLowerCase())
                    .getSingleResult();

            if (emailCount > 0 || usernameCount > 0) {
                tx.rollback();
                return false;
            }

            // Il ruolo 2 corrisponde all'utente normale.
            Ruolo ruoloUtente = em.createQuery(
                    "SELECT r FROM Ruolo r WHERE r.id = 2",
                    Ruolo.class)
                    .getSingleResult();

            user.setEmail(email);
            user.setUsername(user.getUsername().trim());
            user.setPassword(BCrypt.hashpw(
                    user.getPassword(),
                    BCrypt.gensalt()
            ));
            user.setRuolo(ruoloUtente);
            user.setCambioPasswordObbligatorio(true);

            em.persist(user);
            tx.commit();

            return true;

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    public static boolean aggiornaCredenzialiPrimoAccesso(
            Long userId,
            String nuovoUsername,
            String nuovaPassword) {

        EntityManagerFactory emf = null;
        EntityManager em = null;
        EntityTransaction tx = null;

        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();
            tx = em.getTransaction();
            tx.begin();

            User user = em.find(User.class, userId);

            if (user == null || !user.isCambioPasswordObbligatorio()) {
                tx.rollback();
                return false;
            }

            Long count = em.createQuery(
                    "SELECT COUNT(u) FROM User u "
                    + "WHERE LOWER(u.username) = :username "
                    + "AND u.id <> :id",
                    Long.class)
                    .setParameter("username", nuovoUsername.trim().toLowerCase())
                    .setParameter("id", userId)
                    .getSingleResult();

            if (count > 0) {
                tx.rollback();
                return false;
            }

            user.setUsername(nuovoUsername.trim());
            user.setPassword(BCrypt.hashpw(
                    nuovaPassword,
                    BCrypt.gensalt()
            ));
            user.setCambioPasswordObbligatorio(false);

            em.merge(user);
            tx.commit();

            return true;

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

    public static boolean eliminaRegistrazioneIncompleta(Long userId) {
        EntityManagerFactory emf = null;
        EntityManager em = null;
        EntityTransaction tx = null;

        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();
            tx = em.getTransaction();
            tx.begin();

            User user = em.find(User.class, userId);

            if (user != null && user.isCambioPasswordObbligatorio()) {
                em.remove(user);
            }

            tx.commit();
            return true;

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            return false;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
            if (emf != null && emf.isOpen()) {
                emf.close();
            }
        }
    }

}

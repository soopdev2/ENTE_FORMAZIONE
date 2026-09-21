package entity;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

public class AuthenticationService {

    public static int authenticate(String username, String enteredPassword) {
        EntityManagerFactory emf = null;
        EntityManager em = null;
        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();

            jakarta.persistence.TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username", User.class).setParameter("username", username);

            query.setParameter("username", username);
            query.setMaxResults(1);
            List<User> resultList = query.getResultList();

            if (!resultList.isEmpty()) {
                User user = resultList.get(0);
                String hashedPasswordFromDatabase = user.getPassword();
                boolean isPasswordValid = BCrypt.checkpw(enteredPassword, hashedPasswordFromDatabase);
                if (isPasswordValid) {
                    return user.getRuolo().getId();

                }
            }
        } catch (Exception e) {
            //logfile.severe(estraiEccezione(e));
            e.printStackTrace();
        } finally {
            em.close();
            emf.close();
        }
        return -1;
    }

    public static boolean isPasswordValid(String username, String enteredPassword) {
        EntityManagerFactory emf = null;
        EntityManager em = null;
        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();

            jakarta.persistence.TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username", User.class).setParameter("username", username);

            query.setParameter("username", username);
            query.setMaxResults(1);
            List<User> resultList = query.getResultList();

            if (!resultList.isEmpty()) {
                User user = resultList.get(0);
                String hashedPasswordFromDatabase = user.getPassword();

                return BCrypt.checkpw(enteredPassword, hashedPasswordFromDatabase);
            }
        } catch (Exception e) {
            //logfile.severe(estraiEccezione(e));
            e.printStackTrace();
        } finally {
            em.close();
            emf.close();
        }

        return false;
    }

    public static User getUserByUsername(String username) {
        EntityManagerFactory emf = null;
        EntityManager em = null;
        try {
            emf = Persistence.createEntityManagerFactory("enm_fad_video");
            em = emf.createEntityManager();
            jakarta.persistence.TypedQuery<User> query = em.createQuery(
                    "SELECT u FROM User u WHERE u.username = :username", User.class).setParameter("username", username);

            query.setParameter("username", username);
            query.setMaxResults(1);
            List<User> resultList = query.getResultList();

            if (!resultList.isEmpty()) {
                return resultList.get(0);

            }
        } catch (Exception e) {
            //logfile.severe(estraiEccezione(e));
            e.printStackTrace();
        } finally {
            em.close();
            emf.close();
        }

        return null;
    }
}

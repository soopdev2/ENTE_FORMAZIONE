package entity;

import java.io.Serializable;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.List;
import jakarta.persistence.Column;
import jakarta.persistence.SequenceGenerator;

@Entity
@Table(name = "ruolo")
@SequenceGenerator(name = "ruolo_GENERATOR", sequenceName = "ruolo_SEQUENCE", allocationSize = 2)
public class Ruolo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    @Column(name = "nome")
    private String nome;

    @OneToMany(mappedBy = "ruolo")
    private List<User> utenti; // Aggiunto il campo utenti

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public List<User> getUtenti() {
        return utenti;
    }

    public void setUtenti(List<User> utenti) {
        this.utenti = utenti;
    }
}

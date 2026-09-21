package it.spid.cie.oidc.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

/**
 * This model represent a "Fetched Entity Statement": a set of information
 * (metadata) about a federation Entity provided by a the entity itself or by a
 * Trust Anchor.
 * <br/>
 * This model helps to interact with these information generally provided as
 * json
 *
 * @author Mauro Mariuzzo
 */
@Entity
public class CachedEntityInfo extends BaseModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String iss;
    private String sub;
    private LocalDateTime exp;
    private LocalDateTime iat;
    private String statement;
    private String jwt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getIss() {
        return iss;
    }

    public void setIss(String iss) {
        this.iss = iss;
    }

    public String getSub() {
        return sub;
    }

    public void setSub(String sub) {
        this.sub = sub;
    }

    public LocalDateTime getExp() {
        return exp;
    }

    public void setExp(LocalDateTime exp) {
        this.exp = exp;
    }

    public LocalDateTime getIat() {
        return iat;
    }

    public void setIat(LocalDateTime iat) {
        this.iat = iat;
    }

    
    public static CachedEntityInfo of(
            String iss, String sub, LocalDateTime exp, LocalDateTime iat, String statement,
            String jwt) {

        return new CachedEntityInfo()
                .setExpiresOn(exp)
                .setIssuedAt(iat)
                .setIssuer(iss)
                .setJwt(jwt)
                .setStatement(statement)
                .setSubject(sub);
    }

    public LocalDateTime getExpiresOn() {
        return exp;
    }

    public LocalDateTime getIssuedAt() {
        return iat;
    }

    public String getIssuer() {
        return iss;
    }

    public String getJwt() {
        return jwt;
    }

    public String getStatement() {
        return statement;
    }

    public String getSubject() {
        return sub;
    }

    public boolean isExpired() {
        if (exp != null) {
            return exp.isBefore(LocalDateTime.now());
        }

        return true;
    }

    public CachedEntityInfo setExpiresOn(LocalDateTime expiresOn) {
        this.exp = expiresOn;

        return this;
    }

    public CachedEntityInfo setIssuedAt(LocalDateTime issuedAt) {
        this.iat = issuedAt;

        return this;
    }

    public CachedEntityInfo setIssuer(String issuer) {
        this.iss = issuer;

        return this;
    }

    public CachedEntityInfo setJwt(String jwt) {
        this.jwt = jwt;

        return this;
    }

    public CachedEntityInfo setStatement(String statement) {
        this.statement = statement;

        return this;
    }

    public CachedEntityInfo setSubject(String subject) {
        this.sub = subject;

        return this;
    }

}

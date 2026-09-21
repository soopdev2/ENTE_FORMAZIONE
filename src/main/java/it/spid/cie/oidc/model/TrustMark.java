package it.spid.cie.oidc.model;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import it.spid.cie.oidc.exception.OIDCException;
import it.spid.cie.oidc.exception.TrustMarkException;
import it.spid.cie.oidc.helper.EntityHelper;
import it.spid.cie.oidc.helper.JWTHelper;
import it.spid.cie.oidc.util.HashMapConverter;
import java.io.Serializable;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

@Entity
@Table(name = "trustmark")
public class TrustMark implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id2;
    private static final Logger logger = LoggerFactory.getLogger(TrustMark.class);

    public Long getId2() {
        return id2;
    }

    public void setId2(Long id2) {
        this.id2 = id2;
    }

    public JWTHelper getJwtHelper() {
        return jwtHelper;
    }

    public void setJwtHelper(JWTHelper jwtHelper) {
        this.jwtHelper = jwtHelper;
    }

    public JSONObject getHeader() {
        return header;
    }

    public void setHeader(JSONObject header) {
        this.header = header;
    }

    public String getIss() {
        return iss;
    }

    public void setIss(String iss) {
        this.iss = iss;
    }

    public String getJwt() {
        return jwt;
    }

    public void setJwt(String jwt) {
        this.jwt = jwt;
    }

    public String getSub() {
        return sub;
    }

    public void setSub(String sub) {
        this.sub = sub;
    }

    public EntityConfiguration getIssuerEC() {
        return issuerEC;
    }

    public void setIssuerEC(EntityConfiguration issuerEC) {
        this.issuerEC = issuerEC;
    }

    @Transient
    private JWTHelper jwtHelper;
    @Convert(converter = HashMapConverter.class)
    private JSONObject header;
    private String id;
    private String iss;
    private String jwt;
    private String sub;
    private boolean valid = false;
    private EntityConfiguration issuerEC;

    public TrustMark() {
    }

    public TrustMark(String jwt, JWTHelper jwtHelper) {
        JSONObject token = JWTHelper.fastParse(jwt);

        JSONObject header = token.getJSONObject("header");
        JSONObject payload = token.getJSONObject("payload");

        this.jwtHelper = jwtHelper;
        this.jwt = jwt;
        this.id = payload.getString("id");
        this.iss = payload.getString("iss");
        this.sub = payload.getString("sub");
        this.header = header;
    }

    public String getId() {
        return this.id;
    }

    public String getIssuer() {
        return this.iss;
    }

    public boolean isValid() {
        return valid;
    }

    public boolean validate(EntityConfiguration ec) throws OIDCException {
        String kid = header.optString("kid");

        if (!ec.hasJWK(kid)) {
            throw new TrustMarkException(
                    "Trust Mark validation failed: %s not found in %s", kid, ec.getJwks());
        }

        valid = jwtHelper.verifyJWS(jwt, ec.getJWKSet());

        return valid;
    }

    public boolean validateByIssuer() throws OIDCException {
        if (issuerEC == null) {
            String ec = EntityHelper.getEntityConfiguration(iss);

            issuerEC = new EntityConfiguration(ec, jwtHelper);
        }

        if (!issuerEC.validateItself()) {
            valid = false;

            logger.warn("Issuer {} of trust mark {} is not valid.", iss, id);

            return false;
        }

        String kid = header.optString("kid");

        if (!issuerEC.hasJWK(kid)) {
            throw new TrustMarkException(
                    "Trust Mark validation failed by its Issuer: %s not found in %s", kid,
                    issuerEC.getJwks());
        }

        valid = jwtHelper.verifyJWS(jwt, issuerEC.getJWKSet());

        return valid;
    }

    public JSONObject toJSON() {
        return new JSONObject()
                .put("id", this.id)
                .put("trust_mark", this.jwt);
    }

    @Override
    public String toString() {
        return String.format("%s to %s issued by %s", id, sub, iss);
    }

}

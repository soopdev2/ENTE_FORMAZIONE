/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.spid.cie.oidc.persistence;

import com.zaxxer.hikari.HikariDataSource;
import it.spid.cie.oidc.exception.PersistenceException;
import it.spid.cie.oidc.model.AuthnRequest;
import it.spid.cie.oidc.model.AuthnToken;
import it.spid.cie.oidc.model.CachedEntityInfo;
import it.spid.cie.oidc.model.FederationEntity;
import it.spid.cie.oidc.model.TrustChain;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Salvatore
 */
public class JdbcPersistenceAdapter implements PersistenceAdapter {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/spid";
    private static final String JDBC_USER = "spid";
    private static final String JDBC_PASSWORD = "spid";

    private HikariDataSource dataSource;
    private String tablePrefix;
    private Level loggingLevel;
    private Map<String, String> additionalOptions;

    public void setDataSource(HikariDataSource dataSource) {
        this.dataSource = dataSource;
    }

    public void setTablePrefix(String tablePrefix) {
        this.tablePrefix = tablePrefix;
    }

    public void setLoggingLevel(Level loggingLevel) {
        this.loggingLevel = loggingLevel;
    }

    public void setAdditionalOption(String optionName, String optionValue) {
        if (additionalOptions == null) {
            additionalOptions = new HashMap<>();
        }
        additionalOptions.put(optionName, optionValue);
    }

    public String getAdditionalOption(String optionName) {
        return additionalOptions != null ? additionalOptions.get(optionName) : null;
    }

    public Map<String, String> getAdditionalOptions() {
        return additionalOptions;
    }

    public void setAdditionalOptions(Map<String, String> additionalOptions) {
        this.additionalOptions = additionalOptions;
    }

    public static String getJDBC_URL() {
        return JDBC_URL;
    }

    public static String getJDBC_USER() {
        return JDBC_USER;
    }

    public static String getJDBC_PASSWORD() {
        return JDBC_PASSWORD;
    }

    public HikariDataSource getDataSource() {
        return dataSource;
    }

    public String getTablePrefix() {
        return tablePrefix;
    }

    public Level getLoggingLevel() {
        return loggingLevel;
    }

    @Override
    public AuthnRequest fetchAuthnRequest(String storageId) throws PersistenceException {
        try (Connection connection = dataSource.getConnection()) {
            // Utilizza la connessione per eseguire la query e recuperare l'AuthnRequest dal database
            String query = "SELECT * FROM authn_requests WHERE storage_id = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(query)) {
                preparedStatement.setString(1, storageId);
                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        AuthnRequest authnRequest = new AuthnRequest();
                        // Recupera i dati dal ResultSet e popola l'oggetto AuthnRequest
                        authnRequest.setId(resultSet.getLong("id"));
                        // Altre proprietà...

                        return authnRequest;
                    }
                }
            }
        } catch (SQLException e) {
            logError("Errore durante il recupero di AuthnRequest", e);
            throw new PersistenceException("Errore durante il recupero di AuthnRequest", e);
        }
        return null;
    }

    @Override
    public CachedEntityInfo fetchEntityInfo(String subject, String issuer) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public FederationEntity fetchFederationEntity(String subject, String entityType, boolean active) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public FederationEntity fetchFederationEntity(String subject, boolean active) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public TrustChain fetchTrustChain(String subject, String trustAnchor) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public TrustChain fetchTrustChain(String subject, String trustAnchor, String metadataType) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<AuthnRequest> findAuthnRequests(String state) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public List<AuthnToken> findAuthnTokens(String userKey) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public CachedEntityInfo storeEntityInfo(CachedEntityInfo entityInfo) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public FederationEntity storeFederationEntity(FederationEntity federationEntity) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public AuthnRequest storeOIDCAuthnRequest(AuthnRequest authnRequest) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public AuthnToken storeOIDCAuthnToken(AuthnToken authnToken) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public TrustChain storeTrustChain(TrustChain trustChain) throws PersistenceException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    private void logInfo(String message) {
        if (loggingLevel == Level.INFO) {
            Logger.getLogger(JdbcPersistenceAdapter.class.getName()).log(Level.INFO, message);
        }
    }

    private void logError(String message, Throwable throwable) {
        if (loggingLevel == Level.INFO) {
            Logger.getLogger(JdbcPersistenceAdapter.class.getName()).log(Level.SEVERE, message, throwable);
        }
    }

}

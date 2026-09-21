package it.spid.cie.oidc.exception;

public class PersistenceException extends OIDCException {

	private static final long serialVersionUID = -7982037999620098416L;

	public PersistenceException(String errore_durante_il_recupero_di_AuthnReques, Throwable cause) {
		super(cause);
	}

}

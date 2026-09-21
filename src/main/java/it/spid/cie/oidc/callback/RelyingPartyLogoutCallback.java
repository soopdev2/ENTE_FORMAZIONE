/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.spid.cie.oidc.callback;

import it.spid.cie.oidc.model.AuthnRequest;
import it.spid.cie.oidc.model.AuthnToken;

/**
 *
 * @author Salvatore
 */
public interface RelyingPartyLogoutCallback {

    public void logout(String userKey, AuthnRequest authnRequest, AuthnToken authnToken);

}

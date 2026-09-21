/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package it.spid.cie.oidc.util;

/**
 *
 * @author Salvatore
 */
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.json.JSONObject;

@Converter
public class HashMapConverter implements AttributeConverter<JSONObject, String> {

    @Override
    public String convertToDatabaseColumn(JSONObject attribute) {
        // Converti l'oggetto JSONObject in una stringa da salvare nel database
        if (attribute == null) {
            return null;
        }
        return attribute.toString();
    }

    @Override
    public JSONObject convertToEntityAttribute(String dbData) {
        // Converti la stringa dal database in un oggetto JSONObject
        if (dbData == null) {
            return null;
        }
        return new JSONObject(dbData);
    }
}

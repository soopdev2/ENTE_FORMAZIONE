/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// * spid-idps.js *
// This script populate the SPID button with a remote json or the `idps` var content
//var queryURL = "js/JSON_IDP_list_EXAMPLE.json";
var queryURL = "https://registry.spid.gov.it/entities-idp?&output=json&custom=info_display_base";
var idps = [{ "organization_name": "ArubaPEC S.p.A.", "entity_id": "https://loginspid.aruba.it", "logo_uri": "/img/spid-idp-arubaid.svg" },
{ "organization_name": "InfoCert S.p.A.", "entity_id": "https://identity.infocert.it", "logo_uri": "/img/spid-idp-infocertid.svg" },
{ "organization_name": "IN.TE.S.A. S.p.A.", "entity_id": "https://spid.intesa.it", "logo_uri": "/img/spid-idp-intesaid.svg" },
{ "organization_name": "Lepida S.p.A.", "entity_id": "https://id.lepida.it/idp/shibboleth", "logo_uri": "/img/spid-idp-lepidaid.svg" },
{ "organization_name": "Namirial", "entity_id": "https://idp.namirialtsp.com/idp", "logo_uri": "/img/spid-idp-namirialid.svg" },
{ "organization_name": "Poste Italiane SpA", "entity_id": "https://posteid.poste.it", "logo_uri": "/img/spid-idp-posteid.svg" },
{ "organization_name": "Sielte S.p.A.", "entity_id": "https://identity.sieltecloud.it", "logo_uri": "/img/spid-idp-sielteid.svg" },
{ "organization_name": "Register.it S.p.A.", "entity_id": "https://spid.register.it", "logo_uri": "/img/spid-idp-spiditalia.svg" },
{ "organization_name": "TI Trust Technologies srl", "entity_id": "https://login.id.tim.it/affwebservices/public/saml2sso", "logo_uri": "/img/spid-idp-timid.svg" },
{ "organization_name": "TeamSystem s.p.a.", "entity_id": "https://spid.teamsystem.com/idp", "logo_uri": "/img/spid-idp-teamsystemid.svg" }];


// spid_populate function, if '.spid-button[data-spid-remote] ul' exist, try to get the remote json file and pupulate all spid buttons
function spid_populate() {
    let spid_elements = document.querySelectorAll('ul[data-spid-remote]');
    if (spid_elements.length > 0) {
        fetch(queryURL)
            .then(function (response) {
                return response.json();
            })
            .then(function (idps) {
                idps = idps.sort(() => Math.random() - 0.5);
                for (var u = 0; u < spid_elements.length; u++) {
                    for (var i = 0; i < idps.length; i++) {
                        spid_addIdpEntry(idps[i], spid_elements[u]);
                    }

                }
            })
            .catch(function (error) {
                console.log('Error during fetch: ' + error.message);
                idps.sort(() => Math.random() - 0.5);
                for (var u = 0; u < spid_elements.length; u++) {
                    for (var i = 0; i < idps.length; i++) {
                        spid_addIdpEntry(idps[i], spid_elements[u]);
                    }
                }
            });
    }
}

// function spid_addIdpEntry make a "li" element with the ipd link and prepend this in a element
//
// options:
// - data - is an object with "organization_name", "entity_id" and "logo_uri" values
// - element - is the element where is added the new "li" element

function spid_addIdpEntry(data, element) {

    const att = document.createAttribute("data-idp");
    att.value = data['redirectUri'];

    let li = document.createElement('li');
    li.className = 'spid-idp-button-link';

    // Aggiungi l'attributo data-organization con il nome dell'organizzazione
    li.setAttribute('data-organization', data['organization_name']);

    li.setAttributeNode(att);

    if (element.id.indexOf('post') !== -1) {
        let button = document.createElement('button');
        button.className = 'idp-button-idp-logo';
        button.name = data['organization_name'];
        button.type = 'submit';

        let span = document.createElement('span');
        span.className = 'spid-sr-only';
        span.textContent = data['organization_name'];

        let img = document.createElement('img');
        img.className = 'spid-idp-button-logo';
        img.src = data['logo_uri'];
        img.alt = data['organization_name'];

        button.appendChild(span);
        button.appendChild(img);
        li.appendChild(button);
    }

    if (element.id.indexOf('get') !== -1) {
        let a = document.createElement('a');
        a.href = '#';

        a.addEventListener('click', function (event) {
            event.preventDefault();
            setSpidProviderURL(data['redirectUri']);
        });

        let span = document.createElement('span');
        span.className = 'spid-sr-only';
        span.textContent = data['organization_name'];

        let img = document.createElement('img');
        img.src = data['logo_uri'];
        img.alt = data['organization_name'];

        a.appendChild(span);
        a.appendChild(img);
        li.appendChild(a);
    }

    element.prepend(li);
}



// when page is ready populate all spid buttons
document.onreadystatechange = function () {
    if (document.readyState === "interactive") {
        spid_populate();
    }
};

// * spid-idps.js *

// Questo script popola il pulsante SPID con un JSON remoto o il contenuto della variabile `idps`
var queryURL = "https://registry.spid.gov.it/entities-idp?&output=json&custom=info_display_base";
// Lista di tutti i fornitori SPID
var idps = [
    { "organization_name": "ArubaPEC S.p.A.", "entity_id": "https://loginspid.aruba.it", "logo_uri": "img/spid-idp-arubaid.svg" },
    { "organization_name": "InfoCert S.p.A.", "entity_id": "https://identity.infocert.it", "logo_uri": "img/spid-idp-infocertid.svg" },
    { "organization_name": "IN.TE.S.A. S.p.A.", "entity_id": "https://spid.intesa.it", "logo_uri": "img/spid-idp-intesaid.svg" },
    { "organization_name": "Lepida S.p.A.", "entity_id": "https://id.lepida.it/idp/shibboleth", "logo_uri": "img/spid-idp-lepidaid.svg" },
    { "organization_name": "Namirial", "entity_id": "https://idp.namirialtsp.com/idp", "logo_uri": "img/spid-idp-namirialid.svg" },
    { "organization_name": "Poste Italiane SpA", "entity_id": "https://posteid.poste.it", "logo_uri": "img/spid-idp-posteid.svg" },
    { "organization_name": "Sielte S.p.A.", "entity_id": "https://identity.sieltecloud.it", "logo_uri": "img/spid-idp-sielteid.svg" },
    { "organization_name": "Register.it S.p.A.", "entity_id": "https://spid.register.it", "logo_uri": "img/spid-idp-spiditalia.svg" },
    { "organization_name": "TI Trust Technologies srl", "entity_id": "https://login.id.tim.it/affwebservices/public/saml2sso", "logo_uri": "img/spid-idp-timid.svg" },
    { "organization_name": "TeamSystem s.p.a.", "entity_id": "https://spid.teamsystem.com/idp", "logo_uri": "img/spid-idp-teamsystemid.svg" }
];
// Funzione per popolare gli IDP
function spid_populate() {
    let spid_elements = document.querySelectorAll('ul[data-spid-remote]');
    if (spid_elements.length > 0) {
        for (var u = 0; u < spid_elements.length; u++) {
            for (var i = 0; i < idps.length; i++) {
                spid_addIdpEntry(idps[i], spid_elements[u]);
            }
        }
    }
}

function spid_addIdpEntry(data, element) {
    const att = document.createAttribute("data-idp");
    att.value = data['entity_id'];
    let li = document.createElement('li');
    li.className = 'spid-idp-button-link';
    li.setAttributeNode(att);
    if (element.id.indexOf('post') !== -1) {
        li.innerHTML = `<button class="idp-button-idp-logo" name="${data['organization_name']}" type="submit">
            <span class="spid-sr-only">${data['organization_name']}</span>
            <img class="spid-idp-button-logo" src="${data['logo_uri']}" alt="${data['organization_name']}" />
        </button>`;
    }

    if (element.id.indexOf('get') !== -1) {
        li.innerHTML = `<a href="#" onclick="setSpidProviderURL('${data['entity_id']}')">
            <span class="spid-sr-only">${data['organization_name']}</span>
            <img src="${data['logo_uri']}" alt="${data['organization_name']}" />
        </a>`;
    }

    element.prepend(li);
}

function setSpidProviderURL(url) {
    // Imposta l'URL dello SPID Provider nella casella di input nascosta
    document.getElementById('spidProviderURL').value = url;
}

// Quando la pagina è pronta, popola gli IDP
document.onreadystatechange = function () {
    if (document.readyState === "interactive") {
        spid_populate();
    }
};
// Gestisci il click sul pulsante SPID
jQuery(".italia-it-button").click(function () {
    var selectedProvider = jQuery(this).data("idp");
    if (selectedProvider) {
        window.location.href = selectedProvider; // Effettua il reindirizzamento direttamente
    }
});

jQuery(".italia-it-button").click(function () {
    var selectedProvider = jQuery(this).data("idp");
    console.log("Provider selezionato: ", selectedProvider);

    if (selectedProvider) {
        window.location.href = selectedProvider; // Controlla l'URL corretto qui
    }
});





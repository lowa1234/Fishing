

(function () {
	if (!window.Skytech) { window.Skytech = {}; }
	if (!window.Skytech.Services) { window.Skytech.Services = {}; }
	if (!window.Skytech.Services.Intraflex) { window.Skytech.Services.Intraflex = {}; }
	
	Skytech.Services.Intraflex.Recherche = {};


	
	Skytech.Services.Intraflex.Recherche.BuildSearchBox = function () {
		
		
		
 
		var timeoutTyping;
		var timeoutRecherche = 1337;
		var txtRechercheDefault = 'Rechercher...';
		var btnRecherche;
		var btnAnnulerRecherche;
		var txtRecherche;
		var divBoutonsRecherche;

		
		
		document.write("<div class='searchBox'>");

		document.write("<table cellpadding='0' cellspacing='0' border='0'>");
		document.write("<tr>");

		
		

		document.write("<td valign='top'>");
        /* Typo sur le  attr-IndicateurTextboxNonModifier */
		document.write("<input id='txtRecherchePortail' maxlength='150' name='txtRecherchePortail' type='text' value='" + txtRechercheDefault + "' attr-IndicateurTextboxNonModifier='1' />");
		document.write("</td>");

		
		
			document.write("<td valign='top'>");
			document.write("<div class='divBoutonRecherche'>");

			//Christophe Gagnier 2016-04-13 - [F30906] On a des images de recherches fancy et flat à ABI
			
				document.write("<img id='btnRecherche' name='btnRecherche' class='btnRecherche' src='/WebApplication/Module.MIOP/UI/Layout/Themes/Mio_Default/images/MenuBarreOutils_iFind.gif' alt=''  />");
				document.write("<img id='btnAnnulerRecherche' name='btnAnnulerRecherche' class='btnRecherche hidden' src='/images/general/CalculCharge_RetirerGroupe.gif' alt=''  />");
			

			document.write("</div>");
			document.write("</td>");
		

		document.write("</tr>");
		document.write("</table>")

		document.write("</div>");

        document.addEventListener("DOMContentLoaded", function() {

            btnRecherche = $("#btnRecherche");
		    btnAnnulerRecherche = $("#btnAnnulerRecherche");
		    txtRecherche = $("#txtRecherchePortail");
		    divBoutonRecherche = $(".divBoutonRecherche");

		    //on va attacher les événements sur la textbox et sur les boutons Rechercher/Annuler
		    attachEvents();


		    // Mathieu 2013-08-08 [B45412] Petit fix pour Internet Explorer. IE en documentMode 7 présente la textbox et le div un peu décalé.
		    //								en ie8, fixer le vertical-align règle le problème, mais dans les versions supérieures, on a besoin d'ajouter
		    //								un margin-top au div
		    if ($.browser.msie && document.documentMode==7) {
			    txtRecherche.css("vertical-align", "middle");
			    divBoutonRecherche.css("vertical-align", "middle");

			    // Sur IE9 et IE10, on a besoin de se margin-top: 1px; sinon la textbox se trouve décalé, mais pas sur IE7 et IE8
			    // Dawm! IE9 retourne 7 comme version de browser! finalement, on va ajouter le margin si on n'est autre chose que IE8
			    if (typeof $.browser.version !== "undefined" && parseInt($.browser.version) != 8) {
				    divBoutonRecherche.css("margin-top", "1px");
			    }
		    }

		    //Petit fix pour ie quirk mode
		    if ($.browser.msie && document.compatMode != 'CSS1Compat') {
			    divBoutonRecherche.css("margin-top", "0px");
			    txtRecherche.css("height", "19px");

			    if ($.browser.version == "8.0") {
				    txtRecherche.css("height", "20px");
			    }
		    }

		    //statut par defaut de la boite de recherche
		    AnnulerRecherche();

        });

		function Rechercher() 
		{
			if (txtRecherche.val().trim() != '' && txtRecherche.val().trim() != txtRechercheDefault) {
				btnRecherche.hide();
				btnAnnulerRecherche.show();
				txtRecherche.attr('disabled', 'disabled');

				var texteRecherche = remplacerWordCaracteres($("#txtRecherchePortail").val().trim());
				texteRecherche = escape(texteRecherche);

				window.location = "/intr/Module/Recherche/default.aspx?motsCles=" + texteRecherche;
			}
			else {
				btnRecherche.show();
				btnAnnulerRecherche.hide();
			}
		}


		function AnnulerRecherche() {
			txtRecherche.val('');
			btnRecherche.show();
			btnAnnulerRecherche.hide();
			txtRecherche.removeAttr('disabled');

			if (txtRecherche.val().trim() == '') 
			{
				txtRecherche.val(txtRechercheDefault);
				txtRecherche.attr('class', 'txtRechercheDefault');
			}
		}

		function txtRecherche_focus() 
		{
			txtRecherche_click();
		}

		function txtRecherche_click() 
		{
			if (txtRecherche.val().trim() == txtRechercheDefault) {
				txtRecherche.removeAttr('class');
				txtRecherche.val('');
			}
		}


		function txtRecherche_blur() 
		{
			timeoutFiltre = setTimeout(function()
			{
				if (txtRecherche.val().trim() == '') 
				{
					txtRecherche.val(txtRechercheDefault);
					txtRecherche.attr('class', 'txtRechercheDefault');
				}
			}, 200);
		}
		function txtRecherche_keydown(event)
		{
			var keycode = (event.keyCode ? event.keyCode : event.which);

			if (keycode == 13){
				event.preventDefault();
      			return false;
			}
		}
		
		function txtRecherche_keyup(event) 
		{

			var keycode = (event.keyCode ? event.keyCode : event.which);

			if (timeoutTyping) {
				clearTimeout(timeoutTyping);
			}

			if (txtRecherche.val() == '' && txtRecherche.val().trim() != txtRechercheDefault) {
				timeoutTyping = setTimeout(function()
				{
					$("#txtRecherchePortail").val('');
					$("#btnRecherche").show();
					$("#btnAnnulerRecherche").hide();
					$("#txtRecherchePortail").removeAttr('disabled');				
				}, timeoutRecherche);
			}
			else if (keycode == 13){
	
				Rechercher();			
				return false;
			}
			else if (keycode == 27)
			{
				return false;
			}
			else
			{
				if (txtRecherche.val().trim() != '')
				{
					timeoutTyping = setTimeout(function()
					{
						
						$("#btnRecherche").hide();
						$("#btnAnnulerRecherche").show();
						$("#txtRecherchePortail").attr('disabled', 'disabled');

						var texteRecherche = remplacerWordCaracteres($("#txtRecherchePortail").val().trim());
						texteRecherche = escape(texteRecherche);

						window.location = "/intr/Module/Recherche/default.aspx?motsCles=" + texteRecherche;
						
						
					}, timeoutRecherche);
				}

			}

		}


		function attachEvents()
		{

			btnRecherche.click(Rechercher);
			btnAnnulerRecherche.click(AnnulerRecherche);

			txtRecherche.keydown(txtRecherche_keydown);
			txtRecherche.keyup(txtRecherche_keyup);
			txtRecherche.click(txtRecherche_click);
			txtRecherche.focus(txtRecherche_focus);
			txtRecherche.blur(txtRecherche_blur);

		}


		// Remplacer les caractères Word.
		function remplacerWordCaracteres(texte) {
			var NouveauTexte = texte;

			// smart single quotes and apostrophe
			NouveauTexte = NouveauTexte.replace(/[\u2018\u2019\u201A]/g, "\'");
			// smart double quotes
			NouveauTexte = NouveauTexte.replace(/[\u201C\u201D\u201E]/g, "\"");
			// ellipsis
			NouveauTexte = NouveauTexte.replace(/\u2026/g, "...");
			// dashes
			NouveauTexte = NouveauTexte.replace(/[\u2013\u2014]/g, "-");
			// circumflex
			NouveauTexte = NouveauTexte.replace(/\u02C6/g, "^");
			// open angle bracket
			NouveauTexte = NouveauTexte.replace(/\u2039/g, "<");
			// close angle bracket
			NouveauTexte = NouveauTexte.replace(/\u203A/g, ">");
			// spaces
			NouveauTexte = NouveauTexte.replace(/[\u02DC\u00A0]/g, " ");
    
			return NouveauTexte;
		}

		
	};

} ());
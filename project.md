# THÈME : Festival de film (en France)

## Objectifs :
Permettre à un utilisateur :

1. de réserver une place

2.  se renseigner / consulter :
	* une liste de festivals
	* une liste de film (par festival) avec :
		* description du film
		* notation du film
	* liste de personnage invité au festival

## Défintions :

1. Utilisateur
2. Festival
3. une place de festival
4. une réservation de place
5. Film
6. Membre invité à un festival
7. Site de Critique de film
8. Notation d’un film

### Descriptions des tables :

##### Tables :

* Personne : (Id_personne) , nom_personne , prenom_personne , date_naissance 

* Personnes_Invitées : (Id_personne , Id_film , Id_festival) , metier , date_arrivée , date_depart 

* Film : (Id_film) , nom_film , type_film , durée_film , Date_parution 

* Participant : (Id_participant), Id_film , Id_personne , Rôle

* Utilisateur ( user lambda ) : (Id_user , Id_personne , Id_localisation) , Email , Mdp , Téléphone

* Localisation : (Id_localisation), Coord_geo ( lat.  / long. ) 

* Lieu : (Coord_geo),  Département, Ville, Pays, Adresse, Code_postale

* Festival : (Id_festival , Id_edition) , Thème , Nom_festival, Capacité_max, Description_lieu( un cinéma etc), Périodicité, Date_création, Website

* Edition : (Id_edition , Id_festival , Année) , Date_debut , Date_fin , Id_localisation

* Place : (Id_place , Id_festival , Id_personne), Nom_place , Prenom_place , Id_catégorie, Numéro_place 

* Catégorie: (Id_categorie), Prix, Descriptif

* Site_Critique : (Id_site), Nom, Lien

* Critique : (Id_critique , Id_film, Id_site) , Note_global , Avis_general


#### Définitions de Dépendance Fonctionnelles :

* **Personne : Id_personne , nom_personne , prenom_personne , date_naissance**

Id_personne ->  (nom_personne , prenom_personne , date_naissance ) 


* **Personnes_Invitées : (Id_personne , Id_festival , id_film ) , role/metier , date_arrivée , date_depart** 

(Id_personne , Id_festival , id_film) ->  role/metier , date_arrivée , date_depart


* **Film : Id_film , nom_film , type_film , durée_film , Date_parution**

(Id_film ) -> nom_film , type_film , durée_film , Date_parution


* **Participant : ( Id_participant ), Id_film , Id_personne , role**

id_participant -> id_film, id_personne, role
(id_personne, id_film, role) -> id_participant 


* **Localisation : Id_localisation , adresse , code_postale , ville , coord_geo ( lat.  / long. ) , pays , departement**

Id_localisation -> adresse , code_postal , ville , coord_geo , pays , departement

coord_geo -> departement , ville , pays , adresse

_Décomposition :_

loca_1 ( coord_geo, departement , ville , pays , adresse )

ville -> code_postal ,pays , département

code_postal -> departement, ville, pays

loca_2(coord_geo, id_localisation)

Nous avons donc une perte de DF.


* **Festival : ( Id_festival , Id_localisation ) , theme , nombre_place_restante , capacité_max , date_ouverture , date_fermeture , description_lieu( un cinéma etc)**

( Id_festival , Id_localisation ) -> theme , nombre_place_restante , capacité_max , date_ouverture , date_fermeture , description_lieu( un cinéma etc)


* **Place : ( Id_place , Id_festival , Id_personne) , numero_place , nom_place , prenom_place , Prix**

(Id_place , Id_festival , Id_personne) ->  numero_place , nom_place , prenom_place , Prix , categorie

categorie -> prix , numero_place

_Décomposition :_

place_1(categorie, prix , numero_place)

categorie -> prix , numero_place

place_2( Id_place , Id_festival , Id_personne , nom_personne_place , prenom_personne_place , categorie)

( Id_place , Id_festival , Id_personne ) -> nom_personne_place , prenom_personne_place , categorie

Nous avons donc une perte de DF.


* **Site_Critique : Id_site_critique ,nom,  lien**

Id_site_critique -> nom,  lien


* **Critique : (  Id_critique , Id_film , Id_site_critique ) , note_global , avis_general**

(  Id_critique , Id_film , Id_site_critique ) -> note_global , avis_general 
 
* **Utilisateur ( user lambda ) : ( Id_user , Id_personne , Id_localisation ) , adresse_mail ,mot_de_passe , num_tel**

 ( Id_user , Id_personne , Id_localisation ) ->  adresse_mail , mot_de_passe , num_tel
 
* **Edition : ( Id_edition , Id_festival , Année ) , Date_debut , Date_fin , Id_localisation**

( Id_edition , Id_festival , Année ) -> Date_debut , Date_fin , Id_localisation

### Spécifications des contraintes :

* Personne : (Id_personne) , nom_personne , prenom_personne , date_naissance 

* Personnes_Invitées : (Id_personne , Id_film , Id_festival) , Métier , Date_arrivée , Date_depart 
$x \subseteq B$
$Personnes_Invitées[Id_personne] \subseteq Personne[Id_personne]$
$Personnes_Invitées[Id_film] \subseteq Film[Id_film]$
$Personnes_Invitées[Id_festival] \subseteq Festival[Id_festival]$

* Film : (Id_film) , nom_film , type_film , durée_film , Date_parution 

* Participant : (Id_participant), Id_film , Id_personne , role
$Participant[Id_personne] \subseteq Personne[Id_personne]$
$Particpant[Id_film] \subseteq Film[Id_film]$

* Utilisateur ( user lambda ) : (Id_user , Id_personne , Id_localisation) , Email , Mdp , Téléphone
$Utilisateur[Id_personne] \subseteq Personne[Id_personne]$
$Utilisateur[Id_localisation] \subseteq Localisation[Id_localisation]$

* Localisation : (Id_localisation), Coord_geo ( lat.  / long. ) 
$Localisation[Coord_geo] \subseteq Lieu[Coord_geo]$

* Lieu : (Coord_geo),  Département, Ville, Pays, Adresse, Code_postale

* Festival : (Id_festival , Id_edition) , Thème , Nom_festival, Capacité_max, Description_lieu( un cinéma etc), Périodicité, Date_création, Website
$Festival[Id_edition] \subseteq Edition[Id_edition]$

* Edition : (Id_edition , Id_festival , Année) , Date_debut , Date_fin , Id_localisation
$Utilisateur[Id_personne] \subseteq Personne[Id_personne]$

* Place : (Id_place , Id_festival , Id_personne), Nom_place , Prenom_place , Id_categorie, Numero_place 
$Place[Id_festival] \subseteq Festival[Id_festival]$
$Place[Id_personne] \subseteq Personne[Id_personne]$
$Place[Id_categorie] \subseteq Categorie[Id_categorie]$

* Catégorie: (Id_categorie), Prix, Descriptif

* Site_Critique : (Id_site), Nom, Lien

* Critique : (Id_critique , Id_film, Id_site) , Note_global , Avis_general
$Critique[Id_site] \subseteq Site[Id_site]$
$Film[Id_film] \subseteq Film[Id_film]$
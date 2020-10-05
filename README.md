# BDA-FILM

Projet semi-libre autour du monde du cinéma en France.


# Modélisation

## Liste de donées à traiter:
	
La liste de données à traiter est composée de :

1.   "gestion de salle de cinéma"
2.   "gestion de droits à l'image"
3.   "site de critique de films"
4.   "gestion de tournages de films"
5.   "lieux de tournage"
6.   "référence cinématographique"
7.   "festival de film"
8.   "salle de cinéma"
9.   "distribution de films"

## Documentations, Sources :

 * [open data](https://opendata.paris.fr/explore/dataset/tournagesdefilmsparis2011/information/)
 * [city of New York](https://data.cityofnewyork.us/browse?Dataset-Information_Agency=Office+of+Film%2C+Theatre%2C+and+Broadcasting+%28FILM%29)
 * [Ile de France](https://data.iledefrance.fr/explore/dataset/les_salles_de_cinemas_en_ile-de-france/information/)
 * [cinema public](https://cinema-public.opendatasoft.com/explore/)
 * [cnc](https://www.cnc.fr/professionnels/etudes-et-rapports/statistiques/opendata)
 * [données publique francaise](https://www.data.gouv.fr/fr/organizations/centre-national-du-cinema-et-de-l-image-animee/)


## Description des informations :

* Film :

titre, réalisteur, producteur, devis, genre, nationalité, date, aides

* Lieu de tournage :

titre, réalisateur, adresse, organisme demandeur, type de tournage, date de début, date de fin, coordonnées géographique

* Salle de cinéma :

région, département, adresse, code postal, commune, nom, propriétaire, programmateur,  nombre d'écran, nombre de fauteuils, nombre de semaines d'activités, nombre annuel de séances, nombre annuel d'entrées, évolution du nombre d'entrée par rapport à l'année précédente,  nombre annuel de films programmés, nombre annuel de films inédits, nombre annuel de films programmmés en semaine 1, part du marché francais, part du marché européen, part du marché américain, coordonnées géographique 

* Site de critique de film :
	* Uilisateur: nom, prenom, email, mdp, pays
	* Commentaire: film, pseudo, note, 
	
* Festivale :
nom, domaine, complément_domaine, region, departement, commune_principale, communes_secondaire, date_création, periodicité, num_edition, date_debut, date_fin, website, num_identification, postal, INSEE, coordonnées INSEE

## Schéma relationnel :

* **Film** ( id_f, titre, realisateur, année, genre, nationalité )
* **Production** ( id_p, id_f, producteur, devis, date_debut, date_fin, aides )
* **Lieu_Tournage** ( id_lt, adresse, géo )
* **Gestion_Lieu_Tournage**( id_glt, id_p, id_lt, type_tournage, date_debut, date_fin )
* **Salle**( id_s, region, departement, adresse, postal, commune, nom, géo, proprietaire, programmateur)
* **Description_Salle**( id_s, nb_écran, nb_fauteuils)
* **Chiffre_Salle**( id_s, année, nb_entrées, nb_semaines_activités, nb_films, nb_films_inedit, nb_films_semaine1, part_FR, part_UE, part_US)
 * **Seance**( id_s, id_f, date, heure)
 * **Site_Critique_Film**(id_scf, nom, website)
 * **Utilisateur**(id_u, id_scf, nom, prenom, pseudo, email, mdp, pays)
 * **Notation**(id_f, peudo, note)
 * **Festival**(id_fes, nom, domaine,complément_domaine, region, departement, commune_principale, date_création, périodicité, website, num_identification, postal, INSEE, geo_INSEE )
 * **Edition_Festival**(id_ef, id_fes, annee,  date_debut, date_fin, ville, postal, INSEE, geo_INSEE)
 
 
## Dépendances fonctionnelles :

* Film(id_f, titre, réalisateur, année, genre, nationalité) :

(titre, réalisateur, année)  -> (genre, nationalité)
 
* Production (  id_f, id_f, producteur, devis, date_debut, date_fin, aides ) :

	* id_f -> producteur
	* producteur -> (devis, aides)

* Lieu_tournage( id_lt, adresse, géo ) :

	* adresse -> géo
	* géo -> adresse

* Gestion_Lieu_Tournage ( id_glt, id_p, id_lt, type_tournage, date_debut, date_fin):

	* id_p -> id_lt, type_tournage
	* (id_lt, type_tournage) -> (date_debut, date_fin)

* Salle( id_s, region, departement, adresse, postal, commune, nom, géo, proprietaire, programmateur ) :

	* postal -> (departement, commune)
	* (departement, commune) -> (postal, region)
	* (adresse, nom) -> proprietaire
	* propretaire -> programmateur

* Description_Salle ( id_s, nb_écran, nb_fauteuils) :

	* id_s -> (nb_écran, nb_fauteuils)

* Chiffre_Salle ( id_s, année, nb_entrées, nb_semaines_activités, nb_films, nb_films_inedit, nb_films_semaine1, part_FR, part_UE, part_US) :

	* (id_s, année) -> (nb_entrées, nb_semaines_activités, nb_films, nb_films_inédit, nb_films_semaines1, part_FR, part_UE, part_US)

* Seance ( id_s, id_f, date, heure) :

	* (id_s, id_f) -> (date, heure)
	
* Site_Critique_Film id_scf, nom, website) :

	* nom -> website
	* website -> nom
	
* Utilisateur(id_u, id_scf, nom, prenom, pseudo, email, mdp, pays) :

	* pseudo -> ( id_scf, nom, prenom, email, mdp, pays)
	
 * Notation(id_f, id_u, note) :
 
 	* (id_f, id_u) -> note
 
 * Festival(id_fes, nom, domaine,complément_domaine, region, departement, commune_principale, date_création, périodicité, website, num_identification, postal, INSEE, geo_INSEE ) :
 
 	* postal -> commune_principale, depatement, region, INSEE
 	* commune_principale -> postal,  departement, region, INSEE
 	* INSEE -> postal, commune_principale, departement, region
 	* geo_INSEE ->postal, INSEE, commune_principale, departement, region
 	* nom, date_création
 	
 * Edition_Festival(id_ef, id_fes, annee,  date_debut, date_fin, ville, postal, INSEE, geo_INSEE):
 
 	* postal -> ville, INSEE
 	* geo_INSEE -> postal, INSEE, ville
 	* INSEE -> postal, ville
 	

## Définitions :

* Producteur :
> Il a pour fonctions essentielles de :
>  - diriger la conception du projet
>  - en étudier la faisabilité
>  - concevoir le montage financier, en recherchant des financements auprès de partenaires et des aides
>  - mettre en œuvre les ressources humaines, financières et techniques nécessaires à la fabrication du film
> [(gralon)](https://www.gralon.net/articles/art-et-culture/cinema/article-le-producteur---role-et-fonctions-1495.htm)


  	
* Devis :
> L’établissement du devis de production est la pièce financière maîtresse qui va permettre le démarrage de la production.
Il détermine combien d’argent sera dépensé pour chaque phase de réalisation d’un film: développement, pré-production, production, post-production.
(...)
C’est au directeur de production, en collaboration avec le producteur, d’établir le devis et de gérer les dépenses effectuées lors du tournage et de sa préparation.
> [(dirprodformations)](https://dirprodformations.fr/devis-production-cinema/) 



* programmateur :
> « La programmation de salles, lorsqu’elle n’est pas assurée directement par les entreprises propriétaires du fonds de commerce, est effectuée par un groupement ou une entente de programmation. À noter que certains groupements ou ententes programment les salles dont ils sont propriétaires. En 2017, les onze groupements et ententes nationaux agréés programment 3 119 écrans, soit 52,7 % de l’ensemble des écrans. » (cf. Bilan 2017, les dossiers du CNC n°338, mai 2018, p. 85).
 >
 Lorsque le distributeur se réfère à « la salle » ou à « l’exploitant » il faut comprendre par-là l’exploitant programmateur, même si le terme n’est pas mentionné. Le lieu de projection se substitue aux potentiels intermédiaires décisionnaires. Le programmateur devient « la salle », ou parfois une entité, telle « UGC » ou « Gaumont ». 
[(openedition)](https://journals.openedition.org/entrelacs/4204) 






## Discussion :

## Table de bases :

* **Festival**( nom, domaine, complément_domaine, commune_principale,departement, nom_Département, région, autres_communes, date_création, périodicité, 







































# BDA-FILM MODELISATION


## List of data:
	
The data list in the subject is made up of :

1.   "gestion de salle de cinéma"
2.   "gestion de droits à l'image"
3.   "site de critique de films"
4.   "gestion de tournages de films"
5.   "lieux de tournage"
6.   "référence cinématographique"
7.   "festival de film"
8.   "salle de cinéma"
9.   "distribution de films"

## Documentation Sources :

 * [open data](https://opendata.paris.fr/explore/dataset/tournagesdefilmsparis2011/information/)
 * [city of New York](https://data.cityofnewyork.us/browse?Dataset-Information_Agency=Office+of+Film%2C+Theatre%2C+and+Broadcasting+%28FILM%29)
 * [Ile de France](https://data.iledefrance.fr/explore/dataset/les_salles_de_cinemas_en_ile-de-france/information/)
 * [cinema public](https://cinema-public.opendatasoft.com/explore/)
 * [cnc](https://www.cnc.fr/professionnels/etudes-et-rapports/statistiques/opendata)
 * [données publique francaise](https://www.data.gouv.fr/fr/organizations/centre-national-du-cinema-et-de-l-image-animee/)


## Data description :

* Film :

titre, réalisteur, producteur, devis, genre, nationalité, date, aides

* Lieu de tournage :

titre, réalisateur, adresse, organisme demandeur, type de tournage, date de début, date de fin, coordonnées géographique

* Salle de cinéma :

région, département, adresse, code postal, commune, nom, propriétaire, programmateur,  nombre d'écran, nombre de fauteuils, nombre de semaines d'activités, nombre annuel de séances, nombre annuel d'entrées, évolution du nombre d'entrée par rapport à l'année précédente,  nombre annuel de films programmés, nombre annuel de films inédits, nombre annuel de films programmmés en semaine 1, part du marché francais, part du marcché européen, part du marché américain, coordonnées géographique 


## DataBase description :

* **Film** ( id_f, titre, realisateur, année, genre, nationnalié )
* **Tournage_Film** ( id_tf, id_f, producteur, devis, date, aides )
* **Lieu_Tournage** ( id_lt, adresse, géo )
* **Gestion_Lieu_Tournage**( id_glt, id_tf, id_lt, type_tournage, date_debut, date_fin )
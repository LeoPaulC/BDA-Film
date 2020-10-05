-- script de test de cretaion d'utilisateur 

\echo
\echo TEST DE CREATION D UN UTILISATEUR
\echo
\echo essayez de vous créer un utilisateur :
\echo
\echo
\prompt 'entrez votre nom : ' nom
\prompt 'entrez votre prenom : ' prenom
\prompt 'entrez votre date de naissance : ' date_n
\prompt 'entrez votre e-mail : ' mail
\prompt 'entrez votre mot de passe : ' mdp
\echo
select create_utilisateur(varchar :'mail',varchar :'mdp',varchar :'nom',varchar :'prenom',date :'date_n');

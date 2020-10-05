CREATE OR REPLACE FUNCTION create_personne(nom VARCHAR(80), prenom VARCHAR(80), date_n date) RETURNS INTEGER AS $$
DECLARE
	id INTEGER;
BEGIN
	INSERT INTO personne(Nom_personne, Prenom_personne, Date_naissance) VALUES (
		nom,
		prenom,
		date_n
	)RETURNING Id_personne INTO id;

	RAISE NOTICE 'personne : %, %, né le % a été créé avec
	l identificateur : %',nom,prenom,date_n,id;
	
	RETURN id;
END
$$ LANGUAGE plpgsql;
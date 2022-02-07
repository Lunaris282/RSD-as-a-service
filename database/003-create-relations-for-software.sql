CREATE TABLE repository_url (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	software UUID references software (id) NOT NULL,
	url VARCHAR NOT NULL,
	license VARCHAR,
	license_scraped_at TIMESTAMP,
	commit_history JSONB,
	commit_history_scraped_at TIMESTAMP
);


CREATE FUNCTION sanitise_insert_repository_url() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = gen_random_uuid();
	return NEW;
END
$$;

CREATE TRIGGER sanitise_insert_repository_url BEFORE INSERT ON software FOR EACH ROW EXECUTE PROCEDURE sanitise_insert_repository_url();


CREATE FUNCTION sanitise_update_repository_url() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = OLD.id;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_update_repository_url BEFORE UPDATE ON software FOR EACH ROW EXECUTE PROCEDURE sanitise_update_repository_url();



CREATE TABLE license_for_software (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	software UUID references software (id) NOT NULL,
	license VARCHAR(100) NOT NULL,
	UNIQUE(software, license),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE FUNCTION sanitise_insert_license_for_software() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = gen_random_uuid();
	NEW.created_at = LOCALTIMESTAMP;
	NEW.updated_at = NEW.created_at;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_insert_license_for_software BEFORE INSERT ON license_for_software FOR EACH ROW EXECUTE PROCEDURE sanitise_insert_license_for_software();


CREATE FUNCTION sanitise_update_license_for_software() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = OLD.id;
	NEW.created_at = OLD.created_at;
	NEW.updated_at = LOCALTIMESTAMP;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_update_license_for_software BEFORE UPDATE ON license_for_software FOR EACH ROW EXECUTE PROCEDURE sanitise_update_license_for_software();



CREATE TABLE contributor (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	software UUID references software (id) NOT NULL,
	is_contact_person BOOLEAN NOT NULL DEFAULT FALSE,
	email_address VARCHAR,
	family_names VARCHAR NOT NULL,
	given_names VARCHAR NOT NULL,
	name_particle VARCHAR,
	name_suffix VARCHAR,
	avatar_data VARCHAR,
	avatar_mime_type VARCHAR(100),
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

CREATE FUNCTION sanitise_insert_contributor() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = gen_random_uuid();
	NEW.created_at = LOCALTIMESTAMP;
	NEW.updated_at = NEW.created_at;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_insert_contributor BEFORE INSERT ON contributor FOR EACH ROW EXECUTE PROCEDURE sanitise_insert_contributor();


CREATE FUNCTION sanitise_update_contributor() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = OLD.id;
	NEW.created_at = OLD.created_at;
	NEW.updated_at = LOCALTIMESTAMP;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_update_contributor BEFORE UPDATE ON contributor FOR EACH ROW EXECUTE PROCEDURE sanitise_update_contributor();


CREATE FUNCTION get_contributor_image(id UUID) RETURNS BYTEA STABLE LANGUAGE plpgsql AS
$$
DECLARE headers TEXT;
DECLARE blob BYTEA;

BEGIN
	SELECT format(
		'[{"Content-Type": "%s"},'
		'{"Content-Disposition": "inline; filename=\"%s\""},'
		'{"Cache-Control": "max-age=259200"}]',
		contributor.avatar_mime_type,
		contributor.id)
	FROM contributor WHERE contributor.id = get_contributor_image.id INTO headers;

	PERFORM set_config('response.headers', headers, TRUE);

	SELECT decode(contributor.avatar_data, 'base64') FROM contributor WHERE contributor.id = get_contributor_image.id INTO blob;

	IF FOUND
		THEN RETURN(blob);
	ELSE RAISE SQLSTATE 'PT404'
		USING
			message = 'NOT FOUND',
			detail = 'File not found',
			hint = format('%s seems to be an invalid file id', get_contributor_image.id);
	END IF;
END
$$;



CREATE TABLE testimonial (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	software UUID REFERENCES software (id) NOT NULL,
	affiliation VARCHAR(100),
	person VARCHAR(100) NOT NULL,
	text VARCHAR(500) NOT NULL
);

CREATE FUNCTION sanitise_insert_testimonial() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = gen_random_uuid();
	return NEW;
END
$$;

CREATE TRIGGER sanitise_insert_testimonial BEFORE INSERT ON testimonial FOR EACH ROW EXECUTE PROCEDURE sanitise_insert_testimonial();


CREATE FUNCTION sanitise_update_testimonial() RETURNS TRIGGER LANGUAGE plpgsql as
$$
BEGIN
	NEW.id = OLD.id;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_update_testimonial BEFORE UPDATE ON testimonial FOR EACH ROW EXECUTE PROCEDURE sanitise_update_testimonial();

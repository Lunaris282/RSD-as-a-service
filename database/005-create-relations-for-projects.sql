-- SPDX-FileCopyrightText: 2022 Dusan Mijatovic (dv4all)
-- SPDX-FileCopyrightText: 2022 Ewan Cahen (Netherlands eScience Center) <e.cahen@esciencecenter.nl>
-- SPDX-FileCopyrightText: 2022 Netherlands eScience Center
-- SPDX-FileCopyrightText: 2022 dv4all
--
-- SPDX-License-Identifier: Apache-2.0

CREATE TABLE team_member (
	id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
	project UUID references project (id) NOT NULL,
	is_contact_person BOOLEAN NOT NULL DEFAULT FALSE,
	email_address VARCHAR(200),
	family_names VARCHAR(200) NOT NULL,
	given_names VARCHAR(200) NOT NULL,
	affiliation VARCHAR(200),
	role VARCHAR(200),
	orcid VARCHAR(19) CHECK (orcid ~ '^\d{4}-\d{4}-\d{4}-\d{3}[0-9X]$'),
	position INTEGER,
	avatar_data VARCHAR(2750000),
	avatar_mime_type VARCHAR(100),
	created_at TIMESTAMPTZ NOT NULL,
	updated_at TIMESTAMPTZ NOT NULL
);

CREATE FUNCTION sanitise_insert_team_member() RETURNS TRIGGER LANGUAGE plpgsql AS
$$
BEGIN
	NEW.id = gen_random_uuid();
	NEW.created_at = LOCALTIMESTAMP;
	NEW.updated_at = NEW.created_at;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_insert_team_member BEFORE INSERT ON team_member FOR EACH ROW EXECUTE PROCEDURE sanitise_insert_team_member();


CREATE FUNCTION sanitise_update_team_member() RETURNS TRIGGER LANGUAGE plpgsql AS
$$
BEGIN
	NEW.id = OLD.id;
	NEW.created_at = OLD.created_at;
	NEW.updated_at = LOCALTIMESTAMP;
	return NEW;
END
$$;

CREATE TRIGGER sanitise_update_team_member BEFORE UPDATE ON team_member FOR EACH ROW EXECUTE PROCEDURE sanitise_update_team_member();


CREATE FUNCTION get_team_member_image(id UUID) RETURNS BYTEA STABLE LANGUAGE plpgsql AS
$$
DECLARE headers TEXT;
DECLARE blob BYTEA;

BEGIN
	SELECT format(
		'[{"Content-Type": "%s"},'
		'{"Content-Disposition": "inline; filename=\"%s\""},'
		'{"Cache-Control": "max-age=259200"}]',
		team_member.avatar_mime_type,
		team_member.id)
	FROM team_member WHERE team_member.id = get_team_member_image.id INTO headers;

	PERFORM set_config('response.headers', headers, TRUE);

	SELECT decode(team_member.avatar_data, 'base64') FROM team_member WHERE team_member.id = get_team_member_image.id INTO blob;

	IF FOUND
		THEN RETURN(blob);
	ELSE RAISE SQLSTATE 'PT404'
		USING
			message = 'NOT FOUND',
			detail = 'File not found',
			hint = format('%s seems to be an invalid file id', get_team_member_image.id);
	END IF;
END
$$;

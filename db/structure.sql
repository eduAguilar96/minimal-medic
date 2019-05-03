SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: doctors_after_update_row_a(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.doctors_after_update_row_a() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (NEW.years_experience - OLD.years_experience >= 2) THEN
      UPDATE doctors
        SET salary = 1.1*(SELECT salary FROM doctors WHERE id = OLD.id)
      WHERE id = OLD.id;
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: doctors_after_update_row_b(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.doctors_after_update_row_b() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
          IF (NEW.area_id != OLD.area_id AND OLD.domain_id != NULL) THEN
            UPDATE doctors
              SET domain_id = OLD.domain_id
            WHERE id = (
              SELECT id
              FROM doctors
              WHERE area_id = OLD.domain_id LIMIT 1
            );
    
            UPDATE doctors
              SET domain_id = NULL
            WHERE id = OLD.id;
          END IF;
    RETURN NULL;
END;
$$;


--
-- Name: get_area_specialty(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_area_specialty(area_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
      DECLARE
        area_specialty integer;
      BEGIN
        SELECT "specialty"
          INTO area_specialty
        FROM areas a
        WHERE a."id" = area_id;
        RETURN area_specialty;
      END;
      $$;


--
-- Name: get_doctor_specialty(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_doctor_specialty(doctor_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
      DECLARE
        doctor_specialty integer;
      BEGIN
        SELECT "specialty"
          INTO doctor_specialty
        FROM doctors d
        WHERE d."id" = doctor_id;
        RETURN doctor_specialty;
      END;
      $$;


--
-- Name: get_patient_insurance(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_patient_insurance(patient_id uuid) RETURNS integer
    LANGUAGE plpgsql
    AS $$
      DECLARE
        patient_insurance integer;
      BEGIN
        SELECT "insurancePlan"
          INTO patient_insurance
        FROM patients p
        WHERE p."id" = patient_id;
        RETURN patient_insurance;
      END;
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areas (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    location character varying NOT NULL,
    specialty integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_specialty CHECK (((specialty = 0) OR (specialty = 1) OR (specialty = 2) OR (specialty = 3) OR (specialty = 4) OR (specialty = 5) OR (specialty = 6) OR (specialty = 7)))
);


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    specialty integer NOT NULL,
    years_experience integer NOT NULL,
    salary numeric(64,12) NOT NULL,
    domain_id uuid,
    area_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_leader_area CHECK (((area_id = domain_id) OR (domain_id = NULL::uuid))),
    CONSTRAINT check_specialty CHECK (((specialty = 0) OR (specialty = 1) OR (specialty = 2) OR (specialty = 3) OR (specialty = 4) OR (specialty = 5) OR (specialty = 6) OR (specialty = 7))),
    CONSTRAINT check_specialty_area CHECK (((specialty = public.get_area_specialty(area_id)) OR (area_id = NULL::uuid)))
);


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "insurancePlan" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_plan CHECK ((("insurancePlan" = 0) OR ("insurancePlan" = 1) OR ("insurancePlan" = 2)))
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "firstName" character varying NOT NULL,
    "lastName" character varying,
    dob character varying,
    gender character varying NOT NULL,
    labor_type character varying NOT NULL,
    labor_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.treatments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    patient_id uuid NOT NULL,
    doctor_id uuid NOT NULL,
    duration integer,
    medicaments text[] DEFAULT '{}'::text[],
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT check_insurance CHECK ((((public.get_patient_insurance(patient_id) = 0) AND (public.get_doctor_specialty(doctor_id) = 0)) OR ((public.get_patient_insurance(patient_id) = 0) AND (public.get_doctor_specialty(doctor_id) = 6)) OR ((public.get_patient_insurance(patient_id) = 0) AND (public.get_doctor_specialty(doctor_id) = 7)) OR ((public.get_patient_insurance(patient_id) = 1) AND (public.get_doctor_specialty(doctor_id) <> 3)) OR (public.get_patient_insurance(patient_id) = 2)))
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: treatments treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);


--
-- Name: index_doctors_on_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_doctors_on_area_id ON public.doctors USING btree (area_id);


--
-- Name: index_doctors_on_domain_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_doctors_on_domain_id ON public.doctors USING btree (domain_id);


--
-- Name: index_people_on_labor_type_and_labor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_labor_type_and_labor_id ON public.people USING btree (labor_type, labor_id);


--
-- Name: index_treatments_on_doctor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_treatments_on_doctor_id ON public.treatments USING btree (doctor_id);


--
-- Name: index_treatments_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_treatments_on_patient_id ON public.treatments USING btree (patient_id);


--
-- Name: doctors doctors_after_update_row_a; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER doctors_after_update_row_a AFTER UPDATE ON public.doctors FOR EACH ROW EXECUTE PROCEDURE public.doctors_after_update_row_a();


--
-- Name: doctors doctors_after_update_row_b; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER doctors_after_update_row_b AFTER UPDATE ON public.doctors FOR EACH ROW EXECUTE PROCEDURE public.doctors_after_update_row_b();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20190428181243'),
('20190502184505'),
('20190503042729'),
('20190503060016');



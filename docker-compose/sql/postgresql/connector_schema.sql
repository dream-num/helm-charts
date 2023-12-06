--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: connector; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA connector;


ALTER SCHEMA connector OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: connector; Type: TABLE; Schema: connector; Owner: postgres
--

CREATE TABLE connector.connector (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    name text DEFAULT ''::text NOT NULL,
    uuid text DEFAULT ''::text NOT NULL,
    config text DEFAULT ''::text NOT NULL,
    state jsonb DEFAULT '{}'::jsonb NOT NULL,
    table_info jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE connector.connector OWNER TO postgres;

--
-- Name: connector_formdata; Type: TABLE; Schema: connector; Owner: postgres
--

CREATE TABLE connector.connector_formdata (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    uuid text DEFAULT ''::text NOT NULL,
    query_info jsonb DEFAULT '{}'::jsonb NOT NULL,
    schedule text DEFAULT ''::text NOT NULL
);


ALTER TABLE connector.connector_formdata OWNER TO postgres;

--
-- Name: connector_formdata_id_seq; Type: SEQUENCE; Schema: connector; Owner: postgres
--

CREATE SEQUENCE connector.connector_formdata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE connector.connector_formdata_id_seq OWNER TO postgres;

--
-- Name: connector_formdata_id_seq; Type: SEQUENCE OWNED BY; Schema: connector; Owner: postgres
--

ALTER SEQUENCE connector.connector_formdata_id_seq OWNED BY connector.connector_formdata.id;


--
-- Name: connector_id_seq; Type: SEQUENCE; Schema: connector; Owner: postgres
--

CREATE SEQUENCE connector.connector_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE connector.connector_id_seq OWNER TO postgres;

--
-- Name: connector_id_seq; Type: SEQUENCE OWNED BY; Schema: connector; Owner: postgres
--

ALTER SEQUENCE connector.connector_id_seq OWNED BY connector.connector.id;


--
-- Name: connector id; Type: DEFAULT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.connector ALTER COLUMN id SET DEFAULT nextval('connector.connector_id_seq'::regclass);


--
-- Name: connector_formdata id; Type: DEFAULT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.connector_formdata ALTER COLUMN id SET DEFAULT nextval('connector.connector_formdata_id_seq'::regclass);


--
-- Name: connector_formdata connector_formdata_pkey; Type: CONSTRAINT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.connector_formdata
    ADD CONSTRAINT connector_formdata_pkey PRIMARY KEY (id);


--
-- Name: connector connector_pkey; Type: CONSTRAINT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.connector
    ADD CONSTRAINT connector_pkey PRIMARY KEY (id);


--
-- Name: uqe_connector_formdata_uuid; Type: INDEX; Schema: connector; Owner: postgres
--

CREATE UNIQUE INDEX uqe_connector_formdata_uuid ON connector.connector_formdata USING btree (uuid);


--
-- Name: uqe_connector_uuid; Type: INDEX; Schema: connector; Owner: postgres
--

CREATE UNIQUE INDEX uqe_connector_uuid ON connector.connector USING btree (uuid);


--
-- PostgreSQL database dump complete
--


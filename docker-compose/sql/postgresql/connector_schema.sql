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
-- Name: dataform; Type: TABLE; Schema: connector; Owner: postgres
--

CREATE TABLE connector.dataform (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    uuid text DEFAULT ''::text NOT NULL,
    query_info jsonb DEFAULT '{}'::jsonb NOT NULL,
    schedule text DEFAULT ''::text NOT NULL
);


ALTER TABLE connector.dataform OWNER TO postgres;

--
-- Name: dataform_id_seq; Type: SEQUENCE; Schema: connector; Owner: postgres
--

CREATE SEQUENCE connector.dataform_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE connector.dataform_id_seq OWNER TO postgres;

--
-- Name: dataform_id_seq; Type: SEQUENCE OWNED BY; Schema: connector; Owner: postgres
--

ALTER SEQUENCE connector.dataform_id_seq OWNED BY connector.dataform.id;


--
-- Name: displayer; Type: TABLE; Schema: connector; Owner: postgres
--

CREATE TABLE connector.displayer (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    name text DEFAULT ''::text NOT NULL,
    uuid text DEFAULT ''::text NOT NULL,
    config text DEFAULT ''::text NOT NULL
);


ALTER TABLE connector.displayer OWNER TO postgres;

--
-- Name: displayer_id_seq; Type: SEQUENCE; Schema: connector; Owner: postgres
--

CREATE SEQUENCE connector.displayer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE connector.displayer_id_seq OWNER TO postgres;

--
-- Name: displayer_id_seq; Type: SEQUENCE OWNED BY; Schema: connector; Owner: postgres
--

ALTER SEQUENCE connector.displayer_id_seq OWNED BY connector.displayer.id;


--
-- Name: stream_view; Type: TABLE; Schema: connector; Owner: postgres
--

CREATE TABLE connector.stream_view (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    name text DEFAULT ''::text NOT NULL,
    uuid text DEFAULT ''::text NOT NULL,
    config text DEFAULT ''::text NOT NULL
);


ALTER TABLE connector.stream_view OWNER TO postgres;

--
-- Name: stream_view_id_seq; Type: SEQUENCE; Schema: connector; Owner: postgres
--

CREATE SEQUENCE connector.stream_view_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE connector.stream_view_id_seq OWNER TO postgres;

--
-- Name: stream_view_id_seq; Type: SEQUENCE OWNED BY; Schema: connector; Owner: postgres
--

ALTER SEQUENCE connector.stream_view_id_seq OWNED BY connector.stream_view.id;


--
-- Name: connector id; Type: DEFAULT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.connector ALTER COLUMN id SET DEFAULT nextval('connector.connector_id_seq'::regclass);


--
-- Name: dataform id; Type: DEFAULT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.dataform ALTER COLUMN id SET DEFAULT nextval('connector.dataform_id_seq'::regclass);


--
-- Name: displayer id; Type: DEFAULT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.displayer ALTER COLUMN id SET DEFAULT nextval('connector.displayer_id_seq'::regclass);


--
-- Name: stream_view id; Type: DEFAULT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.stream_view ALTER COLUMN id SET DEFAULT nextval('connector.stream_view_id_seq'::regclass);


--
-- Name: connector connector_pkey; Type: CONSTRAINT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.connector
    ADD CONSTRAINT connector_pkey PRIMARY KEY (id);


--
-- Name: dataform dataform_pkey; Type: CONSTRAINT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.dataform
    ADD CONSTRAINT dataform_pkey PRIMARY KEY (id);


--
-- Name: displayer displayer_pkey; Type: CONSTRAINT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.displayer
    ADD CONSTRAINT displayer_pkey PRIMARY KEY (id);


--
-- Name: stream_view stream_view_pkey; Type: CONSTRAINT; Schema: connector; Owner: postgres
--

ALTER TABLE ONLY connector.stream_view
    ADD CONSTRAINT stream_view_pkey PRIMARY KEY (id);


--
-- Name: test; Type: INDEX; Schema: connector; Owner: postgres
--

CREATE UNIQUE INDEX test ON connector.stream_view USING btree (uuid, deleted_at) NULLS NOT DISTINCT;


--
-- Name: uqe_connector_uuid; Type: INDEX; Schema: connector; Owner: postgres
--

CREATE UNIQUE INDEX uqe_connector_uuid ON connector.connector USING btree (uuid);


--
-- Name: uqe_dataform_uuid; Type: INDEX; Schema: connector; Owner: postgres
--

CREATE UNIQUE INDEX uqe_dataform_uuid ON connector.dataform USING btree (uuid, deleted_at) NULLS NOT DISTINCT;


--
-- Name: uqe_displayer_uuid; Type: INDEX; Schema: connector; Owner: postgres
--

CREATE UNIQUE INDEX uqe_displayer_uuid ON connector.displayer USING btree (uuid, deleted_at) NULLS NOT DISTINCT;


--
-- PostgreSQL database dump complete
--


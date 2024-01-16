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
-- Name: universer; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA universer;


ALTER SCHEMA universer OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: changeset; Type: TABLE; Schema: universer; Owner: postgres
--

CREATE TABLE universer.changeset (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    unit_id character varying(255) NOT NULL,
    revision integer NOT NULL,
    type smallint NOT NULL,
    base_rev integer NOT NULL,
    user_id character varying(255) NOT NULL,
    mutations jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE universer.changeset OWNER TO postgres;

--
-- Name: changeset_id_seq; Type: SEQUENCE; Schema: universer; Owner: postgres
--

CREATE SEQUENCE universer.changeset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE universer.changeset_id_seq OWNER TO postgres;

--
-- Name: changeset_id_seq; Type: SEQUENCE OWNED BY; Schema: universer; Owner: postgres
--

ALTER SEQUENCE universer.changeset_id_seq OWNED BY universer.changeset.id;


--
-- Name: resource; Type: TABLE; Schema: universer; Owner: postgres
--

CREATE TABLE universer.resource (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    resource_id character varying NOT NULL,
    name character varying NOT NULL,
    data text DEFAULT '{}'::jsonb
);


ALTER TABLE universer.resource OWNER TO postgres;

--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: universer; Owner: postgres
--

CREATE SEQUENCE universer.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE universer.resource_id_seq OWNER TO postgres;

--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: universer; Owner: postgres
--

ALTER SEQUENCE universer.resource_id_seq OWNED BY universer.resource.id;


--
-- Name: sheet_block; Type: TABLE; Schema: universer; Owner: postgres
--

CREATE TABLE universer.sheet_block (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    block_id character varying NOT NULL,
    start_row integer NOT NULL,
    end_row integer NOT NULL,
    rows jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE universer.sheet_block OWNER TO postgres;

--
-- Name: sheet_block_id_seq; Type: SEQUENCE; Schema: universer; Owner: postgres
--

CREATE SEQUENCE universer.sheet_block_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE universer.sheet_block_id_seq OWNER TO postgres;

--
-- Name: sheet_block_id_seq; Type: SEQUENCE OWNED BY; Schema: universer; Owner: postgres
--

ALTER SEQUENCE universer.sheet_block_id_seq OWNED BY universer.sheet_block.id;


--
-- Name: unit; Type: TABLE; Schema: universer; Owner: postgres
--

CREATE TABLE universer.unit (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    unit_id character varying NOT NULL,
    creator character varying NOT NULL,
    name character varying,
    type smallint NOT NULL
);


ALTER TABLE universer.unit OWNER TO postgres;

--
-- Name: workbook_id_seq; Type: SEQUENCE; Schema: universer; Owner: postgres
--

CREATE SEQUENCE universer.workbook_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE universer.workbook_id_seq OWNER TO postgres;

--
-- Name: workbook_id_seq; Type: SEQUENCE OWNED BY; Schema: universer; Owner: postgres
--

ALTER SEQUENCE universer.workbook_id_seq OWNED BY universer.unit.id;


--
-- Name: workbook_top_snapshot; Type: TABLE; Schema: universer; Owner: postgres
--

CREATE TABLE universer.workbook_top_snapshot (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    unit_id character varying NOT NULL,
    snapshot_id character varying NOT NULL,
    revision integer NOT NULL,
    sheet_count integer NOT NULL,
    sheet_blocks jsonb DEFAULT '{}'::jsonb,
    worksheets jsonb DEFAULT '{}'::jsonb,
    resources jsonb DEFAULT '{}'::jsonb,
    original_meta jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE universer.workbook_top_snapshot OWNER TO postgres;

--
-- Name: workbook_top_snapshot_id_seq; Type: SEQUENCE; Schema: universer; Owner: postgres
--

CREATE SEQUENCE universer.workbook_top_snapshot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE universer.workbook_top_snapshot_id_seq OWNER TO postgres;

--
-- Name: workbook_top_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: universer; Owner: postgres
--

ALTER SEQUENCE universer.workbook_top_snapshot_id_seq OWNED BY universer.workbook_top_snapshot.id;


--
-- Name: worksheet; Type: TABLE; Schema: universer; Owner: postgres
--

CREATE TABLE universer.worksheet (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at timestamp with time zone,
    unit_id character varying NOT NULL,
    sheet_id character varying NOT NULL,
    type smallint NOT NULL,
    name character varying NOT NULL,
    row_count integer NOT NULL,
    column_count integer NOT NULL,
    index integer NOT NULL,
    original_meta jsonb DEFAULT '{}'::jsonb,
    snapshot_id character varying
);


ALTER TABLE universer.worksheet OWNER TO postgres;

--
-- Name: worksheet_id_seq; Type: SEQUENCE; Schema: universer; Owner: postgres
--

CREATE SEQUENCE universer.worksheet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE universer.worksheet_id_seq OWNER TO postgres;

--
-- Name: worksheet_id_seq; Type: SEQUENCE OWNED BY; Schema: universer; Owner: postgres
--

ALTER SEQUENCE universer.worksheet_id_seq OWNED BY universer.worksheet.id;


--
-- Name: changeset id; Type: DEFAULT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.changeset ALTER COLUMN id SET DEFAULT nextval('universer.changeset_id_seq'::regclass);


--
-- Name: resource id; Type: DEFAULT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.resource ALTER COLUMN id SET DEFAULT nextval('universer.resource_id_seq'::regclass);


--
-- Name: sheet_block id; Type: DEFAULT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.sheet_block ALTER COLUMN id SET DEFAULT nextval('universer.sheet_block_id_seq'::regclass);


--
-- Name: unit id; Type: DEFAULT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.unit ALTER COLUMN id SET DEFAULT nextval('universer.workbook_id_seq'::regclass);


--
-- Name: workbook_top_snapshot id; Type: DEFAULT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.workbook_top_snapshot ALTER COLUMN id SET DEFAULT nextval('universer.workbook_top_snapshot_id_seq'::regclass);


--
-- Name: worksheet id; Type: DEFAULT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.worksheet ALTER COLUMN id SET DEFAULT nextval('universer.worksheet_id_seq'::regclass);


--
-- Name: changeset changeset_pkey; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.changeset
    ADD CONSTRAINT changeset_pkey PRIMARY KEY (id);


--
-- Name: resource resource_pkey; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);


--
-- Name: sheet_block sheet_block_pkey; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.sheet_block
    ADD CONSTRAINT sheet_block_pkey PRIMARY KEY (id);


--
-- Name: resource uniq_resource_resource_id; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.resource
    ADD CONSTRAINT uniq_resource_resource_id UNIQUE (resource_id);


--
-- Name: changeset uniq_unit_id_revision; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.changeset
    ADD CONSTRAINT uniq_unit_id_revision UNIQUE (unit_id, revision);


--
-- Name: workbook_top_snapshot uniq_workbook_top_snapshot_snapshot_id; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.workbook_top_snapshot
    ADD CONSTRAINT uniq_workbook_top_snapshot_snapshot_id UNIQUE (snapshot_id);


--
-- Name: workbook_top_snapshot uniq_workbook_top_snapshot_unit_id_revision; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.workbook_top_snapshot
    ADD CONSTRAINT uniq_workbook_top_snapshot_unit_id_revision UNIQUE (unit_id, revision);


--
-- Name: unit uniq_workbook_unit_id; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.unit
    ADD CONSTRAINT uniq_workbook_unit_id UNIQUE (unit_id);


--
-- Name: worksheet uniq_worksheet_unit_id_snapshot_sheet_id; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.worksheet
    ADD CONSTRAINT uniq_worksheet_unit_id_snapshot_sheet_id UNIQUE (unit_id, snapshot_id, sheet_id);


--
-- Name: unit workbook_pkey; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.unit
    ADD CONSTRAINT workbook_pkey PRIMARY KEY (id);


--
-- Name: workbook_top_snapshot workbook_top_snapshot_pkey; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.workbook_top_snapshot
    ADD CONSTRAINT workbook_top_snapshot_pkey PRIMARY KEY (id);


--
-- Name: worksheet worksheet_pkey; Type: CONSTRAINT; Schema: universer; Owner: postgres
--

ALTER TABLE ONLY universer.worksheet
    ADD CONSTRAINT worksheet_pkey PRIMARY KEY (id);


--
-- Name: idx_changeset_deleted_at; Type: INDEX; Schema: universer; Owner: postgres
--

CREATE INDEX idx_changeset_deleted_at ON universer.changeset USING btree (deleted_at);


--
-- Name: uniq_sheet_block_block_id; Type: INDEX; Schema: universer; Owner: postgres
--

CREATE UNIQUE INDEX uniq_sheet_block_block_id ON universer.sheet_block USING btree (block_id);


--
-- PostgreSQL database dump complete
--


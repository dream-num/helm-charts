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
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: convert_ts(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.convert_ts(s character varying) RETURNS timestamp without time zone
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
  RETURN s::timestamptz at time zone 'UTC';
END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.executions_visibility (
    namespace_id character(64) NOT NULL,
    run_id character(64) NOT NULL,
    start_time timestamp without time zone NOT NULL,
    execution_time timestamp without time zone NOT NULL,
    workflow_id character varying(255) NOT NULL,
    workflow_type_name character varying(255) NOT NULL,
    status integer NOT NULL,
    close_time timestamp without time zone,
    history_length bigint,
    memo bytea,
    encoding character varying(64) NOT NULL,
    task_queue character varying(255) DEFAULT ''::character varying NOT NULL
);




--
-- Name: schema_update_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_update_history (
    version_partition integer NOT NULL,
    year integer NOT NULL,
    month integer NOT NULL,
    update_time timestamp without time zone NOT NULL,
    description character varying(255),
    manifest_md5 character varying(64),
    new_version character varying(64),
    old_version character varying(64)
);




--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_version (
    version_partition integer NOT NULL,
    db_name character varying(255) NOT NULL,
    creation_time timestamp without time zone,
    curr_version character varying(64),
    min_compatible_version character varying(64)
);




--
-- Data for Name: executions_visibility; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.executions_visibility VALUES ('32049b68-7872-4094-8e63-d0dd59896a83                            ', '449cb84b-d8dc-4b98-a187-e49ef23f9ca6                            ', '2025-10-29 03:44:26.243203', '2025-10-29 12:00:00.243203', 'temporal-sys-history-scanner', 'temporal-sys-history-scanner-workflow', 1, NULL, NULL, '\x', 'Proto3', 'temporal-sys-history-scanner-taskqueue-0');
INSERT INTO public.executions_visibility VALUES ('32049b68-7872-4094-8e63-d0dd59896a83                            ', '5e61e774-7acb-4078-9703-09630b8d3b0f                            ', '2025-10-29 03:44:26.245052', '2025-10-29 12:00:00.245052', 'temporal-sys-tq-scanner', 'temporal-sys-tq-scanner-workflow', 1, NULL, NULL, '\x', 'Proto3', 'temporal-sys-tq-scanner-taskqueue-0');
INSERT INTO public.executions_visibility VALUES ('32049b68-7872-4094-8e63-d0dd59896a83                            ', 'ef36527f-ddb6-408c-b2f9-3ca46df68996                            ', '2025-10-29 03:44:28.290897', '2025-10-29 03:44:28.290897', 'temporal-sys-add-search-attributes-workflow', 'temporal-sys-add-search-attributes-workflow', 2, '2025-10-29 03:44:28.404246', 23, '\x', 'Proto3', 'default-worker-tq');


--
-- Data for Name: schema_update_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_update_history VALUES (0, 2025, 10, '2025-10-29 03:44:25.452487', 'initial version', '', '0.0', '0');
INSERT INTO public.schema_update_history VALUES (0, 2025, 10, '2025-10-29 03:44:25.529832', 'base version of visibility schema', '698373883c1c0dd44607a446a62f2a79', '1.0', '0.0');
INSERT INTO public.schema_update_history VALUES (0, 2025, 10, '2025-10-29 03:44:25.545121', 'add close time & status index', 'e286f8af0a62e291b35189ce29d3fff3', '1.1', '1.0');


--
-- Data for Name: schema_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_version VALUES (0, 'temporal_visibility', '2025-10-29 03:44:25.542924', '1.1', '0.1');


--
-- Name: executions_visibility executions_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.executions_visibility
    ADD CONSTRAINT executions_visibility_pkey PRIMARY KEY (namespace_id, run_id);


--
-- Name: schema_update_history schema_update_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_update_history
    ADD CONSTRAINT schema_update_history_pkey PRIMARY KEY (version_partition, year, month, update_time);


--
-- Name: schema_version schema_version_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pkey PRIMARY KEY (version_partition, db_name);


--
-- Name: by_close_time_by_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_close_time_by_status ON public.executions_visibility USING btree (namespace_id, close_time DESC, run_id, status);


--
-- Name: by_status_by_close_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_status_by_close_time ON public.executions_visibility USING btree (namespace_id, status, close_time DESC, run_id);


--
-- Name: by_status_by_start_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_status_by_start_time ON public.executions_visibility USING btree (namespace_id, status, start_time DESC, run_id);


--
-- Name: by_type_close_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_type_close_time ON public.executions_visibility USING btree (namespace_id, workflow_type_name, status, close_time DESC, run_id);


--
-- Name: by_type_start_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_type_start_time ON public.executions_visibility USING btree (namespace_id, workflow_type_name, status, start_time DESC, run_id);


--
-- Name: by_workflow_id_close_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_workflow_id_close_time ON public.executions_visibility USING btree (namespace_id, workflow_id, status, close_time DESC, run_id);


--
-- Name: by_workflow_id_start_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX by_workflow_id_start_time ON public.executions_visibility USING btree (namespace_id, workflow_id, status, start_time DESC, run_id);


--
-- PostgreSQL database dump complete
--


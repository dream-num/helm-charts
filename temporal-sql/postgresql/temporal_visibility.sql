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

--
-- Name: executions_visibility; Type: TABLE; Schema: public; Owner: -
--

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
    task_queue character varying(255) DEFAULT ''::character varying NOT NULL,
    search_attributes jsonb,
    temporalchangeversion jsonb GENERATED ALWAYS AS ((search_attributes -> 'TemporalChangeVersion'::text)) STORED,
    binarychecksums jsonb GENERATED ALWAYS AS ((search_attributes -> 'BinaryChecksums'::text)) STORED,
    batcheruser character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'BatcherUser'::text)) STORED,
    temporalscheduledstarttime timestamp without time zone GENERATED ALWAYS AS (public.convert_ts(((search_attributes ->> 'TemporalScheduledStartTime'::text))::character varying)) STORED,
    temporalscheduledbyid character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'TemporalScheduledById'::text)) STORED,
    temporalschedulepaused boolean GENERATED ALWAYS AS (((search_attributes -> 'TemporalSchedulePaused'::text))::boolean) STORED,
    temporalnamespacedivision character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'TemporalNamespaceDivision'::text)) STORED,
    bool01 boolean GENERATED ALWAYS AS (((search_attributes -> 'Bool01'::text))::boolean) STORED,
    bool02 boolean GENERATED ALWAYS AS (((search_attributes -> 'Bool02'::text))::boolean) STORED,
    bool03 boolean GENERATED ALWAYS AS (((search_attributes -> 'Bool03'::text))::boolean) STORED,
    datetime01 timestamp without time zone GENERATED ALWAYS AS (public.convert_ts(((search_attributes ->> 'Datetime01'::text))::character varying)) STORED,
    datetime02 timestamp without time zone GENERATED ALWAYS AS (public.convert_ts(((search_attributes ->> 'Datetime02'::text))::character varying)) STORED,
    datetime03 timestamp without time zone GENERATED ALWAYS AS (public.convert_ts(((search_attributes ->> 'Datetime03'::text))::character varying)) STORED,
    double01 numeric(20,5) GENERATED ALWAYS AS (((search_attributes -> 'Double01'::text))::numeric) STORED,
    double02 numeric(20,5) GENERATED ALWAYS AS (((search_attributes -> 'Double02'::text))::numeric) STORED,
    double03 numeric(20,5) GENERATED ALWAYS AS (((search_attributes -> 'Double03'::text))::numeric) STORED,
    int01 bigint GENERATED ALWAYS AS (((search_attributes -> 'Int01'::text))::bigint) STORED,
    int02 bigint GENERATED ALWAYS AS (((search_attributes -> 'Int02'::text))::bigint) STORED,
    int03 bigint GENERATED ALWAYS AS (((search_attributes -> 'Int03'::text))::bigint) STORED,
    keyword01 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword01'::text)) STORED,
    keyword02 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword02'::text)) STORED,
    keyword03 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword03'::text)) STORED,
    keyword04 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword04'::text)) STORED,
    keyword05 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword05'::text)) STORED,
    keyword06 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword06'::text)) STORED,
    keyword07 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword07'::text)) STORED,
    keyword08 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword08'::text)) STORED,
    keyword09 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword09'::text)) STORED,
    keyword10 character varying(255) GENERATED ALWAYS AS ((search_attributes ->> 'Keyword10'::text)) STORED,
    text01 tsvector GENERATED ALWAYS AS (((search_attributes ->> 'Text01'::text))::tsvector) STORED,
    text02 tsvector GENERATED ALWAYS AS (((search_attributes ->> 'Text02'::text))::tsvector) STORED,
    text03 tsvector GENERATED ALWAYS AS (((search_attributes ->> 'Text03'::text))::tsvector) STORED,
    keywordlist01 jsonb GENERATED ALWAYS AS ((search_attributes -> 'KeywordList01'::text)) STORED,
    keywordlist02 jsonb GENERATED ALWAYS AS ((search_attributes -> 'KeywordList02'::text)) STORED,
    keywordlist03 jsonb GENERATED ALWAYS AS ((search_attributes -> 'KeywordList03'::text)) STORED,
    history_size_bytes bigint,
    buildids jsonb GENERATED ALWAYS AS ((search_attributes -> 'BuildIds'::text)) STORED
);


--
-- Name: schema_update_history; Type: TABLE; Schema: public; Owner: -
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
-- Name: schema_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version (
    version_partition integer NOT NULL,
    db_name character varying(255) NOT NULL,
    creation_time timestamp without time zone,
    curr_version character varying(64),
    min_compatible_version character varying(64)
);


--
-- Name: executions_visibility executions_visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.executions_visibility
    ADD CONSTRAINT executions_visibility_pkey PRIMARY KEY (namespace_id, run_id);


--
-- Name: schema_update_history schema_update_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_update_history
    ADD CONSTRAINT schema_update_history_pkey PRIMARY KEY (version_partition, year, month, update_time);


--
-- Name: schema_version schema_version_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pkey PRIMARY KEY (version_partition, db_name);


--
-- Name: by_batcher_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_batcher_user ON public.executions_visibility USING btree (namespace_id, batcheruser, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_binary_checksums; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_binary_checksums ON public.executions_visibility USING gin (namespace_id, binarychecksums jsonb_path_ops);


--
-- Name: by_bool_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_bool_01 ON public.executions_visibility USING btree (namespace_id, bool01, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_bool_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_bool_02 ON public.executions_visibility USING btree (namespace_id, bool02, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_bool_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_bool_03 ON public.executions_visibility USING btree (namespace_id, bool03, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_build_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_build_ids ON public.executions_visibility USING gin (namespace_id, buildids jsonb_path_ops);


--
-- Name: by_datetime_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_datetime_01 ON public.executions_visibility USING btree (namespace_id, datetime01, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_datetime_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_datetime_02 ON public.executions_visibility USING btree (namespace_id, datetime02, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_datetime_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_datetime_03 ON public.executions_visibility USING btree (namespace_id, datetime03, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_double_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_double_01 ON public.executions_visibility USING btree (namespace_id, double01, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_double_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_double_02 ON public.executions_visibility USING btree (namespace_id, double02, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_double_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_double_03 ON public.executions_visibility USING btree (namespace_id, double03, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_execution_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_execution_time ON public.executions_visibility USING btree (namespace_id, execution_time, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_history_length; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_history_length ON public.executions_visibility USING btree (namespace_id, history_length, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_history_size_bytes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_history_size_bytes ON public.executions_visibility USING btree (namespace_id, history_size_bytes, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_int_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_int_01 ON public.executions_visibility USING btree (namespace_id, int01, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_int_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_int_02 ON public.executions_visibility USING btree (namespace_id, int02, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_int_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_int_03 ON public.executions_visibility USING btree (namespace_id, int03, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_01 ON public.executions_visibility USING btree (namespace_id, keyword01, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_02 ON public.executions_visibility USING btree (namespace_id, keyword02, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_03 ON public.executions_visibility USING btree (namespace_id, keyword03, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_04; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_04 ON public.executions_visibility USING btree (namespace_id, keyword04, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_05; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_05 ON public.executions_visibility USING btree (namespace_id, keyword05, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_06; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_06 ON public.executions_visibility USING btree (namespace_id, keyword06, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_07; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_07 ON public.executions_visibility USING btree (namespace_id, keyword07, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_08; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_08 ON public.executions_visibility USING btree (namespace_id, keyword08, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_09; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_09 ON public.executions_visibility USING btree (namespace_id, keyword09, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_10; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_10 ON public.executions_visibility USING btree (namespace_id, keyword10, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_keyword_list_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_list_01 ON public.executions_visibility USING gin (namespace_id, keywordlist01 jsonb_path_ops);


--
-- Name: by_keyword_list_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_list_02 ON public.executions_visibility USING gin (namespace_id, keywordlist02 jsonb_path_ops);


--
-- Name: by_keyword_list_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_keyword_list_03 ON public.executions_visibility USING gin (namespace_id, keywordlist03 jsonb_path_ops);


--
-- Name: by_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_status ON public.executions_visibility USING btree (namespace_id, status, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_task_queue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_task_queue ON public.executions_visibility USING btree (namespace_id, task_queue, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_temporal_change_version; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_temporal_change_version ON public.executions_visibility USING gin (namespace_id, temporalchangeversion jsonb_path_ops);


--
-- Name: by_temporal_namespace_division; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_temporal_namespace_division ON public.executions_visibility USING btree (namespace_id, temporalnamespacedivision, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_temporal_schedule_paused; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_temporal_schedule_paused ON public.executions_visibility USING btree (namespace_id, temporalschedulepaused, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_temporal_scheduled_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_temporal_scheduled_by_id ON public.executions_visibility USING btree (namespace_id, temporalscheduledbyid, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_temporal_scheduled_start_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_temporal_scheduled_start_time ON public.executions_visibility USING btree (namespace_id, temporalscheduledstarttime, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_text_01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_text_01 ON public.executions_visibility USING gin (namespace_id, text01);


--
-- Name: by_text_02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_text_02 ON public.executions_visibility USING gin (namespace_id, text02);


--
-- Name: by_text_03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_text_03 ON public.executions_visibility USING gin (namespace_id, text03);


--
-- Name: by_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_workflow_id ON public.executions_visibility USING btree (namespace_id, workflow_id, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: by_workflow_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_workflow_type ON public.executions_visibility USING btree (namespace_id, workflow_type_name, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- Name: default_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX default_idx ON public.executions_visibility USING btree (namespace_id, COALESCE(close_time, '9999-12-31 23:59:59'::timestamp without time zone) DESC, start_time DESC, run_id);


--
-- PostgreSQL database dump complete
--


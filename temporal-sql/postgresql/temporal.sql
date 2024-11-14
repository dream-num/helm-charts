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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_info_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity_info_maps (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    schedule_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16)
);


--
-- Name: buffered_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.buffered_events (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: buffered_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.buffered_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: buffered_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.buffered_events_id_seq OWNED BY public.buffered_events.id;


--
-- Name: build_id_to_task_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.build_id_to_task_queue (
    namespace_id bytea NOT NULL,
    build_id character varying(255) NOT NULL,
    task_queue_name character varying(255) NOT NULL
);


--
-- Name: child_execution_info_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.child_execution_info_maps (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    initiated_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16)
);


--
-- Name: cluster_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_membership (
    membership_partition integer NOT NULL,
    host_id bytea NOT NULL,
    rpc_address character varying(128) NOT NULL,
    rpc_port smallint NOT NULL,
    role smallint NOT NULL,
    session_start timestamp without time zone DEFAULT '1970-01-01 00:00:01'::timestamp without time zone,
    last_heartbeat timestamp without time zone DEFAULT '1970-01-01 00:00:01'::timestamp without time zone,
    record_expiry timestamp without time zone DEFAULT '1970-01-01 00:00:01'::timestamp without time zone
);


--
-- Name: cluster_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_metadata (
    metadata_partition integer NOT NULL,
    data bytea DEFAULT '\x'::bytea NOT NULL,
    data_encoding character varying(16) DEFAULT 'Proto3'::character varying NOT NULL,
    version bigint DEFAULT 1 NOT NULL
);


--
-- Name: cluster_metadata_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_metadata_info (
    metadata_partition integer NOT NULL,
    cluster_name character varying(255) NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL,
    version bigint NOT NULL
);


--
-- Name: current_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.current_executions (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    create_request_id character varying(255) NOT NULL,
    state integer NOT NULL,
    status integer NOT NULL,
    start_version bigint DEFAULT 0 NOT NULL,
    last_write_version bigint NOT NULL
);


--
-- Name: executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.executions (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    next_event_id bigint NOT NULL,
    last_write_version bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL,
    state bytea NOT NULL,
    state_encoding character varying(16) NOT NULL,
    db_record_version bigint DEFAULT 0 NOT NULL
);


--
-- Name: history_immediate_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.history_immediate_tasks (
    shard_id integer NOT NULL,
    category_id integer NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: history_node; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.history_node (
    shard_id integer NOT NULL,
    tree_id bytea NOT NULL,
    branch_id bytea NOT NULL,
    node_id bigint NOT NULL,
    txn_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL,
    prev_txn_id bigint DEFAULT 0 NOT NULL
);


--
-- Name: history_scheduled_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.history_scheduled_tasks (
    shard_id integer NOT NULL,
    category_id integer NOT NULL,
    visibility_timestamp timestamp without time zone NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: history_tree; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.history_tree (
    shard_id integer NOT NULL,
    tree_id bytea NOT NULL,
    branch_id bytea NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: namespace_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_metadata (
    partition_id integer NOT NULL,
    notification_version bigint NOT NULL
);


--
-- Name: namespaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespaces (
    partition_id integer NOT NULL,
    id bytea NOT NULL,
    name character varying(255) NOT NULL,
    notification_version bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL,
    is_global boolean NOT NULL
);


--
-- Name: queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.queue (
    queue_type integer NOT NULL,
    message_id bigint NOT NULL,
    message_payload bytea NOT NULL,
    message_encoding character varying(16) DEFAULT 'Json'::character varying NOT NULL
);


--
-- Name: queue_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.queue_metadata (
    queue_type integer NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) DEFAULT 'Json'::character varying NOT NULL,
    version bigint DEFAULT 0 NOT NULL
);


--
-- Name: replication_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.replication_tasks (
    shard_id integer NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: replication_tasks_dlq; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.replication_tasks_dlq (
    source_cluster_name character varying(255) NOT NULL,
    shard_id integer NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: request_cancel_info_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_cancel_info_maps (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    initiated_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16)
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
-- Name: shards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shards (
    shard_id integer NOT NULL,
    range_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: signal_info_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signal_info_maps (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    initiated_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16)
);


--
-- Name: signals_requested_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.signals_requested_sets (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    signal_id character varying(255) NOT NULL
);


--
-- Name: task_queue_user_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_queue_user_data (
    namespace_id bytea NOT NULL,
    task_queue_name character varying(255) NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL,
    version bigint NOT NULL
);


--
-- Name: task_queues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_queues (
    range_hash bigint NOT NULL,
    task_queue_id bytea NOT NULL,
    range_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    range_hash bigint NOT NULL,
    task_queue_id bytea NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: timer_info_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timer_info_maps (
    shard_id integer NOT NULL,
    namespace_id bytea NOT NULL,
    workflow_id character varying(255) NOT NULL,
    run_id bytea NOT NULL,
    timer_id character varying(255) NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16)
);


--
-- Name: timer_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timer_tasks (
    shard_id integer NOT NULL,
    visibility_timestamp timestamp without time zone NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: transfer_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transfer_tasks (
    shard_id integer NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: visibility_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visibility_tasks (
    shard_id integer NOT NULL,
    task_id bigint NOT NULL,
    data bytea NOT NULL,
    data_encoding character varying(16) NOT NULL
);


--
-- Name: buffered_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buffered_events ALTER COLUMN id SET DEFAULT nextval('public.buffered_events_id_seq'::regclass);


--
-- Name: activity_info_maps activity_info_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity_info_maps
    ADD CONSTRAINT activity_info_maps_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, schedule_id);


--
-- Name: buffered_events buffered_events_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buffered_events
    ADD CONSTRAINT buffered_events_id_key UNIQUE (id);


--
-- Name: buffered_events buffered_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.buffered_events
    ADD CONSTRAINT buffered_events_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, id);


--
-- Name: build_id_to_task_queue build_id_to_task_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.build_id_to_task_queue
    ADD CONSTRAINT build_id_to_task_queue_pkey PRIMARY KEY (namespace_id, build_id, task_queue_name);


--
-- Name: child_execution_info_maps child_execution_info_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.child_execution_info_maps
    ADD CONSTRAINT child_execution_info_maps_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, initiated_id);


--
-- Name: cluster_membership cluster_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_membership
    ADD CONSTRAINT cluster_membership_pkey PRIMARY KEY (membership_partition, host_id);


--
-- Name: cluster_metadata_info cluster_metadata_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_metadata_info
    ADD CONSTRAINT cluster_metadata_info_pkey PRIMARY KEY (metadata_partition, cluster_name);


--
-- Name: cluster_metadata cluster_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_metadata
    ADD CONSTRAINT cluster_metadata_pkey PRIMARY KEY (metadata_partition);


--
-- Name: current_executions current_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.current_executions
    ADD CONSTRAINT current_executions_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id);


--
-- Name: executions executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.executions
    ADD CONSTRAINT executions_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id);


--
-- Name: history_immediate_tasks history_immediate_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history_immediate_tasks
    ADD CONSTRAINT history_immediate_tasks_pkey PRIMARY KEY (shard_id, category_id, task_id);


--
-- Name: history_node history_node_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history_node
    ADD CONSTRAINT history_node_pkey PRIMARY KEY (shard_id, tree_id, branch_id, node_id, txn_id);


--
-- Name: history_scheduled_tasks history_scheduled_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history_scheduled_tasks
    ADD CONSTRAINT history_scheduled_tasks_pkey PRIMARY KEY (shard_id, category_id, visibility_timestamp, task_id);


--
-- Name: history_tree history_tree_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.history_tree
    ADD CONSTRAINT history_tree_pkey PRIMARY KEY (shard_id, tree_id, branch_id);


--
-- Name: namespace_metadata namespace_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_metadata
    ADD CONSTRAINT namespace_metadata_pkey PRIMARY KEY (partition_id);


--
-- Name: namespaces namespaces_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT namespaces_name_key UNIQUE (name);


--
-- Name: namespaces namespaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT namespaces_pkey PRIMARY KEY (partition_id, id);


--
-- Name: queue_metadata queue_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queue_metadata
    ADD CONSTRAINT queue_metadata_pkey PRIMARY KEY (queue_type);


--
-- Name: queue queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queue
    ADD CONSTRAINT queue_pkey PRIMARY KEY (queue_type, message_id);


--
-- Name: replication_tasks_dlq replication_tasks_dlq_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replication_tasks_dlq
    ADD CONSTRAINT replication_tasks_dlq_pkey PRIMARY KEY (source_cluster_name, shard_id, task_id);


--
-- Name: replication_tasks replication_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.replication_tasks
    ADD CONSTRAINT replication_tasks_pkey PRIMARY KEY (shard_id, task_id);


--
-- Name: request_cancel_info_maps request_cancel_info_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_cancel_info_maps
    ADD CONSTRAINT request_cancel_info_maps_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, initiated_id);


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
-- Name: shards shards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shards
    ADD CONSTRAINT shards_pkey PRIMARY KEY (shard_id);


--
-- Name: signal_info_maps signal_info_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signal_info_maps
    ADD CONSTRAINT signal_info_maps_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, initiated_id);


--
-- Name: signals_requested_sets signals_requested_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.signals_requested_sets
    ADD CONSTRAINT signals_requested_sets_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, signal_id);


--
-- Name: task_queue_user_data task_queue_user_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_queue_user_data
    ADD CONSTRAINT task_queue_user_data_pkey PRIMARY KEY (namespace_id, task_queue_name);


--
-- Name: task_queues task_queues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_queues
    ADD CONSTRAINT task_queues_pkey PRIMARY KEY (range_hash, task_queue_id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (range_hash, task_queue_id, task_id);


--
-- Name: timer_info_maps timer_info_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timer_info_maps
    ADD CONSTRAINT timer_info_maps_pkey PRIMARY KEY (shard_id, namespace_id, workflow_id, run_id, timer_id);


--
-- Name: timer_tasks timer_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timer_tasks
    ADD CONSTRAINT timer_tasks_pkey PRIMARY KEY (shard_id, visibility_timestamp, task_id);


--
-- Name: transfer_tasks transfer_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transfer_tasks
    ADD CONSTRAINT transfer_tasks_pkey PRIMARY KEY (shard_id, task_id);


--
-- Name: visibility_tasks visibility_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visibility_tasks
    ADD CONSTRAINT visibility_tasks_pkey PRIMARY KEY (shard_id, task_id);


--
-- Name: cm_idx_lasthb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cm_idx_lasthb ON public.cluster_membership USING btree (last_heartbeat);


--
-- Name: cm_idx_recordexpiry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cm_idx_recordexpiry ON public.cluster_membership USING btree (record_expiry);


--
-- Name: cm_idx_rolehost; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cm_idx_rolehost ON public.cluster_membership USING btree (role, host_id);


--
-- Name: cm_idx_rolelasthb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cm_idx_rolelasthb ON public.cluster_membership USING btree (role, last_heartbeat);


--
-- Name: cm_idx_rpchost; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cm_idx_rpchost ON public.cluster_membership USING btree (rpc_address, role);


--
-- PostgreSQL database dump complete
--


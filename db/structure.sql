--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: ranking(timestamp without time zone, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION ranking(created_at timestamp without time zone, votes_count integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT ROUND(LOG(2, greatest(votes_count, 1)) + ((EXTRACT(EPOCH FROM created_at) - EXTRACT(EPOCH from timestamp '2014-1-1 0:00')) / 450000)::numeric, 7);
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    namespace character varying(255)
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    body text,
    rep_id integer,
    question_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    question_id integer,
    user_id integer,
    body text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    email character varying(255),
    name character varying(255),
    inviter_id character varying(255),
    intent character varying(255),
    invitable_id integer,
    invitable_type character varying(255),
    acceptor_id integer,
    accepted_at timestamp without time zone,
    token character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE memberships (
    id integer NOT NULL,
    user_id integer,
    party_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: parties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE parties (
    id integer NOT NULL,
    name character varying(255),
    auth_statement character varying(255),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: parties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE parties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE parties_id_seq OWNED BY parties.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    body text,
    is_anonymous boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    votes_count integer DEFAULT 0,
    answers_count integer DEFAULT 0,
    topic_id integer,
    comments_count integer DEFAULT 0 NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: reps; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reps (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    authorisation character varying(255),
    avatar character varying(255)
);


--
-- Name: reps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reps_id_seq OWNED BY reps.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topics (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_admin boolean DEFAULT false,
    name character varying(255) NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: votes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE votes (
    id integer NOT NULL,
    question_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE votes_id_seq OWNED BY votes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY parties ALTER COLUMN id SET DEFAULT nextval('parties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reps ALTER COLUMN id SET DEFAULT nextval('reps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY votes ALTER COLUMN id SET DEFAULT nextval('votes_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: candidates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reps
    ADD CONSTRAINT candidates_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: parties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY parties
    ADD CONSTRAINT parties_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_comments_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_question_id ON comments USING btree (question_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_invitations_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_email ON invitations USING btree (email);


--
-- Name: index_invitations_on_invitable_id_and_invitable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_invitable_id_and_invitable_type ON invitations USING btree (invitable_id, invitable_type);


--
-- Name: index_invitations_on_inviter_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_inviter_id ON invitations USING btree (inviter_id);


--
-- Name: index_invitations_on_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invitations_on_token ON invitations USING btree (token);


--
-- Name: index_memberships_on_party_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_party_id ON memberships USING btree (party_id);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_memberships_on_user_id ON memberships USING btree (user_id);


--
-- Name: index_questions_on_answers_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_answers_count ON questions USING btree (answers_count);


--
-- Name: index_questions_on_ranking; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_ranking ON questions USING btree (ranking(created_at, votes_count) DESC);


--
-- Name: index_questions_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_topic_id ON questions USING btree (topic_id);


--
-- Name: index_questions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_user_id ON questions USING btree (user_id);


--
-- Name: index_questions_on_votes_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_questions_on_votes_count ON questions USING btree (votes_count);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_votes_on_question_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_question_id ON votes USING btree (question_id);


--
-- Name: index_votes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_votes_on_user_id ON votes USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130907232708');

INSERT INTO schema_migrations (version) VALUES ('20130908004114');

INSERT INTO schema_migrations (version) VALUES ('20130908005354');

INSERT INTO schema_migrations (version) VALUES ('20130908005357');

INSERT INTO schema_migrations (version) VALUES ('20130908005358');

INSERT INTO schema_migrations (version) VALUES ('20130908012025');

INSERT INTO schema_migrations (version) VALUES ('20130908012106');

INSERT INTO schema_migrations (version) VALUES ('20130908020127');

INSERT INTO schema_migrations (version) VALUES ('20130908022435');

INSERT INTO schema_migrations (version) VALUES ('20130914233739');

INSERT INTO schema_migrations (version) VALUES ('20130915030851');

INSERT INTO schema_migrations (version) VALUES ('20130917064842');

INSERT INTO schema_migrations (version) VALUES ('20130924215459');

INSERT INTO schema_migrations (version) VALUES ('20140526055344');

INSERT INTO schema_migrations (version) VALUES ('20140526100133');

INSERT INTO schema_migrations (version) VALUES ('20140526102523');

INSERT INTO schema_migrations (version) VALUES ('20140526103750');

INSERT INTO schema_migrations (version) VALUES ('20140527081031');

INSERT INTO schema_migrations (version) VALUES ('20140527085832');

INSERT INTO schema_migrations (version) VALUES ('20140528044541');

INSERT INTO schema_migrations (version) VALUES ('20140528050748');

INSERT INTO schema_migrations (version) VALUES ('20140528051120');

INSERT INTO schema_migrations (version) VALUES ('20140528192731');

INSERT INTO schema_migrations (version) VALUES ('20140529035046');

INSERT INTO schema_migrations (version) VALUES ('20140529053610');

INSERT INTO schema_migrations (version) VALUES ('20140529060555');

INSERT INTO schema_migrations (version) VALUES ('20140529062245');

INSERT INTO schema_migrations (version) VALUES ('20140529104412');

INSERT INTO schema_migrations (version) VALUES ('20140604111130');

INSERT INTO schema_migrations (version) VALUES ('20140605033507');

INSERT INTO schema_migrations (version) VALUES ('20140605060458');

INSERT INTO schema_migrations (version) VALUES ('20140611044129');

INSERT INTO schema_migrations (version) VALUES ('20140617051140');

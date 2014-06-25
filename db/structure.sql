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


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: donations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE donations (
    id integer NOT NULL,
    student_id integer,
    transcation_id character varying(255),
    customer_id character varying(255),
    recurring boolean,
    subscription_id character varying(255),
    status character varying(255),
    amount numeric(10,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: donations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE donations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: donations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE donations_id_seq OWNED BY donations.id;


--
-- Name: field_hosts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE field_hosts (
    id integer NOT NULL,
    sf_object_id character varying(255),
    first_name character varying(255) NOT NULL,
    middle_initial character varying(1),
    last_name character varying(255) NOT NULL,
    salutation character varying(255),
    role_title character varying(255),
    preferred_phone character varying(255),
    phone_type character varying(255),
    organization_id integer,
    properties hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_picture character varying(255)
);


--
-- Name: field_hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE field_hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: field_hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE field_hosts_id_seq OWNED BY field_hosts.id;


--
-- Name: logins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE logins (
    id integer NOT NULL,
    username character varying(255),
    rol character varying(255),
    entity_id integer,
    entity_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255)
);


--
-- Name: logins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE logins_id_seq OWNED BY logins.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    organization_type character varying(255) NOT NULL,
    website character varying(255),
    sf_object_id character varying(255)
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: person_references; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE person_references (
    id integer NOT NULL,
    reference_type character varying(255),
    reference_id integer,
    referencer_id integer,
    referencer_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: person_references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE person_references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE person_references_id_seq OWNED BY person_references.id;


--
-- Name: project_media; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_media (
    id integer NOT NULL,
    image character varying(255),
    project_id integer,
    "order" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_media_id_seq OWNED BY project_media.id;


--
-- Name: project_sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_sessions (
    id integer NOT NULL,
    project_id integer,
    application_deadline date,
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    session_id integer
);


--
-- Name: project_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE project_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE project_sessions_id_seq OWNED BY project_sessions.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying(255),
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sf_object_id character varying(255),
    organization_id integer,
    field_host_id integer,
    properties hstore,
    status character varying(255),
    wizard_status character varying(255),
    team_mode boolean,
    location_private boolean,
    related_fields_of_study character varying(255)[],
    related_student_passions character varying(255)[],
    location_street_address character varying(255),
    location_city character varying(255),
    location_state_or_province character varying(255),
    location_country character varying(255),
    region character varying(255)
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: references; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE "references" (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    phone character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sf_object_id character varying(255)
);


--
-- Name: references_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE references_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: references_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE references_id_seq OWNED BY "references".id;


--
-- Name: refinery_images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_images (
    id integer NOT NULL,
    image_mime_type character varying(255),
    image_name character varying(255),
    image_size integer,
    image_width integer,
    image_height integer,
    image_uid character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: refinery_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_images_id_seq OWNED BY refinery_images.id;


--
-- Name: refinery_page_part_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_page_part_translations (
    id integer NOT NULL,
    refinery_page_part_id integer,
    locale character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: refinery_page_part_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_page_part_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_page_part_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_page_part_translations_id_seq OWNED BY refinery_page_part_translations.id;


--
-- Name: refinery_page_parts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_page_parts (
    id integer NOT NULL,
    refinery_page_id integer,
    title character varying(255),
    body text,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    color character varying(255),
    display_type character varying(255),
    margin character varying(255)
);


--
-- Name: refinery_page_parts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_page_parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_page_parts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_page_parts_id_seq OWNED BY refinery_page_parts.id;


--
-- Name: refinery_page_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_page_translations (
    id integer NOT NULL,
    refinery_page_id integer,
    locale character varying(255),
    title character varying(255),
    custom_slug character varying(255),
    menu_title character varying(255),
    slug character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: refinery_page_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_page_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_page_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_page_translations_id_seq OWNED BY refinery_page_translations.id;


--
-- Name: refinery_pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_pages (
    id integer NOT NULL,
    parent_id integer,
    path character varying(255),
    slug character varying(255),
    show_in_menu boolean DEFAULT true,
    link_url character varying(255),
    menu_match character varying(255),
    deletable boolean DEFAULT true,
    draft boolean DEFAULT false,
    skip_to_first_child boolean DEFAULT false,
    lft integer,
    rgt integer,
    depth integer,
    view_template character varying(255),
    layout_template character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: refinery_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_pages_id_seq OWNED BY refinery_pages.id;


--
-- Name: refinery_resources; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_resources (
    id integer NOT NULL,
    file_mime_type character varying(255),
    file_name character varying(255),
    file_size integer,
    file_uid character varying(255),
    file_ext character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: refinery_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_resources_id_seq OWNED BY refinery_resources.id;


--
-- Name: refinery_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_roles (
    id integer NOT NULL,
    title character varying(255)
);


--
-- Name: refinery_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_roles_id_seq OWNED BY refinery_roles.id;


--
-- Name: refinery_roles_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_roles_users (
    user_id integer,
    role_id integer
);


--
-- Name: refinery_user_plugins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_user_plugins (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    "position" integer
);


--
-- Name: refinery_user_plugins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_user_plugins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_user_plugins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_user_plugins_id_seq OWNED BY refinery_user_plugins.id;


--
-- Name: refinery_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE refinery_users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    encrypted_password character varying(255) NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    sign_in_count integer,
    remember_created_at timestamp without time zone,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    slug character varying(255)
);


--
-- Name: refinery_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE refinery_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refinery_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE refinery_users_id_seq OWNED BY refinery_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: seo_meta; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE seo_meta (
    id integer NOT NULL,
    seo_meta_id integer,
    seo_meta_type character varying(255),
    browser_title character varying(255),
    meta_description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: seo_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE seo_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: seo_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE seo_meta_id_seq OWNED BY seo_meta.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    title character varying(255),
    start_date date,
    end_date date,
    duration character varying(255),
    application_deadline date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sf_object_id character varying(255)
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: student_applications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE student_applications (
    id integer NOT NULL,
    project_session_id integer,
    student_id integer,
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    wizard_status character varying(255),
    agree_terms boolean,
    sf_object_id character varying(255),
    sf_status character varying(255),
    pay_registration_fee boolean
);


--
-- Name: student_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE student_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE student_applications_id_seq OWNED BY student_applications.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE students (
    id integer NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    birthday date,
    gender character varying(255),
    street_address character varying(255),
    city character varying(255),
    postal_code character varying(255),
    country character varying(255),
    preferred_phone character varying(255),
    phone_type character varying(255),
    properties hstore,
    marital_status character varying(255),
    organization character varying(255),
    applied_ipo_before boolean,
    description text,
    academic_reference_id integer,
    spiritual_reference_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fields_of_study character varying(255)[],
    passions character varying(255)[],
    experiences character varying(255)[],
    spoken_languages character varying(255)[],
    heard_about_ipo character varying(255)[],
    profile_picture character varying(255),
    cover_photo character varying(255),
    biography text,
    public_contact_information text,
    published_status boolean DEFAULT false,
    sf_object_id character varying(255),
    state character varying(255)
);


--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE students_id_seq OWNED BY students.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY donations ALTER COLUMN id SET DEFAULT nextval('donations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY field_hosts ALTER COLUMN id SET DEFAULT nextval('field_hosts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY logins ALTER COLUMN id SET DEFAULT nextval('logins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY person_references ALTER COLUMN id SET DEFAULT nextval('person_references_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_media ALTER COLUMN id SET DEFAULT nextval('project_media_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_sessions ALTER COLUMN id SET DEFAULT nextval('project_sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "references" ALTER COLUMN id SET DEFAULT nextval('references_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_images ALTER COLUMN id SET DEFAULT nextval('refinery_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_page_part_translations ALTER COLUMN id SET DEFAULT nextval('refinery_page_part_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_page_parts ALTER COLUMN id SET DEFAULT nextval('refinery_page_parts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_page_translations ALTER COLUMN id SET DEFAULT nextval('refinery_page_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_pages ALTER COLUMN id SET DEFAULT nextval('refinery_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_resources ALTER COLUMN id SET DEFAULT nextval('refinery_resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_roles ALTER COLUMN id SET DEFAULT nextval('refinery_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_user_plugins ALTER COLUMN id SET DEFAULT nextval('refinery_user_plugins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY refinery_users ALTER COLUMN id SET DEFAULT nextval('refinery_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY seo_meta ALTER COLUMN id SET DEFAULT nextval('seo_meta_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY student_applications ALTER COLUMN id SET DEFAULT nextval('student_applications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY students ALTER COLUMN id SET DEFAULT nextval('students_id_seq'::regclass);


--
-- Name: donations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (id);


--
-- Name: field_hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY field_hosts
    ADD CONSTRAINT field_hosts_pkey PRIMARY KEY (id);


--
-- Name: logins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY logins
    ADD CONSTRAINT logins_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: person_references_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY person_references
    ADD CONSTRAINT person_references_pkey PRIMARY KEY (id);


--
-- Name: project_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_media
    ADD CONSTRAINT project_media_pkey PRIMARY KEY (id);


--
-- Name: project_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_sessions
    ADD CONSTRAINT project_sessions_pkey PRIMARY KEY (id);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: references_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "references"
    ADD CONSTRAINT references_pkey PRIMARY KEY (id);


--
-- Name: refinery_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_images
    ADD CONSTRAINT refinery_images_pkey PRIMARY KEY (id);


--
-- Name: refinery_page_part_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_page_part_translations
    ADD CONSTRAINT refinery_page_part_translations_pkey PRIMARY KEY (id);


--
-- Name: refinery_page_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_page_parts
    ADD CONSTRAINT refinery_page_parts_pkey PRIMARY KEY (id);


--
-- Name: refinery_page_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_page_translations
    ADD CONSTRAINT refinery_page_translations_pkey PRIMARY KEY (id);


--
-- Name: refinery_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_pages
    ADD CONSTRAINT refinery_pages_pkey PRIMARY KEY (id);


--
-- Name: refinery_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_resources
    ADD CONSTRAINT refinery_resources_pkey PRIMARY KEY (id);


--
-- Name: refinery_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_roles
    ADD CONSTRAINT refinery_roles_pkey PRIMARY KEY (id);


--
-- Name: refinery_user_plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_user_plugins
    ADD CONSTRAINT refinery_user_plugins_pkey PRIMARY KEY (id);


--
-- Name: refinery_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY refinery_users
    ADD CONSTRAINT refinery_users_pkey PRIMARY KEY (id);


--
-- Name: seo_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY seo_meta
    ADD CONSTRAINT seo_meta_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: student_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY student_applications
    ADD CONSTRAINT student_applications_pkey PRIMARY KEY (id);


--
-- Name: students_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: field_hosts_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX field_hosts_properties ON field_hosts USING gin (properties);


--
-- Name: id_type_index_on_seo_meta; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX id_type_index_on_seo_meta ON seo_meta USING btree (seo_meta_id, seo_meta_type);


--
-- Name: index_logins_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_logins_on_email ON logins USING btree (email);


--
-- Name: index_logins_on_entity_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_logins_on_entity_id ON logins USING btree (entity_id);


--
-- Name: index_logins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_logins_on_reset_password_token ON logins USING btree (reset_password_token);


--
-- Name: index_refinery_page_part_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_page_part_translations_on_locale ON refinery_page_part_translations USING btree (locale);


--
-- Name: index_refinery_page_part_translations_on_refinery_page_part_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_page_part_translations_on_refinery_page_part_id ON refinery_page_part_translations USING btree (refinery_page_part_id);


--
-- Name: index_refinery_page_parts_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_page_parts_on_id ON refinery_page_parts USING btree (id);


--
-- Name: index_refinery_page_parts_on_refinery_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_page_parts_on_refinery_page_id ON refinery_page_parts USING btree (refinery_page_id);


--
-- Name: index_refinery_page_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_page_translations_on_locale ON refinery_page_translations USING btree (locale);


--
-- Name: index_refinery_page_translations_on_refinery_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_page_translations_on_refinery_page_id ON refinery_page_translations USING btree (refinery_page_id);


--
-- Name: index_refinery_pages_on_depth; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_pages_on_depth ON refinery_pages USING btree (depth);


--
-- Name: index_refinery_pages_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_pages_on_id ON refinery_pages USING btree (id);


--
-- Name: index_refinery_pages_on_lft; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_pages_on_lft ON refinery_pages USING btree (lft);


--
-- Name: index_refinery_pages_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_pages_on_parent_id ON refinery_pages USING btree (parent_id);


--
-- Name: index_refinery_pages_on_rgt; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_pages_on_rgt ON refinery_pages USING btree (rgt);


--
-- Name: index_refinery_roles_users_on_role_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_roles_users_on_role_id_and_user_id ON refinery_roles_users USING btree (role_id, user_id);


--
-- Name: index_refinery_roles_users_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_roles_users_on_user_id_and_role_id ON refinery_roles_users USING btree (user_id, role_id);


--
-- Name: index_refinery_user_plugins_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_user_plugins_on_name ON refinery_user_plugins USING btree (name);


--
-- Name: index_refinery_user_plugins_on_user_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_refinery_user_plugins_on_user_id_and_name ON refinery_user_plugins USING btree (user_id, name);


--
-- Name: index_refinery_users_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_users_on_id ON refinery_users USING btree (id);


--
-- Name: index_refinery_users_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_refinery_users_on_slug ON refinery_users USING btree (slug);


--
-- Name: index_seo_meta_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_seo_meta_on_id ON seo_meta USING btree (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: field_hosts_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY field_hosts
    ADD CONSTRAINT field_hosts_organization_id_fk FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: project_media_project_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_media
    ADD CONSTRAINT project_media_project_id_fk FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- Name: projects_field_host_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_field_host_id_fk FOREIGN KEY (field_host_id) REFERENCES field_hosts(id);


--
-- Name: projects_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_organization_id_fk FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130706200243');

INSERT INTO schema_migrations (version) VALUES ('20130802230047');

INSERT INTO schema_migrations (version) VALUES ('20130823165112');

INSERT INTO schema_migrations (version) VALUES ('20130823165332');

INSERT INTO schema_migrations (version) VALUES ('20130823165418');

INSERT INTO schema_migrations (version) VALUES ('20130828211325');

INSERT INTO schema_migrations (version) VALUES ('20130828222146');

INSERT INTO schema_migrations (version) VALUES ('20130930062101');

INSERT INTO schema_migrations (version) VALUES ('20130930162454');

INSERT INTO schema_migrations (version) VALUES ('20131102202616');

INSERT INTO schema_migrations (version) VALUES ('20131102202617');

INSERT INTO schema_migrations (version) VALUES ('20131102202623');

INSERT INTO schema_migrations (version) VALUES ('20131102202629');

INSERT INTO schema_migrations (version) VALUES ('20131102202637');

INSERT INTO schema_migrations (version) VALUES ('20131102202638');

INSERT INTO schema_migrations (version) VALUES ('20131102202642');

INSERT INTO schema_migrations (version) VALUES ('20131102202643');

INSERT INTO schema_migrations (version) VALUES ('20131102214402');

INSERT INTO schema_migrations (version) VALUES ('20140102160144');

INSERT INTO schema_migrations (version) VALUES ('20140107171451');

INSERT INTO schema_migrations (version) VALUES ('20140110174753');

INSERT INTO schema_migrations (version) VALUES ('20140123194856');

INSERT INTO schema_migrations (version) VALUES ('20140123195819');

INSERT INTO schema_migrations (version) VALUES ('20140123232721');

INSERT INTO schema_migrations (version) VALUES ('20140123232735');

INSERT INTO schema_migrations (version) VALUES ('20140123233300');

INSERT INTO schema_migrations (version) VALUES ('20140123234917');

INSERT INTO schema_migrations (version) VALUES ('20140128150533');

INSERT INTO schema_migrations (version) VALUES ('20140128155054');

INSERT INTO schema_migrations (version) VALUES ('20140204154042');

INSERT INTO schema_migrations (version) VALUES ('20140204221915');

INSERT INTO schema_migrations (version) VALUES ('20140204231710');

INSERT INTO schema_migrations (version) VALUES ('20140211152146');

INSERT INTO schema_migrations (version) VALUES ('20140211153034');

INSERT INTO schema_migrations (version) VALUES ('20140404193239');

INSERT INTO schema_migrations (version) VALUES ('20140414193121');

INSERT INTO schema_migrations (version) VALUES ('20140429005540');

INSERT INTO schema_migrations (version) VALUES ('20140501000237');

INSERT INTO schema_migrations (version) VALUES ('20140502160507');

INSERT INTO schema_migrations (version) VALUES ('20140519154629');

INSERT INTO schema_migrations (version) VALUES ('20140520235541');

INSERT INTO schema_migrations (version) VALUES ('20140603015231');

INSERT INTO schema_migrations (version) VALUES ('20140620000441');

INSERT INTO schema_migrations (version) VALUES ('20140621005243');

INSERT INTO schema_migrations (version) VALUES ('20140625131247');


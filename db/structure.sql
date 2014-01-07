--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
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
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    line1 character varying(255),
    line2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    lat double precision,
    lon double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    timezone character varying(255)
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: checkins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE checkins (
    id integer NOT NULL,
    place_id integer NOT NULL,
    user_id integer NOT NULL,
    lat double precision,
    lon double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: checkins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE checkins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: checkins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE checkins_id_seq OWNED BY checkins.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE companies (
    id integer NOT NULL,
    name character varying(255),
    address_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: credits; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE credits (
    id integer NOT NULL,
    total double precision,
    remaining double precision,
    expiration_date timestamp without time zone,
    user_id integer,
    promo_code_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    package_id integer
);


--
-- Name: credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credits_id_seq OWNED BY credits.id;


--
-- Name: email_collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE email_collections (
    id integer NOT NULL,
    email character varying(255),
    city character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: email_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE email_collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE email_collections_id_seq OWNED BY email_collections.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE favorites (
    id integer NOT NULL,
    workout_key bytea,
    workout_id integer,
    user_id integer,
    place_id integer,
    type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorites_id_seq OWNED BY favorites.id;


--
-- Name: instructors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instructors (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    photo_url character varying(255),
    phone_number character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: instructors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE instructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE instructors_id_seq OWNED BY instructors.id;


--
-- Name: packages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE packages (
    id integer NOT NULL,
    description character varying(255),
    amount integer,
    fit_coins integer,
    discount double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE packages_id_seq OWNED BY packages.id;


--
-- Name: pass_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pass_details (
    id integer NOT NULL,
    place_id integer,
    fine_print text,
    instructions text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    pass_type integer
);


--
-- Name: pass_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pass_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pass_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pass_details_id_seq OWNED BY pass_details.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    user_id integer,
    workout_key bytea,
    place_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    imageable_id integer,
    imageable_type character varying(255),
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    image_remote_url character varying(255),
    url character varying(255)
);


--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: place_contracts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE place_contracts (
    id integer NOT NULL,
    quantity integer,
    price double precision,
    discount double precision,
    place_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: place_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE place_contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: place_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE place_contracts_id_seq OWNED BY place_contracts.id;


--
-- Name: place_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE place_hours (
    id integer NOT NULL,
    day_of_week integer,
    open timestamp without time zone,
    close timestamp without time zone,
    place_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: place_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE place_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: place_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE place_hours_id_seq OWNED BY place_hours.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE places (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    address_id integer,
    source character varying(255),
    source_key bytea,
    url character varying(255),
    phone_number character varying(255),
    tapfit_description text,
    source_description text,
    is_public boolean DEFAULT true NOT NULL,
    dropin_price double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    icon_photo_id integer,
    cover_photo_id integer,
    schedule_url character varying(255),
    can_buy boolean,
    crawler_source integer,
    facility_type integer,
    lowest_price double precision,
    lowest_original_price double precision,
    show_place boolean
);


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: promo_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE promo_codes (
    id integer NOT NULL,
    company_id integer,
    code character varying(255),
    has_used boolean,
    amount double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    quantity integer,
    random_promo double precision,
    user_id integer
);


--
-- Name: promo_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE promo_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: promo_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE promo_codes_id_seq OWNED BY promo_codes.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ratings (
    id integer NOT NULL,
    rating integer NOT NULL,
    user_id integer NOT NULL,
    workout_key bytea,
    workout_id integer,
    place_id integer NOT NULL,
    review text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE receipts (
    id integer NOT NULL,
    place_id integer,
    user_id integer,
    workout_id integer,
    price double precision,
    workout_key bytea,
    expiration_date timestamp without time zone,
    has_used boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    has_booked boolean
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE receipts_id_seq OWNED BY receipts.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE regions (
    id integer NOT NULL,
    name character varying(255),
    city character varying(255),
    state character varying(255),
    lat double precision,
    lon double precision,
    radius integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    low_lat double precision,
    high_lat double precision,
    low_lon double precision,
    high_lon double precision
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE regions_id_seq OWNED BY regions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: trackings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackings (
    id integer NOT NULL,
    distinct_id character varying(255),
    utm_medium character varying(255),
    utm_source character varying(255),
    utm_campaign character varying(255),
    utm_content character varying(255),
    download_iphone boolean DEFAULT false,
    download_android boolean DEFAULT false,
    ip_address character varying(255),
    user_id integer,
    hexicode character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: trackings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trackings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trackings_id_seq OWNED BY trackings.id;


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
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    authentication_token character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255),
    braintree_customer_id text,
    is_guest boolean DEFAULT false,
    title character varying(255),
    phone character varying(255),
    company_id integer,
    provider character varying(255),
    uid character varying(255),
    gender character varying(255),
    birthday timestamp without time zone,
    location character varying(255),
    mb_email text
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
-- Name: workouts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE workouts (
    id integer NOT NULL,
    name character varying(255),
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    instructor_id integer,
    place_id integer,
    source_description text,
    workout_key bytea,
    source character varying(255),
    is_bookable boolean DEFAULT true,
    price double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    can_buy boolean,
    is_day_pass boolean DEFAULT false,
    original_price double precision,
    is_cancelled boolean DEFAULT false,
    pass_detail_id integer,
    crawler_info hstore
);


--
-- Name: workouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE workouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE workouts_id_seq OWNED BY workouts.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY checkins ALTER COLUMN id SET DEFAULT nextval('checkins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits ALTER COLUMN id SET DEFAULT nextval('credits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY email_collections ALTER COLUMN id SET DEFAULT nextval('email_collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorites ALTER COLUMN id SET DEFAULT nextval('favorites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY instructors ALTER COLUMN id SET DEFAULT nextval('instructors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY packages ALTER COLUMN id SET DEFAULT nextval('packages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pass_details ALTER COLUMN id SET DEFAULT nextval('pass_details_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY place_contracts ALTER COLUMN id SET DEFAULT nextval('place_contracts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY place_hours ALTER COLUMN id SET DEFAULT nextval('place_hours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY promo_codes ALTER COLUMN id SET DEFAULT nextval('promo_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY receipts ALTER COLUMN id SET DEFAULT nextval('receipts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY regions ALTER COLUMN id SET DEFAULT nextval('regions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trackings ALTER COLUMN id SET DEFAULT nextval('trackings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY workouts ALTER COLUMN id SET DEFAULT nextval('workouts_id_seq'::regclass);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: checkins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY checkins
    ADD CONSTRAINT checkins_pkey PRIMARY KEY (id);


--
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: email_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY email_collections
    ADD CONSTRAINT email_collections_pkey PRIMARY KEY (id);


--
-- Name: favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instructors
    ADD CONSTRAINT instructors_pkey PRIMARY KEY (id);


--
-- Name: packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: pass_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pass_details
    ADD CONSTRAINT pass_details_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: place_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY place_contracts
    ADD CONSTRAINT place_contracts_pkey PRIMARY KEY (id);


--
-- Name: place_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY place_hours
    ADD CONSTRAINT place_hours_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: promo_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY promo_codes
    ADD CONSTRAINT promo_codes_pkey PRIMARY KEY (id);


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: trackings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackings
    ADD CONSTRAINT trackings_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);


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
-- Name: index_addresses_on_city; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_city ON addresses USING btree (city);


--
-- Name: index_addresses_on_lat; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_lat ON addresses USING btree (lat);


--
-- Name: index_addresses_on_lon; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_lon ON addresses USING btree (lon);


--
-- Name: index_checkins_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_checkins_on_place_id ON checkins USING btree (place_id);


--
-- Name: index_checkins_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_checkins_on_user_id ON checkins USING btree (user_id);


--
-- Name: index_credits_on_package_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credits_on_package_id ON credits USING btree (package_id);


--
-- Name: index_credits_on_promo_code_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credits_on_promo_code_id ON credits USING btree (promo_code_id);


--
-- Name: index_credits_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_credits_on_user_id ON credits USING btree (user_id);


--
-- Name: index_favorites_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_place_id ON favorites USING btree (place_id);


--
-- Name: index_favorites_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_user_id ON favorites USING btree (user_id);


--
-- Name: index_favorites_on_workout_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_workout_id ON favorites USING btree (workout_id);


--
-- Name: index_favorites_on_workout_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_favorites_on_workout_key ON favorites USING btree (workout_key);


--
-- Name: index_instructors_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_instructors_on_email ON instructors USING btree (email);


--
-- Name: index_instructors_on_phone_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_instructors_on_phone_number ON instructors USING btree (phone_number);


--
-- Name: index_pass_details_on_pass_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pass_details_on_pass_type ON pass_details USING btree (pass_type);


--
-- Name: index_pass_details_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pass_details_on_place_id ON pass_details USING btree (place_id);


--
-- Name: index_photos_on_imageable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photos_on_imageable_id ON photos USING btree (imageable_id);


--
-- Name: index_photos_on_imageable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photos_on_imageable_type ON photos USING btree (imageable_type);


--
-- Name: index_photos_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photos_on_place_id ON photos USING btree (place_id);


--
-- Name: index_photos_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photos_on_user_id ON photos USING btree (user_id);


--
-- Name: index_photos_on_workout_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_photos_on_workout_key ON photos USING btree (workout_key);


--
-- Name: index_place_contracts_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_place_contracts_on_place_id ON place_contracts USING btree (place_id);


--
-- Name: index_place_hours_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_place_hours_on_place_id ON place_hours USING btree (place_id);


--
-- Name: index_places_on_can_buy; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_can_buy ON places USING btree (can_buy);


--
-- Name: index_places_on_crawler_source; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_crawler_source ON places USING btree (crawler_source);


--
-- Name: index_places_on_is_public; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_is_public ON places USING btree (is_public);


--
-- Name: index_places_on_show_place; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_show_place ON places USING btree (show_place);


--
-- Name: index_places_on_source; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_source ON places USING btree (source);


--
-- Name: index_places_on_source_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_places_on_source_key ON places USING btree (source_key);


--
-- Name: index_promo_codes_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_promo_codes_on_code ON promo_codes USING btree (code);


--
-- Name: index_promo_codes_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_promo_codes_on_company_id ON promo_codes USING btree (company_id);


--
-- Name: index_promo_codes_on_has_used; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_promo_codes_on_has_used ON promo_codes USING btree (has_used);


--
-- Name: index_promo_codes_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_promo_codes_on_user_id ON promo_codes USING btree (user_id);


--
-- Name: index_ratings_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_place_id ON ratings USING btree (place_id);


--
-- Name: index_ratings_on_rating; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_rating ON ratings USING btree (rating);


--
-- Name: index_ratings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_user_id ON ratings USING btree (user_id);


--
-- Name: index_ratings_on_workout_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_workout_id ON ratings USING btree (workout_id);


--
-- Name: index_ratings_on_workout_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_ratings_on_workout_key ON ratings USING btree (workout_key);


--
-- Name: index_receipts_on_has_used; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_receipts_on_has_used ON receipts USING btree (has_used);


--
-- Name: index_receipts_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_receipts_on_place_id ON receipts USING btree (place_id);


--
-- Name: index_receipts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_receipts_on_user_id ON receipts USING btree (user_id);


--
-- Name: index_receipts_on_workout_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_receipts_on_workout_id ON receipts USING btree (workout_id);


--
-- Name: index_receipts_on_workout_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_receipts_on_workout_key ON receipts USING btree (workout_key);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_trackings_on_distinct_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_distinct_id ON trackings USING btree (distinct_id);


--
-- Name: index_trackings_on_download_android; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_download_android ON trackings USING btree (download_android);


--
-- Name: index_trackings_on_download_iphone; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_download_iphone ON trackings USING btree (download_iphone);


--
-- Name: index_trackings_on_hexicode; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_hexicode ON trackings USING btree (hexicode);


--
-- Name: index_trackings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_user_id ON trackings USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_company_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_company_id ON users USING btree (company_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_is_guest; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_is_guest ON users USING btree (is_guest);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_type ON users USING btree (type);


--
-- Name: index_workouts_on_crawler_info; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_crawler_info ON workouts USING btree (crawler_info);


--
-- Name: index_workouts_on_end_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_end_time ON workouts USING btree (end_time);


--
-- Name: index_workouts_on_instructor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_instructor_id ON workouts USING btree (instructor_id);


--
-- Name: index_workouts_on_is_bookable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_is_bookable ON workouts USING btree (is_bookable);


--
-- Name: index_workouts_on_is_cancelled; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_is_cancelled ON workouts USING btree (is_cancelled);


--
-- Name: index_workouts_on_is_day_pass; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_is_day_pass ON workouts USING btree (is_day_pass);


--
-- Name: index_workouts_on_pass_detail_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_pass_detail_id ON workouts USING btree (pass_detail_id);


--
-- Name: index_workouts_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_place_id ON workouts USING btree (place_id);


--
-- Name: index_workouts_on_source; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_source ON workouts USING btree (source);


--
-- Name: index_workouts_on_start_time; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_start_time ON workouts USING btree (start_time);


--
-- Name: index_workouts_on_workout_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_workouts_on_workout_key ON workouts USING btree (workout_key);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130713152418');

INSERT INTO schema_migrations (version) VALUES ('20130713163009');

INSERT INTO schema_migrations (version) VALUES ('20130713195550');

INSERT INTO schema_migrations (version) VALUES ('20130713221944');

INSERT INTO schema_migrations (version) VALUES ('20130713222215');

INSERT INTO schema_migrations (version) VALUES ('20130715191010');

INSERT INTO schema_migrations (version) VALUES ('20130715192937');

INSERT INTO schema_migrations (version) VALUES ('20130716145757');

INSERT INTO schema_migrations (version) VALUES ('20130716230432');

INSERT INTO schema_migrations (version) VALUES ('20130717163530');

INSERT INTO schema_migrations (version) VALUES ('20130717175002');

INSERT INTO schema_migrations (version) VALUES ('20130717201137');

INSERT INTO schema_migrations (version) VALUES ('20130717225203');

INSERT INTO schema_migrations (version) VALUES ('20130721151118');

INSERT INTO schema_migrations (version) VALUES ('20130722121102');

INSERT INTO schema_migrations (version) VALUES ('20130722122725');

INSERT INTO schema_migrations (version) VALUES ('20130729205825');

INSERT INTO schema_migrations (version) VALUES ('20130802170218');

INSERT INTO schema_migrations (version) VALUES ('20130808234655');

INSERT INTO schema_migrations (version) VALUES ('20130808235315');

INSERT INTO schema_migrations (version) VALUES ('20130809180608');

INSERT INTO schema_migrations (version) VALUES ('20130810215759');

INSERT INTO schema_migrations (version) VALUES ('20130811191343');

INSERT INTO schema_migrations (version) VALUES ('20130813123622');

INSERT INTO schema_migrations (version) VALUES ('20130813205738');

INSERT INTO schema_migrations (version) VALUES ('20130815131940');

INSERT INTO schema_migrations (version) VALUES ('20130827023353');

INSERT INTO schema_migrations (version) VALUES ('20130827211055');

INSERT INTO schema_migrations (version) VALUES ('20130828000312');

INSERT INTO schema_migrations (version) VALUES ('20130828141419');

INSERT INTO schema_migrations (version) VALUES ('20130829142657');

INSERT INTO schema_migrations (version) VALUES ('20130830172813');

INSERT INTO schema_migrations (version) VALUES ('20130901230436');

INSERT INTO schema_migrations (version) VALUES ('20130903000738');

INSERT INTO schema_migrations (version) VALUES ('20130903001946');

INSERT INTO schema_migrations (version) VALUES ('20130905190324');

INSERT INTO schema_migrations (version) VALUES ('20130913171624');

INSERT INTO schema_migrations (version) VALUES ('20130913172623');

INSERT INTO schema_migrations (version) VALUES ('20130913172816');

INSERT INTO schema_migrations (version) VALUES ('20130913172909');

INSERT INTO schema_migrations (version) VALUES ('20130913191524');

INSERT INTO schema_migrations (version) VALUES ('20130928180750');

INSERT INTO schema_migrations (version) VALUES ('20130929165040');

INSERT INTO schema_migrations (version) VALUES ('20130930174828');

INSERT INTO schema_migrations (version) VALUES ('20131001185023');

INSERT INTO schema_migrations (version) VALUES ('20131008183340');

INSERT INTO schema_migrations (version) VALUES ('20131113203740');

INSERT INTO schema_migrations (version) VALUES ('20131120162835');

INSERT INTO schema_migrations (version) VALUES ('20131120211617');

INSERT INTO schema_migrations (version) VALUES ('20131120211741');

INSERT INTO schema_migrations (version) VALUES ('20131129182916');

INSERT INTO schema_migrations (version) VALUES ('20131129185734');

INSERT INTO schema_migrations (version) VALUES ('20131203160208');

INSERT INTO schema_migrations (version) VALUES ('20131205233112');

INSERT INTO schema_migrations (version) VALUES ('20131209191520');

INSERT INTO schema_migrations (version) VALUES ('20131209224009');

INSERT INTO schema_migrations (version) VALUES ('20131211010124');

INSERT INTO schema_migrations (version) VALUES ('20131217145135');

INSERT INTO schema_migrations (version) VALUES ('20131228222856');

INSERT INTO schema_migrations (version) VALUES ('20131230204840');

INSERT INTO schema_migrations (version) VALUES ('20140107210525');

INSERT INTO schema_migrations (version) VALUES ('20140107212535');

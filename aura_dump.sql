--
-- PostgreSQL database dump
--

\restrict dyQwIHIW9FtYhI1mnX20H0ASq8gLYk9MQQdlZhW9Ch7hLo3fhZF6jmeMoAEU0x5

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: day_of_week; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.day_of_week AS ENUM (
    'SEGUNDA',
    'TERÇA',
    'QUARTA',
    'QUINTA',
    'SEXTA',
    'SÁBADO',
    'DOMINGO'
);


--
-- Name: interest_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.interest_type AS ENUM (
    'Skill',
    'Learn'
);


--
-- Name: meeting_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.meeting_status AS ENUM (
    'pending',
    'confirmed',
    'cancelled',
    'done',
    'reported'
);


--
-- Name: meeting_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.meeting_type_enum AS ENUM (
    'PRESENCIAL',
    'ONLINE'
);


--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_type AS ENUM (
    'MEETING_PENDING',
    'MEETING_CONFIRMED',
    'MEETING_CANCELLED',
    'MEETING_DONE',
    'MEETING_REPORTED',
    'MEETING_CANCELLED_BY_TEACHER'
);


--
-- Name: participant_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.participant_role AS ENUM (
    'LEARNER',
    'TEACHER'
);


--
-- Name: report_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.report_status AS ENUM (
    'PENDENTE',
    'EM_ANALISE',
    'RESOLVIDO'
);


--
-- Name: transaction_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.transaction_status AS ENUM (
    'PENDING',
    'COMPLETED',
    'FAILED',
    'CANCELED'
);


--
-- Name: transaction_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.transaction_type AS ENUM (
    'BUY',
    'WITHDRAW'
);


--
-- Name: user_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_type AS ENUM (
    'ADMIN',
    'COMMERCIAL'
);


--
-- Name: create_credits_for_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_credits_for_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO credits (user_id, balance, total_earned, total_spent, created_at, updated_at)
    VALUES (NEW.id, 0, 0, 0, NOW(), NOW());
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: availability; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.availability (
    id integer NOT NULL,
    user_commercial_id integer NOT NULL,
    day_of_week public.day_of_week NOT NULL,
    hour_start time without time zone,
    hour_end time without time zone,
    available boolean NOT NULL,
    CONSTRAINT availability_check CHECK ((hour_end > hour_start))
);


--
-- Name: availability_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.availability_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.availability_id_seq OWNED BY public.availability.id;


--
-- Name: bank_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bank_accounts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    account_number character varying(20) NOT NULL,
    bank_name character varying(255) NOT NULL,
    ispb character varying(50) NOT NULL,
    pix_key character varying(255),
    agency character varying NOT NULL,
    active boolean NOT NULL,
    holder_name character varying(100) NOT NULL
);


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bank_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bank_accounts_id_seq OWNED BY public.bank_accounts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    img_url character varying(300)
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: credits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credits (
    id integer NOT NULL,
    user_id integer NOT NULL,
    balance numeric(10,2) DEFAULT 0.00,
    total_earned numeric(10,2) DEFAULT 0.00,
    total_spent numeric(10,2) DEFAULT 0.00,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.credits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.credits_id_seq OWNED BY public.credits.id;


--
-- Name: credits_package; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credits_package (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    credits integer NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT credits_package_credits_check CHECK ((credits >= 0)),
    CONSTRAINT credits_package_price_check CHECK ((price >= (0)::numeric))
);


--
-- Name: credits_package_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.credits_package_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credits_package_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.credits_package_id_seq OWNED BY public.credits_package.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feedbacks (
    id integer NOT NULL,
    meeting_id integer,
    from_user_id integer,
    to_user_id integer,
    rating integer,
    comment text,
    date date,
    CONSTRAINT feedbacks_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feedbacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feedbacks_id_seq OWNED BY public.feedbacks.id;


--
-- Name: interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.interests (
    id integer NOT NULL,
    category_id integer,
    name character varying(255)
);


--
-- Name: interests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.interests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: interests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.interests_id_seq OWNED BY public.interests.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    city character varying(255),
    neighborhood character varying(255),
    street character varying(255),
    house_number integer,
    reference_point character varying(255)
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: meeting_participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meeting_participants (
    id integer NOT NULL,
    meeting_id integer NOT NULL,
    user_id integer NOT NULL,
    role public.participant_role NOT NULL
);


--
-- Name: meeting_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meeting_participants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meeting_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meeting_participants_id_seq OWNED BY public.meeting_participants.id;


--
-- Name: meeting_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meeting_reports (
    id integer NOT NULL,
    meeting_id integer NOT NULL,
    from_user_id integer NOT NULL,
    reason text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status public.report_status DEFAULT 'PENDENTE'::public.report_status
);


--
-- Name: meeting_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meeting_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meeting_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meeting_reports_id_seq OWNED BY public.meeting_reports.id;


--
-- Name: meetings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meetings (
    id integer NOT NULL,
    description character varying(255),
    scheduled_at timestamp without time zone,
    status public.meeting_status,
    meeting_type public.meeting_type_enum,
    category_id integer,
    location_id integer,
    duration_minutes integer DEFAULT 60 NOT NULL
);


--
-- Name: meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meetings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meetings_id_seq OWNED BY public.meetings.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer NOT NULL,
    type public.notification_type NOT NULL,
    title character varying(150) NOT NULL,
    message character varying(500) NOT NULL,
    redirect_url character varying(300) NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    bank_account_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    description character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type public.transaction_type NOT NULL,
    status public.transaction_status NOT NULL,
    external_id character varying NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: user_interests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_interests (
    user_id integer NOT NULL,
    interest_id integer NOT NULL,
    interest_type public.interest_type
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    age integer,
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(20),
    address character varying(255),
    cpf character varying(14),
    type public.user_type NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_access timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: availability id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability ALTER COLUMN id SET DEFAULT nextval('public.availability_id_seq'::regclass);


--
-- Name: bank_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts ALTER COLUMN id SET DEFAULT nextval('public.bank_accounts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: credits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits ALTER COLUMN id SET DEFAULT nextval('public.credits_id_seq'::regclass);


--
-- Name: credits_package id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits_package ALTER COLUMN id SET DEFAULT nextval('public.credits_package_id_seq'::regclass);


--
-- Name: feedbacks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks ALTER COLUMN id SET DEFAULT nextval('public.feedbacks_id_seq'::regclass);


--
-- Name: interests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interests ALTER COLUMN id SET DEFAULT nextval('public.interests_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: meeting_participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_participants ALTER COLUMN id SET DEFAULT nextval('public.meeting_participants_id_seq'::regclass);


--
-- Name: meeting_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_reports ALTER COLUMN id SET DEFAULT nextval('public.meeting_reports_id_seq'::regclass);


--
-- Name: meetings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings ALTER COLUMN id SET DEFAULT nextval('public.meetings_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: availability; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.availability (id, user_commercial_id, day_of_week, hour_start, hour_end, available) FROM stdin;
2	47	DOMINGO	10:00:00	18:00:00	t
3	1	TERÇA	08:00:00	12:00:00	t
4	47	SEXTA	10:00:00	15:00:00	t
\.


--
-- Data for Name: bank_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.bank_accounts (id, user_id, account_number, bank_name, ispb, pix_key, agency, active, holder_name) FROM stdin;
1	47	123456-X	Itaú	035	jeovana@gmail.com	8756-5	t	Jeovana Miranda
2	1	16528-X	Banco do Brasil	001	7992054774	4190-4	t	Daniel S. Oliveira
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, img_url) FROM stdin;
1	Esportes	/assets/img/categoryIcons/volleyball.png
2	Tecnologia	/assets/img/categoryIcons/code.png
3	Culinária	/assets/img/categoryIcons/chef.png
4	Artes	/assets/img/categoryIcons/pallete.png
5	Idiomas	/assets/img/categoryIcons/internet.png
6	Educação	/assets/img/categoryIcons/open-book.png
7	Negócios	/assets/img/categoryIcons/briefcase.png
8	Bem-estar	/assets/img/categoryIcons/physical-wellbeing.png
\.


--
-- Data for Name: credits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credits (id, user_id, balance, total_earned, total_spent, created_at, updated_at) FROM stdin;
2	2	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
3	3	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
4	4	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
5	5	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
6	6	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
7	7	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
8	8	0.00	0.00	0.00	2026-05-16 18:43:47.824463	2026-05-16 18:43:47.824463
9	9	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
10	10	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
11	11	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
12	12	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
13	13	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
14	14	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
15	15	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
16	16	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
17	17	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
18	18	0.00	0.00	0.00	2026-05-16 18:43:50.754436	2026-05-16 18:43:50.754436
19	19	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
20	20	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
21	21	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
22	22	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
23	23	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
24	24	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
25	25	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
26	26	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
27	27	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
28	28	0.00	0.00	0.00	2026-05-16 18:43:55.117083	2026-05-16 18:43:55.117083
29	29	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
30	30	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
31	31	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
32	32	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
33	33	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
34	34	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
35	35	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
36	36	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
37	37	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
38	38	0.00	0.00	0.00	2026-05-16 18:43:57.945128	2026-05-16 18:43:57.945128
39	39	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
40	40	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
41	41	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
42	42	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
43	43	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
44	44	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
46	46	0.00	0.00	0.00	2026-05-16 18:44:00.606071	2026-05-16 18:44:00.606071
48	48	0.00	0.00	0.00	2026-05-20 11:16:35.240549	2026-05-20 11:16:35.240549
1	1	1370.00	1670.00	300.00	2026-05-16 18:43:47.824463	2026-05-26 19:43:32.825672
47	47	1480.00	1600.00	120.00	2026-05-16 16:24:50.041011	2026-05-26 19:43:32.825672
\.


--
-- Data for Name: credits_package; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.credits_package (id, name, credits, price, created_at) FROM stdin;
1	Pacote Inicial	300	25.00	2026-05-16 18:43:16.003341
2	Aprendiz Pro	650	50.00	2026-05-16 18:43:16.003341
3	Guru da Comunidade	1500	100.00	2026-05-16 18:43:16.003341
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.feedbacks (id, meeting_id, from_user_id, to_user_id, rating, comment, date) FROM stdin;
1	1	47	1	5	Foi show!	2026-05-16
2	1	1	47	5	Foi Show!	2026-05-16
3	4	1	47	5	Aluna excepcional, possui uma facilidade muito boa de aprender, é pontual, responsável e proativa	2026-05-19
4	6	47	1	5	aluno top	2026-05-20
5	10	47	1	5	bom demaise	2026-05-26
\.


--
-- Data for Name: interests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.interests (id, category_id, name) FROM stdin;
21	3	Confeitaria
22	3	Massas
23	3	Churrasco
24	3	Comida Vegana
25	3	Comida Japonesa
26	3	Panificação
27	3	Sobremesas
28	3	Drinks
29	3	Culinária Fitness
30	3	Receitas Rápidas
60	4	Desenho
69	2	Animação
63	2	Design Gráfico
68	2	Edição de Vídeo
66	4	Teatro
47	7	Criação de Conteúdo
7	2	Cybersegurança
46	7	Gestão
31	8	Musculação
61	4	Pintura
20	6	Gramática
49	7	Branding
54	1	Natação
77	6	Preparação ENEM
76	6	Redação
57	1	Ciclismo
75	6	Geografia
74	6	História
32	8	Yoga
33	8	Meditação
40	8	Sono e Descanso
15	5	Alemão
13	5	Francês
19	6	Conversação
5	2	Python
4	2	Java
51	1	Futebol
1	2	Programação
55	1	Academia
48	7	E-commerce
52	1	Vôlei
50	7	Networking
12	5	Espanhol
35	8	Corrida
14	5	Italiano
9	2	UI/UX Design
6	2	Inteligência Artificial
8	2	Arduino
10	2	Banco de Dados
38	8	Alongamento
39	8	Hábitos Saudáveis
37	8	Saúde Mental
36	8	Pilates
42	7	Empreendedorismo
59	1	Artes Marciais
34	8	Nutrição
17	5	Coreano
73	6	Biologia
72	6	Química
64	2	Modelagem 3D
65	4	Música
53	1	Basquete
2	2	Robótica
11	5	Inglês
3	2	Desenvolvimento Web
56	1	Skate
43	7	Investimentos
58	1	Tênis
62	4	Fotografia
67	4	Dança
44	7	Finanças
41	7	Marketing Digital
45	7	Vendas
70	6	Matemática
71	6	Física
18	5	LIBRAS
16	5	Japonês
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.locations (id, city, neighborhood, street, house_number, reference_point) FROM stdin;
1	Igaporã	Centro	Rua Alagoas	79	
\.


--
-- Data for Name: meeting_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meeting_participants (id, meeting_id, user_id, role) FROM stdin;
1	1	1	LEARNER
2	1	47	TEACHER
3	2	1	LEARNER
4	2	47	TEACHER
5	3	47	LEARNER
6	3	1	TEACHER
7	4	47	LEARNER
8	4	1	TEACHER
9	5	47	LEARNER
10	5	1	TEACHER
11	6	1	LEARNER
12	6	47	TEACHER
13	7	47	LEARNER
14	7	1	TEACHER
15	8	1	LEARNER
16	8	47	TEACHER
17	9	1	LEARNER
18	9	47	TEACHER
19	10	47	LEARNER
20	10	1	TEACHER
21	11	1	LEARNER
22	11	47	TEACHER
23	12	1	LEARNER
24	12	47	TEACHER
25	13	1	LEARNER
26	13	47	TEACHER
\.


--
-- Data for Name: meeting_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meeting_reports (id, meeting_id, from_user_id, reason, created_at, status) FROM stdin;
1	2	47	Aluno nao foi	2026-05-16 19:00:56.942818	PENDENTE
2	1	1	Chama chama	2026-05-18 13:32:44.680371	PENDENTE
3	3	1	Professor não compareceu	2026-05-19 16:01:35.412419	PENDENTE
4	6	47	muito paia	2026-05-26 19:08:40.527334	PENDENTE
5	11	1	teste	2026-05-26 19:44:22.597707	PENDENTE
\.


--
-- Data for Name: meetings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.meetings (id, description, scheduled_at, status, meeting_type, category_id, location_id, duration_minutes) FROM stdin;
2	Teste	2026-05-17 13:30:00	reported	ONLINE	1	\N	60
1	Aprendendo algoritmos	2026-05-17 11:30:00	reported	ONLINE	1	\N	60
4	dihshsjdhs	2026-05-26 11:00:00	done	ONLINE	\N	\N	60
3	wiwihwk	2026-05-26 10:00:00	reported	ONLINE	1	\N	60
5	sdsdhsjd	2026-05-26 09:00:00	done	ONLINE	1	\N	60
8	sdsdsdjshdlsjd	2026-05-22 11:00:00	cancelled	ONLINE	5	\N	60
9	kjdlsds;ldsd	2026-05-22 11:00:00	cancelled	ONLINE	\N	\N	90
7	Conceitos de API REST	2026-05-26 10:30:00	confirmed	ONLINE	1	\N	60
10	Introdução a Cybersecurity	2026-06-02 09:00:00	done	ONLINE	2	\N	60
6	fgfgfjhfgjh	2026-05-24 11:00:00	reported	ONLINE	1	\N	90
11	Aula de canva	2026-05-31 14:50:00	reported	ONLINE	7	\N	60
12	teste do polimorfismo	2026-05-31 11:00:00	pending	ONLINE	2	\N	60
13	teste poli2	2026-05-31 11:29:00	pending	PRESENCIAL	2	1	60
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, type, title, message, redirect_url, is_read, created_at) FROM stdin;
1	1	MEETING_PENDING	Novo pedido de meeting	O aluno Jeovana Miranda solicitou um meeting com você: "Introdução a Cybersecurity". Acesse Meetings para confirmar ou recusar.	/aura/autenticado/meeting	t	2026-05-26 19:07:07.458944
2	47	MEETING_CONFIRMED	Meeting confirmado	O professor Daniel Oliveira confirmou seu meeting: "Introdução a Cybersecurity".	/aura/autenticado/meeting	t	2026-05-26 19:07:22.626068
3	47	MEETING_DONE	Meeting concluído	O professor Daniel Oliveira marcou o meeting "Introdução a Cybersecurity" como concluído. Não esqueça de avaliar!	/aura/autenticado/meeting	t	2026-05-26 19:07:41.19417
4	47	MEETING_REPORTED	Meeting reportado	O aluno Jeovana Miranda reportou o meeting: "fgfgfjhfgjh".	/aura/autenticado/meeting	t	2026-05-26 19:08:40.534074
5	47	MEETING_PENDING	Novo pedido de meeting	O aluno Daniel Oliveira solicitou um meeting com você: "Aula de canva". Acesse Meetings para confirmar ou recusar.	/aura/autenticado/meeting	t	2026-05-26 19:42:47.600056
6	1	MEETING_CONFIRMED	Meeting confirmado	O professor Jeovana Miranda confirmou seu meeting: "Aula de canva".	/aura/autenticado/meeting	t	2026-05-26 19:43:32.832651
7	1	MEETING_DONE	Meeting concluído	O professor Jeovana Miranda marcou o meeting "Aula de canva" como concluído. Não esqueça de avaliar!	/aura/autenticado/meeting	t	2026-05-26 19:44:00.990042
8	47	MEETING_PENDING	Novo pedido de meeting	O aluno Daniel Oliveira solicitou um meeting com você: "teste do polimorfismo". Acesse Meetings para confirmar ou recusar.	/aura/autenticado/meeting	f	2026-05-31 09:26:17.799281
9	47	MEETING_PENDING	Novo pedido de meeting	O aluno Daniel Oliveira solicitou um meeting com você: "teste poli2". Acesse Meetings para confirmar ou recusar.	/aura/autenticado/meeting	f	2026-05-31 09:27:51.92524
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (id, bank_account_id, amount, description, created_at, type, status, external_id) FROM stdin;
1	1	50.00	\N	2026-05-16 16:26:45.13633	BUY	COMPLETED	1611522873768624506
2	2	50.00	\N	2026-05-16 16:27:28.059015	BUY	COMPLETED	8125647091545099631
3	1	50.00	\N	2026-05-19 23:12:39.800449	BUY	COMPLETED	578864011164468931
4	2	25.00	\N	2026-05-20 08:17:38.221448	BUY	COMPLETED	4254358622536747779
5	2	25.00	\N	2026-05-20 08:17:44.216659	BUY	COMPLETED	4889672830738780058
6	2	25.00	\N	2026-05-20 08:27:11.177499	BUY	COMPLETED	4559221229024068738
\.


--
-- Data for Name: user_interests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_interests (user_id, interest_id, interest_type) FROM stdin;
3	7	Learn
3	3	Learn
3	8	Skill
3	4	Skill
4	2	Learn
4	1	Skill
5	1	Learn
5	2	Skill
8	2	Learn
8	1	Skill
9	7	Learn
9	8	Learn
9	3	Skill
9	4	Skill
16	1	Learn
17	1	Learn
19	7	Learn
19	4	Skill
21	3	Learn
21	4	Learn
1	7	Learn
1	8	Skill
2	39	Learn
2	49	Skill
6	5	Learn
6	4	Skill
7	76	Learn
7	25	Skill
10	69	Learn
10	33	Skill
11	77	Learn
11	23	Skill
12	11	Skill
12	42	Learn
13	66	Learn
13	57	Skill
14	59	Learn
14	32	Skill
15	1	Learn
15	2	Skill
18	3	Learn
18	4	Skill
20	5	Learn
20	6	Skill
22	7	Learn
22	8	Skill
23	9	Learn
23	10	Skill
24	11	Learn
24	12	Skill
25	13	Learn
25	14	Skill
26	15	Learn
26	16	Skill
27	17	Learn
27	18	Skill
28	19	Learn
28	20	Skill
29	21	Learn
29	22	Skill
30	23	Learn
30	24	Skill
31	25	Learn
31	26	Skill
32	27	Learn
32	28	Skill
33	29	Learn
33	30	Skill
34	31	Learn
34	32	Skill
35	33	Learn
35	34	Skill
36	35	Learn
36	36	Skill
37	37	Learn
37	38	Skill
38	39	Learn
38	40	Skill
39	41	Learn
39	42	Skill
40	43	Learn
40	44	Skill
41	45	Learn
41	46	Skill
42	47	Learn
42	48	Skill
43	49	Learn
43	50	Skill
44	51	Learn
44	52	Skill
46	55	Learn
46	56	Skill
47	41	Learn
47	42	Learn
47	46	Learn
47	1	Skill
47	3	Skill
47	4	Skill
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, age, email, password, phone, address, cpf, type, created_at, updated_at, last_access) FROM stdin;
2	joelma	54	joelma@gmail.com	$2a$10$oLlmYxeGZoSY9CJMB2E.3eCsEc9wS0TuYDVfNinOIyTiC.7CMk1aS	779849723	SP	100.861.535-70	COMMERCIAL	2026-05-02 01:02:53.398145	2026-05-02 01:02:53.395801	\N
3	jussara	45	jussara@gmail.com	$2a$10$OR0dnzhXociDMopU9m8kbeq6IwHsHPIukfj2V60/t5Be2jufIC.nK	779849723	Monte Azul	100.114.899-77	COMMERCIAL	2026-05-02 01:29:30.294402	2026-05-02 01:29:30.291631	\N
4	Livia	18	livs@gmail.com	$2a$10$zercKUIk4f7oEW4Emr5xRuOAa6v5y2o7WwR57PEseggeVIEG/RwuG	779849723	Montalvânia	000.111.222-33	COMMERCIAL	2026-05-06 00:50:47.147469	2026-05-06 00:50:47.144849	\N
5	josé	45	jose@gmail.com	$2a$10$mnhiyiAopzdj6q6RpwDw.uhol6mTGFySmZ20EGgMkNGbieP0FIyGG	779849723	Caetité	152.861.435-78	COMMERCIAL	2026-05-07 17:06:39.802194	2026-05-07 17:06:39.801657	\N
6	yasmim	18	mim@gmail.com	$2a$10$6iutcUDu13IwI87BMizD4e8dgsrrDMQqesTV.GdgwaPMXlfWRT9tG	779849723	Montes Claros	102.861.435-00	COMMERCIAL	2026-05-07 17:36:13.08788	2026-05-07 17:36:13.085649	\N
7	Fabio++	48	fabiomicromais@gmail.com	$2a$10$oOvRCgnpzwOXqJRDT5AV2uPpE5Etz8jma8VYpVYGip6Gom3H0szYS	779849723	Vitória da Conquista	000.861.435-99	COMMERCIAL	2026-05-07 17:44:13.561603	2026-05-07 17:44:13.348941	\N
8	larissa	25	lari@gmail.com	$2a$10$YbQiHsnJopTNZq4Pg9gza.ygmzon/w.HGrtxHLbovkBI4.Fxu5dN.	779849723	Jacobina	107.415.945-11	COMMERCIAL	2026-05-07 17:48:59.388257	2026-05-07 17:48:59.38468	\N
9	George Gabriel	39	gegeo@gmail.com	$2a$10$mHXcnNf2r.iXmqWx5EYJQ.h97UbJBbIrScFUu52h8Ui8g0clHpI8W	779849723	Guanambi	102.861.439-99	COMMERCIAL	2026-05-07 17:54:54.093378	2026-05-07 17:54:53.894776	\N
10	Mariana	20	mari@gmail.com	$2a$10$msWapV0ljh1sJICWZNoIcO9wDXqWfhrW/HfWFOm6khkFLAyVgtdY.	779849723	Montalvânia	222.222.222-22	COMMERCIAL	2026-05-07 17:58:12.158804	2026-05-07 17:58:11.956278	\N
11	Joaquim	32	joaquim@gmail.com	$2a$10$5gTISAchNzI1P7YenwL/d.5i8K76wxFflu3WvkCVgRWVIC2.oDBlW	779849723	Guarulhos	102.861.435-33	COMMERCIAL	2026-05-07 18:03:11.787314	2026-05-07 18:03:11.601907	\N
12	vanessa	30	jvanessa@gmail.com	$2a$10$ubiAIReTgZDArrrPixGkzOwPxAF4uffs/zcwc94mZkliOj/CuGc/u	779849723	Cuiabá	111.222.444-88	COMMERCIAL	2026-05-07 18:32:36.74603	2026-05-07 18:32:36.538211	\N
13	Geovanni	19	geovanni@gmail.com	$2a$10$1zbgNYo51Wype1/SO8jgIO7Yg2MccmcR5cw00DhE2v84R.iN.0HUm	779849723	Mutans	333.555.777-98	COMMERCIAL	2026-05-07 18:41:48.099229	2026-05-07 18:41:47.866665	\N
14	laura	16	laura@gmail.com	$2a$10$UIUtnIQFPvh/djytBnxNoOIaoWgFX0VJaIh0MadqX5.4n3SZENQlS	779849723	Morrinhos	00033366650	COMMERCIAL	2026-05-07 18:51:04.601046	2026-05-07 18:51:04.39577	\N
15	Jayne	27	jayne@gmail.com	$2a$10$/2SX066m4jMD3fRzq1f1/eZ/Z19TnwBfvqMxdPcpspOpZZIkPgeke	779849723	Jaíba	107.444.945-44	COMMERCIAL	2026-05-07 18:58:06.107505	2026-05-07 18:58:05.8986	\N
16	Janielle	16	janielle@gmail.com	$2a$10$cxowi1L4P5fZKp4M7SamCemz4C159E3DhxAxRAn4JZ.b0jx6FViEi	779849723	Fazenda Gongo	232.815.471-99	COMMERCIAL	2026-05-07 20:03:51.000537	2026-05-07 20:03:50.784667	\N
17	Carine	18	carine@gmail.com	$2a$10$vhV3J/QxtClu6d4FTmCYmuPd3R0prAhEzFXc3ig6/Z5APYPCEZgKS	779849723	Brumado	666.444.888-98	COMMERCIAL	2026-05-07 20:12:46.359151	2026-05-07 20:12:46.133654	\N
18	Paulina	27	paulina@gmail.com	$2a$10$VG/52BMYREBIaa06XrrCzOXHW28VBaqhcoKPczcFCX1aQEtJnRNQa	779849723	Goiania	00012578499	COMMERCIAL	2026-05-08 13:01:51.047896	2026-05-08 13:01:50.858128	\N
19	Moniky	39	moniky@gmail.com	$2a$10$D7WIyP5Fa2t1Xd3x4jZfPepxNJtJu9T7IwR3kdsrTxfllqZsz0k8e	779849723	Montes Claros	654.147.987-33	COMMERCIAL	2026-05-12 17:48:29.901213	2026-05-12 17:48:29.708018	\N
20	Vinicius	29	vncsmrqs@gmail.com	$2a$10$U4zFAq3d6AlsvriJ3mEL7OnU1c.eXDU81pXltwYXdrpGYwai25bDC	77991815309	Guanambi	130.852.116-24	COMMERCIAL	2026-05-02 18:18:09.231598	2026-05-02 18:18:09.229326	\N
21	João Silva	22	joao.silva@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990001	Guanambi	11111111111	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
22	Mariana Souza	25	mariana.souza@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990002	Guanambi	11111111112	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
23	Lucas Pereira	28	lucas.pereira@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990003	Ceraíma	11111111113	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
24	Ana Clara	20	ana.clara@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990004	Ceraíma	11111111114	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
25	Vitória Fernandes	20	vitoria.fernandes@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	38999991004	Monte Azul	22211111114	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
26	Carlos Mendes	31	carlos.mendes@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990005	Licínio de Almeida	11111111115	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
27	Fernanda Rocha	24	fernanda.rocha@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990006	Licínio de Almeida	11111111116	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
28	Rafael Costa	27	rafael.costa@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990007	Igaporã	11111111117	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
29	Juliana Alves	26	juliana.alves@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990008	Igaporã	11111111118	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
30	Pedro Henrique	29	pedro.henrique@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	38999990009	Montes Claros	11111111119	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
31	Camila Martins	23	camila.martins@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	38999990010	Montes Claros 	11111111120	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
32	Gabriel Santos	24	gabriel.santos@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	38999991001	Monte Azul	22211111111	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
33	Larissa Prado	22	larissa.prado@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	38999991002	Monte Azul	22211111112	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
34	Mateus Lima	27	mateus.lima@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	38999991003	Monte Azul	22211111113	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
35	Sávio Almeida	26	savio.almeida@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991005	Licínio de Almeida 	22211111115	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
36	Thiago Oliveira	30	thiago.oliveira@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990011	Vitória da Conquista	11111111121	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
37	Beatriz Lima	21	beatriz.lima@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999990012	Vitória da Conquista 	11111111122	COMMERCIAL	2026-05-12 23:28:05.656796	2026-05-12 23:28:05.656796	\N
38	Rafael Oliveira	28	rafael.oliveira@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991006	Cana Brava	22211111116	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
39	Eduarda Nunes	23	eduarda.nunes@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991007	Cana Brava	22211111117	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
40	Isabella Mello	21	isabella.mello@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991008	Guanambi 	22211111118	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
41	Henrique Costa	30	henrique.costa@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991009	Guanambi	22211111119	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
42	Amanda Rocha	24	amanda.rocha@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991010	Guanambi	22211111120	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
43	Bruno Ferreira	29	bruno.ferreira@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991012	Ceraíma	22211111122	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
44	Clara Mendes	22	clara.mendes@gmail.com	$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6x4W7x1YgnSUQoqBYwygJyI072Qtd	77999991013	Ceraíma	22211111123	COMMERCIAL	2026-05-12 23:32:24.932389	2026-05-12 23:32:24.932389	\N
46	jamily	25	jamily@gmail.com	$2a$10$7hQj6BIbMEo3BSsK.6x7guWMfczvH00p5qS68J5q2I4RXddok/Fsq	779849723	Carinhanha	199.861.435-88	COMMERCIAL	2026-05-13 04:56:23.702654	2026-05-13 04:56:23.700667	\N
1	Daniel Oliveira	19	dansoliveira.ba@gmail.com	$2a$10$VjzoDVBRn3AhEayWuq2jUuAXSgEWFuL343zY8gTbzCa0o3tTf5TH.	77992054774	Igaporã	06374861531	COMMERCIAL	2026-04-25 14:39:47.275753	2026-04-25 14:39:47.021681	\N
47	Jeovana Miranda	21	jeovana@gmail.com	$2a$10$f.llSwIJkYK8dZmDyxOiwOZSDOFh61k285Ph6zvgwanlngRef5Suq	77991929394	Ceraíma	896.313.060-62	COMMERCIAL	2026-05-16 16:24:50.041011	2026-05-16 16:24:50.037502	\N
48	Administrador	\N	admin@aura.com	$2a$06$yChd8SzUqzexpJjLzp6X3.Yz7Qro169HUhK2r8UDIgcmWQYXHrlAK	\N	\N	\N	ADMIN	2026-05-20 11:16:35.240549	2026-05-20 11:16:35.240549	\N
\.


--
-- Name: availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.availability_id_seq', 4, true);


--
-- Name: bank_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bank_accounts_id_seq', 2, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 8, true);


--
-- Name: credits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.credits_id_seq', 48, true);


--
-- Name: credits_package_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.credits_package_id_seq', 3, true);


--
-- Name: feedbacks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.feedbacks_id_seq', 5, true);


--
-- Name: interests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.interests_id_seq', 77, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locations_id_seq', 1, true);


--
-- Name: meeting_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meeting_participants_id_seq', 26, true);


--
-- Name: meeting_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meeting_reports_id_seq', 5, true);


--
-- Name: meetings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.meetings_id_seq', 13, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 9, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transactions_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 48, true);


--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_pkey PRIMARY KEY (id);


--
-- Name: bank_accounts bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: credits_package credits_package_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits_package
    ADD CONSTRAINT credits_package_pkey PRIMARY KEY (id);


--
-- Name: credits credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: interests interests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interests
    ADD CONSTRAINT interests_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: meeting_participants meeting_participants_meeting_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_participants
    ADD CONSTRAINT meeting_participants_meeting_id_user_id_key UNIQUE (meeting_id, user_id);


--
-- Name: meeting_participants meeting_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_participants
    ADD CONSTRAINT meeting_participants_pkey PRIMARY KEY (id);


--
-- Name: meeting_reports meeting_reports_meeting_id_from_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_reports
    ADD CONSTRAINT meeting_reports_meeting_id_from_user_id_key UNIQUE (meeting_id, from_user_id);


--
-- Name: meeting_reports meeting_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_reports
    ADD CONSTRAINT meeting_reports_pkey PRIMARY KEY (id);


--
-- Name: meetings meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: feedbacks uq_feedback_meeting_from; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT uq_feedback_meeting_from UNIQUE (meeting_id, from_user_id);


--
-- Name: user_interests user_interests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_interests
    ADD CONSTRAINT user_interests_pkey PRIMARY KEY (user_id, interest_id);


--
-- Name: users users_cpf_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_cpf_key UNIQUE (cpf);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_notifications_user_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, is_read);


--
-- Name: users trigger_create_credits; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_create_credits AFTER INSERT ON public.users FOR EACH ROW EXECUTE FUNCTION public.create_credits_for_user();


--
-- Name: availability availability_user_commercial_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availability
    ADD CONSTRAINT availability_user_commercial_id_fkey FOREIGN KEY (user_commercial_id) REFERENCES public.users(id);


--
-- Name: bank_accounts bank_accounts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bank_accounts
    ADD CONSTRAINT bank_accounts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: credits credits_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credits
    ADD CONSTRAINT credits_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: feedbacks feedbacks_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id);


--
-- Name: feedbacks feedbacks_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id);


--
-- Name: feedbacks feedbacks_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_to_user_id_fkey FOREIGN KEY (to_user_id) REFERENCES public.users(id);


--
-- Name: interests interests_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.interests
    ADD CONSTRAINT interests_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: meeting_participants meeting_participants_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_participants
    ADD CONSTRAINT meeting_participants_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id);


--
-- Name: meeting_participants meeting_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_participants
    ADD CONSTRAINT meeting_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: meeting_reports meeting_reports_from_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_reports
    ADD CONSTRAINT meeting_reports_from_user_id_fkey FOREIGN KEY (from_user_id) REFERENCES public.users(id);


--
-- Name: meeting_reports meeting_reports_meeting_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meeting_reports
    ADD CONSTRAINT meeting_reports_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id);


--
-- Name: meetings meetings_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: meetings meetings_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meetings
    ADD CONSTRAINT meetings_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_bank_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_bank_account_id_fkey FOREIGN KEY (bank_account_id) REFERENCES public.bank_accounts(id);


--
-- Name: user_interests user_interests_interest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_interests
    ADD CONSTRAINT user_interests_interest_id_fkey FOREIGN KEY (interest_id) REFERENCES public.interests(id);


--
-- Name: user_interests user_interests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_interests
    ADD CONSTRAINT user_interests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict dyQwIHIW9FtYhI1mnX20H0ASq8gLYk9MQQdlZhW9Ch7hLo3fhZF6jmeMoAEU0x5


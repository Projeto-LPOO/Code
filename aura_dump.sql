--
-- PostgreSQL database dump
--

\restrict 7OrBF5A9nSOD1nXvvHIMcvBd5MF6D2elztiWWRouGAduzKsyF9jGpPqK5CrUbZH

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

--===============================================================================
--ÚLTIMAS ALTERAÇÕES
--===============================================================================

CREATE TYPE public.report_category AS ENUM (
    'NAO_COMPARECEU',
    'ASSEDIO',
    'VIOLENCIA'
);

CREATE TYPE public.evidence_accepted AS ENUM (
    'ACEITO',
    'PENDENTE',
    'RECUSADO'
);

ALTER TABLE public.meeting_reports
DROP COLUMN status;

ALTER TABLE public.meeting_reports
    ADD COLUMN status boolean,
    ADD COLUMN report_category public.report_category;

CREATE TABLE public.report_evidences (
                                         id SERIAL PRIMARY KEY,
                                         report_id integer NOT NULL REFERENCES public.meeting_reports(id),
                                         user_id integer NOT NULL REFERENCES public.users(id),
                                         description text NOT NULL,
                                         image_path text,
                                         created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
                                         evidence_accepted public.evidence_accepted DEFAULT 'PENDENTE'
);

--===============================================================================
--ÚLTIMAS ALTERAÇÕES
--===============================================================================

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

-- ================================================================
-- SEED — Aura Project
-- Destino: banco vazio recém-criado pelo aura_dump.sql (estrutura)
-- Contém: categories, interests, credits_package e 50 users
-- Senha de todos os users: 123456
-- ================================================================

-- ----------------------------------------------------------------
-- CATEGORIES (espelho exato do dump)
-- ----------------------------------------------------------------
INSERT INTO public.categories (id, name, img_url) VALUES
(1, 'Esportes',   '/assets/img/categoryIcons/volleyball.png'),
(2, 'Tecnologia', '/assets/img/categoryIcons/code.png'),
(3, 'Culinária',  '/assets/img/categoryIcons/chef.png'),
(4, 'Artes',      '/assets/img/categoryIcons/pallete.png'),
(5, 'Idiomas',    '/assets/img/categoryIcons/internet.png'),
(6, 'Educação',   '/assets/img/categoryIcons/open-book.png'),
(7, 'Negócios',   '/assets/img/categoryIcons/briefcase.png'),
(8, 'Bem-estar',  '/assets/img/categoryIcons/physical-wellbeing.png');

-- ----------------------------------------------------------------
-- INTERESTS (espelho exato do dump, com os IDs originais)
-- ----------------------------------------------------------------
INSERT INTO public.interests (id, category_id, name) VALUES
(1,  2, 'Programação'),
(2,  2, 'Robótica'),
(3,  2, 'Desenvolvimento Web'),
(4,  2, 'Java'),
(5,  2, 'Python'),
(6,  2, 'Inteligência Artificial'),
(7,  2, 'Cybersegurança'),
(8,  2, 'Arduino'),
(9,  2, 'UI/UX Design'),
(10, 2, 'Banco de Dados'),
(11, 5, 'Inglês'),
(12, 5, 'Espanhol'),
(13, 5, 'Francês'),
(14, 5, 'Italiano'),
(15, 5, 'Alemão'),
(16, 5, 'Japonês'),
(17, 5, 'Coreano'),
(18, 5, 'LIBRAS'),
(19, 6, 'Conversação'),
(20, 6, 'Gramática'),
(21, 3, 'Confeitaria'),
(22, 3, 'Massas'),
(23, 3, 'Churrasco'),
(24, 3, 'Comida Vegana'),
(25, 3, 'Comida Japonesa'),
(26, 3, 'Panificação'),
(27, 3, 'Sobremesas'),
(28, 3, 'Drinks'),
(29, 3, 'Culinária Fitness'),
(30, 3, 'Receitas Rápidas'),
(31, 8, 'Musculação'),
(32, 8, 'Yoga'),
(33, 8, 'Meditação'),
(34, 8, 'Nutrição'),
(35, 8, 'Corrida'),
(36, 8, 'Pilates'),
(37, 8, 'Saúde Mental'),
(38, 8, 'Alongamento'),
(39, 8, 'Hábitos Saudáveis'),
(40, 8, 'Sono e Descanso'),
(41, 7, 'Marketing Digital'),
(42, 7, 'Empreendedorismo'),
(43, 7, 'Investimentos'),
(44, 7, 'Finanças'),
(45, 7, 'Vendas'),
(46, 7, 'Gestão'),
(47, 7, 'Criação de Conteúdo'),
(48, 7, 'E-commerce'),
(49, 7, 'Branding'),
(50, 7, 'Networking'),
(51, 1, 'Futebol'),
(52, 1, 'Vôlei'),
(53, 1, 'Basquete'),
(54, 1, 'Natação'),
(55, 1, 'Academia'),
(56, 1, 'Skate'),
(57, 1, 'Ciclismo'),
(58, 1, 'Tênis'),
(59, 1, 'Artes Marciais'),
(60, 4, 'Desenho'),
(61, 4, 'Pintura'),
(62, 4, 'Fotografia'),
(63, 2, 'Design Gráfico'),
(64, 2, 'Modelagem 3D'),
(65, 4, 'Música'),
(66, 4, 'Teatro'),
(67, 4, 'Dança'),
(68, 2, 'Edição de Vídeo'),
(69, 2, 'Animação'),
(70, 6, 'Matemática'),
(71, 6, 'Física'),
(72, 6, 'Química'),
(73, 6, 'Biologia'),
(74, 6, 'História'),
(75, 6, 'Geografia'),
(76, 6, 'Redação'),
(77, 6, 'Preparação ENEM');

-- ----------------------------------------------------------------
-- CREDITS_PACKAGE (espelho exato do dump)
-- ----------------------------------------------------------------
INSERT INTO public.credits_package (id, name, credits, price, created_at) VALUES
(1, 'Pacote Inicial',       300,  25.00, '2026-06-01 00:00:00'),
(2, 'Aprendiz Pro',         650,  50.00, '2026-06-01 00:00:00'),
(3, 'Guru da Comunidade',  1500, 100.00, '2026-06-01 00:00:00');

-- ----------------------------------------------------------------
-- USERS — 50 alunos, senha: 123456
-- ----------------------------------------------------------------
INSERT INTO public.users (id, name, age, email, password, phone, address, cpf, type, created_at, updated_at, last_access) VALUES
(1,  'Alice Ferreira',     21, 'alice@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010001', 'Guanambi',             '100.000.001-08', 'COMMERCIAL', NOW(), NOW(), NULL),
(2,  'Bruno Souza',        23, 'bruno@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010002', 'Caetité',              '100.000.002-80', 'COMMERCIAL', NOW(), NOW(), NULL),
(3,  'Carolina Lima',      19, 'carolina@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010003', 'Igaporã',              '100.000.003-61', 'COMMERCIAL', NOW(), NOW(), NULL),
(4,  'Diego Alves',        25, 'diego@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010004', 'Brumado',              '100.000.004-42', 'COMMERCIAL', NOW(), NOW(), NULL),
(5,  'Elena Costa',        22, 'elena@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010005', 'Vitória da Conquista', '100.000.005-23', 'COMMERCIAL', NOW(), NOW(), NULL),
(6,  'Felipe Martins',     28, 'felipe@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010006', 'Montes Claros',        '100.000.006-04', 'COMMERCIAL', NOW(), NOW(), NULL),
(7,  'Giovanna Pereira',   20, 'giovanna@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010007', 'Monte Azul',           '100.000.007-95', 'COMMERCIAL', NOW(), NOW(), NULL),
(8,  'Henrique Rodrigues', 24, 'henrique@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010008', 'Ceraíma',              '100.000.008-76', 'COMMERCIAL', NOW(), NOW(), NULL),
(9,  'Isabela Nascimento', 18, 'isabela@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010009', 'Licínio de Almeida',   '100.000.009-57', 'COMMERCIAL', NOW(), NOW(), NULL),
(10, 'Jonas Carvalho',     26, 'jonas@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010010', 'Carinhanha',           '100.000.010-90', 'COMMERCIAL', NOW(), NOW(), NULL),
(11, 'Karina Mendes',      27, 'karina@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010011', 'Guanambi',             '100.000.011-71', 'COMMERCIAL', NOW(), NOW(), NULL),
(12, 'Leonardo Barbosa',   30, 'leonardo@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010012', 'Caetité',              '100.000.012-52', 'COMMERCIAL', NOW(), NOW(), NULL),
(13, 'Melissa Cardoso',    22, 'melissa@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010013', 'Igaporã',              '100.000.013-33', 'COMMERCIAL', NOW(), NOW(), NULL),
(14, 'Nicolas Araujo',     19, 'nicolas@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010014', 'Brumado',              '100.000.014-14', 'COMMERCIAL', NOW(), NOW(), NULL),
(15, 'Olivia Melo',        21, 'olivia@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010015', 'Vitória da Conquista', '100.000.015-03', 'COMMERCIAL', NOW(), NOW(), NULL),
(16, 'Paulo Teixeira',     25, 'paulo@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010016', 'Montes Claros',        '100.000.016-86', 'COMMERCIAL', NOW(), NOW(), NULL),
(17, 'Queila Monteiro',    23, 'queila@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010017', 'Monte Azul',           '100.000.017-67', 'COMMERCIAL', NOW(), NOW(), NULL),
(18, 'Ricardo Freitas',    29, 'ricardo@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010018', 'Ceraíma',              '100.000.018-48', 'COMMERCIAL', NOW(), NOW(), NULL),
(19, 'Sabrina Gomes',      24, 'sabrina@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010019', 'Licínio de Almeida',   '100.000.019-29', 'COMMERCIAL', NOW(), NOW(), NULL),
(20, 'Tiago Ribeiro',      20, 'tiago@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010020', 'Carinhanha',           '100.000.020-62', 'COMMERCIAL', NOW(), NOW(), NULL),
(21, 'Ursula Pinto',       18, 'ursula@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010021', 'Guanambi',             '100.000.021-43', 'COMMERCIAL', NOW(), NOW(), NULL),
(22, 'Vitor Cavalcanti',   27, 'vitor@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010022', 'Caetité',              '100.000.022-24', 'COMMERCIAL', NOW(), NOW(), NULL),
(23, 'Wanda Correia',      22, 'wanda@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010023', 'Igaporã',              '100.000.023-05', 'COMMERCIAL', NOW(), NOW(), NULL),
(24, 'Xavier Moreira',     31, 'xavier@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010024', 'Brumado',              '100.000.024-96', 'COMMERCIAL', NOW(), NOW(), NULL),
(25, 'Yasmin Cunha',       19, 'yasmin@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010025', 'Vitória da Conquista', '100.000.025-77', 'COMMERCIAL', NOW(), NOW(), NULL),
(26, 'Zeca Farias',        26, 'zeca@gmail.com',       '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010026', 'Montes Claros',        '100.000.026-58', 'COMMERCIAL', NOW(), NOW(), NULL),
(27, 'Andressa Moura',     23, 'andressa@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010027', 'Monte Azul',           '100.000.027-39', 'COMMERCIAL', NOW(), NOW(), NULL),
(28, 'Bernardo Lopes',     28, 'bernardo@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010028', 'Ceraíma',              '100.000.028-10', 'COMMERCIAL', NOW(), NOW(), NULL),
(29, 'Camile Vieira',      21, 'camile@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010029', 'Licínio de Almeida',   '100.000.029-09', 'COMMERCIAL', NOW(), NOW(), NULL),
(30, 'Davi Azevedo',       24, 'davi@gmail.com',       '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010030', 'Carinhanha',           '100.000.030-34', 'COMMERCIAL', NOW(), NOW(), NULL),
(31, 'Estela Campos',      20, 'estela@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010031', 'Guanambi',             '100.000.031-15', 'COMMERCIAL', NOW(), NOW(), NULL),
(32, 'Fabricio Duarte',    27, 'fabricio@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010032', 'Caetité',              '100.000.032-04', 'COMMERCIAL', NOW(), NOW(), NULL),
(33, 'Gisele Miranda',     25, 'gisele@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010033', 'Igaporã',              '100.000.033-87', 'COMMERCIAL', NOW(), NOW(), NULL),
(34, 'Heitor Borges',      22, 'heitor@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010034', 'Brumado',              '100.000.034-68', 'COMMERCIAL', NOW(), NOW(), NULL),
(35, 'Iasmin Macedo',      18, 'iasmin@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010035', 'Vitória da Conquista', '100.000.035-49', 'COMMERCIAL', NOW(), NOW(), NULL),
(36, 'Jefferson Castro',   30, 'jefferson@gmail.com',  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010036', 'Montes Claros',        '100.000.036-20', 'COMMERCIAL', NOW(), NOW(), NULL),
(37, 'Katia Ramos',        19, 'katia@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010037', 'Monte Azul',           '100.000.037-00', 'COMMERCIAL', NOW(), NOW(), NULL),
(38, 'Leandro Nunes',      23, 'leandro@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010038', 'Ceraíma',              '100.000.038-91', 'COMMERCIAL', NOW(), NOW(), NULL),
(39, 'Monique Brito',      21, 'monique@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010039', 'Licínio de Almeida',   '100.000.039-72', 'COMMERCIAL', NOW(), NOW(), NULL),
(40, 'Natan Santana',      26, 'natan@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010040', 'Carinhanha',           '100.000.040-06', 'COMMERCIAL', NOW(), NOW(), NULL),
(41, 'Odete Queiroz',      28, 'odete@gmail.com',      '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010041', 'Guanambi',             '100.000.041-97', 'COMMERCIAL', NOW(), NOW(), NULL),
(42, 'Patricia Viana',     24, 'patricia@gmail.com',   '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010042', 'Caetité',              '100.000.042-78', 'COMMERCIAL', NOW(), NOW(), NULL),
(43, 'Quirino Fonseca',    20, 'quirino@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010043', 'Igaporã',              '100.000.043-59', 'COMMERCIAL', NOW(), NOW(), NULL),
(44, 'Roberta Pires',      22, 'roberta@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010044', 'Brumado',              '100.000.044-30', 'COMMERCIAL', NOW(), NOW(), NULL),
(45, 'Samuel Lacerda',     25, 'samuel@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010045', 'Vitória da Conquista', '100.000.045-10', 'COMMERCIAL', NOW(), NOW(), NULL),
(46, 'Talita Andrade',     18, 'talita@gmail.com',     '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010046', 'Montes Claros',        '100.000.046-00', 'COMMERCIAL', NOW(), NOW(), NULL),
(47, 'Ulisses Nogueira',   29, 'ulisses@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010047', 'Monte Azul',           '100.000.047-82', 'COMMERCIAL', NOW(), NOW(), NULL),
(48, 'Valeria Rezende',    23, 'valeria@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010048', 'Ceraíma',              '100.000.048-63', 'COMMERCIAL', NOW(), NOW(), NULL),
(49, 'Wellington Soares',  27, 'wellington@gmail.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010049', 'Licínio de Almeida',   '100.000.049-44', 'COMMERCIAL', NOW(), NOW(), NULL),
(50, 'Xiomara Torres',     21, 'xiomara@gmail.com',    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL56lhOC', '77900010050', 'Carinhanha',           '100.000.050-88', 'COMMERCIAL', NOW(), NOW(), NULL);

-- ----------------------------------------------------------------
-- CREDITS (trigger cria automaticamente, mas caso não exista)
-- ----------------------------------------------------------------
INSERT INTO public.credits (id, user_id, balance, total_earned, total_spent, created_at, updated_at)
SELECT id, id, 0.00, 0.00, 0.00, NOW(), NOW()
FROM public.users
ON CONFLICT (user_id) DO NOTHING;

-- ----------------------------------------------------------------
-- SEQUENCES
-- ----------------------------------------------------------------
SELECT setval('public.categories_id_seq',    (SELECT MAX(id) FROM public.categories));
SELECT setval('public.interests_id_seq',     (SELECT MAX(id) FROM public.interests));
SELECT setval('public.credits_package_id_seq',(SELECT MAX(id) FROM public.credits_package));
SELECT setval('public.users_id_seq',         (SELECT MAX(id) FROM public.users));
SELECT setval('public.credits_id_seq',       (SELECT MAX(id) FROM public.credits));

\unrestrict 7OrBF5A9nSOD1nXvvHIMcvBd5MF6D2elztiWWRouGAduzKsyF9jGpPqK5CrUbZH


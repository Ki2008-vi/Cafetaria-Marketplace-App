--
-- PostgreSQL database dump
--

\restrict KhrRjg0TQprsNQ6p0rOSz7FO7eCssWHgMMxNX1vsV77J6uzgaeUw50YgNm5GFCe

-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

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
-- Name: cache; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache OWNER TO dev;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO dev;

--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection character varying(255) NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO dev;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO dev;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    invoice_number character varying(40) NOT NULL,
    status character varying(20) DEFAULT 'unpaid'::character varying NOT NULL,
    issued_at timestamp(0) without time zone NOT NULL,
    due_at timestamp(0) without time zone NOT NULL,
    paid_at timestamp(0) without time zone,
    total numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.invoices OWNER TO dev;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_id_seq OWNER TO dev;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO dev;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO dev;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO dev;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.menu_items (
    id bigint NOT NULL,
    caterer_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    photo_path character varying(255) NOT NULL,
    price numeric(12,2) NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.menu_items OWNER TO dev;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.menu_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_items_id_seq OWNER TO dev;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO dev;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO dev;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    menu_item_id bigint,
    name character varying(255) NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    quantity integer NOT NULL,
    line_total numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.order_items OWNER TO dev;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO dev;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    order_number character varying(40) NOT NULL,
    caterer_id bigint NOT NULL,
    office_id bigint NOT NULL,
    delivery_date date NOT NULL,
    delivery_address character varying(255) NOT NULL,
    notes text,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    total numeric(12,2) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.orders OWNER TO dev;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO dev;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO dev;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO dev;

--
-- Name: users; Type: TABLE; Schema: public; Owner: dev
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    role character varying(20) DEFAULT 'office'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    company_name character varying(255) NOT NULL,
    phone character varying(30) NOT NULL,
    address character varying(255) NOT NULL,
    city character varying(100) NOT NULL,
    cuisine_type character varying(100),
    description text,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO dev;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: dev
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO dev;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dev
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.invoices (id, order_id, invoice_number, status, issued_at, due_at, paid_at, total, created_at, updated_at) FROM stdin;
2	2	INV-20261023-KOKYFP	paid	2026-10-23 15:09:38	2026-10-30 15:09:38	2026-10-23 15:09:44	42000.00	2026-10-23 15:09:38	2026-10-23 15:09:44
3	3	INV-20261023-WFUIWN	paid	2026-10-23 17:52:10	2026-10-30 17:52:10	2026-10-23 17:52:16	110000.00	2026-10-23 17:52:10	2026-10-23 17:52:16
4	4	INV-20261023-FSNIWB	paid	2026-10-23 18:30:03	2026-10-30 18:30:03	2026-10-23 18:30:06	187000.00	2026-10-23 18:30:03	2026-10-23 18:30:06
5	5	INV-20261023-PCJD6I	paid	2026-10-23 20:23:30	2026-10-30 20:23:30	2026-10-23 20:23:36	603000.00	2026-10-23 20:23:30	2026-10-23 20:23:36
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.menu_items (id, caterer_id, name, description, photo_path, price, is_available, created_at, updated_at) FROM stdin;
1	1	Nasi Rendang Box	Slow-cooked beef rendang with fragrant coconut rice, cassava leaves and pickles.	menu-items/nasi-rendang.svg	45000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
3	1	Gado-Gado Segar	Seasonal vegetables, tofu, tempeh and boiled egg with a creamy peanut dressing.	menu-items/gado-gado.svg	32000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
4	1	Es Teh Lemon	Freshly brewed Indonesian tea with lemon and a touch of palm sugar.	menu-items/es-teh.svg	10000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
5	3	Grilled Chicken Quinoa Bowl	Grilled chicken breast, tri-colour quinoa, roasted pumpkin and a lemon herb dressing.	menu-items/chicken-quinoa.svg	55000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
6	3	Vegan Buddha Bowl	Brown rice, crispy tofu, chickpeas, avocado and seasonal greens with tahini sauce.	menu-items/buddha-bowl.svg	48000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
7	3	Tropical Fruit Salad	Papaya, pineapple, mango and mint with a tangy lime dressing.	menu-items/fruit-salad.svg	30000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
8	3	Infused Water	Chilled mineral water infused with cucumber, lemon and mint.	menu-items/infused-water.svg	12000.00	t	2026-10-23 14:54:50	2026-10-23 14:54:50
2	1	Ayam Bakar Sambal	Charcoal-grilled chicken with Balinese raw sambal, steamed rice and fresh vegetables.	menu-items/ayam-bakar.svg	42000.00	t	2026-10-23 14:54:50	2026-10-23 15:08:42
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2026_10_23_130407_create_menu_items_table	2
5	2026_10_23_130429_create_orders_table	2
6	2026_10_23_130459_create_order_items_table	2
7	2026_10_23_130509_create_invoices_table	2
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.order_items (id, order_id, menu_item_id, name, unit_price, quantity, line_total, created_at, updated_at) FROM stdin;
2	2	2	Ayam Bakar Sambal	42000.00	1	42000.00	2026-10-23 15:09:38	2026-10-23 15:09:38
3	3	5	Grilled Chicken Quinoa Bowl	55000.00	2	110000.00	2026-10-23 17:52:10	2026-10-23 17:52:10
4	4	2	Ayam Bakar Sambal	42000.00	1	42000.00	2026-10-23 18:30:03	2026-10-23 18:30:03
5	4	4	Es Teh Lemon	10000.00	1	10000.00	2026-10-23 18:30:03	2026-10-23 18:30:03
6	4	1	Nasi Rendang Box	45000.00	3	135000.00	2026-10-23 18:30:03	2026-10-23 18:30:03
7	5	2	Ayam Bakar Sambal	42000.00	10	420000.00	2026-10-23 20:23:30	2026-10-23 20:23:30
8	5	4	Es Teh Lemon	10000.00	1	10000.00	2026-10-23 20:23:30	2026-10-23 20:23:30
9	5	3	Gado-Gado Segar	32000.00	4	128000.00	2026-10-23 20:23:30	2026-10-23 20:23:30
10	5	1	Nasi Rendang Box	45000.00	1	45000.00	2026-10-23 20:23:30	2026-10-23 20:23:30
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.orders (id, order_number, caterer_id, office_id, delivery_date, delivery_address, notes, status, total, created_at, updated_at) FROM stdin;
2	ORD-20261023-9XO35T	1	2	2026-10-24	Jl. Sudirman Kav. 52, Lantai 8	\N	confirmed	42000.00	2026-10-23 15:09:38	2026-10-23 16:21:27
4	ORD-20261023-L9TLC7	1	2	2026-10-24	Jl. Sudirman Kav. 52, Lantai 8	\N	pending	187000.00	2026-10-23 18:30:03	2026-10-23 18:30:03
3	ORD-20261023-X8DQFD	3	2	2026-10-24	Jl. Sudirman Kav. 52, Lantai 8	\N	confirmed	110000.00	2026-10-23 17:52:10	2026-10-23 18:59:19
5	ORD-20261023-GCBNVW	1	6	2026-10-24	Jalan Jawa	\N	pending	603000.00	2026-10-23 20:23:30	2026-10-23 20:23:30
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
MK3pWL96YjGgQ6vLrCDrn9u8gTqlykIUOF5DGhtN	1	127.0.0.1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36	eyJfdG9rZW4iOiJJTHVaOWV1MmRmMHFGWXhyT0MxZGxnVlNiU1Axd3djT3FrRDVnY003IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9sb2dpbiIsInJvdXRlIjpudWxsfSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119LCJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI6MSwicGFzc3dvcmRfaGFzaF93ZWIiOiI1OGRmMTg0N2Y2MGJjMzc2Mzc5Y2NkMDNkMzRmODlmOTJiZTIwZGE3OTRhZDVjYTIzZjZlM2Q3ZDc1MTJmM2JkIn0=	1792805732
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: dev
--

COPY public.users (id, role, name, email, email_verified_at, password, company_name, phone, address, city, cuisine_type, description, remember_token, created_at, updated_at) FROM stdin;
3	merchant	Ardi Santoso	healthy@catering.test	\N	$2y$12$XvSYmm69mckiQQ5CPAS3l.52tbefX6EIgys3SatS2vqgD2UEkboZ6	Green Bowl Kitchen	0813-2222-1100	Jl. Dago Asri No. 7	Bandung	Healthy	Balanced, colourful bowls with locally sourced produce. Vegetarian and high-protein options available with daily delivery to offices in Bandung.	\N	2026-10-23 14:54:50	2026-10-23 14:54:50
2	office	Dina Lestari	office@company.test	2026-10-23 11:52:13	$2y$12$4YHzhHLLq9SYMGmAJD9k2enQRsvdc52upt/AXcEmnHMDqQojytgne	PT Maju Bersama	021-555-0199	Jl. Sudirman Kav. 52, Lantai 8	Jakarta	\N	A growing technology team in central Jakarta.	JAwTBuah8kF3x4pjjCib9Py1k5eZzCVb8F7mDZ8caBwSVo6AUKXzdaiJxfHl	2026-10-23 11:52:13	2026-10-23 11:52:13
4	office	082182811878	boby@gmail.com	\N	$2y$12$gBGhF6YbmAgx79Cuov7ILedWW3t.oNQ7nWpuquA0UBH1azR0LNz5u	Kimak	+62 838 5033  9921	Jalan Jawa	Ponorogo	\N	Yes	\N	2026-10-23 19:46:35	2026-10-23 19:46:35
1	merchant	Rani Prameswarii	merchant@catering.test	2026-10-23 11:52:13	$2y$12$4YHzhHLLq9SYMGmAJD9k2enQRsvdc52upt/AXcEmnHMDqQojytgne	Dapur Nusantara Cateringg	0812-3456-7892	Jl. Kebon Jeruk No. 12	Bogor	Indonesia	Home-style Indonesian lunches for offices across Jakarta.	E3kYy4ZUwbojTAV2J86hR8aF98gherpQDIdaLbxjMIsrANR9l2EvCOISiR0X	2026-10-23 11:52:13	2026-10-23 18:28:08
6	office	Bob	merchantjalul@catering.test	\N	$2y$12$pjc2OvJKZ6dsaCsuabJXMOQAAEDEAg7BMxp3cHYga2Pa3vzQhGzim	Kimak	+62 838 5034 9922	Jalan Jawa	Bogor	\N	ss	\N	2026-10-23 20:23:06	2026-10-23 20:23:06
\.


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.invoices_id_seq', 5, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 9, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.migrations_id_seq', 7, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.order_items_id_seq', 10, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.orders_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dev
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: invoices invoices_invoice_number_unique; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_unique UNIQUE (invoice_number);


--
-- Name: invoices invoices_order_id_unique; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_unique UNIQUE (order_id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_unique; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_unique UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: failed_jobs_connection_queue_failed_at_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX failed_jobs_connection_queue_failed_at_index ON public.failed_jobs USING btree (connection, queue, failed_at);


--
-- Name: invoices_status_issued_at_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX invoices_status_issued_at_index ON public.invoices USING btree (status, issued_at);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: menu_items_caterer_id_is_available_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX menu_items_caterer_id_is_available_index ON public.menu_items USING btree (caterer_id, is_available);


--
-- Name: orders_caterer_id_status_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX orders_caterer_id_status_index ON public.orders USING btree (caterer_id, status);


--
-- Name: orders_office_id_status_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX orders_office_id_status_index ON public.orders USING btree (office_id, status);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: dev
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: invoices invoices_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_order_id_foreign FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_caterer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_caterer_id_foreign FOREIGN KEY (caterer_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: order_items order_items_menu_item_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_foreign FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE SET NULL;


--
-- Name: order_items order_items_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_foreign FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_caterer_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_caterer_id_foreign FOREIGN KEY (caterer_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: orders orders_office_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: dev
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_office_id_foreign FOREIGN KEY (office_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict KhrRjg0TQprsNQ6p0rOSz7FO7eCssWHgMMxNX1vsV77J6uzgaeUw50YgNm5GFCe


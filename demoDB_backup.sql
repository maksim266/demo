--
-- PostgreSQL database dump
--

\restrict 3iFvwt4jB5zxVwY5pdquWdUhaJfE0NmWM5jU47V4LQ04El38TZmDFegzheGtLl6

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-06-18 23:30:50

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 16401)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id_category integer NOT NULL,
    category_name character varying(100) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16400)
-- Name: categories_id_category_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_category_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_category_seq OWNER TO postgres;

--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 223
-- Name: categories_id_category_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_category_seq OWNED BY public.categories.id_category;


--
-- TOC entry 226 (class 1259 OID 16412)
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufacturers (
    id_manufacturer integer NOT NULL,
    manufacturer_name character varying(100) NOT NULL
);


ALTER TABLE public.manufacturers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16411)
-- Name: manufacturers_id_manufacturer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manufacturers_id_manufacturer_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manufacturers_id_manufacturer_seq OWNER TO postgres;

--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 225
-- Name: manufacturers_id_manufacturer_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manufacturers_id_manufacturer_seq OWNED BY public.manufacturers.id_manufacturer;


--
-- TOC entry 240 (class 1259 OID 16555)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id_order integer NOT NULL,
    article character varying(10) NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16527)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id_order integer NOT NULL,
    id_client integer NOT NULL,
    id_pickup_point integer NOT NULL,
    id_status integer NOT NULL,
    order_date date NOT NULL,
    delivery_date date NOT NULL,
    pickup_code integer NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16526)
-- Name: orders_id_order_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_order_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_order_seq OWNER TO postgres;

--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 238
-- Name: orders_id_order_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_order_seq OWNED BY public.orders.id_order;


--
-- TOC entry 232 (class 1259 OID 16445)
-- Name: orderstatuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orderstatuses (
    id_status integer NOT NULL,
    status_name character varying(50) NOT NULL
);


ALTER TABLE public.orderstatuses OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16444)
-- Name: orderstatuses_id_status_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orderstatuses_id_status_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orderstatuses_id_status_seq OWNER TO postgres;

--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 231
-- Name: orderstatuses_id_status_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orderstatuses_id_status_seq OWNED BY public.orderstatuses.id_status;


--
-- TOC entry 234 (class 1259 OID 16456)
-- Name: pickuppoints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pickuppoints (
    id_pickup_point integer NOT NULL,
    address character varying(255) NOT NULL
);


ALTER TABLE public.pickuppoints OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16455)
-- Name: pickuppoints_id_pickup_point_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pickuppoints_id_pickup_point_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pickuppoints_id_pickup_point_seq OWNER TO postgres;

--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 233
-- Name: pickuppoints_id_pickup_point_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pickuppoints_id_pickup_point_seq OWNED BY public.pickuppoints.id_pickup_point;


--
-- TOC entry 237 (class 1259 OID 16485)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    article character varying(10) NOT NULL,
    product_name character varying(150) NOT NULL,
    id_category integer NOT NULL,
    id_manufacturer integer NOT NULL,
    id_supplier integer NOT NULL,
    id_unit integer NOT NULL,
    price numeric(10,2) NOT NULL,
    discount_percent integer DEFAULT 0 NOT NULL,
    stock_quantity integer DEFAULT 0 NOT NULL,
    description text,
    photo_path character varying(255),
    CONSTRAINT products_discount_percent_check CHECK (((discount_percent >= 0) AND (discount_percent <= 100))),
    CONSTRAINT products_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= 0))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16390)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_role integer NOT NULL,
    role_name character varying(50) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16389)
-- Name: roles_id_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_role_seq OWNER TO postgres;

--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 221
-- Name: roles_id_role_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_role_seq OWNED BY public.roles.id_role;


--
-- TOC entry 228 (class 1259 OID 16423)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id_supplier integer NOT NULL,
    supplier_name character varying(100) NOT NULL
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16422)
-- Name: suppliers_id_supplier_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_id_supplier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_supplier_seq OWNER TO postgres;

--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 227
-- Name: suppliers_id_supplier_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_supplier_seq OWNED BY public.suppliers.id_supplier;


--
-- TOC entry 230 (class 1259 OID 16434)
-- Name: units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.units (
    id_unit integer NOT NULL,
    unit_name character varying(20) NOT NULL
);


ALTER TABLE public.units OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16433)
-- Name: units_id_unit_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.units_id_unit_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.units_id_unit_seq OWNER TO postgres;

--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 229
-- Name: units_id_unit_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.units_id_unit_seq OWNED BY public.units.id_unit;


--
-- TOC entry 236 (class 1259 OID 16467)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    full_name character varying(150) NOT NULL,
    login character varying(100) NOT NULL,
    password character varying(50) NOT NULL,
    id_role integer NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16466)
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_user_seq OWNER TO postgres;

--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 235
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;


--
-- TOC entry 4806 (class 2604 OID 16658)
-- Name: categories id_category; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id_category SET DEFAULT nextval('public.categories_id_category_seq'::regclass);


--
-- TOC entry 4807 (class 2604 OID 16659)
-- Name: manufacturers id_manufacturer; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN id_manufacturer SET DEFAULT nextval('public.manufacturers_id_manufacturer_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 16660)
-- Name: orders id_order; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id_order SET DEFAULT nextval('public.orders_id_order_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 16661)
-- Name: orderstatuses id_status; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderstatuses ALTER COLUMN id_status SET DEFAULT nextval('public.orderstatuses_id_status_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 16662)
-- Name: pickuppoints id_pickup_point; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickuppoints ALTER COLUMN id_pickup_point SET DEFAULT nextval('public.pickuppoints_id_pickup_point_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 16663)
-- Name: roles id_role; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id_role SET DEFAULT nextval('public.roles_id_role_seq'::regclass);


--
-- TOC entry 4808 (class 2604 OID 16664)
-- Name: suppliers id_supplier; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id_supplier SET DEFAULT nextval('public.suppliers_id_supplier_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 16665)
-- Name: units id_unit; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units ALTER COLUMN id_unit SET DEFAULT nextval('public.units_id_unit_seq'::regclass);


--
-- TOC entry 4812 (class 2604 OID 16666)
-- Name: users id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);


--
-- TOC entry 5024 (class 0 OID 16401)
-- Dependencies: 224
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id_category, category_name) FROM stdin;
1	Общестроительные материалы
2	Стеновые и фасадные материалы
3	Сухие строительные смеси и гидроизоляция
4	Ручной инструмент
5	Защита лица, глаз, головы
\.


--
-- TOC entry 5026 (class 0 OID 16412)
-- Dependencies: 226
-- Data for Name: manufacturers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manufacturers (id_manufacturer, manufacturer_name) FROM stdin;
1	М500
2	Изостронг
3	Knauf
4	MixMaster
5	ЛСР
6	ВОЛМА
7	Vinylon
8	Павловский завод
9	Weber
10	Hesler
11	Armero
12	Wenzo Roma
13	KILIMGRIN
14	Исток
15	RUIZ
16	Husqvarna
17	Delta
\.


--
-- TOC entry 5040 (class 0 OID 16555)
-- Dependencies: 240
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id_order, article, quantity) FROM stdin;
1	PMEZMH	2
1	BPV4MM	2
2	JVL42J	1
2	F895RB	1
3	3XBOTN	10
3	3L7RCZ	10
4	S72AM3	5
4	2G3280	4
5	MIO8YV	2
5	UER2QD	2
6	ZR70B4	1
6	LPDDM4	1
7	LQ48MW	10
7	O43COU	10
8	M26EXW	5
8	K0YACK	4
9	ASPXSG	5
9	ZKQ5FF	1
10	4WZEOT	5
10	4JR1HN	5
\.


--
-- TOC entry 5039 (class 0 OID 16527)
-- Dependencies: 239
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id_order, id_client, id_pickup_point, id_status, order_date, delivery_date, pickup_code) FROM stdin;
1	7	1	2	2025-02-27	2025-04-20	901
2	8	11	2	2024-09-28	2025-04-21	902
3	9	2	2	2025-03-21	2025-04-22	903
4	10	11	2	2025-02-20	2025-04-23	904
5	7	2	2	2025-03-17	2025-04-24	905
6	8	15	2	2025-03-01	2025-04-25	906
7	9	3	2	2025-02-28	2025-04-26	907
8	10	19	1	2025-03-31	2025-04-27	908
9	9	5	1	2025-04-02	2025-04-28	909
10	10	19	1	2025-04-03	2025-04-29	910
\.


--
-- TOC entry 5032 (class 0 OID 16445)
-- Dependencies: 232
-- Data for Name: orderstatuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orderstatuses (id_status, status_name) FROM stdin;
1	Новый
2	Завершен
\.


--
-- TOC entry 5034 (class 0 OID 16456)
-- Dependencies: 234
-- Data for Name: pickuppoints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pickuppoints (id_pickup_point, address) FROM stdin;
1	420151, г. Лесной, ул. Вишневая, 32
2	125061, г. Лесной, ул. Подгорная, 8
3	630370, г. Лесной, ул. Шоссейная, 24
4	400562, г. Лесной, ул. Зеленая, 32
5	614510, г. Лесной, ул. Маяковского, 47
6	410542, г. Лесной, ул. Светлая, 46
7	620839, г. Лесной, ул. Цветочная, 8
8	443890, г. Лесной, ул. Коммунистическая, 1
9	603379, г. Лесной, ул. Спортивная, 46
10	603721, г. Лесной, ул. Гоголя, 41
11	410172, г. Лесной, ул. Северная, 13
12	614611, г. Лесной, ул. Молодежная, 50
13	454311, г.Лесной, ул. Новая, 19
14	660007, г.Лесной, ул. Октябрьская, 19
15	603036, г. Лесной, ул. Садовая, 4
16	394060, г.Лесной, ул. Фрунзе, 43
17	410661, г. Лесной, ул. Школьная, 50
18	625590, г. Лесной, ул. Коммунистическая, 20
19	625683, г. Лесной, ул. 8 Марта
20	450983, г.Лесной, ул. Комсомольская, 26
21	394782, г. Лесной, ул. Чехова, 3
22	603002, г. Лесной, ул. Дзержинского, 28
23	450558, г. Лесной, ул. Набережная, 30
24	344288, г. Лесной, ул. Чехова, 1
25	614164, г.Лесной, ул. Степная, 30
26	394242, г. Лесной, ул. Коммунистическая, 43
27	660540, г. Лесной, ул. Солнечная, 25
28	125837, г. Лесной, ул. Шоссейная, 40
29	125703, г. Лесной, ул. Партизанская, 49
30	625283, г. Лесной, ул. Победы, 46
31	614753, г. Лесной, ул. Полевая, 35
32	426030, г. Лесной, ул. Маяковского, 44
33	450375, г. Лесной ул. Клубная, 44
34	625560, г. Лесной, ул. Некрасова, 12
35	630201, г. Лесной, ул. Комсомольская, 17
36	190949, г. Лесной, ул. Мичурина, 26
\.


--
-- TOC entry 5037 (class 0 OID 16485)
-- Dependencies: 237
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (article, product_name, id_category, id_manufacturer, id_supplier, id_unit, price, discount_percent, stock_quantity, description, photo_path) FROM stdin;
PMEZMH	Цемент	1	1	1	1	440.00	8	34	Цемент Евроцемент М500 Д0 ЦЕМ I 42,5 50 кг	PMEZMH.jpg
BPV4MM	Пленка техническая	1	2	2	1	8.00	8	2	Пленка техническая полиэтиленовая Изостронг 60 мк 3 м рукав 1,5 м, пог.м	BPV4MM.jpg
JVL42J	Пленка техническая	1	2	2	1	13.00	4	34	Пленка техническая полиэтиленовая Изостронг 100 мк 3 м рукав 1,5 м, пог.м	JVL42J.jpg
F895RB	Песок строительный	1	3	3	1	102.00	6	7	Песок строительный 50 кг	F895RB.jpg
3XBOTN	Керамзит фракция	1	4	4	1	110.00	5	21	Керамзит фракция 10-20 мм 0,05 куб.м	3XBOTN.jpg
3L7RCZ	Газобетон	2	5	5	1	7400.00	2	20	Газобетон ЛСР 100х250х625 мм D400	3L7RCZ.jpg
S72AM3	Пазогребневая плита	2	6	6	1	500.00	5	35	Пазогребневая плита ВОЛМА Гидро 667х500х80 мм полнотелая	S72AM3.jpg
2G3280	Угол наружный	2	7	7	1	795.00	9	20	Угол наружный Vinylon 3050 мм серо-голубой	2G3280.jpg
MIO8YV	Кирпич	2	6	6	1	30.00	9	31	Кирпич рядовой Боровичи полнотелый М150 250х120х65 мм 1NF	MIO8YV.jpg
UER2QD	Скоба для пазогребневой плиты	2	3	3	1	25.00	8	27	Скоба для пазогребневой плиты Knauf С1 120х100 мм	UER2QD.jpg
ZR70B4	Кирпич	2	8	8	1	16.00	3	0	Кирпич рядовой силикатный Павловский завод полнотелый М200 250х120х65 мм 1NF	\N
LPDDM4	Штукатурка гипсовая	3	3	3	1	500.00	6	38	Штукатурка гипсовая Knauf Ротбанд 30 кг	\N
LQ48MW	Штукатурка гипсовая	3	9	9	1	462.00	6	33	Штукатурка гипсовая Knauf МП-75 машинная 30 кг	\N
O43COU	Шпаклевка	3	6	6	1	750.00	1	16	Шпаклевка полимерная Weber.vetonit LR + для сухих помещений белая 20 кг	\N
M26EXW	Клей для плитки, керамогранита и камня	3	3	3	1	340.00	8	0	Клей для плитки, керамогранита и камня Крепс Усиленный серый (класс С1) 25 кг	\N
K0YACK	Смесь цементно-песчаная	3	4	4	1	160.00	8	19	Смесь цементно-песчаная (ЦПС) 300 по ТУ MixMaster Универсал 25 кг	\N
ASPXSG	Ровнитель	3	9	9	1	711.00	10	20	Ровнитель (наливной пол) финишный Weber.vetonit 4100 самовыравнивающийся высокопрочный 20 кг	\N
ZKQ5FF	Лезвие для ножа	4	10	10	1	65.00	6	6	Лезвие для ножа Hesler 18 мм прямое (10 шт.)	\N
4WZEOT	Лезвие для ножа	4	11	11	1	110.00	6	17	Лезвие для ножа Armero 18 мм прямое (10 шт.)	\N
4JR1HN	Шпатель	4	10	10	1	26.00	6	7	Шпатель малярный 100 мм с пластиковой ручкой	\N
Z3XFSP	Нож строительный	4	10	10	1	63.00	8	5	Нож строительный Hesler 18 мм с ломающимся лезвием пластиковый корпус	\N
I6MH89	Валик	4	12	12	1	326.00	12	3	Валик Wenzo Roma полиакрил 250 мм ворс 18 мм для красок грунтов и антисептиков на водной основе с рукояткой	\N
83M5ME	Кисть	4	11	11	1	122.00	9	26	Кисть плоская смешанная щетина 100х12 мм для красок и антисептиков на водной основе	\N
61PGH3	Очки защитные	5	13	13	1	184.00	6	25	Очки защитные Delta Plus KILIMANDJARO (KILIMGRIN) открытые с прозрачными линзами	\N
GN6ICZ	Каска защитная	5	14	14	1	154.00	15	8	Каска защитная Исток (КАС001О) оранжевая	\N
Z3LO0U	Очки защитные	5	15	15	1	228.00	9	11	Очки защитные Delta Plus RUIZ (RUIZ1VI) закрытые с прозрачными линзами	\N
QHNOKR	Маска защитная	5	14	14	1	251.00	2	22	Маска защитная Исток (ЩИТ001) ударопрочная и термостойкая	\N
EQ6RKO	Подшлемник	5	16	16	1	36.00	17	22	Подшлемник для каски одноразовый	\N
81F1WG	Каска защитная	5	17	17	1	1500.00	2	13	Каска защитная Delta Plus BASEBALL DIAMOND V UP (DIAM5UPBCFLBS) белая	\N
0YGHZ7	Очки защитные	5	16	16	1	700.00	9	36	Очки защитные Husqvarna Clear (5449638-01) открытые с прозрачными линзами	\N
\.


--
-- TOC entry 5022 (class 0 OID 16390)
-- Dependencies: 222
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id_role, role_name) FROM stdin;
1	Администратор
2	Менеджер
3	Авторизированный клиент
\.


--
-- TOC entry 5028 (class 0 OID 16423)
-- Dependencies: 228
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id_supplier, supplier_name) FROM stdin;
1	М500
2	Изостронг
3	Knauf
4	MixMaster
5	ЛСР
6	ВОЛМА
7	Vinylon
8	Павловский завод
9	Weber
10	Hesler
11	Armero
12	Wenzo Roma
13	KILIMGRIN
14	Исток
15	RUIZ
16	Husqvarna
17	Delta
\.


--
-- TOC entry 5030 (class 0 OID 16434)
-- Dependencies: 230
-- Data for Name: units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.units (id_unit, unit_name) FROM stdin;
1	шт.
\.


--
-- TOC entry 5036 (class 0 OID 16467)
-- Dependencies: 236
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, full_name, login, password, id_role) FROM stdin;
1	Ворсин Петр Евгеньевич	94d5ous@gmail.com	uzWC67	1
2	Старикова Елена Павловна	uth4iz@mail.com	2L6KZG	1
3	Одинцов Серафим Артёмович	yzls62@outlook.com	JlFRCZ	1
4	Степанов Михаил Артёмович	1diph5e@tutanota.com	8ntwUp	2
5	Ворсин Петр Евгеньевич	tjde7c@yahoo.com	YOyhfR	2
6	Старикова Елена Павловна	wpmrc3do@tutanota.com	RSbvHv	2
7	Михайлюк Анна Вячеславовна	5d4zbu@tutanota.com	rwVDh9	3
8	Ситдикова Елена Анатольевна	ptec8ym@yahoo.com	LdNyos	3
9	Никифорова Весения Николаевна	1qz4kw@mail.com	gynQMT	3
10	Сазонов Руслан Германович	4np6se@mail.com	AtnDjr	3
\.


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 223
-- Name: categories_id_category_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_category_seq', 5, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 225
-- Name: manufacturers_id_manufacturer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manufacturers_id_manufacturer_seq', 17, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 238
-- Name: orders_id_order_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_order_seq', 10, true);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 231
-- Name: orderstatuses_id_status_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orderstatuses_id_status_seq', 2, true);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 233
-- Name: pickuppoints_id_pickup_point_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pickuppoints_id_pickup_point_seq', 36, true);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 221
-- Name: roles_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_role_seq', 3, true);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 227
-- Name: suppliers_id_supplier_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_supplier_seq', 17, true);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 229
-- Name: units_id_unit_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.units_id_unit_seq', 1, true);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 235
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_user_seq', 10, true);


--
-- TOC entry 4825 (class 2606 OID 16410)
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- TOC entry 4827 (class 2606 OID 16408)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id_category);


--
-- TOC entry 4829 (class 2606 OID 16421)
-- Name: manufacturers manufacturers_manufacturer_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_manufacturer_name_key UNIQUE (manufacturer_name);


--
-- TOC entry 4831 (class 2606 OID 16419)
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id_manufacturer);


--
-- TOC entry 4863 (class 2606 OID 16563)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id_order, article);


--
-- TOC entry 4859 (class 2606 OID 16539)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id_order);


--
-- TOC entry 4841 (class 2606 OID 16452)
-- Name: orderstatuses orderstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderstatuses
    ADD CONSTRAINT orderstatuses_pkey PRIMARY KEY (id_status);


--
-- TOC entry 4843 (class 2606 OID 16454)
-- Name: orderstatuses orderstatuses_status_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orderstatuses
    ADD CONSTRAINT orderstatuses_status_name_key UNIQUE (status_name);


--
-- TOC entry 4845 (class 2606 OID 16465)
-- Name: pickuppoints pickuppoints_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickuppoints
    ADD CONSTRAINT pickuppoints_address_key UNIQUE (address);


--
-- TOC entry 4847 (class 2606 OID 16463)
-- Name: pickuppoints pickuppoints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pickuppoints
    ADD CONSTRAINT pickuppoints_pkey PRIMARY KEY (id_pickup_point);


--
-- TOC entry 4855 (class 2606 OID 16505)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (article);


--
-- TOC entry 4821 (class 2606 OID 16397)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_role);


--
-- TOC entry 4823 (class 2606 OID 16399)
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- TOC entry 4833 (class 2606 OID 16430)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id_supplier);


--
-- TOC entry 4835 (class 2606 OID 16432)
-- Name: suppliers suppliers_supplier_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_supplier_name_key UNIQUE (supplier_name);


--
-- TOC entry 4837 (class 2606 OID 16441)
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id_unit);


--
-- TOC entry 4839 (class 2606 OID 16443)
-- Name: units units_unit_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_unit_name_key UNIQUE (unit_name);


--
-- TOC entry 4849 (class 2606 OID 16479)
-- Name: users users_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_login_key UNIQUE (login);


--
-- TOC entry 4851 (class 2606 OID 16477)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 4860 (class 1259 OID 16579)
-- Name: idx_order_items_article; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_article ON public.order_items USING btree (article);


--
-- TOC entry 4861 (class 1259 OID 16578)
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (id_order);


--
-- TOC entry 4856 (class 1259 OID 16576)
-- Name: idx_orders_client; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_client ON public.orders USING btree (id_client);


--
-- TOC entry 4857 (class 1259 OID 16577)
-- Name: idx_orders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status ON public.orders USING btree (id_status);


--
-- TOC entry 4852 (class 1259 OID 16574)
-- Name: idx_products_category; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category ON public.products USING btree (id_category);


--
-- TOC entry 4853 (class 1259 OID 16575)
-- Name: idx_products_manufacturer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_manufacturer ON public.products USING btree (id_manufacturer);


--
-- TOC entry 4872 (class 2606 OID 16564)
-- Name: order_items fk_order_items_orders; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_order_items_orders FOREIGN KEY (id_order) REFERENCES public.orders(id_order) ON DELETE CASCADE;


--
-- TOC entry 4873 (class 2606 OID 16569)
-- Name: order_items fk_order_items_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_order_items_products FOREIGN KEY (article) REFERENCES public.products(article) ON DELETE RESTRICT;


--
-- TOC entry 4869 (class 2606 OID 16545)
-- Name: orders fk_orders_pickup_points; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_pickup_points FOREIGN KEY (id_pickup_point) REFERENCES public.pickuppoints(id_pickup_point) ON DELETE RESTRICT;


--
-- TOC entry 4870 (class 2606 OID 16550)
-- Name: orders fk_orders_statuses; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_statuses FOREIGN KEY (id_status) REFERENCES public.orderstatuses(id_status) ON DELETE RESTRICT;


--
-- TOC entry 4871 (class 2606 OID 16540)
-- Name: orders fk_orders_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_orders_users FOREIGN KEY (id_client) REFERENCES public.users(id_user) ON DELETE RESTRICT;


--
-- TOC entry 4865 (class 2606 OID 16506)
-- Name: products fk_products_categories; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_categories FOREIGN KEY (id_category) REFERENCES public.categories(id_category) ON DELETE RESTRICT;


--
-- TOC entry 4866 (class 2606 OID 16511)
-- Name: products fk_products_manufacturers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_manufacturers FOREIGN KEY (id_manufacturer) REFERENCES public.manufacturers(id_manufacturer) ON DELETE RESTRICT;


--
-- TOC entry 4867 (class 2606 OID 16516)
-- Name: products fk_products_suppliers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_suppliers FOREIGN KEY (id_supplier) REFERENCES public.suppliers(id_supplier) ON DELETE RESTRICT;


--
-- TOC entry 4868 (class 2606 OID 16521)
-- Name: products fk_products_units; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_products_units FOREIGN KEY (id_unit) REFERENCES public.units(id_unit) ON DELETE RESTRICT;


--
-- TOC entry 4864 (class 2606 OID 16480)
-- Name: users fk_users_roles; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_roles FOREIGN KEY (id_role) REFERENCES public.roles(id_role) ON DELETE RESTRICT;


-- Completed on 2026-06-18 23:30:50

--
-- PostgreSQL database dump complete
--

\unrestrict 3iFvwt4jB5zxVwY5pdquWdUhaJfE0NmWM5jU47V4LQ04El38TZmDFegzheGtLl6


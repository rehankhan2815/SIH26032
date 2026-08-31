--
-- PostgreSQL database dump
--

\restrict Dm1JakwEZ68wCEpx4JXPKM0G7V1XwFcO5gin0cxG3Putc7PF3Mw7Sc26UgY4bbB

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-08-31 23:01:28

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
-- TOC entry 230 (class 1259 OID 16489)
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    booking_id bigint NOT NULL,
    farmer_id bigint NOT NULL,
    slot_id bigint NOT NULL,
    quantity numeric(10,2) NOT NULL,
    queue_position integer,
    estimated_wait_minutes integer,
    booking_status character varying(20) DEFAULT 'CONFIRMED'::character varying NOT NULL,
    booked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT bookings_booking_status_check CHECK (((booking_status)::text = ANY ((ARRAY['CONFIRMED'::character varying, 'WAITING'::character varying, 'CALLED'::character varying, 'COMPLETED'::character varying, 'CANCELLED'::character varying])::text[]))),
    CONSTRAINT bookings_quantity_check CHECK ((quantity > (0)::numeric))
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16488)
-- Name: bookings_booking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.bookings ALTER COLUMN booking_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bookings_booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 16582)
-- Name: commodity_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commodity_prices (
    price_id bigint NOT NULL,
    crop_id bigint NOT NULL,
    market_name character varying(150),
    district character varying(100),
    state character varying(100),
    price_date date NOT NULL,
    min_price numeric(10,2),
    max_price numeric(10,2),
    modal_price numeric(10,2),
    source character varying(100) DEFAULT 'Agmarknet'::character varying NOT NULL,
    fetched_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.commodity_prices OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16581)
-- Name: commodity_prices_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.commodity_prices ALTER COLUMN price_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.commodity_prices_price_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 16515)
-- Name: crop_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crop_submissions (
    submission_id bigint NOT NULL,
    booking_id bigint NOT NULL,
    actual_quantity numeric(10,2),
    submission_status character varying(30) DEFAULT 'RECEIVED'::character varying NOT NULL,
    quality_notes text,
    rejection_reason text,
    payment_status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    payment_reference character varying(100),
    submitted_at timestamp without time zone,
    accepted_at timestamp without time zone,
    paid_at timestamp without time zone,
    CONSTRAINT crop_submissions_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['PENDING'::character varying, 'PROCESSING'::character varying, 'PAID'::character varying])::text[]))),
    CONSTRAINT crop_submissions_submission_status_check CHECK (((submission_status)::text = ANY ((ARRAY['RECEIVED'::character varying, 'QUALITY_CHECKED'::character varying, 'ACCEPTED'::character varying, 'REJECTED'::character varying, 'PAYMENT_PROCESSING'::character varying, 'PAID'::character varying])::text[])))
);


ALTER TABLE public.crop_submissions OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16514)
-- Name: crop_submissions_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.crop_submissions ALTER COLUMN submission_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.crop_submissions_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 16442)
-- Name: crops; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crops (
    crop_id bigint NOT NULL,
    crop_name character varying(100) NOT NULL,
    crop_code character varying(30),
    unit character varying(20) DEFAULT 'QUINTAL'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.crops OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16441)
-- Name: crops_crop_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.crops ALTER COLUMN crop_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.crops_crop_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16410)
-- Name: farmer_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.farmer_profiles (
    farmer_id bigint NOT NULL,
    user_id bigint NOT NULL,
    village character varying(100),
    district character varying(100),
    state character varying(100),
    address text
);


ALTER TABLE public.farmer_profiles OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16409)
-- Name: farmer_profiles_farmer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.farmer_profiles ALTER COLUMN farmer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.farmer_profiles_farmer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 16561)
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    notification_id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(150) NOT NULL,
    message text NOT NULL,
    notification_type character varying(30),
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16560)
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.notifications ALTER COLUMN notification_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.notifications_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 16427)
-- Name: procurement_centers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procurement_centers (
    center_id bigint NOT NULL,
    center_name character varying(150) NOT NULL,
    address text NOT NULL,
    village character varying(100),
    district character varying(100),
    state character varying(100),
    contact_phone character varying(15),
    opening_time time without time zone,
    closing_time time without time zone,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.procurement_centers OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16426)
-- Name: procurement_centers_center_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.procurement_centers ALTER COLUMN center_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.procurement_centers_center_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 16458)
-- Name: procurement_slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.procurement_slots (
    slot_id bigint NOT NULL,
    center_id bigint NOT NULL,
    crop_id bigint NOT NULL,
    slot_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    capacity integer NOT NULL,
    booked_count integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT chk_booked_capacity CHECK ((booked_count <= capacity)),
    CONSTRAINT chk_slot_time CHECK ((end_time > start_time)),
    CONSTRAINT procurement_slots_booked_count_check CHECK ((booked_count >= 0)),
    CONSTRAINT procurement_slots_capacity_check CHECK ((capacity > 0))
);


ALTER TABLE public.procurement_slots OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16457)
-- Name: procurement_slots_slot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.procurement_slots ALTER COLUMN slot_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.procurement_slots_slot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 16538)
-- Name: status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_history (
    history_id bigint NOT NULL,
    submission_id bigint NOT NULL,
    old_status character varying(30),
    new_status character varying(30) NOT NULL,
    changed_by bigint,
    remarks text,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.status_history OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16537)
-- Name: status_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.status_history ALTER COLUMN history_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.status_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16390)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    full_name character varying(100) NOT NULL,
    phone character varying(15) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['FARMER'::character varying, 'ADMIN'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5035 (class 0 OID 16489)
-- Dependencies: 230
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (booking_id, farmer_id, slot_id, quantity, queue_position, estimated_wait_minutes, booking_status, booked_at) FROM stdin;
1	1	1	25.00	1	10	CONFIRMED	2026-08-31 22:31:40.739794
2	2	1	30.00	2	20	CONFIRMED	2026-08-31 22:31:40.739794
\.


--
-- TOC entry 5043 (class 0 OID 16582)
-- Dependencies: 238
-- Data for Name: commodity_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commodity_prices (price_id, crop_id, market_name, district, state, price_date, min_price, max_price, modal_price, source, fetched_at) FROM stdin;
1	1	Dewas Mandi	Dewas	Madhya Pradesh	2026-08-31	2200.00	2500.00	2350.00	Demo - Agmarknet	2026-08-31 22:31:40.739794
\.


--
-- TOC entry 5037 (class 0 OID 16515)
-- Dependencies: 232
-- Data for Name: crop_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crop_submissions (submission_id, booking_id, actual_quantity, submission_status, quality_notes, rejection_reason, payment_status, payment_reference, submitted_at, accepted_at, paid_at) FROM stdin;
1	1	25.00	RECEIVED	\N	\N	PENDING	\N	2026-08-31 22:31:40.739794	\N	\N
\.


--
-- TOC entry 5031 (class 0 OID 16442)
-- Dependencies: 226
-- Data for Name: crops; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crops (crop_id, crop_name, crop_code, unit, is_active) FROM stdin;
1	Wheat	WHEAT	QUINTAL	t
2	Paddy	PADDY	QUINTAL	t
3	Soybean	SOYBEAN	QUINTAL	t
\.


--
-- TOC entry 5027 (class 0 OID 16410)
-- Dependencies: 222
-- Data for Name: farmer_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.farmer_profiles (farmer_id, user_id, village, district, state, address) FROM stdin;
1	1	Sonkatch	Dewas	Madhya Pradesh	Demo Address 1
2	2	Bagli	Dewas	Madhya Pradesh	Demo Address 2
3	3	Kannod	Dewas	Madhya Pradesh	Demo Address 3
\.


--
-- TOC entry 5041 (class 0 OID 16561)
-- Dependencies: 236
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (notification_id, user_id, title, message, notification_type, is_read, created_at) FROM stdin;
1	1	Booking Confirmed	Your wheat procurement slot has been confirmed.	BOOKING	f	2026-08-31 22:31:40.739794
\.


--
-- TOC entry 5029 (class 0 OID 16427)
-- Dependencies: 224
-- Data for Name: procurement_centers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procurement_centers (center_id, center_name, address, village, district, state, contact_phone, opening_time, closing_time, is_active, created_at) FROM stdin;
1	Dewas Central Procurement Center	Main Mandi Road	Dewas	Dewas	Madhya Pradesh	9000010001	09:00:00	17:00:00	t	2026-08-31 22:31:40.739794
2	Sonkatch Procurement Center	Mandi Campus	Sonkatch	Dewas	Madhya Pradesh	9000010002	09:00:00	17:00:00	t	2026-08-31 22:31:40.739794
\.


--
-- TOC entry 5033 (class 0 OID 16458)
-- Dependencies: 228
-- Data for Name: procurement_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.procurement_slots (slot_id, center_id, crop_id, slot_date, start_time, end_time, capacity, booked_count, is_active) FROM stdin;
1	1	1	2026-09-01	09:00:00	10:00:00	10	0	t
2	1	1	2026-09-01	10:00:00	11:00:00	10	0	t
3	2	2	2026-09-01	09:00:00	10:00:00	8	0	t
\.


--
-- TOC entry 5039 (class 0 OID 16538)
-- Dependencies: 234
-- Data for Name: status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status_history (history_id, submission_id, old_status, new_status, changed_by, remarks, changed_at) FROM stdin;
\.


--
-- TOC entry 5025 (class 0 OID 16390)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, full_name, phone, password_hash, role, is_active, created_at) FROM stdin;
1	Ramesh Patil	9000000001	demo_hash_1	FARMER	t	2026-08-31 22:31:40.739794
2	Suresh Verma	9000000002	demo_hash_2	FARMER	t	2026-08-31 22:31:40.739794
3	Amit Sharma	9000000003	demo_hash_3	FARMER	t	2026-08-31 22:31:40.739794
4	Rajesh Kumar	9000000004	demo_hash_4	ADMIN	t	2026-08-31 22:31:40.739794
5	Priya Singh	9000000005	demo_hash_5	ADMIN	t	2026-08-31 22:31:40.739794
\.


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 229
-- Name: bookings_booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bookings_booking_id_seq', 2, true);


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 237
-- Name: commodity_prices_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commodity_prices_price_id_seq', 1, true);


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 231
-- Name: crop_submissions_submission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crop_submissions_submission_id_seq', 1, true);


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 225
-- Name: crops_crop_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.crops_crop_id_seq', 3, true);


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 221
-- Name: farmer_profiles_farmer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.farmer_profiles_farmer_id_seq', 3, true);


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 235
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 1, true);


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 223
-- Name: procurement_centers_center_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procurement_centers_center_id_seq', 2, true);


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 227
-- Name: procurement_slots_slot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.procurement_slots_slot_id_seq', 3, true);


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 233
-- Name: status_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_history_history_id_seq', 1, false);


--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 5, true);


--
-- TOC entry 4847 (class 2606 OID 16503)
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (booking_id);


--
-- TOC entry 4865 (class 2606 OID 16593)
-- Name: commodity_prices commodity_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commodity_prices
    ADD CONSTRAINT commodity_prices_pkey PRIMARY KEY (price_id);


--
-- TOC entry 4854 (class 2606 OID 16531)
-- Name: crop_submissions crop_submissions_booking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_submissions
    ADD CONSTRAINT crop_submissions_booking_id_key UNIQUE (booking_id);


--
-- TOC entry 4856 (class 2606 OID 16529)
-- Name: crop_submissions crop_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_submissions
    ADD CONSTRAINT crop_submissions_pkey PRIMARY KEY (submission_id);


--
-- TOC entry 4837 (class 2606 OID 16456)
-- Name: crops crops_crop_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crops
    ADD CONSTRAINT crops_crop_code_key UNIQUE (crop_code);


--
-- TOC entry 4839 (class 2606 OID 16454)
-- Name: crops crops_crop_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crops
    ADD CONSTRAINT crops_crop_name_key UNIQUE (crop_name);


--
-- TOC entry 4841 (class 2606 OID 16452)
-- Name: crops crops_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crops
    ADD CONSTRAINT crops_pkey PRIMARY KEY (crop_id);


--
-- TOC entry 4831 (class 2606 OID 16418)
-- Name: farmer_profiles farmer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer_profiles
    ADD CONSTRAINT farmer_profiles_pkey PRIMARY KEY (farmer_id);


--
-- TOC entry 4833 (class 2606 OID 16420)
-- Name: farmer_profiles farmer_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer_profiles
    ADD CONSTRAINT farmer_profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 4863 (class 2606 OID 16575)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- TOC entry 4835 (class 2606 OID 16440)
-- Name: procurement_centers procurement_centers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurement_centers
    ADD CONSTRAINT procurement_centers_pkey PRIMARY KEY (center_id);


--
-- TOC entry 4845 (class 2606 OID 16477)
-- Name: procurement_slots procurement_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurement_slots
    ADD CONSTRAINT procurement_slots_pkey PRIMARY KEY (slot_id);


--
-- TOC entry 4860 (class 2606 OID 16549)
-- Name: status_history status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT status_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 4827 (class 2606 OID 16408)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4829 (class 2606 OID 16406)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4848 (class 1259 OID 16601)
-- Name: idx_bookings_farmer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_farmer ON public.bookings USING btree (farmer_id);


--
-- TOC entry 4849 (class 1259 OID 16603)
-- Name: idx_bookings_queue; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_queue ON public.bookings USING btree (slot_id, queue_position);


--
-- TOC entry 4850 (class 1259 OID 16602)
-- Name: idx_bookings_slot; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_slot ON public.bookings USING btree (slot_id);


--
-- TOC entry 4861 (class 1259 OID 16606)
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- TOC entry 4866 (class 1259 OID 16607)
-- Name: idx_prices_crop_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_prices_crop_date ON public.commodity_prices USING btree (crop_id, price_date);


--
-- TOC entry 4842 (class 1259 OID 16599)
-- Name: idx_slots_center_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_slots_center_date ON public.procurement_slots USING btree (center_id, slot_date);


--
-- TOC entry 4843 (class 1259 OID 16600)
-- Name: idx_slots_crop_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_slots_crop_date ON public.procurement_slots USING btree (crop_id, slot_date);


--
-- TOC entry 4858 (class 1259 OID 16605)
-- Name: idx_status_history_submission; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_status_history_submission ON public.status_history USING btree (submission_id);


--
-- TOC entry 4857 (class 1259 OID 16604)
-- Name: idx_submissions_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_submissions_status ON public.crop_submissions USING btree (submission_status);


--
-- TOC entry 4851 (class 1259 OID 16608)
-- Name: idx_unique_farmer_slot; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_farmer_slot ON public.bookings USING btree (farmer_id, slot_id);


--
-- TOC entry 4852 (class 1259 OID 16609)
-- Name: idx_unique_slot_queue; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_unique_slot_queue ON public.bookings USING btree (slot_id, queue_position) WHERE (queue_position IS NOT NULL);


--
-- TOC entry 4870 (class 2606 OID 16504)
-- Name: bookings fk_booking_farmer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_booking_farmer FOREIGN KEY (farmer_id) REFERENCES public.farmer_profiles(farmer_id) ON DELETE RESTRICT;


--
-- TOC entry 4871 (class 2606 OID 16509)
-- Name: bookings fk_booking_slot; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_booking_slot FOREIGN KEY (slot_id) REFERENCES public.procurement_slots(slot_id) ON DELETE RESTRICT;


--
-- TOC entry 4867 (class 2606 OID 16421)
-- Name: farmer_profiles fk_farmer_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.farmer_profiles
    ADD CONSTRAINT fk_farmer_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4873 (class 2606 OID 16550)
-- Name: status_history fk_history_submission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT fk_history_submission FOREIGN KEY (submission_id) REFERENCES public.crop_submissions(submission_id) ON DELETE CASCADE;


--
-- TOC entry 4874 (class 2606 OID 16555)
-- Name: status_history fk_history_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_history
    ADD CONSTRAINT fk_history_user FOREIGN KEY (changed_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 4875 (class 2606 OID 16576)
-- Name: notifications fk_notification_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 4876 (class 2606 OID 16594)
-- Name: commodity_prices fk_price_crop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commodity_prices
    ADD CONSTRAINT fk_price_crop FOREIGN KEY (crop_id) REFERENCES public.crops(crop_id) ON DELETE RESTRICT;


--
-- TOC entry 4868 (class 2606 OID 16478)
-- Name: procurement_slots fk_slot_center; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurement_slots
    ADD CONSTRAINT fk_slot_center FOREIGN KEY (center_id) REFERENCES public.procurement_centers(center_id) ON DELETE CASCADE;


--
-- TOC entry 4869 (class 2606 OID 16483)
-- Name: procurement_slots fk_slot_crop; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.procurement_slots
    ADD CONSTRAINT fk_slot_crop FOREIGN KEY (crop_id) REFERENCES public.crops(crop_id) ON DELETE RESTRICT;


--
-- TOC entry 4872 (class 2606 OID 16532)
-- Name: crop_submissions fk_submission_booking; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crop_submissions
    ADD CONSTRAINT fk_submission_booking FOREIGN KEY (booking_id) REFERENCES public.bookings(booking_id) ON DELETE RESTRICT;


-- Completed on 2026-08-31 23:01:28

--
-- PostgreSQL database dump complete
--

\unrestrict Dm1JakwEZ68wCEpx4JXPKM0G7V1XwFcO5gin0cxG3Putc7PF3Mw7Sc26UgY4bbB


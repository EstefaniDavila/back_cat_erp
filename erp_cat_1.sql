--
-- PostgreSQL database dump
--

\restrict IwdKPH9YEAMZTNXVXrZ7eUNaQs55XWDXQuhsd4jX4axUESuLVWSKRsJHv8Gw9hg

-- Dumped from database version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.activity_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    action character varying,
    browser character varying,
    ip_address character varying,
    note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.activity_logs OWNER TO egusquiza31;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.admins (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    full_name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    document_number character varying DEFAULT ''::character varying NOT NULL,
    document_type character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.admins OWNER TO egusquiza31;

--
-- Name: advisors; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.advisors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    full_name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    document_number character varying DEFAULT ''::character varying NOT NULL,
    document_type character varying DEFAULT ''::character varying NOT NULL,
    code character varying NOT NULL,
    phone character varying,
    commission_rate numeric(5,2),
    status character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.advisors OWNER TO egusquiza31;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO egusquiza31;

--
-- Name: area_requests; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.area_requests (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    area character varying,
    name character varying,
    description text,
    status character varying,
    reviewed_at timestamp(6) without time zone,
    notes text,
    quotation_id uuid NOT NULL,
    created_by_id uuid NOT NULL,
    reviewed_by_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.area_requests OWNER TO egusquiza31;

--
-- Name: blacklisted_tokens; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.blacklisted_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token character varying,
    expire_at timestamp(6) without time zone,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.blacklisted_tokens OWNER TO egusquiza31;

--
-- Name: client_advisors; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.client_advisors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    role character varying,
    active boolean,
    assigned_at timestamp(6) without time zone,
    client_id uuid NOT NULL,
    advisor_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.client_advisors OWNER TO egusquiza31;

--
-- Name: client_contacts; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.client_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    "position" character varying,
    phone character varying,
    email character varying,
    is_primary boolean,
    client_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.client_contacts OWNER TO egusquiza31;

--
-- Name: clients; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.clients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    business_name character varying,
    document_type character varying,
    document_number character varying,
    contact_name character varying,
    phone character varying,
    email character varying,
    address text,
    city character varying,
    status character varying,
    client_category character varying,
    first_contact_date date,
    last_purchase_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.clients OWNER TO egusquiza31;

--
-- Name: customer_assets; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.customer_assets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    asset_type character varying,
    name character varying,
    brand character varying,
    asset_model character varying,
    serial_number character varying,
    year integer,
    description text,
    status character varying,
    client_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.customer_assets OWNER TO egusquiza31;

--
-- Name: delivery_guides; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.delivery_guides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    guide_number character varying,
    destination_address text,
    issued_at timestamp(6) without time zone,
    delivered_at timestamp(6) without time zone,
    status character varying,
    dispatch_order_id uuid NOT NULL,
    driver_id uuid NOT NULL,
    vehicle_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.delivery_guides OWNER TO egusquiza31;

--
-- Name: delivery_incidents; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.delivery_incidents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    incident_type character varying,
    description text,
    reported_by_id uuid NOT NULL,
    delivery_guide_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.delivery_incidents OWNER TO egusquiza31;

--
-- Name: dispatch_items; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.dispatch_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quantity integer,
    checked boolean,
    dispatch_order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.dispatch_items OWNER TO egusquiza31;

--
-- Name: dispatch_orders; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.dispatch_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    status character varying,
    dispatched_at timestamp(6) without time zone,
    delivered_at timestamp(6) without time zone,
    prepared_by_id uuid NOT NULL,
    sales_order_id uuid,
    rental_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.dispatch_orders OWNER TO egusquiza31;

--
-- Name: lead_comments; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.lead_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    message text,
    lead_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.lead_comments OWNER TO egusquiza31;

--
-- Name: lead_status_histories; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.lead_status_histories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    status character varying,
    changed_by_id uuid NOT NULL,
    lead_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.lead_status_histories OWNER TO egusquiza31;

--
-- Name: leads; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.leads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    name character varying,
    email character varying,
    phone character varying,
    source character varying,
    lead_type character varying,
    status character varying,
    priority character varying,
    notes text,
    assigned_to_id uuid NOT NULL,
    client_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.leads OWNER TO egusquiza31;

--
-- Name: logistics_users; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.logistics_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    full_name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    document_number character varying DEFAULT ''::character varying NOT NULL,
    document_type character varying DEFAULT ''::character varying NOT NULL,
    "position" character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.logistics_users OWNER TO egusquiza31;

--
-- Name: maintenance_reports; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.maintenance_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    summary text,
    details text,
    recommendations text,
    created_by_id uuid NOT NULL,
    maintenance_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.maintenance_reports OWNER TO egusquiza31;

--
-- Name: maintenances; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.maintenances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    description text,
    maintenance_type character varying,
    priority character varying,
    status character varying,
    requested_at timestamp(6) without time zone,
    scheduled_at timestamp(6) without time zone,
    completed_at timestamp(6) without time zone,
    client_id uuid NOT NULL,
    customer_asset_id uuid,
    enterprise_vehicle_id uuid,
    quotation_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.maintenances OWNER TO egusquiza31;

--
-- Name: managers; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.managers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    full_name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    document_number character varying DEFAULT ''::character varying NOT NULL,
    document_type character varying DEFAULT ''::character varying NOT NULL,
    area character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.managers OWNER TO egusquiza31;

--
-- Name: product_images; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.product_images (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    url character varying,
    product_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.product_images OWNER TO egusquiza31;

--
-- Name: products; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_type character varying,
    code character varying,
    name character varying,
    description text,
    base_price numeric(12,2),
    active boolean,
    created_by_id uuid NOT NULL,
    updated_by_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.products OWNER TO egusquiza31;

--
-- Name: purchase_order_items; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.purchase_order_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quantity integer,
    unit_cost numeric(12,2),
    total_cost numeric(12,2),
    received_quantity integer,
    purchase_order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.purchase_order_items OWNER TO egusquiza31;

--
-- Name: purchase_orders; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.purchase_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    status character varying,
    total numeric(12,2),
    expected_date date,
    received_at timestamp(6) without time zone,
    notes text,
    supplier_id uuid NOT NULL,
    requested_by_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.purchase_orders OWNER TO egusquiza31;

--
-- Name: quotation_comments; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.quotation_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    message text,
    quotation_id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.quotation_comments OWNER TO egusquiza31;

--
-- Name: quotation_files; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.quotation_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    file_url character varying,
    file_type character varying,
    quotation_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.quotation_files OWNER TO egusquiza31;

--
-- Name: quotation_items; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.quotation_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    description text,
    quantity integer,
    unit_price numeric(12,2),
    total_price numeric(12,2),
    item_type character varying,
    quotation_id uuid NOT NULL,
    product_id uuid,
    customer_asset_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.quotation_items OWNER TO egusquiza31;

--
-- Name: quotation_status_histories; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.quotation_status_histories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    status character varying,
    changed_by_id uuid NOT NULL,
    quotation_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.quotation_status_histories OWNER TO egusquiza31;

--
-- Name: quotations; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.quotations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    quotation_type character varying,
    status character varying,
    subtotal numeric(12,2),
    tax numeric(12,2),
    total numeric(12,2),
    valid_until date,
    sent_at timestamp(6) without time zone,
    approved_at timestamp(6) without time zone,
    rejected_at timestamp(6) without time zone,
    client_id uuid NOT NULL,
    advisor_id uuid NOT NULL,
    lead_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.quotations OWNER TO egusquiza31;

--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token character varying,
    user_id uuid NOT NULL,
    expire_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO egusquiza31;

--
-- Name: rentals; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.rentals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    start_date date,
    end_date date,
    status character varying,
    delivery_date timestamp(6) without time zone,
    return_date timestamp(6) without time zone,
    vehicle_condition_delivery text,
    vehicle_condition_return text,
    total numeric(12,2),
    notes text,
    quotation_id uuid NOT NULL,
    client_id uuid NOT NULL,
    vehicle_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.rentals OWNER TO egusquiza31;

--
-- Name: sales_orders; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.sales_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    status character varying,
    total numeric(12,2),
    notes text,
    quotation_id uuid NOT NULL,
    client_id uuid NOT NULL,
    advisor_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.sales_orders OWNER TO egusquiza31;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO egusquiza31;

--
-- Name: spare_part_categories; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.spare_part_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.spare_part_categories OWNER TO egusquiza31;

--
-- Name: spare_part_compatibilities; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.spare_part_compatibilities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    spare_part_id uuid NOT NULL,
    vehicle_model_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.spare_part_compatibilities OWNER TO egusquiza31;

--
-- Name: spare_part_specs; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.spare_part_specs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying,
    value character varying,
    unit character varying,
    spare_part_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.spare_part_specs OWNER TO egusquiza31;

--
-- Name: spare_parts; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.spare_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    part_number character varying,
    manufacturer_brand character varying,
    stock integer,
    min_stock integer,
    sale_unit character varying,
    is_critical boolean,
    product_id uuid NOT NULL,
    spare_part_category_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.spare_parts OWNER TO egusquiza31;

--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.stock_movements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    movement_type character varying,
    quantity integer,
    reference character varying,
    performed_by_id uuid NOT NULL,
    spare_part_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.stock_movements OWNER TO egusquiza31;

--
-- Name: supplier_products; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.supplier_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    supplier_code character varying,
    unit_cost numeric(12,2),
    lead_time_days integer,
    supplier_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.supplier_products OWNER TO egusquiza31;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.suppliers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    business_name character varying,
    document_type character varying,
    document_number character varying,
    contact_name character varying,
    phone character varying,
    email character varying,
    address text,
    city character varying,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.suppliers OWNER TO egusquiza31;

--
-- Name: technicians; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.technicians (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying DEFAULT ''::character varying NOT NULL,
    last_name character varying DEFAULT ''::character varying NOT NULL,
    full_name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    document_number character varying DEFAULT ''::character varying NOT NULL,
    document_type character varying DEFAULT ''::character varying NOT NULL,
    specialty character varying,
    certification text,
    status character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.technicians OWNER TO egusquiza31;

--
-- Name: user_tracks; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.user_tracks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    os_data character varying,
    remote_ip character varying,
    browser_data character varying,
    aud character varying,
    user_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.user_tracks OWNER TO egusquiza31;

--
-- Name: users; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    password_digest character varying DEFAULT ''::character varying NOT NULL,
    status integer,
    avatar character varying,
    phone character varying,
    document_number character varying DEFAULT ''::character varying NOT NULL,
    roleable_type character varying NOT NULL,
    roleable_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO egusquiza31;

--
-- Name: vehicle_model_specs; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.vehicle_model_specs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying,
    value character varying,
    unit character varying,
    vehicle_model_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.vehicle_model_specs OWNER TO egusquiza31;

--
-- Name: vehicle_models; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.vehicle_models (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    brand character varying,
    model character varying,
    power_hp numeric(8,2),
    weight_ton numeric(8,2),
    capacity_m3 numeric(8,2),
    active boolean,
    vehicle_type_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.vehicle_models OWNER TO egusquiza31;

--
-- Name: vehicle_types; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.vehicle_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.vehicle_types OWNER TO egusquiza31;

--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.vehicles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    vehicle_model_id uuid NOT NULL,
    serial character varying,
    manufacture_year integer,
    hours_used numeric(10,2),
    status character varying,
    price_per_hour numeric(12,2),
    price_per_day numeric(12,2),
    location character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.vehicles OWNER TO egusquiza31;

--
-- Name: versions; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    whodunnit character varying,
    created_at timestamp(6) without time zone,
    item_id bigint NOT NULL,
    item_type character varying NOT NULL,
    event character varying NOT NULL,
    object text,
    object_changes text
);


ALTER TABLE public.versions OWNER TO egusquiza31;

--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: egusquiza31
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.versions_id_seq OWNER TO egusquiza31;

--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: egusquiza31
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: warehousemen; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.warehousemen (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying,
    last_name character varying,
    full_name character varying,
    email character varying,
    document_number character varying,
    document_type character varying,
    "position" character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.warehousemen OWNER TO egusquiza31;

--
-- Name: work_order_actions; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.work_order_actions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action character varying,
    description text,
    evidence character varying,
    performed_by_id uuid NOT NULL,
    work_order_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.work_order_actions OWNER TO egusquiza31;

--
-- Name: work_order_parts; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.work_order_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    quantity integer,
    unit_price numeric(12,2),
    work_order_id uuid NOT NULL,
    product_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.work_order_parts OWNER TO egusquiza31;

--
-- Name: work_orders; Type: TABLE; Schema: public; Owner: egusquiza31
--

CREATE TABLE public.work_orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying,
    diagnosis text,
    diagnosis_result character varying,
    work_order_type character varying,
    status character varying,
    scheduled_date timestamp(6) without time zone,
    closed_date timestamp(6) without time zone,
    maintenance_id uuid NOT NULL,
    assigned_to_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.work_orders OWNER TO egusquiza31;

--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.activity_logs (id, user_id, action, browser, ip_address, note, created_at, updated_at) FROM stdin;
a7e6dd36-26eb-4741-b202-1e556738c9db	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	PostmanRuntime/7.51.1	127.0.0.1	\N	2026-05-08 23:57:10.983418	2026-05-08 23:57:10.983418
e431ec8c-db36-4533-95dc-1c33b201de2c	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	PostmanRuntime/7.51.1	127.0.0.1	\N	2026-05-08 23:59:37.48818	2026-05-08 23:59:37.48818
c6fd5924-066c-4285-9e9b-ddcbd90cc2c3	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 00:19:38.365729	2026-05-09 00:19:38.365729
88b4b582-0706-475c-85da-6531bf90481b	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 00:21:40.846527	2026-05-09 00:21:40.846527
ad38c665-ae2d-4a67-be03-08cb5c0e8835	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	PostmanRuntime/7.51.1	127.0.0.1	\N	2026-05-09 00:23:13.01823	2026-05-09 00:23:13.01823
e6361179-2bba-4028-a3ca-65b94766bd3d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 00:24:58.144475	2026-05-09 00:24:58.144475
1b9e4b16-1417-4ba6-a4a0-464aaabc898f	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	127.0.0.1	\N	2026-05-09 00:27:31.507522	2026-05-09 00:27:31.507522
0e18dd2f-9d47-4f45-b93d-088f0a221468	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	PostmanRuntime/7.51.1	127.0.0.1	\N	2026-05-09 01:30:28.246904	2026-05-09 01:30:28.246904
d787aa21-7967-41ea-bb62-616812cf4e5c	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 OPR/130.0.0.0	127.0.0.1	\N	2026-05-09 01:35:55.572433	2026-05-09 01:35:55.572433
30ab4a4b-a973-44e8-9890-15c4c6c53bf9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:13:14.961235	2026-05-09 02:13:14.961235
c82b6b3a-58a4-4b6e-8b81-6c8453ab8a37	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:14:51.759669	2026-05-09 02:14:51.759669
52c31af9-d8ce-47cd-a089-7db1fa92ae04	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:16:02.86978	2026-05-09 02:16:02.86978
7d8d32e0-6b19-4889-942e-80b4a6312040	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:16:10.190763	2026-05-09 02:16:10.190763
2dc8cfdb-2c70-443e-8299-22b490f6a57b	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	PostmanRuntime/7.51.1	127.0.0.1	\N	2026-05-09 02:17:23.991861	2026-05-09 02:17:23.991861
61afaaf5-9c5b-4309-8d3a-6ad637bae0fc	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:18:11.946699	2026-05-09 02:18:11.946699
e0562128-77c9-460b-a076-5c35723ca1a6	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:19:12.844902	2026-05-09 02:19:12.844902
371f0ea3-d1c1-4af6-bb3f-e3f3e8e81d43	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:19:23.589724	2026-05-09 02:19:23.589724
66187b8d-6051-4a43-b789-a01b3b3d186f	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:23:53.400216	2026-05-09 02:23:53.400216
a2095e5c-407d-4978-b3d8-1674ef7bbb1c	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:24:20.991721	2026-05-09 02:24:20.991721
acc3d711-102b-4b99-9c55-6874d00dcdea	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:26:15.694149	2026-05-09 02:26:15.694149
5833844b-e2ee-42b2-bf22-cb770a02b18e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:26:15.959543	2026-05-09 02:26:15.959543
db1f1b33-321b-41d1-be5f-a2c43a4c5221	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:27:13.788013	2026-05-09 02:27:13.788013
c54c1691-b058-4249-ad42-96ebc8aea153	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:28:04.744023	2026-05-09 02:28:04.744023
2acc1b26-edf8-4af5-80ac-5aab07685dcd	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:28:22.442086	2026-05-09 02:28:22.442086
0da250e5-6513-4550-8106-e812401322e5	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	127.0.0.1	\N	2026-05-09 02:34:05.241367	2026-05-09 02:34:05.241367
a0c19272-0af4-45f9-a7fc-0a5ba3266b3b	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-09 15:18:50.04299	2026-05-09 15:18:50.04299
5b95eb58-de51-4d1d-b4d2-61b347b80f15	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-09 15:18:55.836428	2026-05-09 15:18:55.836428
e957697d-40be-48f7-a4f3-fc769cf6c894	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-10 16:17:33.573168	2026-05-10 16:17:33.573168
dc3cceae-03e9-488c-8fb4-00be7c34f111	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-12 15:47:31.501544	2026-05-12 15:47:31.501544
780e11be-edea-4104-a1c8-bb99855f1da4	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-12 17:11:00.790082	2026-05-12 17:11:00.790082
7c27f321-2d6b-454c-a91e-14f1db87cc8e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-12 17:14:12.309205	2026-05-12 17:14:12.309205
f1d8537a-bc63-40c3-86b6-ca7e425df785	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-13 17:09:46.56724	2026-05-13 17:09:46.56724
20d48a42-1c4b-430a-8514-a2ff01adc72e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-13 17:10:01.364121	2026-05-13 17:10:01.364121
79029c34-c347-4ae7-a193-6984b2df1d50	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 15:49:13.581754	2026-05-14 15:49:13.581754
aa159333-6502-4827-958f-befafb109595	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 15:52:54.51009	2026-05-14 15:52:54.51009
610b4eb9-6bd5-4ee2-ad5e-4cff302bb7d1	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 15:58:36.579477	2026-05-14 15:58:36.579477
7193b79b-d9fa-468f-aff6-22ae23b6f4b8	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 15:59:05.977097	2026-05-14 15:59:05.977097
7f68179c-d2b3-423f-b195-8181b7ec8531	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:16:12.053482	2026-05-14 16:16:12.053482
ed1b855d-3abb-498e-a4c4-d192f836018d	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:18:37.585824	2026-05-14 16:18:37.585824
cc94932b-b059-4a2c-b899-edb4d2b5763b	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:19:01.15542	2026-05-14 16:19:01.15542
e081e299-1996-4567-b233-cf0187ac71bd	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:24:44.837968	2026-05-14 16:24:44.837968
791ab387-c238-4e73-850b-fcdcc69cf5ff	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:26:19.453216	2026-05-14 16:26:19.453216
e17f1a4c-d9cf-467f-b6a5-e7af5218bb7c	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:26:31.210565	2026-05-14 16:26:31.210565
90cd59b2-d1e2-4bc6-bc44-3b0ae7accfc0	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:28:18.677612	2026-05-14 16:28:18.677612
73acda88-82fd-4951-b51f-521f981d6601	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:28:28.549232	2026-05-14 16:28:28.549232
c2f2e745-1aff-4f86-8b05-7d3dee994751	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 16:38:14.780643	2026-05-14 16:38:14.780643
5234c942-a142-4795-9894-da8ea9c6347f	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 18:37:00.080304	2026-05-14 18:37:00.080304
254527d2-e514-4898-9576-a0638cb41170	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 18:37:10.036303	2026-05-14 18:37:10.036303
11ac4a30-ba29-418f-8d45-243dc6ccfaee	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:00:40.96165	2026-05-14 19:00:40.96165
9c36d24c-dde4-4463-a8f3-14b9e66131ad	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:00:48.119212	2026-05-14 19:00:48.119212
6c93ceea-e41a-4c29-89be-ccdafab4c2be	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:01:09.423079	2026-05-14 19:01:09.423079
2ba352cb-d1c4-488b-bf54-ff2fd44c3cd5	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:01:17.986117	2026-05-14 19:01:17.986117
c6206bc3-6ae6-4501-8a2a-258bf5bb1697	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:01:25.657877	2026-05-14 19:01:25.657877
2109d485-628e-4527-a519-b59a045c9fa8	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:01:34.585892	2026-05-14 19:01:34.585892
3ccc67cc-c2a1-401f-a04e-15d4532a3710	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:02:07.01869	2026-05-14 19:02:07.01869
598e6d7a-6d2f-4510-99bf-12285e1dc46c	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:03:17.634881	2026-05-14 19:03:17.634881
cf1d64fe-b875-42a9-a551-6674850676d8	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 19:21:17.147074	2026-05-14 19:21:17.147074
07d4ab63-02e5-4454-a060-2e7adf56e6bf	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 20:17:59.229628	2026-05-14 20:17:59.229628
1c654c74-fdfe-42c2-9745-c673dfb709ff	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-14 20:18:16.537186	2026-05-14 20:18:16.537186
3f5f281a-325c-4fd0-9131-75a5162c9ca8	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 01:07:32.76502	2026-05-15 01:07:32.76502
a7cc5841-8750-4041-a20b-bed4f4bd95f6	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 01:07:45.251692	2026-05-15 01:07:45.251692
ad33b4e1-08dc-4933-aae4-15c6159b253d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 01:08:23.887892	2026-05-15 01:08:23.887892
666ab97d-9be1-4ad4-b022-88b54d9655fd	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 15:07:29.342156	2026-05-15 15:07:29.342156
5c1a39d8-abd8-4529-8647-4a914a775ef0	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 15:07:58.184271	2026-05-15 15:07:58.184271
21301947-120a-4674-88ca-be9a3d0d89b1	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 15:08:45.961416	2026-05-15 15:08:45.961416
782a9670-8732-4a3d-ae9f-bdaf03e46529	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 15:08:56.64683	2026-05-15 15:08:56.64683
5c996a49-6069-42be-8eed-4ea646d6e7b9	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 15:28:36.442465	2026-05-15 15:28:36.442465
50d4dd77-9fcc-420a-9ca5-ad7960167c5f	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:31:03.570591	2026-05-15 16:31:03.570591
3125b2d9-e0db-4003-9b39-b7b949b164c7	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:31:18.942946	2026-05-15 16:31:18.942946
0adb09a6-647d-4fe3-8f43-73103a072205	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:31:28.795326	2026-05-15 16:31:28.795326
76f41853-d1b0-4dd5-93e6-a4127de3b35a	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:33:50.022064	2026-05-15 16:33:50.022064
ae7d6e06-2a39-4b09-bd59-368113a6ff6a	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:34:02.689506	2026-05-15 16:34:02.689506
3f63a444-317c-4628-b1ff-503b24db056a	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:34:17.630495	2026-05-15 16:34:17.630495
01259bcf-b45a-4d77-b4b2-49f7999676c2	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 16:35:06.373276	2026-05-15 16:35:06.373276
df948ccf-a2bc-40ea-b8e2-c1beab0e8e38	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 17:32:47.622021	2026-05-15 17:32:47.622021
699ef21a-d50b-45f8-97e9-a6d88d0d1955	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 17:33:00.470003	2026-05-15 17:33:00.470003
9259fac4-25a5-4af5-b353-fb0c90585252	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 17:33:54.406908	2026-05-15 17:33:54.406908
484cc821-5a90-474e-9d15-8e9ff859eb88	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 17:34:02.621964	2026-05-15 17:34:02.621964
c352626a-5b9f-43d2-abe3-223f8f8fa586	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:20:12.694085	2026-05-15 18:20:12.694085
0844d518-fc1c-4610-90b5-22bbba108de9	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:40:28.708935	2026-05-15 18:40:28.708935
096f6331-8eab-4aca-a709-5746d5a8cabb	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:40:41.857995	2026-05-15 18:40:41.857995
15cff2ee-928d-44f2-a4aa-c50c14dc7a2b	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:40:58.736766	2026-05-15 18:40:58.736766
2b6573f0-2bea-40c1-9972-6dd7a959fcb4	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:41:08.660069	2026-05-15 18:41:08.660069
2087d0a9-e0e0-440a-a9c2-a1ca175e72d3	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:43:04.318527	2026-05-15 18:43:04.318527
15246bb0-46b0-4472-8130-121d88e9c17c	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:43:12.372387	2026-05-15 18:43:12.372387
30930693-3cb3-425c-9e0b-3ccabddfb410	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:47:39.448562	2026-05-15 18:47:39.448562
efa3d490-d930-41d2-ad38-8886e1a90334	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 18:48:24.758836	2026-05-15 18:48:24.758836
dff17f9f-b12a-456a-a135-b6edad4d7399	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 19:39:30.14712	2026-05-15 19:39:30.14712
fb35cb85-e693-4e19-9348-c4b0a7149985	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 19:39:39.964215	2026-05-15 19:39:39.964215
f39d2366-f3b7-4737-b705-ca7144da67d0	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 19:47:32.979298	2026-05-15 19:47:32.979298
d261e353-aa3f-4136-8895-3f0ca7b31f94	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 20:00:07.604979	2026-05-15 20:00:07.604979
53d6962b-574d-4c31-ba12-1341f6ee8ac9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 20:08:15.699727	2026-05-15 20:08:15.699727
3aa6c501-841c-456c-b086-38dcde0e03ea	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 21:22:53.673912	2026-05-15 21:22:53.673912
c16129b7-813e-431b-a6e7-f22cdd229c7b	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 21:23:00.677587	2026-05-15 21:23:00.677587
d43e5256-8fa5-439c-82b9-f84e94e3b8e3	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 21:24:42.793031	2026-05-15 21:24:42.793031
cbd5a41c-13e9-4d41-80e1-5ee03f5d732e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 21:24:53.064061	2026-05-15 21:24:53.064061
57c8e082-4aaf-42c8-9b6c-f917c5ae22d3	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 21:49:10.9152	2026-05-15 21:49:10.9152
0c8f42d7-eff6-4635-b6dd-6064ef336667	47cd2452-fb03-4452-9509-4f4efba4f1a7	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-15 21:51:42.002693	2026-05-15 21:51:42.002693
7b87e3fd-4416-4c42-97dc-ba0a2ea84e67	47cd2452-fb03-4452-9509-4f4efba4f1a7	Cierre de sesión	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-16 01:44:32.713103	2026-05-16 01:44:32.713103
df4c811b-97c1-4977-9f96-bfd346669fe7	50572d23-a9dc-4b86-9a9c-14ed4a45910e	Inicio de sesión exitoso	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	127.0.0.1	\N	2026-05-16 01:44:40.394564	2026-05-16 01:44:40.394564
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.admins (id, first_name, last_name, full_name, email, document_number, document_type, created_at, updated_at) FROM stdin;
35cab582-2715-47ab-ab15-49308936e0af	Temp	User	Temp User	temp@test.com	99999999	DNI	2026-05-04 02:06:46.469151	2026-05-04 02:06:46.469151
51ba9316-2a45-46a6-b567-6fda5ff7ec6b	Juan	Perez	Juan Perez	juan@test.com	22222222	DNI	2026-05-05 21:14:07.472773	2026-05-05 21:14:07.472773
c356e23a-6cad-41d9-9798-fbd006ab066a	Juan	Perez	Juan Perez	juan2@test.com	33333333	DNI	2026-05-05 21:18:24.066918	2026-05-05 21:18:24.066918
\.


--
-- Data for Name: advisors; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.advisors (id, first_name, last_name, full_name, email, document_number, document_type, code, phone, commission_rate, status, created_at, updated_at) FROM stdin;
76b8c456-12fe-4bf1-bd68-b5a4261119c7	Carlos	Ruiz	Carlos Ruiz	carlos.ruiz@rentamax.com	12345678	DNI	ADV-001	999888777	5.00	active	2026-05-12 10:33:24.6434	2026-05-12 10:33:24.6434
bc7a199b-b81a-42f8-b689-6954ccea0b84	Patricia	López	Patricia López	patricia.lopez@rentamax.com	87654321	DNI	ADV-002	977788899	4.50	active	2026-05-12 10:34:18.639937	2026-05-12 10:34:18.639937
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2026-05-02 03:54:42.20969	2026-05-02 03:54:42.20969
schema_sha1	26d3894aa938e67d899780d18c25e224694fdea7	2026-05-03 21:44:36.201181	2026-05-03 21:44:36.201181
\.


--
-- Data for Name: area_requests; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.area_requests (id, area, name, description, status, reviewed_at, notes, quotation_id, created_by_id, reviewed_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: blacklisted_tokens; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.blacklisted_tokens (id, token, expire_at, user_id, created_at, updated_at) FROM stdin;
bdf7bbba-2bf1-4f44-bcd7-13124b6d528b	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MTAyNTE5LCJpYXQiOjE3NzgwMTYxMTksInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMjE6MTQ6MDcuNjcxWiIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTA1VDIxOjE0OjA3LjY3MVoifX0.hHm06Vf_k-PA4MQ1hbxnXBQ8Jl1DQ1XZD3wtMGNcAlE	2026-05-06 21:25:21.329858	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-05 21:25:21.336054	2026-05-05 21:25:21.336054
d31416e7-c011-4ca0-9dbc-33ae91020849	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MTAyNzM5LCJpYXQiOjE3NzgwMTYzMzksInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMjE6MTQ6MDcuNjcxWiIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTA1VDIxOjE0OjA3LjY3MVoifX0.8Pw32Zcp-7HSFwZV1cX_13VOK6JwKBN0wvBOfLmOPxE	2026-05-06 23:18:01.632766	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-05 23:18:01.646945	2026-05-05 23:18:01.646945
7586a9a9-0c4a-4e8d-98de-e92685e8c592	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MTA5NTQ1LCJpYXQiOjE3NzgwMjMxNDUsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMjE6MTQ6MDcuNjcxWiIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTA1VDIxOjE0OjA3LjY3MVoifX0.PkBgTcIpTA616u-GERnbo5idK5LG4exyr7RIA2_vBcA	2026-05-07 01:25:18.380003	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-06 01:25:18.48124	2026-05-06 01:25:18.48124
e075655a-c17d-4ecb-be29-d749f09a8c59	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MTE3MTMxLCJpYXQiOjE3NzgwMzA3MzEsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMjE6MTQ6MDcuNjcxWiIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTA1VDIxOjE0OjA3LjY3MVoifX0.pLrQcdMstL5kIxAR9PkE2yWcGYBCKD_q-FvkipGFFhQ	2026-05-08 01:09:24.239314	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-07 01:09:24.268824	2026-05-07 01:09:24.268824
79672e38-9699-4a9a-9f6f-1110c54ca9a1	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MjkyMTU5LCJpYXQiOjE3NzgyMDU3NTksInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMjE6MTQ6MDcuNjcxWiIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTA1VDIxOjE0OjA3LjY3MVoifX0.XPVkviVXFqpzbOySvomoF-yUac3_jV50qyhI35VP6Og	2026-05-09 02:02:49.23079	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-08 02:02:49.23873	2026-05-08 02:02:49.23873
e451413a-2e90-4e06-8588-8b31b33faf13	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MzcyMzc4LCJpYXQiOjE3NzgyODU5NzgsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.CYLV-jMazfvtYZm6o2jdLgFH3FNXoOrgB7qwWoP8bd8	2026-05-10 00:21:40.832071	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 00:21:40.838204	2026-05-09 00:21:40.838204
204fc836-3ba1-4628-a2c7-90224743890d	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MzcyNjk4LCJpYXQiOjE3NzgyODYyOTgsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.rtHLtYO4krDpU86BAgL5czBuA7VGTYyQ2LYdvl1VRuI	2026-05-10 02:13:14.948281	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:13:14.953572	2026-05-09 02:13:14.953572
0acf6f22-7156-4f6b-919f-a3055787565f	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Mzc5MjkxLCJpYXQiOjE3NzgyOTI4OTEsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.cuq5gjVaZlJY-C0CR7nsHOwXmuaoE_1nOUJn9BfTuh0	2026-05-10 02:16:02.859257	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:16:02.859653	2026-05-09 02:16:02.859653
e7fa6405-8846-4eeb-b8e6-01eb26541787	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Mzc5MzcwLCJpYXQiOjE3NzgyOTI5NzAsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.J7_rWaX0jlpYHEPVJde0ZMVyoTq5DR4AUDEbzo_oEOs	2026-05-10 02:18:11.938354	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:18:11.938684	2026-05-09 02:18:11.938684
0b2cf798-212f-4ce9-bd0c-016a5a2544ab	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Mzc5NTUyLCJpYXQiOjE3NzgyOTMxNTIsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.AvIgTXQm1oQx8njJIzykdwfkTn3zotBEU13Wcy_98lg	2026-05-10 02:19:23.580977	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:19:23.581386	2026-05-09 02:19:23.581386
425bc799-0a8d-484a-94da-c2506d0e8f7a	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Mzc5ODMzLCJpYXQiOjE3NzgyOTM0MzMsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.uw2IpYihQqm_bRGxXYpYcaX8f4x8isRhxGOGDJdRW_0	2026-05-10 02:24:20.981986	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:24:20.982438	2026-05-09 02:24:20.982438
73f62b5d-61e2-4bdf-875f-9583265c3d3f	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Mzc5OTc1LCJpYXQiOjE3NzgyOTM1NzUsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.hh6UNZXMquJLsKeNzi8CiM5tKR-3Ee8uW8mJTu7s-y8	2026-05-10 02:27:13.779293	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:27:13.779817	2026-05-09 02:27:13.779817
8fedbe41-c9f8-4781-a6fb-6a4128943ff5	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MzgwMDg0LCJpYXQiOjE3NzgyOTM2ODQsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.zV5DZpS6FbePEgL6knrO2vLsYNN7uLAkvjvoEHF_7NU	2026-05-10 02:28:22.433955	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 02:28:22.434347	2026-05-09 02:28:22.434347
bc39f312-77e9-45a0-af51-38f1ad5595a4	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4MzgwNDQ1LCJpYXQiOjE3NzgyOTQwNDUsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.l5ixsO1Ng6mEV_rINqtVlze4GdCZWy6ky_1oUbjSZlU	2026-05-10 15:18:49.997416	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 15:18:50.013347	2026-05-09 15:18:50.013347
5de12cce-7543-4b0a-a3d7-88e8643b9236	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Njg3MjUxLCJpYXQiOjE3Nzg2MDA4NTEsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.gUlHqlRwpB29Zfj6krPBwBWQCIZmnlsYXLaDmOJkY3E	2026-05-13 17:11:00.749144	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-12 17:11:00.760649	2026-05-12 17:11:00.760649
a1cbb4ea-01cb-4e5d-a6b3-67a40c50257e	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4NjkyNDUyLCJpYXQiOjE3Nzg2MDYwNTIsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.hADISbKG92PvYYUzc_wOiz-CEOhm5jFWY6NI3GiKw3E	2026-05-14 17:09:46.518226	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-13 17:09:46.538118	2026-05-13 17:09:46.538118
eeb007f8-553b-4caa-82fa-7b33c4a78463	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4Nzc4NjAxLCJpYXQiOjE3Nzg2OTIyMDEsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.TL1Q0aEhwF10CojSfnX-3_p0f7MEzRYhkJyqlGIEVtg	2026-05-15 15:49:13.548869	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 15:49:13.559281	2026-05-14 15:49:13.559281
b7b84efa-0477-43a2-b674-b27f88952153	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4ODYwMzc0LCJpYXQiOjE3Nzg3NzM5NzQsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.DkIlK0hQ9iLMaxWhXqBHJKgkcqU1OBVcP1U4aLybsio	2026-05-15 15:58:36.56344	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-14 15:58:36.570988	2026-05-14 15:58:36.570988
a6714171-ed88-49ab-943f-7389ec5105d0	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4ODYwNzQ1LCJpYXQiOjE3Nzg3NzQzNDUsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.igMxBl4-vTutsA9fOMRSq1cIwThEW14cto4IHLwf97M	2026-05-15 16:16:12.043292	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-14 16:16:12.044553	2026-05-14 16:16:12.044553
71c08cbb-0a31-4565-8ebe-c28f66953dcf	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODYxOTE3LCJpYXQiOjE3Nzg3NzU1MTcsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.D2yye7MCojix-pyIsczeMmWuAa3TnIc0qKUsgMVmfd0	2026-05-15 16:26:19.444711	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-14 16:26:19.446075	2026-05-14 16:26:19.446075
d1259c13-5f98-4190-ac09-0d59a219947c	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODYyMzkxLCJpYXQiOjE3Nzg3NzU5OTEsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ._PCWJHY16_AEa8VkAQa9s670anhz3FwmqioLv8dTahs	2026-05-15 16:28:18.667937	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-14 16:28:18.668609	2026-05-14 16:28:18.668609
ada8637d-d452-480d-8907-0070c5c0cc05	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODYyNTA4LCJpYXQiOjE3Nzg3NzYxMDgsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.I-7sDOSHXutHh20vif2fxhVOsaUJVNXmrGAr3xmuY0k	2026-05-15 18:37:00.052884	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-14 18:37:00.058535	2026-05-14 18:37:00.058535
78734bbe-bb6c-4fe4-adaf-009a4d620ba7	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODcwMjMwLCJpYXQiOjE3Nzg3ODM4MzAsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.27iIjY2PY_0-0KOMCPtZOLLjYYWrL5crfziGaAIdMfg	2026-05-15 19:00:40.933944	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-14 19:00:40.944486	2026-05-14 19:00:40.944486
ef0651cb-c619-46bf-8047-d10a89471576	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4ODcxNjQ4LCJpYXQiOjE3Nzg3ODUyNDgsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.donyfK-Jhug3hdx_v-ihEC3TeHRGmMSm8akctcPj60s	2026-05-15 19:01:09.41283	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 19:01:09.413294	2026-05-14 19:01:09.413294
252acbd2-4eb4-4e48-b4a9-8dab87cb3a30	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODcxNjc3LCJpYXQiOjE3Nzg3ODUyNzcsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.ekHWNqF4_aZFO9siQvFLjF9Zz9g4pY1Ny99A0PMMwQE	2026-05-15 19:01:25.648214	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-14 19:01:25.648715	2026-05-14 19:01:25.648715
9df1532b-cd6d-4b93-9af7-43f05f8fc0fd	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4ODcxNjk0LCJpYXQiOjE3Nzg3ODUyOTQsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.gbpyTNiaidfvGiunOQmRrexg0nf7rc-ZSY-gWe40r7c	2026-05-15 19:02:07.010829	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-14 19:02:07.01134	2026-05-14 19:02:07.01134
3151b5da-5523-4f02-a4d8-4d7723b8c007	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODcxNzk3LCJpYXQiOjE3Nzg3ODUzOTcsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.YODeUnVSUToe_rIkBlDdEO6N8OIepajuQ1m5vOwM0Lw	2026-05-15 20:17:59.206275	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-14 20:17:59.213302	2026-05-14 20:17:59.213302
87bdb857-5e1c-40ea-b934-1b590ad48055	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4ODkzNjUyLCJpYXQiOjE3Nzg4MDcyNTIsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.emRiOUY6DuRRT6IEiV4puWw-zpFZcSCz4ZGwZMJRYS8	2026-05-16 01:07:45.236545	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 01:07:45.242609	2026-05-15 01:07:45.242609
65ce6393-7487-404d-a003-9817bb8c6fc0	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4ODkzNzAzLCJpYXQiOjE3Nzg4MDczMDMsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.A0jV9dqgLzmLal4hQe4y6nklIHuHkrMxyH8CmEkmhww	2026-05-16 15:07:29.313649	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 15:07:29.321034	2026-05-15 15:07:29.321034
93daa403-1c03-49b2-921a-5b2deddc25c8	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTQ0MDc4LCJpYXQiOjE3Nzg4NTc2NzgsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ._ozPgwcChHhRyZsZtvLRJINaVgqX6LkRYUOTuTI1CO4	2026-05-16 15:08:45.952155	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 15:08:45.952705	2026-05-15 15:08:45.952705
10a36284-3e64-41c0-8078-846c7ed63e75	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4OTQ5MDYzLCJpYXQiOjE3Nzg4NjI2NjMsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.p1BZSfQjGQWOI5VpKMIQLPzy5k6k3lespKOCHWVHU8M	2026-05-16 16:31:18.927926	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 16:31:18.935615	2026-05-15 16:31:18.935615
cf0ce23d-39a8-4e48-ba5a-84ea4aae02fd	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTQ5MDg4LCJpYXQiOjE3Nzg4NjI2ODgsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.FzlRu_x6P6JbfJELqx4WStDmKccK5Ha287CR4V6DpYI	2026-05-16 16:33:50.013368	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 16:33:50.014071	2026-05-15 16:33:50.014071
a13c31af-ee78-435a-a9a8-2dc1838a0f33	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4OTQ5MjQyLCJpYXQiOjE3Nzg4NjI4NDIsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.t08nV-oj-_ML7jq9L6puzRZgTtCfh0wY8yOyBLDT9VM	2026-05-16 16:34:17.621222	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-15 16:34:17.621706	2026-05-15 16:34:17.621706
6d29149d-75ba-435c-95eb-b2bae011be0d	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTQ5MzA2LCJpYXQiOjE3Nzg4NjI5MDYsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.RAhn6krA5aGaBAaCjmptTUDQiqTB-poCTduhhDimAQs	2026-05-16 17:32:47.571741	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 17:32:47.590109	2026-05-15 17:32:47.590109
1e6e57a9-d722-44bd-8a05-c65ea7abc90e	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4OTUyNzgwLCJpYXQiOjE3Nzg4NjYzODAsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.JYUEYAxZDcjgF_vMkti3b9JLnI-IsSRISXeRWA46I3o	2026-05-16 17:33:54.388677	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-15 17:33:54.389666	2026-05-15 17:33:54.389666
1618ece6-9e7a-4ee4-ac14-203c462bc72a	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTU1NjEyLCJpYXQiOjE3Nzg4NjkyMTIsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.dbgyT3g6FzFfjDfbFk4JuhukLCrTKBbIMohkLaKokb4	2026-05-16 18:40:28.689964	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 18:40:28.701379	2026-05-15 18:40:28.701379
b668e7fa-9f1e-4a58-b826-1aa1a658ba9a	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTU2ODQxLCJpYXQiOjE3Nzg4NzA0NDEsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ._QGQxP_qgtsgvrozg3BJhCZTlMe3YuwZ4hjtscE4o3I	2026-05-16 18:40:58.730025	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 18:40:58.730498	2026-05-15 18:40:58.730498
038f148e-8bb5-4a28-af8e-d9fae3bcc8d6	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4OTU2ODY4LCJpYXQiOjE3Nzg4NzA0NjgsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.CkXc6PujggUogD-cQweLDggJ6f59Q_I-TZDAHHTGm0E	2026-05-16 18:43:04.308591	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-15 18:43:04.310556	2026-05-15 18:43:04.310556
cd669408-c010-4d96-bb77-12dfc713fab5	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTU2OTkyLCJpYXQiOjE3Nzg4NzA1OTIsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.bl5Cur6GtDTUPs2iPJC9DXK7MIUc5WZIgBlclzJ-ttU	2026-05-16 18:47:39.438587	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 18:47:39.439801	2026-05-15 18:47:39.439801
25e3b1d6-cf93-4c3b-8e7c-a9e6c577742b	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4OTU3MzA0LCJpYXQiOjE3Nzg4NzA5MDQsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.73DQGYOpcVd8H-p1PNMldxsJrVKkSpN3MUaIudGPt78	2026-05-16 19:39:30.137777	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-15 19:39:30.138821	2026-05-15 19:39:30.138821
a9fa98d2-1ccb-411c-b56e-e459d1152cc4	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTA1NzJkMjMtYTlkYy00Yjg2LTlhOWMtMTRlZDRhNDU5MTBlIiwiZXhwIjoxNzc4OTYyMDk1LCJpYXQiOjE3Nzg4NzU2OTUsInVzZXIiOnsiaWQiOiI1MDU3MmQyMy1hOWRjLTRiODYtOWE5Yy0xNGVkNGE0NTkxMGUiLCJlbWFpbCI6Imp1YW5AdGVzdC5jb20iLCJwYXNzd29yZF9kaWdlc3QiOiIkMmEkMTIkdlJMMngyTUs2REpveXgweVNqYjFjLi5RRFVHRm5sN0R1ZU9KV0xRWUMuR2RvNGVvWE5HTnEiLCJzdGF0dXMiOiJhY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIyMjIyMjIyMiIsInJvbGVhYmxlX3R5cGUiOiJBZG1pbiIsInJvbGVhYmxlX2lkIjoiNTFiYTkzMTYtMmE0NS00NmE2LWI1NjctNmZkYTVmZjdlYzZiIiwiY3JlYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIiwidXBkYXRlZF9hdCI6IjIwMjYtMDUtMDVUMTY6MTQ6MDcuNjcxLTA1OjAwIn19.uXsf73GZEBkXrhLxGJKJ8-xX_FLJg81jrnfUoo_9NZc	2026-05-16 21:22:53.648035	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 21:22:53.655455	2026-05-15 21:22:53.655455
807cf21c-1550-4f0f-befe-62a9005eccc7	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMGNiZWQ0YmItMDhkNy00OGFjLTk4NDctY2E3ZmQ1ZDAwZTI5IiwiZXhwIjoxNzc4OTY2NTgwLCJpYXQiOjE3Nzg4ODAxODAsInVzZXIiOnsiaWQiOiIwY2JlZDRiYi0wOGQ3LTQ4YWMtOTg0Ny1jYTdmZDVkMDBlMjkiLCJlbWFpbCI6ImNhcmxvcy5nYXJjaWFAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJDZCMy54Z0hDRkFVdDc5eXFjWE41NmVZRG13bkpzQWtTTUNFdXh0Tk8vd0tBc1RodWJZcHRDIiwic3RhdHVzIjoiaW5hY3RpdmUiLCJhdmF0YXIiOm51bGwsInBob25lIjpudWxsLCJkb2N1bWVudF9udW1iZXIiOiIxMTIyMzM0NCIsInJvbGVhYmxlX3R5cGUiOiJXYXJlaG91c2VtYW4iLCJyb2xlYWJsZV9pZCI6IjE1YjVjY2RmLWUyNTUtNGY2NC04MWJjLTBhMjBlNTRlNGQ5ZiIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDExOjE1OjA2LjQxMy0wNTowMCJ9fQ.LIcPRb_cz4axFhVtwLSXaSPEMnOGVJMbf92x4gljJvc	2026-05-16 21:24:42.782835	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-15 21:24:42.783304	2026-05-15 21:24:42.783304
6c74558c-db5a-494d-8d49-ab185630e885	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4OTYxNjA3LCJpYXQiOjE3Nzg4NzUyMDcsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.LlrrUAyQAVRsFloAmLkj5CRrhpySDpDdNfWBm29a_yk	2026-05-16 21:49:10.90636	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-15 21:49:10.907049	2026-05-15 21:49:10.907049
746694e9-f7ca-4c36-ba7d-d91edce31960	eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNDdjZDI0NTItZmIwMy00NDUyLTk1MDktNGY0ZWZiYTRmMWE3IiwiZXhwIjoxNzc4OTY4MzAyLCJpYXQiOjE3Nzg4ODE5MDIsInVzZXIiOnsiaWQiOiI0N2NkMjQ1Mi1mYjAzLTQ0NTItOTUwOS00ZjRlZmJhNGYxYTciLCJlbWFpbCI6Im1pZ3VlbC5yb2RyaWd1ZXpAcmVudGFtYXguY29tIiwicGFzc3dvcmRfZGlnZXN0IjoiJDJhJDEyJFc1NWh5OE9QbWNtaVg2dUhUQlEwSS5RMTVscFlIZTNnam5wTDg2SXhBY1BMYURXMGdJZG1hIiwic3RhdHVzIjoiYWN0aXZlIiwiYXZhdGFyIjpudWxsLCJwaG9uZSI6Ijk1NTU2NjY3NyIsImRvY3VtZW50X251bWJlciI6Ijk5ODg3NzY2Iiwicm9sZWFibGVfdHlwZSI6IkxvZ2lzdGljc1VzZXIiLCJyb2xlYWJsZV9pZCI6ImRiODlmMmU4LTU3ZmQtNDI4ZC1iZWIwLTQwZTAwNjVjNjJkYyIsImNyZWF0ZWRfYXQiOiIyMDI2LTA1LTEyVDA3OjEwOjU1LjY1NS0wNTowMCIsInVwZGF0ZWRfYXQiOiIyMDI2LTA1LTE0VDEwOjM5OjM0LjQ4Ni0wNTowMCJ9fQ.CsccKMGnrdzblElLg-rnC_cs6u8m2mCy5L5DmZu7xzQ	2026-05-17 01:44:32.588128	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-16 01:44:32.618277	2026-05-16 01:44:32.618277
\.


--
-- Data for Name: client_advisors; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.client_advisors (id, role, active, assigned_at, client_id, advisor_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: client_contacts; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.client_contacts (id, name, "position", phone, email, is_primary, client_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.clients (id, code, business_name, document_type, document_number, contact_name, phone, email, address, city, status, client_category, first_contact_date, last_purchase_date, created_at, updated_at) FROM stdin;
dfaefd47-25c2-498a-bb2a-1f838010043a	CLI-001	Constructora Los Andes SAC	RUC	20601234567	Roberto Sánchez	987654321	rsanchez@constructoralosandes.com	Av. Industrial 450	Lima	active	premium	2024-01-15	\N	2026-05-12 10:33:24.6434	2026-05-12 10:33:24.6434
a34bcdbe-f660-41f2-a2c3-18330eb882b7	CLI-002	Minera Southern Perl SAC	RUC	20789123456	Jorge Mamani	976543210	jmamani@minerasouthern.com	Carretera Central Km 42	La Oroya	active	premium	2024-02-20	\N	2026-05-12 10:34:18.639937	2026-05-12 10:34:18.639937
143c8e5e-f230-4378-a5f5-ba8744efbd28	CLI-003	Minera Los Andes S.A.	RUC	20678901234	Juan Pérez	976543210	juan@mineralosandes.com	Carretera Central Km 45	Junín	active	premium	2024-02-20	\N	2026-05-13 00:47:23.801849	2026-05-13 00:47:23.801849
\.


--
-- Data for Name: customer_assets; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.customer_assets (id, asset_type, name, brand, asset_model, serial_number, year, description, status, client_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: delivery_guides; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.delivery_guides (id, guide_number, destination_address, issued_at, delivered_at, status, dispatch_order_id, driver_id, vehicle_id, created_at, updated_at) FROM stdin;
f9974cd1-ea9a-45f5-b357-debe36b8741c	GUI-20260513-97562360	TEST	\N	\N	pending	b24d6d04-c372-470f-b33a-7555f7b625ed	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 02:25:37.068384	2026-05-14 02:25:37.068384
fc6f5577-8710-46bd-b548-aac815651d16	GUI-20260513-831B4DA0	ss	\N	\N	pending	b24d6d04-c372-470f-b33a-7555f7b625ed	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 02:26:48.027178	2026-05-14 02:26:48.027178
279dffd4-7cad-4609-ba30-2decf9b6e6ec	GUI-20260513-A5B42FD1	eeeee	\N	\N	pending	b24d6d04-c372-470f-b33a-7555f7b625ed	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 02:27:58.745859	2026-05-14 02:27:58.745859
6011c530-3203-4bb5-a04c-0b3547355a85	GUI-20260513-1FD82814	ddddd	\N	\N	pending	b24d6d04-c372-470f-b33a-7555f7b625ed	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 02:37:50.108893	2026-05-14 02:37:50.108893
be9e06ed-373d-4f80-9238-0db04a72e14d	GUI-20260513-CE6B6DC0	TEST	\N	\N	pending	3295e881-7be1-4a37-b9c3-db6ca128c833	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 02:50:17.216174	2026-05-14 02:50:17.216174
5d5330b3-9499-4722-b54c-0cc896b128d7	GUI-20260513-66898CFA	test	\N	\N	pending	d486e059-1c17-480f-9d2e-fd9e03352e10	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 02:56:06.814037	2026-05-14 02:56:06.814037
6c5cf2ae-e8f7-47d2-a6eb-abe673ade71f	GUI-20260513-9F61BA95	av test	\N	\N	pending	34902783-727a-4f2f-922f-cf3416ed7b11	db89f2e8-57fd-428d-beb0-40e0065c62dc	f3395eed-3e03-490e-8eca-0e1063f72026	2026-05-14 03:09:21.805788	2026-05-14 03:09:21.805788
\.


--
-- Data for Name: delivery_incidents; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.delivery_incidents (id, incident_type, description, reported_by_id, delivery_guide_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dispatch_items; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.dispatch_items (id, quantity, checked, dispatch_order_id, product_id, created_at, updated_at) FROM stdin;
415092a9-ae91-4719-9f55-91b86dcacda5	1	t	872d0ed2-135f-46f4-b37b-2b414f795102	b19a7579-77fb-47d7-9293-302304aa8a36	2026-05-15 20:26:53.265938	2026-05-15 20:26:55.009534
f38d6be2-c544-411b-9d92-dd1a2bf356c2	1	t	3bc57387-3174-4dd9-bab4-efcd0271b002	dda8bcda-aff4-413b-8a43-c615850074f8	2026-05-13 04:02:47.294841	2026-05-13 04:02:47.294841
b541c3a3-2684-4862-8226-cc5d61b56c81	1	t	efa0838e-e273-4fcd-8a55-a7a97884d8bb	b19a7579-77fb-47d7-9293-302304aa8a36	2026-05-13 04:54:21.669827	2026-05-13 04:54:21.669827
05f329a4-07d3-4ff3-ae8a-ed4c34f58c0d	1	t	dd8c4293-82aa-40e0-9829-458de6102cd9	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-13 05:17:42.017854	2026-05-13 05:17:42.017854
cb5187f4-6c69-43f2-9f98-942f3109f658	10	t	d5876e54-d78f-46e6-a697-91111f9aeab0	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-13 05:22:59.812182	2026-05-13 05:22:59.812182
6519a9cb-89da-43cb-8529-e4fcfad8984b	10	t	f24b9df8-5851-46f8-a6b8-cd28dc52d8f2	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-13 05:53:33.239192	2026-05-13 05:53:33.239192
6b8422f3-b142-4ded-a2f7-3271b88b4be2	10	t	8cc9681f-8cb6-47d4-8c7c-de6e63eaa03e	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-13 06:04:29.761891	2026-05-13 06:04:29.761891
eae31b60-49e5-4862-9a81-061ab500bee4	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 01:00:11.859312	2026-05-14 01:02:36.340373
ddb4bf33-d539-4833-8734-142d9e60d622	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	8ae62307-c089-4509-8d80-13259a73339d	2026-05-14 01:02:05.983541	2026-05-14 01:02:36.68449
a5828c2a-e473-4273-8e35-1749b936859f	1	f	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 01:20:08.710932	2026-05-14 01:20:08.710932
bdfffbdd-7498-4ed1-b41f-ebb61d34197b	1	f	b24d6d04-c372-470f-b33a-7555f7b625ed	dda8bcda-aff4-413b-8a43-c615850074f8	2026-05-14 01:20:46.421739	2026-05-14 01:20:46.421739
f3da872e-49b5-4688-bc10-68a2c58ff601	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	b19a7579-77fb-47d7-9293-302304aa8a36	2026-05-14 01:21:21.737293	2026-05-14 01:21:22.364983
aee4b771-cca5-4dc7-91f5-40892482b158	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-14 01:21:28.708634	2026-05-14 01:21:32.113565
d8431fc0-f951-4d02-b938-dac9d6c250ea	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	dda8bcda-aff4-413b-8a43-c615850074f8	2026-05-14 01:32:38.327826	2026-05-14 01:32:39.550889
e4be530b-0aea-4ed8-9c5d-d0b792b2e15e	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	b19a7579-77fb-47d7-9293-302304aa8a36	2026-05-14 01:32:42.425071	2026-05-14 01:32:42.925098
d71a2502-6415-46d8-95ad-d4a2aa6e5ba1	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	fcf98163-de97-4377-96f6-1789c5fbd87a	2026-05-14 01:52:16.119628	2026-05-14 01:52:16.878728
3a715c48-e795-4254-bd13-b5fc775ffeeb	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	3d9de8c5-f204-49b7-a09f-55e7f8dd483f	2026-05-14 02:08:42.449291	2026-05-14 02:08:43.15249
bedc77b4-861a-44f2-a20d-bbbad5e295da	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:09:11.965124	2026-05-14 02:09:12.95573
2e67e24d-d5ac-484e-8b35-869992f1c43d	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:09:30.537047	2026-05-14 02:09:31.835296
2957ebfd-7140-45a7-9bfe-5bb630a8e3b1	1	f	b24d6d04-c372-470f-b33a-7555f7b625ed	fcf98163-de97-4377-96f6-1789c5fbd87a	2026-05-14 02:10:07.42457	2026-05-14 02:10:07.42457
82b9ea25-1686-4dff-a877-8c06b560d748	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:10:55.691466	2026-05-14 02:10:56.312292
34f73924-1f3b-4955-a090-8d350ef5562d	10	f	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:15:51.098714	2026-05-14 02:15:51.098714
c5daf609-d022-421a-8607-d203246ee891	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	fcf98163-de97-4377-96f6-1789c5fbd87a	2026-05-14 02:16:10.872293	2026-05-14 02:16:11.78037
f91d4965-0d1c-463f-b709-1a788ce163c4	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:16:24.329195	2026-05-14 02:16:25.183213
1fc8b9eb-2ac1-4a63-92c1-1c321bffda9e	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:16:33.565319	2026-05-14 02:16:34.289679
9700a077-f2b3-4ed6-940f-e13c9b7d1d62	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:16:52.893597	2026-05-14 02:16:53.581605
72b178e7-4f7e-4543-8c02-bac3237ba58b	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-14 02:20:14.878578	2026-05-14 02:20:15.616263
736f725f-f59b-4417-94de-e2336e46a318	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:21:21.521559	2026-05-14 02:21:22.277096
7c7ae889-a977-4248-9ab4-8d79aa01fc79	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:25:26.665982	2026-05-14 02:25:28.924642
1cfffd05-5783-4073-b689-63cef262c77c	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:27:44.976405	2026-05-14 02:27:46.153214
9edb7d66-dd6e-4c35-a0c9-2e04f1d700bc	1	t	b24d6d04-c372-470f-b33a-7555f7b625ed	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-14 02:37:43.817218	2026-05-14 02:37:44.518284
a6b77544-5350-4045-8c3d-abd228173765	1	t	3295e881-7be1-4a37-b9c3-db6ca128c833	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-14 02:50:05.436599	2026-05-14 02:50:06.318734
a4b3943d-82f6-4de6-a41f-42a919a80e2f	1	t	d486e059-1c17-480f-9d2e-fd9e03352e10	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-14 02:55:46.169895	2026-05-14 02:56:01.316575
37424b46-35c3-4e49-8dc5-06298bda97a1	10	t	d486e059-1c17-480f-9d2e-fd9e03352e10	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-14 02:56:00.605916	2026-05-14 02:56:01.693516
2d8208fb-a2a1-4456-b4f2-d794a993eafe	1	t	34902783-727a-4f2f-922f-cf3416ed7b11	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-14 03:09:07.819711	2026-05-14 03:09:10.323465
6975aadd-6915-4301-9889-c53b64aba727	1	f	872d0ed2-135f-46f4-b37b-2b414f795102	fcf98163-de97-4377-96f6-1789c5fbd87a	2026-05-15 01:21:34.826316	2026-05-15 01:21:34.826316
\.


--
-- Data for Name: dispatch_orders; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.dispatch_orders (id, code, status, dispatched_at, delivered_at, prepared_by_id, sales_order_id, rental_id, created_at, updated_at) FROM stdin;
3bc57387-3174-4dd9-bab4-efcd0271b002	DISP-20260512-AA614637	delivered	2026-05-13 04:11:12.553477	2026-05-13 04:40:42.129888	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-13 03:58:09.790721	2026-05-13 04:40:42.147835
efa0838e-e273-4fcd-8a55-a7a97884d8bb	DISP-20260512-43AB1DF8	delivered	\N	2026-05-13 04:54:52.399725	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	\N	3d9cdb28-aade-48cf-9043-24492c23f57b	2026-05-13 04:52:06.558285	2026-05-13 04:54:52.404891
dd8c4293-82aa-40e0-9829-458de6102cd9	DISP-CUSTOM-001	delivered	\N	2026-05-13 05:17:58.783652	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-13 03:57:46.270638	2026-05-13 05:17:58.791607
d5876e54-d78f-46e6-a697-91111f9aeab0	DISP-20260513-E21447B2	delivered	\N	2026-05-13 05:37:04.208278	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	\N	15e9e7bc-bee3-4fae-ae77-2b1a4df3085b	2026-05-13 05:21:04.192929	2026-05-13 05:37:04.22139
f24b9df8-5851-46f8-a6b8-cd28dc52d8f2	DISP-20260512-BEB0E57A	delivered	\N	2026-05-13 05:53:53.615043	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-12 16:06:05.843829	2026-05-13 05:53:53.621911
8cc9681f-8cb6-47d4-8c7c-de6e63eaa03e	DISP-20260513-A326EC0C	delivered	\N	2026-05-13 06:05:19.340722	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-13 06:03:46.274603	2026-05-13 06:05:19.34837
b24d6d04-c372-470f-b33a-7555f7b625ed	DISP-20260513-228C8335	dispatched	2026-05-14 02:37:50.128924	\N	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-13 06:02:41.43511	2026-05-14 02:37:50.13746
3295e881-7be1-4a37-b9c3-db6ca128c833	DISP-20260513-16AA22A6	delivered	2026-05-14 02:50:17.238102	2026-05-14 02:52:12.415391	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-14 02:47:15.186237	2026-05-14 02:52:12.422001
d486e059-1c17-480f-9d2e-fd9e03352e10	DISP-20260513-8CBB2282	delivered	2026-05-14 02:56:06.831519	2026-05-14 02:56:55.842833	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-14 02:51:44.069827	2026-05-14 02:56:55.848457
34902783-727a-4f2f-922f-cf3416ed7b11	DISP-20260513-72A836BF	dispatched	2026-05-14 03:09:22.766116	\N	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-14 03:08:22.8774	2026-05-14 03:09:22.776438
872d0ed2-135f-46f4-b37b-2b414f795102	DISP-20260514-6C4F5566	pending	\N	\N	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	afcffb7b-198e-49ee-befe-9d0c13c9890b	\N	2026-05-15 01:21:20.870787	2026-05-15 01:21:20.870787
\.


--
-- Data for Name: lead_comments; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.lead_comments (id, message, lead_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: lead_status_histories; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.lead_status_histories (id, status, changed_by_id, lead_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.leads (id, code, name, email, phone, source, lead_type, status, priority, notes, assigned_to_id, client_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: logistics_users; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.logistics_users (id, first_name, last_name, full_name, email, document_number, document_type, "position", created_at, updated_at) FROM stdin;
db89f2e8-57fd-428d-beb0-40e0065c62dc	Miguel	Rodríguez	Miguel Rodríguez	miguel.rodriguez@rentamax.com	99887766	DNI	Coordinador de Logística	2026-05-12 12:10:55.65538	2026-05-12 12:10:55.65538
66004442-aa5c-4514-8260-38588dc9952c	Juan	Pérez	Juan Pérez	juan.perez@logistica.com	999888777	DNI	Coordinador de Logística	2026-05-14 15:35:34.552747	2026-05-14 15:35:34.552747
\.


--
-- Data for Name: maintenance_reports; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.maintenance_reports (id, summary, details, recommendations, created_by_id, maintenance_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: maintenances; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.maintenances (id, code, description, maintenance_type, priority, status, requested_at, scheduled_at, completed_at, client_id, customer_asset_id, enterprise_vehicle_id, quotation_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: managers; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.managers (id, first_name, last_name, full_name, email, document_number, document_type, area, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.product_images (id, url, product_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.products (id, product_type, code, name, description, base_price, active, created_by_id, updated_by_id, created_at, updated_at) FROM stdin;
fcf98163-de97-4377-96f6-1789c5fbd87a	vehicle	VEH-D51F3B9A	Hilux	Hilux	2500.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 01:40:04.748893	2026-05-14 01:40:04.748893
866436ac-d79b-4dfb-960d-6480b89e40a2	vehicle	VEH-6016E1F3	hiluz	hiluz	250.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 01:51:28.292279	2026-05-14 01:51:28.292279
88c77073-7c47-48d6-9456-109de8d521c9	spare_part	DASDADASDAS	Repuesto TEST	REPUESTO TEST	250.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 20:33:52.119354	2026-05-14 02:49:49.201363
00d34907-a489-4f6b-b501-a2f13a0f4104	vehicle	TEST-2020	Test vehiculo-stock	Test vehiculo-stock	15000.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 17:40:17.031445	2026-05-14 02:55:06.185465
4a29c117-408f-4fb4-8cd3-9b8bab13bbdc	vehicle	VH-2024-001	Excavadora CAT 320	Unidad 2021 en buen estado	850.00	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-07 18:16:52.678408	2026-05-07 18:16:52.678408
b500c835-8580-4842-9b3e-96387e5f3014	vehicle	VH-2024-002	Excavadora CAT 320	Unidad 2022 recién revisada	850.00	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-07 18:21:48.896336	2026-05-07 18:21:48.896336
a11d4838-86f2-4e42-9c51-c6c04368bd14	vehicle	VH-2026-003	Excavadora Komatsu PC210	Unidad 2020	950.00	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-07 18:31:17.942717	2026-05-07 18:31:17.942717
18e2b3f3-4f73-4fc4-a05b-d82f8a6b9971	vehicle	VH-2026-004	Cargador Frontal CAT 950M	Unidad 2023	1200.00	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-07 18:36:52.868554	2026-05-07 18:36:52.868554
3d9de8c5-f204-49b7-a09f-55e7f8dd483f	spare_part	FRE-001	Bomba Hidráulica Principal CAT 320	OEM CAT,presión 350 bar	450.75	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-07 18:53:09.13131	2026-05-07 18:53:09.13131
4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	spare_part	REP-003	Rodillo Inferiror CAT D6T	Acero Forjado,par	380.75	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-07 18:57:13.638207	2026-05-07 18:57:13.638207
8ae62307-c089-4509-8d80-13259a73339d	vehicle	VEHICULO_TEST	CATERPILLAR2020	CAT-2020PARA TESTEO	1500.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 01:11:18.75046	2026-05-10 01:11:18.75046
f5744375-193b-439d-8961-156e7a0cb1bb	vehicle	VEH-7976C50B	CATERPILLAR2020	Camioneta para trabajo pesado	250.00	t	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-14 04:04:13.605851	2026-05-14 04:04:13.605851
24c9d220-b3f8-4232-82ae-e8c07e5b1de3	vehicle	VEHICULO_ALGO	CATERPILLAR20285	gdfgdfgdf	50.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 01:27:36.855852	2026-05-13 20:14:10.046842
347bba78-6be7-4e35-a805-11a5fa31df09	spare_part	TEST-02	TESTEO	TEST DE REPUESTOS	50.00	f	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 01:12:55.613779	2026-05-13 20:14:19.862109
b19a7579-77fb-47d7-9293-302304aa8a36	vehicle	VEHICULO_TEST22222222	Testeo	asdasddsaasd	250.00	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 20:33:15.380946	2026-05-13 20:18:09.872678
dda8bcda-aff4-413b-8a43-c615850074f8	vehicle	NUEVO_CODIGO	Nuevo nombre pe	testeo	910.99	t	50572d23-a9dc-4b86-9a9c-14ed4a45910e	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-10 21:08:35.542444	2026-05-13 20:19:37.518078
\.


--
-- Data for Name: purchase_order_items; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.purchase_order_items (id, quantity, unit_cost, total_cost, received_quantity, purchase_order_id, product_id, created_at, updated_at) FROM stdin;
245f6401-a180-4646-84fe-d45e1235ae1e	10	25.50	255.00	0	8f037b5d-76dc-4cbe-b3c1-7ad080a3abf0	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-07 21:16:24.307041	2026-05-07 21:16:24.307041
c3ee7082-2cbf-4215-999c-fba4b785175e	10	25.50	255.00	0	b0be6ab2-8e96-435b-81b7-b899be989281	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-07 21:31:58.429712	2026-05-07 21:31:58.429712
8bca61b1-4f9e-490f-8f83-52af20fa3f7c	1	450.75	450.75	0	8f85753f-33f8-4eda-8557-2f79f67b3a9e	3d9de8c5-f204-49b7-a09f-55e7f8dd483f	2026-05-07 22:05:43.453712	2026-05-07 22:05:43.453712
15ad6f01-ad56-4e5a-b0f9-268bd45be6aa	1	850.00	850.00	0	97c72228-b463-45f0-b07c-fff2f4d3e61c	b500c835-8580-4842-9b3e-96387e5f3014	2026-05-09 15:22:07.062327	2026-05-09 15:22:07.062327
13a1ee9c-508a-45f7-bfbd-a074b64465c8	1	380.75	380.75	0	6ad76533-f9db-45c9-8cbd-afecf1b66521	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-09 16:09:38.875798	2026-05-09 16:09:38.875798
52b6688f-cfdb-4a3f-b15a-8c407023021a	1	450.75	450.75	0	6ad76533-f9db-45c9-8cbd-afecf1b66521	3d9de8c5-f204-49b7-a09f-55e7f8dd483f	2026-05-09 16:09:38.879986	2026-05-09 16:09:38.879986
fcb96ca7-3721-41da-8d67-5db4830bab4c	1	1200.00	1200.00	0	6ad76533-f9db-45c9-8cbd-afecf1b66521	18e2b3f3-4f73-4fc4-a05b-d82f8a6b9971	2026-05-09 16:09:38.883432	2026-05-09 16:09:38.883432
ece1d296-7e19-4683-b4cc-9a25514ce322	20	250.00	5000.00	0	b8a5e163-102c-44bb-9f0a-16db4f6673f6	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-13 06:08:42.162971	2026-05-13 06:08:42.162971
7216efd7-1b4f-47b2-9691-1de7bbc0f6b2	4	250.00	1000.00	0	ae9451c7-d5d6-4e8b-a0bc-d729d992b98b	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-14 20:30:30.085221	2026-05-14 20:30:30.085221
e352273f-4bb0-4620-946b-39b9b27fcf11	4	15000.00	60000.00	0	a4ef6727-4d3e-4c67-aa82-270156edb3e1	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-14 20:31:15.788496	2026-05-14 20:31:15.788496
364de858-beb2-442a-9052-3dc66af14bce	1	15000.00	15000.00	0	ab857be3-7e13-4af5-9d6a-6ac1490e1d17	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-15 17:20:40.042747	2026-05-15 17:20:40.042747
1ae74ba9-0d81-4475-985a-2bde0624ec7d	1	15000.00	15000.00	0	2edd8d91-c40f-47eb-a6f7-69e213479ee3	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-15 17:26:33.037906	2026-05-15 17:26:33.037906
ce5e40a3-dc03-4b71-a830-f9e92714ee49	5	100.50	502.50	0	48c158c2-e469-43ef-a259-7680dcaa2e76	00d34907-a489-4f6b-b501-a2f13a0f4104	2026-05-15 21:20:24.326111	2026-05-15 21:20:24.326111
5b7f8065-5a51-4ddd-9e09-6529b53edf24	3	75.00	225.00	0	48c158c2-e469-43ef-a259-7680dcaa2e76	b19a7579-77fb-47d7-9293-302304aa8a36	2026-05-15 21:20:24.331572	2026-05-15 21:20:24.331572
48c514d7-3661-4102-b8a6-7b2f23b992a8	1	250.00	250.00	0	eefccf83-4b44-4bb6-afd9-dfa9ed7dfb82	88c77073-7c47-48d6-9456-109de8d521c9	2026-05-15 21:22:06.345681	2026-05-15 21:22:06.345681
\.


--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.purchase_orders (id, code, status, total, expected_date, received_at, notes, supplier_id, requested_by_id, created_at, updated_at) FROM stdin;
48c158c2-e469-43ef-a259-7680dcaa2e76	PO-20260515-F225A557	cancelled	727.50	2025-12-25	\N	Pedido de prueba	e95dd9f6-7419-47f3-9e05-70f18c2db0f9	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	2026-05-15 21:20:24.318901	2026-05-15 21:23:58.008628
8f037b5d-76dc-4cbe-b3c1-7ad080a3abf0	PO-20260507-F089608B	completed	255.00	2026-06-15	2026-05-07 22:23:28.981524	Orden de compra para productos electrónicos	e95dd9f6-7419-47f3-9e05-70f18c2db0f9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-07 21:16:24.301892	2026-05-07 22:23:28.991583
eefccf83-4b44-4bb6-afd9-dfa9ed7dfb82	PO-20260515-7BAD42DC	cancelled	250.00	2026-05-22	\N	test logistic	0327b498-2fd3-4fc7-9aa0-4622e8b17f11	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-15 21:22:06.343294	2026-05-15 21:23:59.914678
8f85753f-33f8-4eda-8557-2f79f67b3a9e	PO-20260507-71B66475	completed	450.75	2026-05-13	2026-05-07 22:23:58.105093	testeo	d1a540b3-53c4-473f-992d-8a74a552b27d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-07 22:05:43.447994	2026-05-07 22:23:58.123193
b0be6ab2-8e96-435b-81b7-b899be989281	PO-20260507-D74AF85C	completed	255.00	2026-06-15	2026-05-09 23:11:27.073452	Orden de compra para productos electrónicos	e95dd9f6-7419-47f3-9e05-70f18c2db0f9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-07 21:31:58.426696	2026-05-09 23:11:27.084698
b8a5e163-102c-44bb-9f0a-16db4f6673f6	PO-20260513-E09173BB	completed	5000.00	2026-05-14	2026-05-13 06:08:46.230354	test	d1a540b3-53c4-473f-992d-8a74a552b27d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-13 06:08:42.158102	2026-05-13 06:08:46.24082
6ad76533-f9db-45c9-8cbd-afecf1b66521	PO-20260509-F54D676D	cancelled	2031.50	2026-05-20	\N	testeo varios items	d1a540b3-53c4-473f-992d-8a74a552b27d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 16:09:38.869564	2026-05-09 23:12:43.038702
97c72228-b463-45f0-b07c-fff2f4d3e61c	PO-20260509-46C6E4CC	completed	850.00	2026-05-11	2026-05-09 23:14:06.879139	Testeo	d1a540b3-53c4-473f-992d-8a74a552b27d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-09 15:22:07.056193	2026-05-09 23:14:06.887607
a4ef6727-4d3e-4c67-aa82-270156edb3e1	PO-20260514-46C63B62	completed	60000.00	2026-05-20	2026-05-14 20:32:30.514536	newtest20	e95dd9f6-7419-47f3-9e05-70f18c2db0f9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 20:31:15.786225	2026-05-14 20:32:30.528084
ae9451c7-d5d6-4e8b-a0bc-d729d992b98b	PO-20260514-F0AF9EDE	completed	1000.00	2026-05-19	2026-05-14 20:32:34.246415	test	0327b498-2fd3-4fc7-9aa0-4622e8b17f11	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 20:30:30.077842	2026-05-14 20:32:34.255977
ab857be3-7e13-4af5-9d6a-6ac1490e1d17	PO-20260515-80ABBFCA	cancelled	15000.00	2026-05-22	\N	prueba warehouse	0327b498-2fd3-4fc7-9aa0-4622e8b17f11	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 17:20:40.020568	2026-05-15 17:21:06.971748
2edd8d91-c40f-47eb-a6f7-69e213479ee3	PO-20260515-C2388243	completed	15000.00	2026-05-17	2026-05-15 18:25:37.320361	test warehouse	0327b498-2fd3-4fc7-9aa0-4622e8b17f11	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 17:26:33.034771	2026-05-15 18:25:37.33833
\.


--
-- Data for Name: quotation_comments; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.quotation_comments (id, message, quotation_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quotation_files; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.quotation_files (id, file_url, file_type, quotation_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quotation_items; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.quotation_items (id, description, quantity, unit_price, total_price, item_type, quotation_id, product_id, customer_asset_id, created_at, updated_at) FROM stdin;
7e07f624-d8a7-4eb1-9c09-509263397b50	321312231 - Excavadora/Equipo	1	2312312.00	2312312.00	product	ada78606-5b75-410d-b73d-180fadc88935	dda8bcda-aff4-413b-8a43-c615850074f8	\N	2026-05-12 10:33:24.6434	2026-05-12 10:33:24.6434
428147c8-0bde-4c4b-b785-1d9bc26f5ee8	Rodillo Inferior CAT D6T - Acero Forjado, par	4	380.75	1523.00	product	e2d176b7-9dbc-4f2d-a270-9d2811234c5a	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	\N	2026-05-12 10:34:18.639937	2026-05-12 10:34:18.639937
\.


--
-- Data for Name: quotation_status_histories; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.quotation_status_histories (id, status, changed_by_id, quotation_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.quotations (id, code, quotation_type, status, subtotal, tax, total, valid_until, sent_at, approved_at, rejected_at, client_id, advisor_id, lead_id, created_at, updated_at) FROM stdin;
ada78606-5b75-410d-b73d-180fadc88935	COT-001	sale	approved	2312312.00	416216.16	2728528.16	2026-06-30	\N	\N	\N	dfaefd47-25c2-498a-bb2a-1f838010043a	76b8c456-12fe-4bf1-bd68-b5a4261119c7	\N	2026-05-12 10:33:24.6434	2026-05-12 10:33:24.6434
e2d176b7-9dbc-4f2d-a270-9d2811234c5a	COT-002	sale	approved	380.75	68.54	449.29	2026-06-30	\N	\N	\N	a34bcdbe-f660-41f2-a2c3-18330eb882b7	bc7a199b-b81a-42f8-b689-6954ccea0b84	\N	2026-05-12 10:34:18.639937	2026-05-12 10:34:18.639937
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.refresh_tokens (id, token, user_id, expire_at, created_at, updated_at) FROM stdin;
2c46479e-b408-413e-8573-c1d6e11c15b5	02ce925f8b02c1ee9be9f68caafbf904096149c8c4ff0b51fda193925c0942c3f8c1d289deb5a6d7bef3a3d3d788f35eaad8e5822fb23e7d835975136e58d60b	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-12 21:20:54.111042	2026-05-05 21:20:54.125683	2026-05-05 21:20:54.125683
2a893523-97d1-4ad6-93f6-8fb10c9dbfd5	b422f6a6660314b9cd6cf1d7eb680ccac8f7b2551aa4bc1a62d58f889064b92ece179b3dd008ddc285ec15cbc192b3bb1852b9cb1a24df211ea128e90a738ff0	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-12 21:21:59.546098	2026-05-05 21:21:59.577291	2026-05-05 21:21:59.577291
c29a33fb-de94-45dc-8341-695aacce2bab	9daaaf486d60eae645d58809a365f963d184a27b6164eaf459adf1fede25afa46e0db64cf8ba894b752f8c507fb4c744ad8c96cb3ef250f6525e4cb15e543379	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-12 21:25:39.407869	2026-05-05 21:25:39.408555	2026-05-05 21:25:39.408555
306654e2-b7de-4a01-a208-3022aa275713	aed9d9303eccf7dcb8a476a62359253b9e30743c778f950e81c65cbc83191f106a9797ee1df0c59e7b3eedf996a721e7b73e014563e73f0421f43f2ece79a043	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-12 23:19:05.472439	2026-05-05 23:19:05.476753	2026-05-05 23:19:05.476753
b16cff0b-449d-4c8d-9bbb-3edbd287f130	2d395e09866de4b9a45880506cdc6f76596747fb702746284789323459f1ae32362e0a959a45259eb56a8ccac299379ee9f3bfa777d56fa69758fc759d2cfce0	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-13 01:25:31.757959	2026-05-06 01:25:31.772245	2026-05-06 01:25:31.772245
a17703ae-5439-4f42-bae7-f1d81e544cfc	3a6fa08ea8786daf58c17ef8a5f1bac73b871222a6992f1f546ce3cdb632bc0f2e908752a56f1ef8df9595acaee8d2a351d3040f4db920191a921c3cfa89ff4f	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-14 01:09:32.917271	2026-05-07 01:09:32.922254	2026-05-07 01:09:32.922254
6151cd4d-1435-4d6f-8af1-c46136a5eb1b	c5dabc7562ceeb981fefd6df27b6ce0203c211389deb9a9089a54087b10a769502d9eb470dcbdb8ce8dc23b073f1468042d0891c6f5e75069d488d87d35e46b1	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 02:02:39.327358	2026-05-08 02:02:39.337413	2026-05-08 02:02:39.337413
e4be57d0-9de8-44b5-9feb-09df00648535	38e9ecb8adca61ec6b9e2633497c111e247eadaa9ecb0027061fe1bc68cf0f32581f01a0c7c8e03ee3859e66bb9c69563349dc17bc34b3728b6b982f8cc98358	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 02:02:55.689	2026-05-08 02:02:55.697881	2026-05-08 02:02:55.697881
1a2f2394-36e2-4693-bfdc-f6bf7d2f9443	ba82f2f0ac041f495019d3e89c5beba34017ab1f81bcb00924846e9ef818d3928db6b13f74990ca6236ee36b8983ad74b7e3d93b2b407104c830ba8e4bc17c0d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 23:57:10.994398	2026-05-08 23:57:11.017903	2026-05-08 23:57:11.017903
4f27b51c-dfbc-41d7-a123-257aa38ff796	9a6d332a17e34cd3681199fd245c4d0be57b17447ab9d6a0e5462072ce104d458d27398a73dc61c7f1369052a4460774e52de8b88fe488fec036f8a55b9b90c9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-15 23:59:37.496956	2026-05-08 23:59:37.497913	2026-05-08 23:59:37.497913
9bc0fe44-05b7-4b27-994b-0a13462190db	b47e791ae220ab39fe78e4b2af79e081396e33dd902d7ed019d4f5c7bc62df0afe1e50baab3b83cd870e42662abce7f57f1313eaed32137e634842071d0239ed	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 00:19:38.377176	2026-05-09 00:19:38.384372	2026-05-09 00:19:38.384372
0d5c7a91-88e5-4035-93de-b00e0c3455dc	dddfb0da4d1c7e7384c241bddfb12b0b90a9b0d1c3178257a85d213b88469cc09fe0f249aa35f3d2a0048880a1838af2e72e600da0b1ebc21c1235e648ba692b	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 00:23:13.025772	2026-05-09 00:23:13.026589	2026-05-09 00:23:13.026589
a2fe6fdd-70c5-46bf-804e-e0ebd7501bd5	43ed6f946f15ae9e1d300fd579400961ad9a339298ddca5c0b4613391ef2cbbdd40e8d0d009e9f24f15ede975fb016f8f55959d4e87f8c902a4dcdec612727cd	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 00:24:58.150872	2026-05-09 00:24:58.151706	2026-05-09 00:24:58.151706
7035a798-0429-423b-a52d-d0d03a8a1f1e	22cbb58556b6ac21f5dfec11b6a4b6701c081aa81cc22a38c92f4da1d85ffd1436c84789537894da9afed254d3a413321033ca221592471f2781973254b4e55f	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 00:27:31.513779	2026-05-09 00:27:31.51446	2026-05-09 00:27:31.51446
e1b35278-9e53-4f03-b412-7e87b88b28f0	2157f1d45de3fd1100c63f83b34b72fc10647f7d5d649eb9afd16644c6670f635218a217cd1e6733d366086c02cd489d89449d255fc6bd177648bc6cbf04101d	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 01:30:28.259768	2026-05-09 01:30:28.272378	2026-05-09 01:30:28.272378
c3a12dee-d6b9-4651-92ec-c90b487eefa3	f332ec0488e38dc1f7ded426fd2a80d0c3343ac7876b698bafe681b63981b99aec45e5faec8b2e4f3898abded4b441f926d00197222c0e1b77135d6a740da3d1	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 01:35:55.579476	2026-05-09 01:35:55.580139	2026-05-09 01:35:55.580139
3ec7fc8c-8eda-4592-ab31-3437cb5552ab	53fdfd35eecca2aba1936076a728cc0ce60ec57d179b592b2a3eb547a1ccde8138fd7a4a27460826bd7aaf736147a6aec23832eb8895fedc3736776a0babd154	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:14:51.765373	2026-05-09 02:14:51.766216	2026-05-09 02:14:51.766216
5691cb87-51c8-475a-9b62-a1e74984438e	1288bf440adbd6f332a01df3af0fc91d302aba78281a30ac63bc6ea36b11712be7736fc30400a381fc185ef0cee0c0863a1758d42547d555a170e46f8a8517e6	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:16:10.198333	2026-05-09 02:16:10.198996	2026-05-09 02:16:10.198996
a39a9b82-52ef-4d6e-8f85-1bf4c102d3b1	572860cdc0d550fa6687ec3d9990d1acf7606f9b0711da59781372c540b853281671da9c0733fad56e6964dc7de2dd33808d8002ede85dda67ea76923871d776	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:17:23.998263	2026-05-09 02:17:23.998987	2026-05-09 02:17:23.998987
99811ec3-589a-4ce5-a7ab-be1c83446649	13ed2a1b3c0c79a5c855d986f8c469311d53645a8c9bf83c68d8c27bcb5c7bd23bbd3a13de70938fdc8235ea40304af28214c951c8b1f493122aa5648cd81aa9	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:19:12.851086	2026-05-09 02:19:12.852071	2026-05-09 02:19:12.852071
22a700c5-e836-4c8a-a4f5-6acd3dd7a3a6	327e2e4995ccad7f1018a7da2c5556928fe0cb3bd11e6df01fecf34c496caee5b18100449de70304b7927b795018ef2a3e78e3ff7c220de21e14a627e975a838	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:23:53.408766	2026-05-09 02:23:53.409555	2026-05-09 02:23:53.409555
a5c4f9c9-fc85-47f9-95c8-26eb4103c765	59b2b57f7b98c7cf04fa1b246ae2306ac32833ce345d6bfeb4a43873f47005e4c155213c7798cf33090abc763cbb6a9ce0e370ccdd5021e62ab2b5d26d773dad	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:26:15.700872	2026-05-09 02:26:15.701618	2026-05-09 02:26:15.701618
b7ee42ca-0b12-441c-baa1-428c508636bd	a8aa0a9d348dc4a490f6505b129f3427ac5d8ef6f9bcaf3293f7cb7b939dc385c286c709596a12f832ddc9f920ba4a0b839156874bf1febeed49d3c20ae7174b	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:26:15.965836	2026-05-09 02:26:15.966601	2026-05-09 02:26:15.966601
48736c57-07a1-45ea-b4be-d539890f46c6	1ae2638779c8650c27acb9c4d25d40dd34ac199ee18ad25a7b5eea5673af706c94d36c1297cc2de6ee36ecc352fca2c048a3094a155761755f2a02ff0992c865	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:28:04.750104	2026-05-09 02:28:04.750842	2026-05-09 02:28:04.750842
806ab16f-62d6-4219-84d5-c8e493158057	030b1b8b4e5c9a4b23199097cd2a9bb025d3cad943ae8dbcd1f14baec5dbbb6a6d52e00b9313c6c68de6b76f6b7e2e1f25ab37aeec10254430f4a448cf1a11ad	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 02:34:05.248227	2026-05-09 02:34:05.24888	2026-05-09 02:34:05.24888
5082efa9-beda-46d4-9ca0-58d78384fb48	da62aa4217ae44d5a217bd47e9fa9b27f6d735a39838168fb24e20dd00ccb23da1a0f05b88e61f642f310ef4f3cc2fc8988be863440b883518b6c842347d6dbe	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-16 15:18:55.84835	2026-05-09 15:18:55.854653	2026-05-09 15:18:55.854653
19094eb8-e443-40f2-bb2e-2808d4024272	35104f4a3624de3205714fa7891b9db499c18825364889527552d772da35e3ade7683ea86fe17d43452cc73c7ef4728bbcb6bd4b064dfc5f6735521428acdced	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-17 16:17:33.586401	2026-05-10 16:17:33.592196	2026-05-10 16:17:33.592196
c2a4f467-447a-40bd-bbbf-2ccc792ac912	916e79621cb5b58c26b2c306ddaa183b7ff0f817a9190348210aae48b40bbf7e30fbfff643204f047cbc9849d41a2b21c68509d2325f3c4ddbe219614157a107	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-19 15:47:31.510192	2026-05-12 15:47:31.519337	2026-05-12 15:47:31.519337
827c4928-4919-4ea2-92e2-94d9d58f7efa	6778c0a1b3485bef2e690c889e7d6479d46202852ac20fccb4c759c65b77608be9a0feafc1f063072af03dfe095b5d013aec85ac74e2d31a53a39509c9af98d2	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-19 17:14:12.322317	2026-05-12 17:14:12.326805	2026-05-12 17:14:12.326805
5f1d8237-9dd1-43a8-bcef-6a3356d861e7	51d5a96b308c0b9e0820530c0be31be72c1a8d85afea5fed9974f7ddf93872be007e9c70e64faa7dee2e517eaaf1256ff8b960e8b150960906b8a4fbe8a4e8e0	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-20 17:10:01.386945	2026-05-13 17:10:01.403172	2026-05-13 17:10:01.403172
53330900-104e-40e6-9779-65e1f43f6120	1f52bca5721e76634c82e64b1299ea0f955758ea9fe8e5098600e8b1fcdd573d2236b543771e2f608020f3305fba82956eb818732107737ee820a8af9ce8f807	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-21 15:52:54.528667	2026-05-14 15:52:54.541851	2026-05-14 15:52:54.541851
5b805b64-70cb-4150-870d-9c9bdd23b876	0c90ee5e0f4e91f73041e1809eeee8d24e869481bbfd0001a896a6e158e7bbbee95fc67ae2e62e7181c09e09ecda83a6b8f574b9cbf04a4eb370984313bf3070	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-21 15:59:05.983579	2026-05-14 15:59:05.984313	2026-05-14 15:59:05.984313
2830d9af-1f16-4888-839b-19f384a0532c	2878e47db472e3c3e3fbe5403d2611f0f428a296b56970dc4edc5567a0b601d6d16a570727a2fe10fbab4ff1a5f2a1d67452c51c6d426e9d4bddeef8fc9f21b0	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 16:18:37.592312	2026-05-14 16:18:37.593301	2026-05-14 16:18:37.593301
2ca54b9c-bab9-44d8-84db-7b83fb365f2a	3dcbb585092d84df04019afbbc5afbd49075e3b14972d581a3f31892347931d633d661544e266717db929f00f809146393efd8aae490386419c2875cbd0ddfa3	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 16:19:01.162825	2026-05-14 16:19:01.163489	2026-05-14 16:19:01.163489
d65753c3-5bdf-4a7d-8a0c-7a18bfb57acb	0dc9d6c6cc3e857ec03d2bdb626d006cc67997e12e5467d4c6103cc71a4186cf923e355d20357d6b6d8ecdb9862608eb12e027abb992859f8ccfc53891ee9017	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 16:24:44.845979	2026-05-14 16:24:44.847079	2026-05-14 16:24:44.847079
360f5130-0b54-4a30-9db5-d44f4900d967	30920820485bbd0274c10d50c5cfd0d42d7d63154f57cca06432d60ed9d164faf281a5670bf34b4ebcfd6c8aae65c7a7d0e796b2a1fe221ca93da40226b424c8	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 16:26:31.217031	2026-05-14 16:26:31.217754	2026-05-14 16:26:31.217754
97fe3242-1e89-4a48-b55e-d30c4310a7c0	59cf75feb1fff483be2d565204cb4e50dc7d768cb3ee590d8e5d418d703ced3247cee4e9ddaa5d7dd5d93304faad6ccb0a7a0703f77391642eafda714f95c997	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 16:28:28.556731	2026-05-14 16:28:28.557513	2026-05-14 16:28:28.557513
fc9ba91d-e038-455b-847f-f8849f038604	d1f313a1c6acb1ac2bca24c3228227b9d1547337ed287ea3bf3b93589d2f4f8e46906ff06549e877a045153b1c91722772c5896361daa87e6ff15575d77fa529	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-21 16:38:14.78992	2026-05-14 16:38:14.7912	2026-05-14 16:38:14.7912
86001198-9706-4b1b-bb66-98d09a92880a	f1a88d0012e1244cca862b20db7ee75b61569e1ea8485df02acd3be82c57c2459fe84b86df480d3ede09dafb7124e2bab0182531cef593d46d3dadceb60c69f6	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 18:37:10.049833	2026-05-14 18:37:10.056637	2026-05-14 18:37:10.056637
9358fbe6-59f2-4631-9ca3-717fd304d210	b4528454cfaba7597039ffddf7e81f5f3b1ecd02bb52fbfc0b9bf60647512a0595e681e64c21eb9854115c8ccb79d006900fe28e24b3bcafe0d13fadfa790760	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-21 19:00:48.12866	2026-05-14 19:00:48.133941	2026-05-14 19:00:48.133941
aba1c54d-4526-4bdf-b10e-923811e36a91	a6e24beb220105521bd9c7fe5e08f51b16737cb56378bfee0ca63669739f0ac771b384ab3b605d819f5a962747450bbb7e36444fb36543446bf3384caeacd198	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 19:01:17.991811	2026-05-14 19:01:17.992613	2026-05-14 19:01:17.992613
5e3ead1f-eb32-46de-acb0-1bdd744b4a8e	5e605a32309221f60ce5b2375940620a0d7e42ae76524736aacf2f5797d64b854afc583afaac902950ac00018c29d616c151ef6f27f8e6b34a4d34ce92d470cb	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-21 19:01:34.590195	2026-05-14 19:01:34.590936	2026-05-14 19:01:34.590936
3759eec5-33c7-4771-83c8-86a9995d9600	c47e2401c98774d6f10baa86cbd8ff4ea54e28b79fc28c218256ab0d29adc0d87de11203d31571dec5dcd54a8190bf85f2d7a2a6eaebb4646a8334594e816d67	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-21 19:03:17.642322	2026-05-14 19:03:17.643046	2026-05-14 19:03:17.643046
ca2cc04b-9fe6-4af6-97c3-3e5281d8b317	b5501cf3ad8cd3dcf267ff53ecc52628b4fb6ec4ae0f6d20c1f964c5a873075651e404de9e57113f60a70f132114cfa0399f769c2b1aa617073e3ce1535a4850	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-21 19:21:17.153611	2026-05-14 19:21:17.154272	2026-05-14 19:21:17.154272
a8f7aa74-6e4f-4735-bfb3-2f9188b43159	ee9f03669419645cc4b88f8cbfcca7c99a3c2d6d560786a2d9dfa3b8254e5f67d17c85a90d2287680ef01ca9a55a1d71776cfdcc4aa62c3449ab67acbda6fbee	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-21 20:18:16.547003	2026-05-14 20:18:16.552407	2026-05-14 20:18:16.552407
a70d9980-fa27-4de9-870d-2ff0d09e8c25	68e2217ddb73cf19fb4e0b3464d00cbea724378f47322a26d096410dc126fc815c37dc0d3d4e23c9b6cb9c66b1a76f4a3c28bb12fb31bcdcefe8723433795bbf	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 01:07:32.779379	2026-05-15 01:07:32.796812	2026-05-15 01:07:32.796812
270e6d28-545a-4360-a314-4d1fb559e028	cb638b3e5803993bf4f5747f3a42033f1cbad9888480fd63a19d3aee7abd834a75991192e16256c093ca47915cf64811eefa233b92c3bd67117b00cc5c778899	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-22 01:08:23.894296	2026-05-15 01:08:23.894902	2026-05-15 01:08:23.894902
906f3cf7-2dca-4baf-8413-dd24e388b756	f5bed5b0bcf892e2694e7d8e5632d315c723d61dcde7debd0a5bb64e34155af63b8289f3ce37b330c24dafcfec53c63277f71bc75cad8c51a2a4c4feb65f22d8	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 15:07:58.193318	2026-05-15 15:07:58.201281	2026-05-15 15:07:58.201281
b19d127f-b962-4152-aab5-abc34ccede34	35aa01e4ef512b13d9552323e99dad0d50ff11fadeb05a4f10074a8d86aaca9327ef4c62cd54b71b11f0a4ea71effe7be5621045f8e8bbf71f7dd5bf94dd99fe	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-22 15:08:56.653663	2026-05-15 15:08:56.654313	2026-05-15 15:08:56.654313
856a014d-7992-4ba8-b7ae-7696a77809a8	9ec9ba9745866635275225bdfa69a57ade15e6a4591fecaa362f34f867bb0b0b3cc6e682608e11c91e5ed2867137aa0e4189526715316954cc0fe19e3ec980a4	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 15:28:36.450271	2026-05-15 15:28:36.458691	2026-05-15 15:28:36.458691
40ac8fb8-1051-4638-a8de-641c71e82443	d07d0d295ed81e675c7226cd1b9f399da0d6c56e3840eb2ec7762344e09ba49f5cb168cf02c1e5b26b97000c269a314383cac30af40dfad6bf10d3358075ea94	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-22 16:31:03.582516	2026-05-15 16:31:03.592864	2026-05-15 16:31:03.592864
45b86131-e879-4896-8986-a574b3d205c5	09ba0b9ce241ccbc27e9db241c95682c0917254288224135b45e5dda6c44bf2d173ab89b2482f8ad5c677171496dbfc9598c43267ca862d1ac804fa9ca784a89	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 16:31:28.804655	2026-05-15 16:31:28.805719	2026-05-15 16:31:28.805719
3d7b64b9-3100-4902-bcd2-3da3d634a067	b59bec9e33c6b0cdbbc3a9a26d82209f58391793c4bfc48a6f52ad5c33617c582fe6f36796f1b6c51ced3e1913b7707be5af1df6b21e30c946353d19b9d53e65	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 16:34:02.695549	2026-05-15 16:34:02.696458	2026-05-15 16:34:02.696458
76d48810-043f-4160-b220-41c3d5ed3ab8	47699cc320fd1f846fef54b82481f88fae6492a6491fd368f9ee1a7a9c2191651e24f0286575bf2cecbaa08f2e2a8ca1dcad3e558dd3d96348ec17a830b76294	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 16:35:06.380501	2026-05-15 16:35:06.3812	2026-05-15 16:35:06.3812
fa181154-1dc9-48ee-ad89-a9be3747a3e3	c7350e010120165206796e610c279b6f406339845b89cec61e95a2001ebdb281cc0b51ab42e2442ce931aaf9e78af9f84215a1954f710299c443256a09222788	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 17:33:00.478975	2026-05-15 17:33:00.483531	2026-05-15 17:33:00.483531
3bfef947-e86b-4f5a-935d-56da47cad669	eb9fdf47f62f5f730835ade7077e48b974e5bc7cd179c13d873316b2d2a8f596efb66e296af56a7ebcc8709d10a7597b5f0607e7ed5c7e7501f0d366b6693064	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 17:34:02.628393	2026-05-15 17:34:02.629219	2026-05-15 17:34:02.629219
8becf431-2b6c-41fb-a58a-c575ac686210	d4082f23197ba30a695ccb966ad5bce887d372c7fc18b1c2db90b125f472b4566bc3dd360e8ede95b850f14db0cb02ae44cdb02c6eb126602956282379ec63e3	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 18:20:12.7257	2026-05-15 18:20:12.739341	2026-05-15 18:20:12.739341
4e810972-5418-4a42-9847-5cb5e489f979	e95abec31f97cbef29571ffaa70b325c8e7c1a48d6b8111c8dea667aef4d6a878c32f169d84f0a4a68c20f7dc323d949b5980b7472384e6ff7f1f85089527f06	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 18:40:41.864313	2026-05-15 18:40:41.865132	2026-05-15 18:40:41.865132
bc7dc635-3e6b-454f-8bb8-23bbddb213ae	b72ddca114c9c7fa81abe9618603c4ef30b62362f685ad1848151c0dd5a5bcbbd890f000832566749fb4287728ecbb9e25779839909427e785f2b70a41a0fea7	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 18:41:08.666735	2026-05-15 18:41:08.667721	2026-05-15 18:41:08.667721
a7f77b6f-fe66-430b-ad1a-ddcd4bcb86d8	6c31ed9effbd435e8c98db6bbfedcf3a45da6315d331c7096d71d5ee53d39dc86acb6b8584ceeda488421386aa834c3b8f9073016b880efd07db6f2b192555cb	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 18:43:12.377944	2026-05-15 18:43:12.378619	2026-05-15 18:43:12.378619
d1031ab2-d215-45ca-b63c-63b71f7c903f	63bb34d153312e39cdf23f4e746c4089675c437599631bc2323a557b0f561acdc4520a7320192462bea43eeb3d333bf871f2596312fb954bb977b78db3ad0ea4	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 18:48:24.765102	2026-05-15 18:48:24.765987	2026-05-15 18:48:24.765987
b6f41eb7-35d5-447f-a033-48df01a8fbf4	43137ba401763e6fff96b1cefc5ea01fee76856e7ef00dba78fa348e1c8aee8c7ca4aa5b8ea6c83f16f1f5ceefba5a0d60d12c32f34b9f55cbdbe4b8e9c1bdc5	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 19:39:39.97176	2026-05-15 19:39:39.973378	2026-05-15 19:39:39.973378
35a60c51-6eae-48d4-90ad-a79edc4fc123	f3c66c1f089ed59ce29e3ffe6a8b39af21a20ad69fa26dd9e87a49e9230acaa521459015eb954b93f7b2b745779e6bc06fd0d6cda15e14c48f875fefd14af4b3	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 19:47:32.988309	2026-05-15 19:47:32.989438	2026-05-15 19:47:32.989438
278ddd8b-ff46-410c-a14d-6b126e7997b3	e3c056b6d04fc89e5516113eb398a6f784020f8be3f8fea151d5cbd86a22167f0ad479cd51a3b88c448b1d1eaec6d77266c689c172d117bdd273c562c7fc356f	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 20:00:07.615712	2026-05-15 20:00:07.63557	2026-05-15 20:00:07.63557
9bddcd5d-7cb0-4d7b-ad16-387e3e21f12e	e17c08628e3d01defa1cc4c98afe90ba8372ecbea0d8665973653619f0c99757b3011b94b842f7a5e96c36612140e4dd66c219dfd5efec29c631e43fb624a6b8	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-22 20:08:15.707122	2026-05-15 20:08:15.707831	2026-05-15 20:08:15.707831
7a241751-6559-49ce-9e68-470c815faad8	03a1611f2534e300a6b88814393114f3af33aebddf0e62293a898f55031cf72a03e139cabca3ae580bec55066a2841355d24e14b4d098a54bd6027dc5f2b134b	0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	2026-05-22 21:23:00.695493	2026-05-15 21:23:00.700666	2026-05-15 21:23:00.700666
64cf9315-9ffd-44f3-8387-d546173b610f	71f74a423216a3a6582193e97b2df9e4d61d681c129653ab7637aeffc516f13e821fd496d30fc183c58baba0634de492d9cd827f3de62ed5ecb3c77fb1805fa7	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-22 21:24:53.071974	2026-05-15 21:24:53.072697	2026-05-15 21:24:53.072697
a9796647-b13d-4951-ac9d-e6d3299fb39d	35bfa8e77d8c860f2181dc79e659f440c800e2d691feffc6d77a5f9670cfd9f0c6c29627fae1d15ffc5dee496bd93f9b9bc8bfb8b85104db5a0a96bfb1782e3a	47cd2452-fb03-4452-9509-4f4efba4f1a7	2026-05-22 21:51:42.008997	2026-05-15 21:51:42.009813	2026-05-15 21:51:42.009813
d5107875-d57f-45e8-ad21-58a33e707698	b221c6de37d3bf27b863a2085cf5fdeffd47a9a9bf1bc66f427b16a4a1002fbd6326c90dd5dd54d4289ec6670db5573818e90776888bf22cca99ab2aae28ca36	50572d23-a9dc-4b86-9a9c-14ed4a45910e	2026-05-23 01:44:40.412622	2026-05-16 01:44:40.426142	2026-05-16 01:44:40.426142
\.


--
-- Data for Name: rentals; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.rentals (id, code, start_date, end_date, status, delivery_date, return_date, vehicle_condition_delivery, vehicle_condition_return, total, notes, quotation_id, client_id, vehicle_id, created_at, updated_at) FROM stdin;
3d9cdb28-aade-48cf-9043-24492c23f57b	RENT-001	2026-06-01	2026-06-07	active	\N	\N	\N	\N	\N	\N	ada78606-5b75-410d-b73d-180fadc88935	dfaefd47-25c2-498a-bb2a-1f838010043a	b0c53920-435d-4378-ae60-71037b808a20	2026-05-12 23:49:40.221749	2026-05-12 23:49:40.221749
15e9e7bc-bee3-4fae-ae77-2b1a4df3085b	RENT-002	2026-06-15	2026-06-20	active	\N	\N	\N	\N	\N	\N	e2d176b7-9dbc-4f2d-a270-9d2811234c5a	a34bcdbe-f660-41f2-a2c3-18330eb882b7	b0c53920-435d-4378-ae60-71037b808a20	2026-05-13 00:20:32.225754	2026-05-13 00:20:32.225754
\.


--
-- Data for Name: sales_orders; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.sales_orders (id, code, status, total, notes, quotation_id, client_id, advisor_id, created_at, updated_at) FROM stdin;
28dbe96c-e7e7-47e4-8574-a951c25d39d7	SO-001	confirmed	2728528.16	Orden generada para producto: 321312231	ada78606-5b75-410d-b73d-180fadc88935	dfaefd47-25c2-498a-bb2a-1f838010043a	76b8c456-12fe-4bf1-bd68-b5a4261119c7	2026-05-12 10:33:24.6434	2026-05-12 10:33:24.6434
afcffb7b-198e-49ee-befe-9d0c13c9890b	SO-002	confirmed	1523.00	Compra de repuestos para mantenimiento de flota CAT D6T	e2d176b7-9dbc-4f2d-a270-9d2811234c5a	a34bcdbe-f660-41f2-a2c3-18330eb882b7	bc7a199b-b81a-42f8-b689-6954ccea0b84	2026-05-12 10:34:18.639937	2026-05-12 10:34:18.639937
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.schema_migrations (version) FROM stdin;
20260501225319
20260501230917
20260501232320
20260501232503
20260501232729
20260501232933
20260501234546
20260501234723
20260501234829
20260502203419
20260503005611
20260503005934
20260503005942
20260503005947
20260503021339
20260503021340
20260503021341
20260503021342
20260503021343
20260501233000
20260503062623
20260503061201
20260503061202
20260503061203
20260503061204
20260503061205
20260503061206
20260503061207
20260503061208
20260503061209
20260503061210
20260503061211
20260503061915
20260503061916
20260503061917
20260503061921
20260503061923
20260503061924
20260503061925
20260503062153
20260503062154
20260503062156
20260503062158
20260503062200
20260503062201
20260503062202
20260503062602
20260503062604
20260503062605
20260503062606
20260503062608
20260503062609
20260503062610
20260503062612
20260503062613
20260503062614
20260503062616
20260503062617
20260503062618
20260508063820
20260508063821
20260508064913
\.


--
-- Data for Name: spare_part_categories; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.spare_part_categories (id, name, description, created_at, updated_at) FROM stdin;
8d27dd3f-5d0e-4958-9fce-7a4d015ee55a	COMPONENTES CRÍTICOS	Componentes Críticos', 'Motores, bombas hidráulicas, cilindros y componentes de alto valor	2026-05-04 05:50:26.741092	2026-05-07 16:55:08.135496
d814726a-6415-484f-8673-0d42a8dc58cf	TREN DE RODAJE	Tren de Rodaje', 'Cadenas, rodillos, sprockets, zapatas y componentes de desplazamiento	2026-05-07 16:51:46.128295	2026-05-07 16:56:17.363716
5f86ed22-03f8-433f-8673-7cfa950a9b4f	G.E.T -ELEMENTOS DE DESGASTE	Cucharones, dientes, cuchillas de nivelación y adaptadores	2026-05-07 16:57:41.93799	2026-05-07 16:57:41.93799
6881a844-2dcc-4b95-9747-c4d130cdb3d4	CONSUMIBLES	Filtros,aceites,lubricantes,correas y fluidos hidráulicos	2026-05-07 16:59:11.07805	2026-05-07 16:59:11.07805
\.


--
-- Data for Name: spare_part_compatibilities; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.spare_part_compatibilities (id, spare_part_id, vehicle_model_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: spare_part_specs; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.spare_part_specs (id, key, value, unit, spare_part_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: spare_parts; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.spare_parts (id, part_number, manufacturer_brand, stock, min_stock, sale_unit, is_critical, product_id, spare_part_category_id, created_at, updated_at) FROM stdin;
987e5121-dfb5-43e8-aa95-8396e14f1060	1u-3302	Caterpillar	57	10	unidad	t	3d9de8c5-f204-49b7-a09f-55e7f8dd483f	8d27dd3f-5d0e-4958-9fce-7a4d015ee55a	2026-05-07 18:53:09.134235	2026-05-07 18:53:09.134235
bfe419da-34d7-4388-bf74-db33de69da67	CAT-2S-4400	Caterpillar	36	5	par	t	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	d814726a-6415-484f-8673-0d42a8dc58cf	2026-05-07 18:57:13.640418	2026-05-07 18:57:13.640418
d6f7a1d2-1e3b-436d-89b2-2e3188e2ca96	EEEEE-TEST	KOMATSU	71	5	unidad	t	347bba78-6be7-4e35-a805-11a5fa31df09	6881a844-2dcc-4b95-9747-c4d130cdb3d4	2026-05-10 01:12:55.620114	2026-05-10 01:12:55.620114
21f1ce11-8967-4eb8-a01a-d9601c54dfd8	dasdasdasdsa	dasdasdasdasdas	54	4	unidad	f	88c77073-7c47-48d6-9456-109de8d521c9	d814726a-6415-484f-8673-0d42a8dc58cf	2026-05-10 20:33:52.1231	2026-05-14 02:56:55.872579
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.stock_movements (id, movement_type, quantity, reference, performed_by_id, spare_part_id, created_at, updated_at) FROM stdin;
ddcede77-7da3-4719-8bbd-3c3595408f25	IN	10	PO-20260507-F089608B	50572d23-a9dc-4b86-9a9c-14ed4a45910e	bfe419da-34d7-4388-bf74-db33de69da67	2026-05-07 21:21:55.154729	2026-05-07 21:21:55.154729
7e86188a-e319-4b70-9a13-fe600b1982eb	IN	1	PO-20260507-71B66475	50572d23-a9dc-4b86-9a9c-14ed4a45910e	987e5121-dfb5-43e8-aa95-8396e14f1060	2026-05-07 22:23:58.183886	2026-05-07 22:23:58.183886
4153b9cf-b30e-4890-884f-13b03afc9f63	IN	6	PO-20260507-1543516E	50572d23-a9dc-4b86-9a9c-14ed4a45910e	987e5121-dfb5-43e8-aa95-8396e14f1060	2026-05-07 22:24:22.851279	2026-05-07 22:24:22.851279
5648b7b9-96cf-49a3-b9bc-e2e58405bb50	IN	10	PO-20260507-D74AF85C	50572d23-a9dc-4b86-9a9c-14ed4a45910e	bfe419da-34d7-4388-bf74-db33de69da67	2026-05-09 23:11:27.151157	2026-05-09 23:11:27.151157
80385f32-a33d-44a4-aeae-d09fc62809f9	IN	1	PO-20260509-4A8445A7	50572d23-a9dc-4b86-9a9c-14ed4a45910e	bfe419da-34d7-4388-bf74-db33de69da67	2026-05-10 01:17:11.235772	2026-05-10 01:17:11.235772
19d535f7-b977-4291-88ef-14a9137b820b	IN	10	PO-20260509-BA7F3768	50572d23-a9dc-4b86-9a9c-14ed4a45910e	d6f7a1d2-1e3b-436d-89b2-2e3188e2ca96	2026-05-10 01:25:33.510386	2026-05-10 01:25:33.510386
e8106ac6-d326-429f-88cf-f7c97c7a6847	IN	10	PO-20260509-6B997DB4	50572d23-a9dc-4b86-9a9c-14ed4a45910e	d6f7a1d2-1e3b-436d-89b2-2e3188e2ca96	2026-05-10 01:29:30.474888	2026-05-10 01:29:30.474888
e16c9531-08e4-4005-8418-e71aeab777d2	IN	1	PO-20260509-1E53E9C1	50572d23-a9dc-4b86-9a9c-14ed4a45910e	d6f7a1d2-1e3b-436d-89b2-2e3188e2ca96	2026-05-10 01:53:28.372731	2026-05-10 01:53:28.372731
3c80144e-7cef-4d65-945c-91d1161c2df9	IN	1	PO-20260510-62C18E12	50572d23-a9dc-4b86-9a9c-14ed4a45910e	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-10 20:34:52.085537	2026-05-10 20:34:52.085537
dbdc1d47-9b72-460b-8917-0f665d61edee	OUT	10	Venta - Orden: DISP-20260513-E21447B2	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-13 05:37:04.277376	2026-05-13 05:37:04.277376
37b7599e-f212-484e-bb76-d9289e88f0ae	OUT	10	Venta - Orden: DISP-20260512-BEB0E57A	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-13 05:53:53.655099	2026-05-13 05:53:53.655099
9b73603a-5fc0-4a47-b4ce-41bddec58285	OUT	10	Venta - Orden: DISP-20260513-A326EC0C	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-13 06:05:19.396945	2026-05-13 06:05:19.396945
7a63f91b-86f9-4576-b23a-c2475f3c27cc	IN	20	PO-20260513-E09173BB	50572d23-a9dc-4b86-9a9c-14ed4a45910e	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-13 06:08:46.252934	2026-05-13 06:08:46.252934
072813d1-cf22-412f-b2d0-71c9bf880c6d	OUT	1	Venta - Orden: DISP-20260513-16AA22A6	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-14 02:52:12.454088	2026-05-14 02:52:12.454088
d3389f6b-676b-454f-a5c9-b2ad3cd632a5	OUT	10	Venta - Orden: DISP-20260513-8CBB2282	1eb92bee-6e92-4f20-8862-d5b699b8c5d1	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-14 02:56:55.868264	2026-05-14 02:56:55.868264
2ee27723-611f-457d-bdb4-55903fdd62aa	IN	4	PO-20260514-F0AF9EDE	50572d23-a9dc-4b86-9a9c-14ed4a45910e	21f1ce11-8967-4eb8-a01a-d9601c54dfd8	2026-05-14 20:32:34.29004	2026-05-14 20:32:34.29004
\.


--
-- Data for Name: supplier_products; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.supplier_products (id, supplier_code, unit_cost, lead_time_days, supplier_id, product_id, created_at, updated_at) FROM stdin;
3c728da1-0ffe-468a-bf3d-47fc2b498fa8	PROV-001	100.00	5	e95dd9f6-7419-47f3-9e05-70f18c2db0f9	4f04eab6-a9b9-4ca5-a08d-e06dd7d7cb70	2026-05-07 20:54:15.282558	2026-05-07 20:54:15.282558
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.suppliers (id, code, business_name, document_type, document_number, contact_name, phone, email, address, city, status, created_at, updated_at) FROM stdin;
0327b498-2fd3-4fc7-9aa0-4622e8b17f11	PROV-322	TEST	RUC	123456789	TEST	1223456789	TEST@gmail.com	Av.Las Palmeras	Arequipa	active	2026-05-13 21:49:20.104716	2026-05-13 21:49:20.104716
d1a540b3-53c4-473f-992d-8a74a552b27d	PRO-005	Repuestos Industriales SAC	RUC	20123456789	Carlos Mendoza	987654321	ventas@repuestos.com	Av. Industrial 123, Lima	Arequipa	active	2026-05-05 21:29:33.718505	2026-05-15 20:12:13.571197
e95dd9f6-7419-47f3-9e05-70f18c2db0f9	PROV-001	AutoSuministros S.A.C	RUC	20512345678	Juan Pérez	987654321	ventas@repuestosindustrial.com	Av. Industrial 123, Lima	Lima	active	2026-05-04 08:04:56.596428	2026-05-15 20:12:17.097429
\.


--
-- Data for Name: technicians; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.technicians (id, first_name, last_name, full_name, email, document_number, document_type, specialty, certification, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_tracks; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.user_tracks (id, os_data, remote_ip, browser_data, aud, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.users (id, email, password_digest, status, avatar, phone, document_number, roleable_type, roleable_id, created_at, updated_at) FROM stdin;
1eb92bee-6e92-4f20-8862-d5b699b8c5d1	temp@test.com	$2a$12$2qnOvvgXrIfazp41ii1Ln.8ub1zYHV0HYGyyqSncUGnEjsyvMpB/K	0	\N	\N	99999999	Admin	35cab582-2715-47ab-ab15-49308936e0af	2026-05-04 02:06:46.651517	2026-05-04 02:06:46.651517
50572d23-a9dc-4b86-9a9c-14ed4a45910e	juan@test.com	$2a$12$vRL2x2MK6DJoyx0ySjb1c..QDUGFnl7DueOJWLQYC.Gdo4eoXNGNq	0	\N	\N	22222222	Admin	51ba9316-2a45-46a6-b567-6fda5ff7ec6b	2026-05-05 21:14:07.671552	2026-05-05 21:14:07.671552
729495cd-f833-4add-9c1c-bcfb0048d1ec	juan2@test.com	$2a$12$rwPFZBgy62ZC8kAeSHChW.plBOCwvOhm/TDsKanLg7Dx1TSNFBPYu	0	\N	\N	33333333	Admin	c356e23a-6cad-41d9-9798-fbd006ab066a	2026-05-05 21:18:24.2708	2026-05-05 21:18:24.2708
8bc26801-9b36-444a-9754-8e3278e06993	carlos.ruiz@rentamax.com	$2a$12$6UfH8XkZLX9YxZwKjLwQN.LqVqGqVqGqVqGqVqGqVqGqVqGqVqGq	1	\N	999888777	12345678	Advisor	76b8c456-12fe-4bf1-bd68-b5a4261119c7	2026-05-12 10:33:24.6434	2026-05-12 10:33:24.6434
a1f2c1d6-d6b3-4e36-ab38-abc1ed600079	patricia.lopez@rentamax.com	$2a$12$6UfH8XkZLX9YxZwKjLwQN.LqVqGqVqGqVqGqVqGqVqGqVqGqVqGq	1	\N	977788899	87654321	Advisor	bc7a199b-b81a-42f8-b689-6954ccea0b84	2026-05-12 10:34:18.639937	2026-05-12 10:34:18.639937
2a671bfb-bf41-4a0c-bc8c-1349923677af	juan.perez@logistica.com	$2a$12$PKXOTzrg3VFmnk/HUR3tF.A8oBWokb1L/ZVyIy/cmEH55duUEPSS.	0	\N	\N	999888777	LogisticsUser	66004442-aa5c-4514-8260-38588dc9952c	2026-05-14 15:35:34.739832	2026-05-14 15:35:34.739832
47cd2452-fb03-4452-9509-4f4efba4f1a7	miguel.rodriguez@rentamax.com	$2a$12$W55hy8OPmcmiX6uHTBQ0I.Q15lpYHe3gjnpL86IxAcPLaDW0gIdma	0	\N	955566677	99887766	LogisticsUser	db89f2e8-57fd-428d-beb0-40e0065c62dc	2026-05-12 12:10:55.65538	2026-05-14 15:39:34.486111
0cbed4bb-08d7-48ac-9847-ca7fd5d00e29	carlos.garcia@rentamax.com	$2a$12$6B3.xgHCFAUt79yqcXN56eYDmwnJsAkSMCEuxtNO/wKAsThubYptC	1	\N	\N	11223344	Warehouseman	15b5ccdf-e255-4f64-81bc-0a20e54e4d9f	2026-05-14 16:15:06.413435	2026-05-14 16:15:06.413435
\.


--
-- Data for Name: vehicle_model_specs; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.vehicle_model_specs (id, key, value, unit, vehicle_model_id, created_at, updated_at) FROM stdin;
47399ab9-8c6c-4d4e-853e-4ca73a013e4a	Profundidad de excavación	6.71	m	8b8f0694-8b33-4765-8fe0-8fdd7b5d2d4c	2026-05-07 17:37:22.594841	2026-05-07 17:37:22.594841
\.


--
-- Data for Name: vehicle_models; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.vehicle_models (id, brand, model, power_hp, weight_ton, capacity_m3, active, vehicle_type_id, created_at, updated_at) FROM stdin;
8b8f0694-8b33-4765-8fe0-8fdd7b5d2d4c	Caterpillar	320D	200.00	20.50	1.20	t	327074aa-6db3-45f0-a6ac-9e43865df225	2026-05-04 01:04:00.860158	2026-05-04 01:04:00.860158
fd1a4d1c-d139-4625-8577-f1338d55323e	Komatsu	Excavadora	158.00	21.00	1.10	t	327074aa-6db3-45f0-a6ac-9e43865df225	2026-05-04 15:36:38.529502	2026-05-04 15:36:38.529502
4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	Caterpillar	950M	215.00	17.60	10.70	t	e4e471d2-4a89-4c84-86de-afc6f7a56b5e	2026-05-04 15:39:22.926029	2026-05-04 15:39:22.926029
d2928050-4e28-4b91-93f8-06727910c423	Komatsu	WA380	213.00	17.30	3.50	t	e4e471d2-4a89-4c84-86de-afc6f7a56b5e	2026-05-04 15:41:46.19358	2026-05-04 15:41:46.19358
86d11710-fb34-4ec2-ad90-b76cc9765fdb	Volvo	A40G	540.00	30.50	24.00	t	0ffa23e4-e6db-4f89-8705-495935e5b95c	2026-05-04 15:45:28.143888	2026-05-04 15:45:28.143888
826554e5-211e-454e-8cf8-9b504a02e021	Bell	B40E	523.00	28.80	23.50	t	0ffa23e4-e6db-4f89-8705-495935e5b95c	2026-05-04 15:45:32.235339	2026-05-04 15:45:32.235339
8a862352-1cc0-41b3-9730-3f4b934fd063	KomatsuTEST	WA380	248.50	18.50	3.50	t	e4e471d2-4a89-4c84-86de-afc6f7a56b5e	2026-05-14 04:00:04.808048	2026-05-14 04:00:04.808048
\.


--
-- Data for Name: vehicle_types; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.vehicle_types (id, name, description, created_at, updated_at) FROM stdin;
327074aa-6db3-45f0-a6ac-9e43865df225	EXCAVADORA DE ORUGAS	Maquinaria pesada para excavación y movimiento de tierras	2026-05-04 00:50:09.940486	2026-05-04 00:50:09.940486
e4e471d2-4a89-4c84-86de-afc6f7a56b5e	CARGADOR FRONTAL	Cargador de ruedas con cucharón frontal de gran capacidad.	2026-05-04 09:18:38.990843	2026-05-04 09:18:38.990843
0ffa23e4-e6db-4f89-8705-495935e5b95c	CAMIÓN ARTICULADO	Camión volquete articulado para transporte en minería y construcción.	2026-05-04 09:19:16.334013	2026-05-04 09:19:16.334013
ed6f0cd1-6436-4976-9045-72f7d7a7e711	MOTONIVELADORA	Máquina para nivelar y perfilar terrenos con hoja central.	2026-05-04 09:19:47.994039	2026-05-04 09:19:47.994039
fe284439-16e6-42fd-a24d-8fac0f312567	TRACTOR	Tractor de oruga para empuje y nivelación de terreno.	2026-05-04 09:20:14.318098	2026-05-04 09:20:14.318098
81194abe-97ed-4689-aba4-d0fc55a1d812	CARGADOR FRONTAL	Maquinaria pesada para carga de materiales	2026-05-14 03:55:11.493807	2026-05-14 03:55:11.493807
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.vehicles (id, product_id, vehicle_model_id, serial, manufacture_year, hours_used, status, price_per_hour, price_per_day, location, created_at, updated_at) FROM stdin;
b0c53920-435d-4378-ae60-71037b808a20	8ae62307-c089-4509-8d80-13259a73339d	4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	CAT-T333ST	2020	120.00	available	50.00	150.00	AV TESTEO	2026-05-10 01:11:18.763505	2026-05-10 01:11:18.763505
b3c9c9bb-77bd-438c-9552-8537d07474a9	fcf98163-de97-4377-96f6-1789c5fbd87a	d2928050-4e28-4b91-93f8-06727910c423	HILUX	2026	25.00	rented	250.00	250.00	Hilux	2026-05-14 01:40:04.753198	2026-05-14 01:40:04.753198
eea2cc86-72bc-4fae-be4a-ca4aa5b21c1e	18e2b3f3-4f73-4fc4-a05b-d82f8a6b9971	4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	CAT950-AQ2023-001	2023	600.00	available	105.00	750.00	Taller Oeste	2026-05-07 18:36:52.877354	2026-05-13 03:43:50.283995
2285777a-ec05-4fb5-98f9-af26152fc38d	a11d4838-86f2-4e42-9c51-c6c04368bd14	fd1a4d1c-d139-4625-8577-f1338d55323e	KOM210-AQ2020-001	2020	600.50	available	105.00	720.00	Taller Oeste	2026-05-07 18:31:17.946248	2026-05-13 03:44:25.409846
ace72053-7c85-4b9f-93b7-dc383a0bf654	4a29c117-408f-4fb4-8cd3-9b8bab13bbdc	4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	CAT320-AQ2021-001	2021	3220.50	available	45.00	300.00	Taller Norte	2026-05-07 18:16:52.682219	2026-05-13 03:45:14.012681
43b8d6ab-9d65-46b2-b070-86393dec2c99	b500c835-8580-4842-9b3e-96387e5f3014	4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	CAT320-AQ2022-002	2022	4220.50	available	110.00	800.00	Taller Sur	2026-05-07 18:21:48.899868	2026-05-13 03:45:27.346362
1644142a-8ad5-451e-888a-e2882391dec5	b19a7579-77fb-47d7-9293-302304aa8a36	4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	DASDASDASDAS	2026	520000.00	rented	50.00	14.00	aea	2026-05-10 20:33:15.388751	2026-05-13 04:54:52.41916
f3395eed-3e03-490e-8eca-0e1063f72026	866436ac-d79b-4dfb-960d-6480b89e40a2	d2928050-4e28-4b91-93f8-06727910c423	HILUZZZZ	2026	250.00	logistic	50.00	50.00	hiluz	2026-05-14 01:51:28.303649	2026-05-14 01:51:28.303649
d5f84dd9-06b7-4f4d-b3ff-52d3317ae4bb	00d34907-a489-4f6b-b501-a2f13a0f4104	4a4b3f83-4fa5-4ff4-bc9e-0208b505323b	CAT-T333STEEEEE	2026	250.00	sold	250.00	49.98	av teesssssst	2026-05-10 17:40:17.037335	2026-05-14 02:56:55.862629
d89623c0-ff5d-4a59-8f2c-1cb0a6cea477	f5744375-193b-439d-8961-156e7a0cb1bb	d2928050-4e28-4b91-93f8-06727910c423	CATERPILLAR2020666	2026	250.00	logistic	50.00	50.00	Bodega Central	2026-05-14 04:04:13.608717	2026-05-14 04:04:13.608717
1ae2d6e9-6069-47a9-baee-353e45f88e5c	24c9d220-b3f8-4232-82ae-e8c07e5b1de3	86d11710-fb34-4ec2-ad90-b76cc9765fdb	CAT-T333STTTTTTT	2026	50.00	available	50.00	50.00	AV TESTEO	2026-05-10 01:27:36.858584	2026-05-13 03:43:09.087666
2cab05ab-6a30-4649-85e2-e7cbdf3ed81f	dda8bcda-aff4-413b-8a43-c615850074f8	86d11710-fb34-4ec2-ad90-b76cc9765fdb	321312321	2026	250.00	available	0.04	0.03	dasdasdas	2026-05-10 21:08:35.550503	2026-05-13 04:38:46.993463
\.


--
-- Data for Name: versions; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.versions (id, whodunnit, created_at, item_id, item_type, event, object, object_changes) FROM stdin;
1	\N	2026-05-14 15:35:34.739832	2	User	create	\N	---\nid:\n-\n- 2a671bfb-bf41-4a0c-bc8c-1349923677af\nemail:\n- ''\n- juan.perez@logistica.com\npassword_digest:\n- ''\n- "$2a$12$PKXOTzrg3VFmnk/HUR3tF.A8oBWokb1L/ZVyIy/cmEH55duUEPSS."\nstatus:\n-\n- 0\ndocument_number:\n- ''\n- '999888777'\nroleable_type:\n-\n- LogisticsUser\nroleable_id:\n-\n- 66004442-aa5c-4514-8260-38588dc9952c\ncreated_at:\n-\n- 2026-05-14 15:35:34.739832000 Z\nupdated_at:\n-\n- 2026-05-14 15:35:34.739832000 Z\n
2	\N	2026-05-14 15:39:34.486111	47	User	update	---\nstatus: 1\npassword_digest: "$2a$12$6UfH8XkZLX9YxZwKjLwQN.LqVqGqVqGqVqGqVqGqVqGqVqGqVqGq"\nid: 47cd2452-fb03-4452-9509-4f4efba4f1a7\nemail: miguel.rodriguez@rentamax.com\navatar:\nphone: '955566677'\ndocument_number: '99887766'\nroleable_type: LogisticsUser\nroleable_id: db89f2e8-57fd-428d-beb0-40e0065c62dc\ncreated_at: 2026-05-12 12:10:55.655380000 Z\nupdated_at: 2026-05-12 12:10:55.655380000 Z\n	---\npassword_digest:\n- "$2a$12$6UfH8XkZLX9YxZwKjLwQN.LqVqGqVqGqVqGqVqGqVqGqVqGqVqGq"\n- "$2a$12$W55hy8OPmcmiX6uHTBQ0I.Q15lpYHe3gjnpL86IxAcPLaDW0gIdma"\nstatus:\n- 1\n- 0\nupdated_at:\n- 2026-05-12 12:10:55.655380000 Z\n- 2026-05-14 15:39:34.486111000 Z\n
3	\N	2026-05-14 16:15:06.413435	0	User	create	\N	---\nid:\n-\n- 0cbed4bb-08d7-48ac-9847-ca7fd5d00e29\nemail:\n- ''\n- carlos.garcia@rentamax.com\npassword_digest:\n- ''\n- "$2a$12$6B3.xgHCFAUt79yqcXN56eYDmwnJsAkSMCEuxtNO/wKAsThubYptC"\nstatus:\n-\n- 1\ndocument_number:\n- ''\n- '11223344'\nroleable_type:\n-\n- Warehouseman\nroleable_id:\n-\n- 15b5ccdf-e255-4f64-81bc-0a20e54e4d9f\ncreated_at:\n-\n- 2026-05-14 16:15:06.413435000 Z\nupdated_at:\n-\n- 2026-05-14 16:15:06.413435000 Z\n
\.


--
-- Data for Name: warehousemen; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.warehousemen (id, first_name, last_name, full_name, email, document_number, document_type, "position", created_at, updated_at) FROM stdin;
15b5ccdf-e255-4f64-81bc-0a20e54e4d9f	Carlos	García	Carlos García	carlos.garcia@rentamax.com	11223344	DNI	Almacenero	2026-05-14 16:15:06.222257	2026-05-14 16:15:06.222257
\.


--
-- Data for Name: work_order_actions; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.work_order_actions (id, action, description, evidence, performed_by_id, work_order_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: work_order_parts; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.work_order_parts (id, quantity, unit_price, work_order_id, product_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: work_orders; Type: TABLE DATA; Schema: public; Owner: egusquiza31
--

COPY public.work_orders (id, code, diagnosis, diagnosis_result, work_order_type, status, scheduled_date, closed_date, maintenance_id, assigned_to_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: egusquiza31
--

SELECT pg_catalog.setval('public.versions_id_seq', 3, true);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: advisors advisors_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.advisors
    ADD CONSTRAINT advisors_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: area_requests area_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.area_requests
    ADD CONSTRAINT area_requests_pkey PRIMARY KEY (id);


--
-- Name: blacklisted_tokens blacklisted_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.blacklisted_tokens
    ADD CONSTRAINT blacklisted_tokens_pkey PRIMARY KEY (id);


--
-- Name: client_advisors client_advisors_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.client_advisors
    ADD CONSTRAINT client_advisors_pkey PRIMARY KEY (id);


--
-- Name: client_contacts client_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.client_contacts
    ADD CONSTRAINT client_contacts_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: customer_assets customer_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.customer_assets
    ADD CONSTRAINT customer_assets_pkey PRIMARY KEY (id);


--
-- Name: delivery_guides delivery_guides_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_guides
    ADD CONSTRAINT delivery_guides_pkey PRIMARY KEY (id);


--
-- Name: delivery_incidents delivery_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_incidents
    ADD CONSTRAINT delivery_incidents_pkey PRIMARY KEY (id);


--
-- Name: dispatch_items dispatch_items_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_items
    ADD CONSTRAINT dispatch_items_pkey PRIMARY KEY (id);


--
-- Name: dispatch_orders dispatch_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_orders
    ADD CONSTRAINT dispatch_orders_pkey PRIMARY KEY (id);


--
-- Name: lead_comments lead_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.lead_comments
    ADD CONSTRAINT lead_comments_pkey PRIMARY KEY (id);


--
-- Name: lead_status_histories lead_status_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.lead_status_histories
    ADD CONSTRAINT lead_status_histories_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: logistics_users logistics_users_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.logistics_users
    ADD CONSTRAINT logistics_users_pkey PRIMARY KEY (id);


--
-- Name: maintenance_reports maintenance_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenance_reports
    ADD CONSTRAINT maintenance_reports_pkey PRIMARY KEY (id);


--
-- Name: maintenances maintenances_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT maintenances_pkey PRIMARY KEY (id);


--
-- Name: managers managers_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (id);


--
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchase_order_items purchase_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT purchase_order_items_pkey PRIMARY KEY (id);


--
-- Name: purchase_orders purchase_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT purchase_orders_pkey PRIMARY KEY (id);


--
-- Name: quotation_comments quotation_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_comments
    ADD CONSTRAINT quotation_comments_pkey PRIMARY KEY (id);


--
-- Name: quotation_files quotation_files_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_files
    ADD CONSTRAINT quotation_files_pkey PRIMARY KEY (id);


--
-- Name: quotation_items quotation_items_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT quotation_items_pkey PRIMARY KEY (id);


--
-- Name: quotation_status_histories quotation_status_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_status_histories
    ADD CONSTRAINT quotation_status_histories_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: rentals rentals_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.rentals
    ADD CONSTRAINT rentals_pkey PRIMARY KEY (id);


--
-- Name: sales_orders sales_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT sales_orders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: spare_part_categories spare_part_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_part_categories
    ADD CONSTRAINT spare_part_categories_pkey PRIMARY KEY (id);


--
-- Name: spare_part_compatibilities spare_part_compatibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_part_compatibilities
    ADD CONSTRAINT spare_part_compatibilities_pkey PRIMARY KEY (id);


--
-- Name: spare_part_specs spare_part_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_part_specs
    ADD CONSTRAINT spare_part_specs_pkey PRIMARY KEY (id);


--
-- Name: spare_parts spare_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_parts
    ADD CONSTRAINT spare_parts_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: supplier_products supplier_products_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT supplier_products_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: technicians technicians_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.technicians
    ADD CONSTRAINT technicians_pkey PRIMARY KEY (id);


--
-- Name: user_tracks user_tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.user_tracks
    ADD CONSTRAINT user_tracks_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicle_model_specs vehicle_model_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicle_model_specs
    ADD CONSTRAINT vehicle_model_specs_pkey PRIMARY KEY (id);


--
-- Name: vehicle_models vehicle_models_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicle_models
    ADD CONSTRAINT vehicle_models_pkey PRIMARY KEY (id);


--
-- Name: vehicle_types vehicle_types_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicle_types
    ADD CONSTRAINT vehicle_types_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: warehousemen warehousemen_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.warehousemen
    ADD CONSTRAINT warehousemen_pkey PRIMARY KEY (id);


--
-- Name: work_order_actions work_order_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_order_actions
    ADD CONSTRAINT work_order_actions_pkey PRIMARY KEY (id);


--
-- Name: work_order_parts work_order_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_order_parts
    ADD CONSTRAINT work_order_parts_pkey PRIMARY KEY (id);


--
-- Name: work_orders work_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT work_orders_pkey PRIMARY KEY (id);


--
-- Name: index_activity_logs_on_user_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_activity_logs_on_user_id ON public.activity_logs USING btree (user_id);


--
-- Name: index_admins_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_admins_on_document_number ON public.admins USING btree (document_number);


--
-- Name: index_advisors_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_advisors_on_code ON public.advisors USING btree (code);


--
-- Name: index_advisors_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_advisors_on_document_number ON public.advisors USING btree (document_number);


--
-- Name: index_area_requests_on_created_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_area_requests_on_created_by_id ON public.area_requests USING btree (created_by_id);


--
-- Name: index_area_requests_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_area_requests_on_quotation_id ON public.area_requests USING btree (quotation_id);


--
-- Name: index_area_requests_on_reviewed_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_area_requests_on_reviewed_by_id ON public.area_requests USING btree (reviewed_by_id);


--
-- Name: index_blacklisted_tokens_on_user_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_blacklisted_tokens_on_user_id ON public.blacklisted_tokens USING btree (user_id);


--
-- Name: index_client_advisors_on_advisor_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_client_advisors_on_advisor_id ON public.client_advisors USING btree (advisor_id);


--
-- Name: index_client_advisors_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_client_advisors_on_client_id ON public.client_advisors USING btree (client_id);


--
-- Name: index_client_contacts_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_client_contacts_on_client_id ON public.client_contacts USING btree (client_id);


--
-- Name: index_clients_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_clients_on_code ON public.clients USING btree (code);


--
-- Name: index_clients_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_clients_on_document_number ON public.clients USING btree (document_number);


--
-- Name: index_customer_assets_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_customer_assets_on_client_id ON public.customer_assets USING btree (client_id);


--
-- Name: index_delivery_guides_on_dispatch_order_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_delivery_guides_on_dispatch_order_id ON public.delivery_guides USING btree (dispatch_order_id);


--
-- Name: index_delivery_guides_on_driver_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_delivery_guides_on_driver_id ON public.delivery_guides USING btree (driver_id);


--
-- Name: index_delivery_guides_on_guide_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_delivery_guides_on_guide_number ON public.delivery_guides USING btree (guide_number);


--
-- Name: index_delivery_guides_on_vehicle_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_delivery_guides_on_vehicle_id ON public.delivery_guides USING btree (vehicle_id);


--
-- Name: index_delivery_incidents_on_delivery_guide_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_delivery_incidents_on_delivery_guide_id ON public.delivery_incidents USING btree (delivery_guide_id);


--
-- Name: index_delivery_incidents_on_reported_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_delivery_incidents_on_reported_by_id ON public.delivery_incidents USING btree (reported_by_id);


--
-- Name: index_dispatch_items_on_dispatch_order_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_dispatch_items_on_dispatch_order_id ON public.dispatch_items USING btree (dispatch_order_id);


--
-- Name: index_dispatch_items_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_dispatch_items_on_product_id ON public.dispatch_items USING btree (product_id);


--
-- Name: index_dispatch_orders_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_dispatch_orders_on_code ON public.dispatch_orders USING btree (code);


--
-- Name: index_dispatch_orders_on_prepared_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_dispatch_orders_on_prepared_by_id ON public.dispatch_orders USING btree (prepared_by_id);


--
-- Name: index_dispatch_orders_on_rental_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_dispatch_orders_on_rental_id ON public.dispatch_orders USING btree (rental_id);


--
-- Name: index_dispatch_orders_on_sales_order_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_dispatch_orders_on_sales_order_id ON public.dispatch_orders USING btree (sales_order_id);


--
-- Name: index_lead_comments_on_lead_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_lead_comments_on_lead_id ON public.lead_comments USING btree (lead_id);


--
-- Name: index_lead_comments_on_user_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_lead_comments_on_user_id ON public.lead_comments USING btree (user_id);


--
-- Name: index_lead_status_histories_on_changed_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_lead_status_histories_on_changed_by_id ON public.lead_status_histories USING btree (changed_by_id);


--
-- Name: index_lead_status_histories_on_lead_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_lead_status_histories_on_lead_id ON public.lead_status_histories USING btree (lead_id);


--
-- Name: index_leads_on_assigned_to_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_leads_on_assigned_to_id ON public.leads USING btree (assigned_to_id);


--
-- Name: index_leads_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_leads_on_client_id ON public.leads USING btree (client_id);


--
-- Name: index_leads_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_leads_on_code ON public.leads USING btree (code);


--
-- Name: index_logistics_users_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_logistics_users_on_document_number ON public.logistics_users USING btree (document_number);


--
-- Name: index_maintenance_reports_on_created_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_maintenance_reports_on_created_by_id ON public.maintenance_reports USING btree (created_by_id);


--
-- Name: index_maintenance_reports_on_maintenance_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_maintenance_reports_on_maintenance_id ON public.maintenance_reports USING btree (maintenance_id);


--
-- Name: index_maintenances_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_maintenances_on_client_id ON public.maintenances USING btree (client_id);


--
-- Name: index_maintenances_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_maintenances_on_code ON public.maintenances USING btree (code);


--
-- Name: index_maintenances_on_customer_asset_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_maintenances_on_customer_asset_id ON public.maintenances USING btree (customer_asset_id);


--
-- Name: index_maintenances_on_enterprise_vehicle_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_maintenances_on_enterprise_vehicle_id ON public.maintenances USING btree (enterprise_vehicle_id);


--
-- Name: index_maintenances_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_maintenances_on_quotation_id ON public.maintenances USING btree (quotation_id);


--
-- Name: index_managers_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_managers_on_document_number ON public.managers USING btree (document_number);


--
-- Name: index_product_images_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_product_images_on_product_id ON public.product_images USING btree (product_id);


--
-- Name: index_products_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_products_on_code ON public.products USING btree (code);


--
-- Name: index_products_on_created_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_products_on_created_by_id ON public.products USING btree (created_by_id);


--
-- Name: index_products_on_updated_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_products_on_updated_by_id ON public.products USING btree (updated_by_id);


--
-- Name: index_purchase_order_items_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_purchase_order_items_on_product_id ON public.purchase_order_items USING btree (product_id);


--
-- Name: index_purchase_order_items_on_purchase_order_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_purchase_order_items_on_purchase_order_id ON public.purchase_order_items USING btree (purchase_order_id);


--
-- Name: index_purchase_orders_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_purchase_orders_on_code ON public.purchase_orders USING btree (code);


--
-- Name: index_purchase_orders_on_requested_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_purchase_orders_on_requested_by_id ON public.purchase_orders USING btree (requested_by_id);


--
-- Name: index_purchase_orders_on_supplier_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_purchase_orders_on_supplier_id ON public.purchase_orders USING btree (supplier_id);


--
-- Name: index_quotation_comments_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_comments_on_quotation_id ON public.quotation_comments USING btree (quotation_id);


--
-- Name: index_quotation_comments_on_user_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_comments_on_user_id ON public.quotation_comments USING btree (user_id);


--
-- Name: index_quotation_files_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_files_on_quotation_id ON public.quotation_files USING btree (quotation_id);


--
-- Name: index_quotation_items_on_customer_asset_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_items_on_customer_asset_id ON public.quotation_items USING btree (customer_asset_id);


--
-- Name: index_quotation_items_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_items_on_product_id ON public.quotation_items USING btree (product_id);


--
-- Name: index_quotation_items_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_items_on_quotation_id ON public.quotation_items USING btree (quotation_id);


--
-- Name: index_quotation_status_histories_on_changed_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_status_histories_on_changed_by_id ON public.quotation_status_histories USING btree (changed_by_id);


--
-- Name: index_quotation_status_histories_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotation_status_histories_on_quotation_id ON public.quotation_status_histories USING btree (quotation_id);


--
-- Name: index_quotations_on_advisor_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotations_on_advisor_id ON public.quotations USING btree (advisor_id);


--
-- Name: index_quotations_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotations_on_client_id ON public.quotations USING btree (client_id);


--
-- Name: index_quotations_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_quotations_on_code ON public.quotations USING btree (code);


--
-- Name: index_quotations_on_lead_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_quotations_on_lead_id ON public.quotations USING btree (lead_id);


--
-- Name: index_refresh_tokens_on_token; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_refresh_tokens_on_token ON public.refresh_tokens USING btree (token);


--
-- Name: index_refresh_tokens_on_user_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_refresh_tokens_on_user_id ON public.refresh_tokens USING btree (user_id);


--
-- Name: index_rentals_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_rentals_on_client_id ON public.rentals USING btree (client_id);


--
-- Name: index_rentals_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_rentals_on_code ON public.rentals USING btree (code);


--
-- Name: index_rentals_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_rentals_on_quotation_id ON public.rentals USING btree (quotation_id);


--
-- Name: index_rentals_on_vehicle_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_rentals_on_vehicle_id ON public.rentals USING btree (vehicle_id);


--
-- Name: index_sales_orders_on_advisor_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_sales_orders_on_advisor_id ON public.sales_orders USING btree (advisor_id);


--
-- Name: index_sales_orders_on_client_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_sales_orders_on_client_id ON public.sales_orders USING btree (client_id);


--
-- Name: index_sales_orders_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_sales_orders_on_code ON public.sales_orders USING btree (code);


--
-- Name: index_sales_orders_on_quotation_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_sales_orders_on_quotation_id ON public.sales_orders USING btree (quotation_id);


--
-- Name: index_spare_part_compatibilities_on_spare_part_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_spare_part_compatibilities_on_spare_part_id ON public.spare_part_compatibilities USING btree (spare_part_id);


--
-- Name: index_spare_part_compatibilities_on_vehicle_model_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_spare_part_compatibilities_on_vehicle_model_id ON public.spare_part_compatibilities USING btree (vehicle_model_id);


--
-- Name: index_spare_part_specs_on_spare_part_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_spare_part_specs_on_spare_part_id ON public.spare_part_specs USING btree (spare_part_id);


--
-- Name: index_spare_parts_on_part_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_spare_parts_on_part_number ON public.spare_parts USING btree (part_number);


--
-- Name: index_spare_parts_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_spare_parts_on_product_id ON public.spare_parts USING btree (product_id);


--
-- Name: index_spare_parts_on_spare_part_category_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_spare_parts_on_spare_part_category_id ON public.spare_parts USING btree (spare_part_category_id);


--
-- Name: index_stock_movements_on_performed_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_stock_movements_on_performed_by_id ON public.stock_movements USING btree (performed_by_id);


--
-- Name: index_stock_movements_on_spare_part_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_stock_movements_on_spare_part_id ON public.stock_movements USING btree (spare_part_id);


--
-- Name: index_supplier_products_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_supplier_products_on_product_id ON public.supplier_products USING btree (product_id);


--
-- Name: index_supplier_products_on_supplier_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_supplier_products_on_supplier_id ON public.supplier_products USING btree (supplier_id);


--
-- Name: index_suppliers_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_suppliers_on_code ON public.suppliers USING btree (code);


--
-- Name: index_suppliers_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_suppliers_on_document_number ON public.suppliers USING btree (document_number);


--
-- Name: index_technicians_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_technicians_on_document_number ON public.technicians USING btree (document_number);


--
-- Name: index_user_tracks_on_user_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_user_tracks_on_user_id ON public.user_tracks USING btree (user_id);


--
-- Name: index_users_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_users_on_document_number ON public.users USING btree (document_number);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_phone; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_users_on_phone ON public.users USING btree (phone);


--
-- Name: index_users_on_roleable; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_users_on_roleable ON public.users USING btree (roleable_type, roleable_id);


--
-- Name: index_vehicle_model_specs_on_vehicle_model_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_vehicle_model_specs_on_vehicle_model_id ON public.vehicle_model_specs USING btree (vehicle_model_id);


--
-- Name: index_vehicle_models_on_vehicle_type_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_vehicle_models_on_vehicle_type_id ON public.vehicle_models USING btree (vehicle_type_id);


--
-- Name: index_vehicles_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_vehicles_on_product_id ON public.vehicles USING btree (product_id);


--
-- Name: index_vehicles_on_serial; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_vehicles_on_serial ON public.vehicles USING btree (serial);


--
-- Name: index_vehicles_on_vehicle_model_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_vehicles_on_vehicle_model_id ON public.vehicles USING btree (vehicle_model_id);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: index_warehousemen_on_document_number; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_warehousemen_on_document_number ON public.warehousemen USING btree (document_number);


--
-- Name: index_work_order_actions_on_performed_by_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_work_order_actions_on_performed_by_id ON public.work_order_actions USING btree (performed_by_id);


--
-- Name: index_work_order_actions_on_work_order_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_work_order_actions_on_work_order_id ON public.work_order_actions USING btree (work_order_id);


--
-- Name: index_work_order_parts_on_product_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_work_order_parts_on_product_id ON public.work_order_parts USING btree (product_id);


--
-- Name: index_work_order_parts_on_work_order_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_work_order_parts_on_work_order_id ON public.work_order_parts USING btree (work_order_id);


--
-- Name: index_work_orders_on_assigned_to_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_work_orders_on_assigned_to_id ON public.work_orders USING btree (assigned_to_id);


--
-- Name: index_work_orders_on_code; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE UNIQUE INDEX index_work_orders_on_code ON public.work_orders USING btree (code);


--
-- Name: index_work_orders_on_maintenance_id; Type: INDEX; Schema: public; Owner: egusquiza31
--

CREATE INDEX index_work_orders_on_maintenance_id ON public.work_orders USING btree (maintenance_id);


--
-- Name: stock_movements fk_rails_01eda0a955; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT fk_rails_01eda0a955 FOREIGN KEY (spare_part_id) REFERENCES public.spare_parts(id);


--
-- Name: vehicle_model_specs fk_rails_02b2c506dc; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicle_model_specs
    ADD CONSTRAINT fk_rails_02b2c506dc FOREIGN KEY (vehicle_model_id) REFERENCES public.vehicle_models(id);


--
-- Name: area_requests fk_rails_074f974a9c; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.area_requests
    ADD CONSTRAINT fk_rails_074f974a9c FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: lead_status_histories fk_rails_0a7676a3b6; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.lead_status_histories
    ADD CONSTRAINT fk_rails_0a7676a3b6 FOREIGN KEY (lead_id) REFERENCES public.leads(id);


--
-- Name: dispatch_items fk_rails_0c0447f59f; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_items
    ADD CONSTRAINT fk_rails_0c0447f59f FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: dispatch_orders fk_rails_0fed8e5645; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_orders
    ADD CONSTRAINT fk_rails_0fed8e5645 FOREIGN KEY (rental_id) REFERENCES public.rentals(id);


--
-- Name: quotation_comments fk_rails_185c4d1e60; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_comments
    ADD CONSTRAINT fk_rails_185c4d1e60 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: quotation_items fk_rails_19f58012b0; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT fk_rails_19f58012b0 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_images fk_rails_1c991d3be6; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT fk_rails_1c991d3be6 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: purchase_orders fk_rails_1d67bb2d7b; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT fk_rails_1d67bb2d7b FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: quotations fk_rails_1ec34a68a5; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT fk_rails_1ec34a68a5 FOREIGN KEY (advisor_id) REFERENCES public.advisors(id);


--
-- Name: sales_orders fk_rails_21ac35bd7b; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT fk_rails_21ac35bd7b FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: maintenances fk_rails_22829b5f82; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT fk_rails_22829b5f82 FOREIGN KEY (enterprise_vehicle_id) REFERENCES public.vehicles(id);


--
-- Name: refresh_tokens fk_rails_279e9a0091; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT fk_rails_279e9a0091 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: lead_status_histories fk_rails_27e7525f26; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.lead_status_histories
    ADD CONSTRAINT fk_rails_27e7525f26 FOREIGN KEY (changed_by_id) REFERENCES public.users(id);


--
-- Name: delivery_guides fk_rails_29771e29c2; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_guides
    ADD CONSTRAINT fk_rails_29771e29c2 FOREIGN KEY (driver_id) REFERENCES public.logistics_users(id);


--
-- Name: products fk_rails_2e9b78a2e7; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_rails_2e9b78a2e7 FOREIGN KEY (updated_by_id) REFERENCES public.users(id);


--
-- Name: delivery_guides fk_rails_2eefbd1295; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_guides
    ADD CONSTRAINT fk_rails_2eefbd1295 FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id);


--
-- Name: spare_part_compatibilities fk_rails_35472bc139; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_part_compatibilities
    ADD CONSTRAINT fk_rails_35472bc139 FOREIGN KEY (vehicle_model_id) REFERENCES public.vehicle_models(id);


--
-- Name: quotations fk_rails_36967ab08f; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT fk_rails_36967ab08f FOREIGN KEY (lead_id) REFERENCES public.leads(id);


--
-- Name: work_order_actions fk_rails_3d63418c5e; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_order_actions
    ADD CONSTRAINT fk_rails_3d63418c5e FOREIGN KEY (work_order_id) REFERENCES public.work_orders(id);


--
-- Name: delivery_guides fk_rails_3e6737cb00; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_guides
    ADD CONSTRAINT fk_rails_3e6737cb00 FOREIGN KEY (dispatch_order_id) REFERENCES public.dispatch_orders(id);


--
-- Name: dispatch_orders fk_rails_40a946038e; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_orders
    ADD CONSTRAINT fk_rails_40a946038e FOREIGN KEY (prepared_by_id) REFERENCES public.users(id);


--
-- Name: customer_assets fk_rails_4e96133548; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.customer_assets
    ADD CONSTRAINT fk_rails_4e96133548 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: work_order_actions fk_rails_555db8273d; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_order_actions
    ADD CONSTRAINT fk_rails_555db8273d FOREIGN KEY (performed_by_id) REFERENCES public.technicians(id);


--
-- Name: work_order_parts fk_rails_5bb1b0a968; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_order_parts
    ADD CONSTRAINT fk_rails_5bb1b0a968 FOREIGN KEY (work_order_id) REFERENCES public.work_orders(id);


--
-- Name: sales_orders fk_rails_5c3688ef39; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT fk_rails_5c3688ef39 FOREIGN KEY (advisor_id) REFERENCES public.advisors(id);


--
-- Name: work_orders fk_rails_5f87acb881; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT fk_rails_5f87acb881 FOREIGN KEY (maintenance_id) REFERENCES public.maintenances(id);


--
-- Name: quotation_items fk_rails_62757dc7bc; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT fk_rails_62757dc7bc FOREIGN KEY (customer_asset_id) REFERENCES public.customer_assets(id);


--
-- Name: work_orders fk_rails_70d64c0f49; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_orders
    ADD CONSTRAINT fk_rails_70d64c0f49 FOREIGN KEY (assigned_to_id) REFERENCES public.technicians(id);


--
-- Name: work_order_parts fk_rails_74d1f2be2c; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.work_order_parts
    ADD CONSTRAINT fk_rails_74d1f2be2c FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: lead_comments fk_rails_75cda4d75a; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.lead_comments
    ADD CONSTRAINT fk_rails_75cda4d75a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: leads fk_rails_76674cac6b; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_rails_76674cac6b FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: client_contacts fk_rails_766917a6b6; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.client_contacts
    ADD CONSTRAINT fk_rails_766917a6b6 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: spare_parts fk_rails_769146d401; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_parts
    ADD CONSTRAINT fk_rails_769146d401 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: delivery_incidents fk_rails_78f91eefcb; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_incidents
    ADD CONSTRAINT fk_rails_78f91eefcb FOREIGN KEY (delivery_guide_id) REFERENCES public.delivery_guides(id);


--
-- Name: maintenances fk_rails_7bec3fc513; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT fk_rails_7bec3fc513 FOREIGN KEY (customer_asset_id) REFERENCES public.customer_assets(id);


--
-- Name: dispatch_orders fk_rails_7c580c9220; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_orders
    ADD CONSTRAINT fk_rails_7c580c9220 FOREIGN KEY (sales_order_id) REFERENCES public.sales_orders(id);


--
-- Name: delivery_incidents fk_rails_7e438e0bc6; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.delivery_incidents
    ADD CONSTRAINT fk_rails_7e438e0bc6 FOREIGN KEY (reported_by_id) REFERENCES public.users(id);


--
-- Name: quotation_files fk_rails_7eb5457d5d; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_files
    ADD CONSTRAINT fk_rails_7eb5457d5d FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: area_requests fk_rails_7ff3e484f7; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.area_requests
    ADD CONSTRAINT fk_rails_7ff3e484f7 FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: dispatch_items fk_rails_81c80adeeb; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.dispatch_items
    ADD CONSTRAINT fk_rails_81c80adeeb FOREIGN KEY (dispatch_order_id) REFERENCES public.dispatch_orders(id);


--
-- Name: vehicles fk_rails_83f60c4d50; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT fk_rails_83f60c4d50 FOREIGN KEY (vehicle_model_id) REFERENCES public.vehicle_models(id);


--
-- Name: purchase_orders fk_rails_8464c566e9; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.purchase_orders
    ADD CONSTRAINT fk_rails_8464c566e9 FOREIGN KEY (requested_by_id) REFERENCES public.users(id);


--
-- Name: blacklisted_tokens fk_rails_84eb108184; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.blacklisted_tokens
    ADD CONSTRAINT fk_rails_84eb108184 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: spare_parts fk_rails_8c0cb694ef; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_parts
    ADD CONSTRAINT fk_rails_8c0cb694ef FOREIGN KEY (spare_part_category_id) REFERENCES public.spare_part_categories(id);


--
-- Name: spare_part_specs fk_rails_8caf59e650; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_part_specs
    ADD CONSTRAINT fk_rails_8caf59e650 FOREIGN KEY (spare_part_id) REFERENCES public.spare_parts(id);


--
-- Name: supplier_products fk_rails_8e1c65b71a; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT fk_rails_8e1c65b71a FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- Name: sales_orders fk_rails_8ef5a42bfb; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.sales_orders
    ADD CONSTRAINT fk_rails_8ef5a42bfb FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: user_tracks fk_rails_99e944edbc; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.user_tracks
    ADD CONSTRAINT fk_rails_99e944edbc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: supplier_products fk_rails_9a363579c5; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.supplier_products
    ADD CONSTRAINT fk_rails_9a363579c5 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: maintenance_reports fk_rails_9e1fccd087; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenance_reports
    ADD CONSTRAINT fk_rails_9e1fccd087 FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: maintenance_reports fk_rails_a0986851a8; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenance_reports
    ADD CONSTRAINT fk_rails_a0986851a8 FOREIGN KEY (maintenance_id) REFERENCES public.maintenances(id);


--
-- Name: area_requests fk_rails_a80b51ed02; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.area_requests
    ADD CONSTRAINT fk_rails_a80b51ed02 FOREIGN KEY (reviewed_by_id) REFERENCES public.users(id);


--
-- Name: maintenances fk_rails_ab260edd67; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT fk_rails_ab260edd67 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: products fk_rails_aefb4f3a33; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_rails_aefb4f3a33 FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: quotation_comments fk_rails_c28dfc080a; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_comments
    ADD CONSTRAINT fk_rails_c28dfc080a FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: lead_comments fk_rails_c62051e885; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.lead_comments
    ADD CONSTRAINT fk_rails_c62051e885 FOREIGN KEY (lead_id) REFERENCES public.leads(id);


--
-- Name: activity_logs fk_rails_c9badf82db; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT fk_rails_c9badf82db FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: purchase_order_items fk_rails_d9bc69e4b3; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT fk_rails_d9bc69e4b3 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: quotation_status_histories fk_rails_d9e2b2c258; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_status_histories
    ADD CONSTRAINT fk_rails_d9e2b2c258 FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotation_status_histories fk_rails_df5f4e19e6; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_status_histories
    ADD CONSTRAINT fk_rails_df5f4e19e6 FOREIGN KEY (changed_by_id) REFERENCES public.users(id);


--
-- Name: quotation_items fk_rails_e38f77754f; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotation_items
    ADD CONSTRAINT fk_rails_e38f77754f FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: stock_movements fk_rails_e3e848d430; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.stock_movements
    ADD CONSTRAINT fk_rails_e3e848d430 FOREIGN KEY (performed_by_id) REFERENCES public.users(id);


--
-- Name: vehicles fk_rails_e40a89ee36; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT fk_rails_e40a89ee36 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: maintenances fk_rails_e6368dbecc; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.maintenances
    ADD CONSTRAINT fk_rails_e6368dbecc FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: vehicle_models fk_rails_e64af80885; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.vehicle_models
    ADD CONSTRAINT fk_rails_e64af80885 FOREIGN KEY (vehicle_type_id) REFERENCES public.vehicle_types(id);


--
-- Name: leads fk_rails_e68b669097; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_rails_e68b669097 FOREIGN KEY (assigned_to_id) REFERENCES public.advisors(id);


--
-- Name: client_advisors fk_rails_eae40c65ea; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.client_advisors
    ADD CONSTRAINT fk_rails_eae40c65ea FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: rentals fk_rails_ede3db960f; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.rentals
    ADD CONSTRAINT fk_rails_ede3db960f FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: rentals fk_rails_f01d550491; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.rentals
    ADD CONSTRAINT fk_rails_f01d550491 FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: client_advisors fk_rails_f239dbdc9e; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.client_advisors
    ADD CONSTRAINT fk_rails_f239dbdc9e FOREIGN KEY (advisor_id) REFERENCES public.advisors(id);


--
-- Name: purchase_order_items fk_rails_f247068a39; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.purchase_order_items
    ADD CONSTRAINT fk_rails_f247068a39 FOREIGN KEY (purchase_order_id) REFERENCES public.purchase_orders(id);


--
-- Name: rentals fk_rails_f32ed36f5d; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.rentals
    ADD CONSTRAINT fk_rails_f32ed36f5d FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id);


--
-- Name: spare_part_compatibilities fk_rails_f87ec5a15e; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.spare_part_compatibilities
    ADD CONSTRAINT fk_rails_f87ec5a15e FOREIGN KEY (spare_part_id) REFERENCES public.spare_parts(id);


--
-- Name: quotations fk_rails_fe0f05c203; Type: FK CONSTRAINT; Schema: public; Owner: egusquiza31
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT fk_rails_fe0f05c203 FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- PostgreSQL database dump complete
--

\unrestrict IwdKPH9YEAMZTNXVXrZ7eUNaQs55XWDXQuhsd4jX4axUESuLVWSKRsJHv8Gw9hg


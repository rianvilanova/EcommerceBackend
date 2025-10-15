CREATE TABLE IF NOT EXISTS "public"."customers" (
    "id" "uuid" NOT NULL,
    "first_name" "text",
    "last_name" "text",
    "address" "text"
);

CREATE TABLE IF NOT EXISTS "public"."orders" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "customer_id" "uuid" NOT NULL,
    "total" numeric(8,2) NOT NULL,
    "status" "public"."order_status" DEFAULT 'Pendente'::"public"."order_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."order_items" (
    "id" bigint NOT NULL,
    "order_id" "uuid" NOT NULL,
    "product_id" "uuid" NOT NULL,
    "quantity" integer NOT NULL,
    "unit_price" numeric(8,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."products" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text" DEFAULT 'Sem descrição'::"text" NOT NULL,
    "price" numeric(8,2) NOT NULL,
    "stock" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
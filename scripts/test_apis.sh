#!/bin/bash
# =============================================================================
# SCRIPT DE VERIFICACIÓN DE APIs - ERP CAT
# Uso: bash scripts/test_apis.sh
# Prerequisito: El servidor debe estar corriendo en localhost:3000
#               Haber ejecutado: rails runner scripts/seed_masivo.rb
# =============================================================================

BASE="http://localhost:3000/api/v1"
PASS=0
FAIL=0
SKIP=0

# ─── Colores ───────────────────────────────────────────────
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Helpers ───────────────────────────────────────────────
check() {
  local label="$1"
  local expected="$2"
  local status="$3"
  local body="$4"

  if [[ "$status" == "$expected" ]]; then
    echo -e "  ${GREEN}✅ PASS${NC} [$status] $label"
    ((PASS++))
  else
    echo -e "  ${RED}❌ FAIL${NC} [$status] $label"
    echo -e "     ${YELLOW}Response: $(echo "$body" | head -c 200)${NC}"
    ((FAIL++))
  fi
}

get() {
  local url="$1"
  local token="$2"
  local resp
  resp=$(curl -s -w "\n%{http_code}" -H "Authorization: Bearer $token" -H "Content-Type: application/json" "$url")
  echo "$resp"
}

post() {
  local url="$1"
  local data="$2"
  local token="$3"
  local resp
  if [[ -n "$token" ]]; then
    resp=$(curl -s -w "\n%{http_code}" -X POST -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$data" "$url")
  else
    resp=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -d "$data" "$url")
  fi
  echo "$resp"
}

put() {
  local url="$1"
  local data="$2"
  local token="$3"
  local resp
  resp=$(curl -s -w "\n%{http_code}" -X PUT -H "Authorization: Bearer $token" -H "Content-Type: application/json" -d "$data" "$url")
  echo "$resp"
}

extract_status() { echo "$1" | tail -1; }
extract_body()   { echo "$1" | head -n -1; }
extract_token()  { echo "$1" | python3 -c "import sys,json; d=sys.stdin.read(); lines=d.split('\n'); body='\n'.join(lines[:-1]); print(json.loads(body).get('access_token',''))" 2>/dev/null; }
extract_json()   { echo "$1" | python3 -c "import sys,json; d=sys.stdin.read(); lines=d.split('\n'); body='\n'.join(lines[:-1]); data=json.loads(body); k='$2'; print(data.get(k,'') or (data.get('data',[{}])[0].get('id','') if isinstance(data.get('data',[]),list) else data.get('data',{}).get('id','')))" 2>/dev/null; }

echo ""
echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║       VERIFICACIÓN DE APIs - ERP CAT                    ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# AUTENTICACIÓN
# =============================================================================
echo -e "${CYAN}━━━ 🔐 AUTENTICACIÓN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Login Admin
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000001","password":"10000001"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login Admin (10000001)" "200" "$STATUS" "$BODY"
TOKEN_ADMIN=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Login Manager
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000002","password":"10000002"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login Manager (10000002)" "200" "$STATUS" "$BODY"
TOKEN_MANAGER=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Login Advisor
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000003","password":"10000003"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login Advisor (10000003)" "200" "$STATUS" "$BODY"
TOKEN_ADVISOR=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Login Technician
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000004","password":"10000004"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login Technician (10000004)" "200" "$STATUS" "$BODY"
TOKEN_TECH=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Login Logistics
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000005","password":"10000005"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login LogisticsUser (10000005)" "200" "$STATUS" "$BODY"
TOKEN_LOG=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Login Warehouse
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000006","password":"10000006"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login Warehouseman (10000006)" "200" "$STATUS" "$BODY"
TOKEN_WH=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Login Client
RESP=$(post "$BASE/general/users/sign_in" '{"user":{"document_number":"10000007","password":"10000007"}}')
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "Login Client (10000007)" "200" "$STATUS" "$BODY"
TOKEN_CLIENT=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('access_token',''))" 2>/dev/null)

# Verificar que tenemos token de admin
if [[ -z "$TOKEN_ADMIN" ]]; then
  echo -e "\n${RED}❌ No se pudo obtener el token de Admin. Verifica que el seed fue ejecutado y que el servidor está corriendo.${NC}"
  echo -e "${YELLOW}   Comando: rails runner scripts/seed_masivo.rb${NC}"
  exit 1
fi

echo ""

# =============================================================================
# ADMIN APIs
# =============================================================================
echo -e "${CYAN}━━━ 👑 ADMIN APIs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Vehicle Types
RESP=$(get "$BASE/admin/vehicle_types" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "GET /admin/vehicle_types" "200" "$STATUS" "$BODY"

RESP=$(post "$BASE/admin/vehicle_types" '{"vehicle_type":{"name":"Grúa Test","description":"Test grúa"}}' "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "POST /admin/vehicle_types" "200 201" "$STATUS" "$BODY"

# Vehicle Models
RESP=$(get "$BASE/admin/vehicle_models" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "GET /admin/vehicle_models" "200" "$STATUS" "$BODY"

# Vehicles
RESP=$(get "$BASE/admin/vehicles" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "GET /admin/vehicles" "200" "$STATUS" "$BODY"

# Products
RESP=$(get "$BASE/admin/products" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "GET /admin/products" "200" "$STATUS" "$BODY"
PRODUCT_ID=$(echo "$BODY" | python3 -c "import sys,json; d=json.load(sys.stdin); items=d.get('data',[]); print(items[0]['id'] if items else '')" 2>/dev/null)

if [[ -n "$PRODUCT_ID" ]]; then
  RESP=$(get "$BASE/admin/products/$PRODUCT_ID" "$TOKEN_ADMIN")
  STATUS=$(extract_status "$RESP")
  check "GET /admin/products/:id" "200" "$STATUS" ""
fi

# Spare Part Categories
RESP=$(get "$BASE/admin/spare_part_categories" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/spare_part_categories" "200" "$STATUS" ""

RESP=$(post "$BASE/admin/spare_part_categories" '{"spare_part_category":{"name":"Test Cat","description":"Categoría de prueba"}}' "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "POST /admin/spare_part_categories" "200 201" "$STATUS" ""

# Spare Parts
RESP=$(get "$BASE/admin/spare_parts" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/spare_parts" "200" "$STATUS" ""

# Suppliers
RESP=$(get "$BASE/admin/suppliers" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/suppliers" "200" "$STATUS" ""

RESP=$(post "$BASE/admin/suppliers" '{"supplier":{"business_name":"Proveedor Test S.A.","document_type":"RUC","document_number":"20999000001","contact_name":"Test","phone":"01-9999999","email":"test@proveedor.com","city":"Lima","status":"active"}}' "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP"); BODY=$(extract_body "$RESP")
check "POST /admin/suppliers" "200 201" "$STATUS" "$BODY"

# Clients
RESP=$(get "$BASE/admin/clients" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/clients" "200" "$STATUS" ""

RESP=$(post "$BASE/admin/clients" '{"client":{"business_name":"Cliente API Test","document_type":"RUC","document_number":"20999888001","contact_name":"Test API","email":"apitest@cliente.com","status":"active","city":"Lima"}}' "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "POST /admin/clients" "200 201" "$STATUS" ""

# Leads
RESP=$(get "$BASE/admin/leads" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/leads" "200" "$STATUS" ""

# Quotations
RESP=$(get "$BASE/admin/quotations" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/quotations" "200" "$STATUS" ""

# Purchase Orders
RESP=$(get "$BASE/admin/purchase_orders" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/purchase_orders" "200" "$STATUS" ""

# Dispatch Orders
RESP=$(get "$BASE/admin/dispatch_orders" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/dispatch_orders" "200" "$STATUS" ""

# Stock Movements
RESP=$(get "$BASE/admin/stock_movements" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/stock_movements" "200" "$STATUS" ""

# Delivery Guides
RESP=$(get "$BASE/admin/delivery_guides" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/delivery_guides" "200" "$STATUS" ""

# Delivery Incidents
RESP=$(get "$BASE/admin/delivery_incidents" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/delivery_incidents" "200" "$STATUS" ""

# Logistics Users
RESP=$(get "$BASE/admin/logistics_users" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/logistics_users" "200" "$STATUS" ""

# Warehousemen
RESP=$(get "$BASE/admin/warehousemen" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/warehousemen" "200" "$STATUS" ""

# Area Requests
RESP=$(get "$BASE/admin/area_requests" "$TOKEN_ADMIN")
STATUS=$(extract_status "$RESP")
check "GET /admin/area_requests" "200" "$STATUS" ""

echo ""

# =============================================================================
# MANAGER APIs
# =============================================================================
echo -e "${CYAN}━━━ 📊 MANAGER APIs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

RESP=$(get "$BASE/manager/clients" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/clients" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/leads" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/leads" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/quotations" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/quotations" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/area_requests" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/area_requests" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/maintenances" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/maintenances" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/work_orders" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/work_orders" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/work_order_actions" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/work_order_actions" "200" "$STATUS" ""

RESP=$(get "$BASE/manager/work_order_parts" "$TOKEN_MANAGER")
STATUS=$(extract_status "$RESP")
check "GET /manager/work_order_parts" "200" "$STATUS" ""

echo ""

# =============================================================================
# ADVISOR APIs
# =============================================================================
echo -e "${CYAN}━━━ 💼 ADVISOR APIs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

RESP=$(get "$BASE/advisor/clients" "$TOKEN_ADVISOR")
STATUS=$(extract_status "$RESP")
check "GET /advisor/clients" "200" "$STATUS" ""

RESP=$(get "$BASE/advisor/leads" "$TOKEN_ADVISOR")
STATUS=$(extract_status "$RESP")
check "GET /advisor/leads" "200" "$STATUS" ""

RESP=$(get "$BASE/advisor/quotations" "$TOKEN_ADVISOR")
STATUS=$(extract_status "$RESP")
check "GET /advisor/quotations" "200" "$STATUS" ""

RESP=$(get "$BASE/advisor/area_requests" "$TOKEN_ADVISOR")
STATUS=$(extract_status "$RESP")
check "GET /advisor/area_requests" "200" "$STATUS" ""

echo ""

# =============================================================================
# LOGISTIC USER APIs
# =============================================================================
echo -e "${CYAN}━━━ 🚚 LOGISTIC USER APIs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

RESP=$(get "$BASE/logistic_user/suppliers" "$TOKEN_LOG")
STATUS=$(extract_status "$RESP")
check "GET /logistic_user/suppliers" "200" "$STATUS" ""

RESP=$(get "$BASE/logistic_user/purchase_orders" "$TOKEN_LOG")
STATUS=$(extract_status "$RESP")
check "GET /logistic_user/purchase_orders" "200" "$STATUS" ""

RESP=$(get "$BASE/logistic_user/purchase_order_items" "$TOKEN_LOG")
STATUS=$(extract_status "$RESP")
check "GET /logistic_user/purchase_order_items" "200" "$STATUS" ""

RESP=$(get "$BASE/logistic_user/products" "$TOKEN_LOG")
STATUS=$(extract_status "$RESP")
check "GET /logistic_user/products" "200" "$STATUS" ""

echo ""

# =============================================================================
# WAREHOUSE APIs
# =============================================================================
echo -e "${CYAN}━━━ 🏭 WAREHOUSE APIs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

RESP=$(get "$BASE/warehouse/products" "$TOKEN_WH")
STATUS=$(extract_status "$RESP")
check "GET /warehouse/products" "200" "$STATUS" ""

RESP=$(get "$BASE/warehouse/purchase_orders" "$TOKEN_WH")
STATUS=$(extract_status "$RESP")
check "GET /warehouse/purchase_orders" "200" "$STATUS" ""

RESP=$(get "$BASE/warehouse/dispatch_items" "$TOKEN_WH")
STATUS=$(extract_status "$RESP")
check "GET /warehouse/dispatch_items" "200" "$STATUS" ""

RESP=$(get "$BASE/warehouse/suppliers" "$TOKEN_WH")
STATUS=$(extract_status "$RESP")
check "GET /warehouse/suppliers" "200" "$STATUS" ""

echo ""

# =============================================================================
# CLIENT APIs
# =============================================================================
echo -e "${CYAN}━━━ 👤 CLIENT APIs ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

RESP=$(get "$BASE/client/portal/quotations" "$TOKEN_CLIENT")
STATUS=$(extract_status "$RESP")
check "GET /client/portal/quotations" "200" "$STATUS" ""

RESP=$(get "$BASE/client/portal/maintenances" "$TOKEN_CLIENT")
STATUS=$(extract_status "$RESP")
check "GET /client/portal/maintenances" "200" "$STATUS" ""

RESP=$(get "$BASE/client/portal/orders" "$TOKEN_CLIENT")
STATUS=$(extract_status "$RESP")
check "GET /client/portal/orders" "200" "$STATUS" ""

echo ""

# =============================================================================
# RESUMEN
# =============================================================================
TOTAL=$((PASS + FAIL))
echo -e "${BOLD}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║                    RESUMEN FINAL                        ║${NC}"
echo -e "${BOLD}╠══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}║  ${GREEN}PASS: $PASS${NC}${BOLD}   ${RED}FAIL: $FAIL${NC}${BOLD}   TOTAL: $TOTAL                       ║${NC}"
echo -e "${BOLD}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

if [[ "$FAIL" -eq 0 ]]; then
  echo -e "${GREEN}🎉 ¡Todas las APIs funcionan correctamente!${NC}"
else
  echo -e "${RED}⚠️  Hay $FAIL API(s) con errores. Revisa los detalles arriba.${NC}"
fi
echo ""

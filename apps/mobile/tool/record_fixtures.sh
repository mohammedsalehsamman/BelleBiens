#!/usr/bin/env bash
# Records test fixtures from the local API (apps/api, seeded: pnpm --filter @belle/api seed).
# Answers that depend on the time of day are normalized so tests do not:
# the shop is always "open, 10:00 - 24:00" in the fixtures.
set -euo pipefail
cd "$(dirname "$0")/.."
B=${API:-http://localhost:3000/v1}
C=test/fixtures/catalog
D=test/fixtures/designer
mkdir -p "$C" "$D"
get() { curl -sf "$B/$1" -o "$2"; }
get home "$C/home.json"
get "products?pageSize=20" "$C/products.json"
get "products?pageSize=0&occasion=love" "$C/count.json"
get products/red-rose-bouquet "$C/product_bouquet.json"
get products/rose-pistachio-cake "$C/product_cake.json"
get products/iced-rose-matcha-latte "$C/product_drink.json"
get "search?q=%D8%AC%D9%88%D8%B1%D9%8A" "$C/search.json"
get daily-flowers "$C/daily.json"
get occasions/birthday "$C/occasion.json"
get catalog/filters "$C/filters.json"
get branch "$C/branch.json"
get pages/delivery "$C/page.json"
get app/config "$C/app_config.json"
get designer/catalog "$D/catalog.json"
post() { curl -sf -X POST "$B/$1" -H 'content-type: application/json' -d "$2" -o "$3"; }
# The README bouquet (screen 18) and the FR-DSG-03 case (8 gypsophila, 6 left).
post designer/quote '{"spec":{"schemaVersion":1,"occasion":"birthday","size":"medium","flowers":[{"id":"red_rose","qty":12},{"id":"white_gypsophila","qty":6}],"greens":[{"id":"eucalyptus","qty":3}],"wrap":"satin_bordeaux","ribbon":"satin_pink","extras":[{"id":"teddy_bear_small","qty":1}]}}' "$D/quote_readme.json"
post designer/quote '{"spec":{"schemaVersion":1,"occasion":"birthday","size":"medium","flowers":[{"id":"red_rose","qty":12},{"id":"white_gypsophila","qty":8}],"wrap":"satin_bordeaux","ribbon":"satin_pink"}}' "$D/quote_short.json"
E=test/fixtures/cart
mkdir -p "$E"
get boxes/catalog "$E/boxes.json"
# The README cart (screen 20): design + 2 lattes + a 22 cm cake with a candle = 7,116.
post cart/quote '{"lines":[{"id":"l1","kind":"design","qty":1,"spec":{"schemaVersion":1,"occasion":"birthday","size":"medium","flowers":[{"id":"red_rose","qty":12},{"id":"white_gypsophila","qty":6}],"greens":[{"id":"eucalyptus","qty":3}],"wrap":"satin_bordeaux","ribbon":"satin_pink","extras":[{"id":"teddy_bear_small","qty":1}],"cardMessage":"كل عام وأنتِ أجمل يا لين"}},{"id":"l2","kind":"product","qty":2,"product":{"slug":"iced-rose-matcha-latte","options":[]}},{"id":"l3","kind":"product","qty":1,"product":{"slug":"rose-pistachio-cake","options":[{"group":"size","option":"22cm"},{"group":"extras","option":"birthday-candle"}],"inscription":"كل عام وأنت بخير"}}]}' "$E/quote_readme.json"
node -e '
const fs = require("fs");
const open = { mode: "open", openNow: true, opensAt: "10:00", closesAt: "24:00" };
for (const [file, at] of [["test/fixtures/catalog/home.json", (j) => j.branch], ["test/fixtures/catalog/branch.json", (j) => j]]) {
  const j = JSON.parse(fs.readFileSync(file, "utf8"));
  at(j).status = open;
  fs.writeFileSync(file, JSON.stringify(j));
}
'
echo "Fixtures recorded from $B"

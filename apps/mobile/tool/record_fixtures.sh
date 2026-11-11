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

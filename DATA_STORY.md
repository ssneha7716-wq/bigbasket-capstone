# BigBasket Category Performance — Data Story

*Based on `monthly_category_revenue.csv` (Jan–Jun 2026, Delivered orders only) and the
category-target variance computed in `03_reporting.sql`, Task 5(c).*

## Category status against target

| Category | Delivered Revenue (₹) | Target (₹) | Variance vs Target | Status |
|---|---:|---:|---:|---|
| Household Essentials | 21,715 | 17,000 | +27.7% | **Above Target** |
| Bakery | 15,410 | 12,000 | +28.4% | **Above Target** |
| Personal Care | 16,382 | 15,500 | +5.7% | **Above Target** |
| Dairy & Eggs | 14,090 | 16,500 | −14.6% | **Below Target – Watch** |
| Snacks & Beverages | 10,895 | 13,000 | −16.2% | **Below Target – Critical** |
| Fruits & Vegetables | 9,790 | 12,000 | −18.4% | **Below Target – Critical** |

Three of six categories are ahead of target, led by Household Essentials and Bakery, both
more than 27% over their monthly goal. The two categories furthest behind — Fruits &
Vegetables and Snacks & Beverages — are both more than 15% under target and are flagged
Critical.

## Recommendations for the category team

1. **Invest catalog/marketing effort in Fruits & Vegetables.** It is the single furthest
   category below target (−18.4%) despite carrying five everyday, high-repeat-purchase
   SKUs (bananas, tomatoes, onions, apples, spinach). Low average order value here (an
   average delivered order in this category is well under ₹200) suggests customers are
   buying small, single-item baskets rather than being upsold into a fuller produce
   basket — a "build your basket" bundle promotion or a delivery-fee waiver above a
   modest produce basket size is a low-cost lever to test first.

2. **Review Snacks & Beverages' supplier/product mix.** This category has the highest
   order *count* of any category (83 delivered orders) but the lowest total revenue
   (₹10,895) and the lowest average order value of any category — customers are
   ordering snacks frequently but in small amounts. Rather than a marketing push, this
   points to a margin/assortment problem: work with SnackHub India and BakeHouse
   Supplies to introduce higher-value multipacks or combo SKUs so the same order
   frequency converts into more revenue per order.

*(Dairy & Eggs sits closer to target and in "Watch" status rather than "Critical" — worth
monitoring over the next reporting cycle rather than an immediate intervention.)*

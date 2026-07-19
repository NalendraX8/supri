# UI_UX.md - Supri POS UI/UX Design Specification

## 1. Screen List
1. **Login Page:** Clean login card, input fields with autocomplete support, password visibility toggles, and clear error banners.
2. **Outlet Selection Page:** Simple list of available outlets assigned to the logged-in cashier.
3. **Sales Checkout (Main Dashboard):**
   * Left/Main area: Search bar, category filters (chips), and scrollable product grid.
   * Right/Drawer area (or bottom sheet on phones): Order cart summary, quantity adjustments, discount inputs, and payment checkout button.
4. **Kas shifts Drawer (Drawer Manager):** Active shift info, cash-in/out form fields, and cash register balance totals.
5. **Transaction History Log:** Tab-based scroll list showing Synced vs Offline transactions, search by transaction number, and details popup.
6. **Shift Recap (Rekapitulasi):** Sales reports, payment category splits, cash drawer reconciliation totals, and closing cash button.

---

## 2. Navigation Flow
The navigation employs a simple, persistent bottom navigation bar (`NavigationBar`) on phone viewports:
* **Sales** (Cart & Checkout) -> Default Landing.
* **Kas** (Shift management, Cash flow entries).
* **History** (Sales logs, Sync statuses).
* **Rekap** (Shift summary, closure details).
* **Settings** (App modes, printer configurations).

---

## 3. Responsive Layout Strategy
* **Compact Viewports (Phones):** Uses bottom sheets for cart checkout, collapsible drawers for menus, and single/double-column product grids.
* **Medium/Wide Viewports (Tablets):** Split-screen layout displaying the product catalog grid and active cart side-by-side to minimize navigation clicks during rushes.
* Uses **`flutter_screenutil`** for proportional font sizing and dynamic padding scaling.

---

## 4. Accessibility & UI Guidelines
* **Target Sizes:** Touch targets are kept to a minimum height/width of 48dp.
* **Contrasts:** Deep black/charcoal backgrounds for action bars, and vibrant red (`AppColors.primary`) primary indicators ensuring high visibility.
* **Font Legibility:** Employs clean sans-serif layouts via Google Fonts (e.g., Inter or Roboto).

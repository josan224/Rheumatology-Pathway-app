# UCB Pathway Stakeholder Tool

A web-based stakeholder mapping and clinical pathway tool built for the UCB Rheumatology therapy area. It allows the team to record, track and visualise key stakeholders across the RA, PsA and Plaque Psoriasis pathways, and map them against a 13-step clinical pathway.

---

## What the tool does

The tool is split into six tabs:

- **Dashboard** — a summary overview showing total stakeholders, high-priority contacts, advocacy levels and indication coverage, displayed as charts and stat cards.
- **Stakeholders** — a register of all recorded clinicians and contacts. You can add, edit, filter and export stakeholders from here.
- **Pathway Map** — a grid view of all 13 clinical pathway steps, showing condition-specific variations for RA, PsA and Plaque Psoriasis, along with the lead and supporting roles at each step.
- **Quadrant** — a scatter chart plotting all stakeholders by their Impact and Influence ratings, so you can see at a glance who the highest-priority contacts are.
- **Pains & Gains** — a section for recording the key frustrations and motivations for each clinical role (Consultant, Nurse, Pharmacist, GP, Radiologist). Templates are pre-loaded for each role and can be edited before saving.
- **Flow Diagram** — a vertical visual flow of the 13-step pathway, grouped into clinical phases, with lead and supporting roles shown on each step card. This is the default view when you open the tool.

---

## How data is stored — Supabase

After you sign in with **email and password**, stakeholder data, pathway role overrides, and pains & gains entries are saved to **your Supabase project** (PostgreSQL). Each user only sees and edits **their own rows** (enforced with **Row Level Security**).

Setup for new environments:

1. Follow **[docs/USER_AUTH_BACKEND.md](docs/USER_AUTH_BACKEND.md)** for Auth and API keys (`SB_URL`, `SB_ANON_KEY` in `index.html`).
2. Run **[docs/supabase_schema.sql](docs/supabase_schema.sql)** once in the Supabase SQL Editor to create the `stakeholders`, `pathway_roles`, and `pains_gains` tables.

### If something stops saving or loading

- Confirm **SB_URL** and **SB_ANON_KEY** are set in `index.html` and match your Supabase project.
- Confirm the SQL schema has been applied and you are **signed in** (the API uses your session token).
- Open the browser **developer console** on the failing page for error details.

---

## How to update content in the tool

Most content updates can be made directly in the `index.html` file in GitHub, without any technical knowledge. The sections below explain where to find the relevant parts.

### Updating the pathway steps

The 13 pathway steps are defined in a section of the code labelled:

```
3. PATHWAY STEPS DATA
```

Each step looks like this:

```javascript
{ step:1, core:"Recognition and referral to specialist service", ra:"Recognition of inflammatory arthritis symptoms", psa:"...", pp:"...", lead:"GP" },
```

To change the wording of a step, find the relevant line and edit the text inside the quotation marks. Do not change the field names themselves (e.g. `core:`, `ra:`, `psa:`), only the text after them.

### Updating the pains and gains templates

The pre-written content that loads when you select a role in the Pains & Gains tab is stored in a section labelled:

```
19. PAINS & GAINS TEMPLATES
```

Each role has a `pain` and a `gain` block. To update the content for a role, find it by name (e.g. `Consultant:`, `Nurse:`) and edit the bullet points inside the backtick marks. Keep the bullet point format (starting with `•`) so it displays correctly in the tool.

### Adding a new therapy area

The Dermatology and Osteoporosis cards on the landing page are currently marked as "coming soon". When a new therapy area is ready to be built out, speak to Joe — this requires code changes beyond simple content edits.

---

## Deployment — GitHub and Netlify

The tool is a single HTML file (`index.html`) hosted via **Netlify**, which is connected directly to this **GitHub** repository. When a change is made to `index.html` in the `main` branch on GitHub, Netlify automatically picks it up and publishes the updated version of the site within a minute or two.

### Making a content update

1. Open the `index.html` file in this GitHub repository
2. Click the pencil icon (Edit this file) in the top right
3. Make your changes
4. Scroll to the bottom and click **Commit changes**
5. The site will update automatically shortly after

> ⚠️ If you need to do anything beyond editing content — such as changing how the site is deployed, connecting a new Supabase project, updating API credentials, or making structural changes to the code — **please speak to Joe** rather than attempting it directly.

---

## Therapy areas

| Therapy area | Status |
|---|---|
| Rheumatology | ✅ Live |
| Dermatology | 🔜 Coming soon |
| Osteoporosis | 🔜 Coming soon |

---

## Questions or issues

For anything related to the tool — whether it's a bug, a content change you are unsure about, or a new feature request — speak to Joe in the first instance.

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

## How data is stored — Airtable

All data entered into the tool is saved to and loaded from **Airtable**, an online database. You do not need to access Airtable directly to use the tool — everything is managed through the tool interface itself. However, it is useful to know how it is structured.

### Tables

There are three tables in the Airtable base:

| Table | What it stores |
|---|---|
| `Stakeholders` | All registered stakeholders and their details |
| `PathwayRoles` | The lead and supporting roles assigned to each of the 13 pathway steps |
| `PainsGains` | The saved pains and gains entries, grouped by clinical role |

### Fields — Stakeholders table

| Field name | What it is |
|---|---|
| Organisation | The NHS Trust or Health Board |
| Name | The stakeholder's name |
| Title | Their title or seniority (e.g. Specialist, Lead) |
| Role | Consultant, GP, Nurse, Pharmacist, or Other |
| Indication | RA, PsA, Plaque Psoriasis, or Multiple / All |
| Impact | High, Medium or Low |
| Influence | High, Medium or Low |
| Advocacy | Their current advocacy level (Unaware through to Advocacy) |
| Steps | Which of the 13 pathway steps they are involved in |
| Key Interests | Their areas of clinical interest |
| Engagement Strategy | How you plan to engage them |
| Notes | Any additional context |

### If something stops saving or loading

If the tool stops saving data or shows an error message, it is most likely one of two things:

1. **The Airtable API token has expired.** The token is a long string of characters near the top of the `index.html` file, on the line that begins `const AT_TOKEN =`. If this needs updating, speak to Joe.
2. **The Airtable base has been moved or renamed.** The base ID is on the line directly below, beginning `const AT_BASE =`. Again, speak to Joe if this needs changing.

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

> ⚠️ If you need to do anything beyond editing content — such as changing how the site is deployed, connecting a new Airtable base, updating API credentials, or making structural changes to the code — **please speak to Joe** rather than attempting it directly.

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

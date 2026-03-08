# Record of Processing Activities (Draft)

## Controller / system context

Project: CiCwtch

Current repository stage: internal development / Phase 1 CRUD prototype.

## Processing inventory

| Processing area | Data subjects | Main data | Purpose | Storage |
|---|---|---|---|---|
| Client management | clients / pet owners | names, phone, email, address link, emergency contact data, notes | manage customer records and service delivery | D1 |
| Dog management | client pets | dog identity, breed, sex, DOB, microchip, vet, medical and behavioural notes | manage pet records and operational suitability | D1 |
| Walker management | staff / contractors | names, phone, email, role, start date, notes | manage worker records | D1 |
| Walk scheduling | clients, dogs, walkers | assignments, dates, times, status, service notes | run scheduled services | D1 |
| Invoice headers | clients | invoice number, client linkage, issue/due dates, status, notes | operational billing records | D1 |
| Invoice lines | clients, walks | descriptions, quantities, monetary values, walk linkage | itemised billing records | D1 |
| Attachments (schema only) | clients / dogs / walkers / walks | metadata for files, object keys, mime types | future attachment support | D1 + future R2 |
| Audit log (schema only) | actors tied to system actions | actor and change summary metadata | future traceability | D1 |

## Special-category / higher-risk data present

Potentially sensitive data is already represented in schema/design, especially:

- dog medical notes
- dog behavioural notes
- access notes on addresses
- free-text notes across multiple entities

These are not special-category personal data in every case, but they can carry sensitive operational or household details and should be treated with care.

## Recipients / processors

Current technical processors:

- Cloudflare Workers / D1
- GitHub (source code and CI)

Future likely processor:

- Cloudflare R2 for attachments

## International transfer note

Cloudflare is a global provider. Before production, the deployment and storage regions, contractual safeguards, and transfer-risk position must be explicitly documented.

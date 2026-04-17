# Customer notes and activity timeline

This document describes how the customer detail UI maps to the Supabase schema for notes and timeline history.

## Tables

### `public.customers`

Relevant fields:

- `id`
- `user_id`
- `name`
- `notes`
- `created_at`

`customers.notes` is still treated as a single summary note. It is shown in the UI, but it is not the historical notes feed.

### `public.customer_notes`

Purpose: append-only note history for each customer.

Columns:

- `id`
- `customer_id` -> `customers.id`
- `user_id` -> `auth.users.id`
- `body`
- `created_at`

Behavior:

- one customer can have many notes
- notes are listed newest first
- notes are created from the customer detail screen

### `public.customer_activities`

Added in migration `006_customer_activities.sql`.

Purpose: persistent activity timeline for customer-related events.

Columns:

- `id`
- `customer_id` -> `customers.id`
- `user_id` -> `auth.users.id`
- `type`
- `body`
- `related_task_id` -> `tasks.id`
- `related_property_id` -> `properties.id`
- `metadata` JSONB
- `created_at`

Supported `type` values:

- `customer_created`
- `note_added`
- `task_linked`
- `property_matched`
- `property_shared`

## How the UI uses the schema

Customer detail is split into two data-backed areas:

- Notes tab:
  - writes new records to `customer_notes`
  - reads `customer_notes` ordered by `created_at desc`
  - still shows legacy `customers.notes` as a separate summary card when present
- History tab:
  - reads `customer_activities` ordered by `created_at desc`
  - renders a timeline row per event

## How activity events are created

### Database-triggered events

Handled inside `006_customer_activities.sql`:

- customer creation -> `customer_created`
- note insert -> `note_added`
- task insert/update with `customer_id` -> `task_linked`

### App-triggered events

Handled in Flutter when the user performs feature actions:

- sync matches -> `property_matched`
- share property from customer detail -> `property_shared`
- share property from property detail -> `property_shared`
- sync matched customers from property detail -> `property_matched`

## Relationships

- one `customers` row has many `customer_notes`
- one `customers` row has many `customer_activities`
- one `tasks` row can be referenced by many activity rows over time
- one `properties` row can be referenced by many activity rows over time

## Assumptions and limitations

- `customers.notes` remains in place for backwards compatibility and summary text only.
- Historical notes should be created in `customer_notes`, not by overwriting `customers.notes`.
- `property_matched` de-duplication is best-effort per customer/property pair in the app logger.
- `property_shared` events are intentionally append-only and can appear multiple times if the same property is shared repeatedly.
- Notes and activities are filtered by `user_id`, consistent with the existing Supabase access pattern.
- Admin access in the separate Refine panel relies on `profiles.is_admin = true`.

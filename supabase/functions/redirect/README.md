# Redirect edge function

This function resolves a short code and increments aggregate click counters.

## URL

`/functions/v1/redirect?c={short_code}`

## Required secrets

Set these in Supabase before deployment:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`

## Deploy

From the `hestora` folder:

```bash
supabase functions deploy redirect
```

Set secrets with either the CLI or the dashboard:

```bash
supabase secrets set SUPABASE_URL="https://YOUR_PROJECT.supabase.co"
supabase secrets set SUPABASE_SERVICE_ROLE_KEY="YOUR_SERVICE_ROLE_KEY"
```

## Data handling and KVKK-safe behavior

- The function does not write IP addresses.
- The function does not write location, device, or user-agent data.
- The function does not create visitor profiles.
- It only calls `public.track_redirect_click(text)`, which increments:
  - `redirect_links.click_count`
  - `properties.share_click_count`
- No request payload is stored beyond those aggregate counters.

## Logging

Runtime logs are intentionally minimal and structured:

- `requestId`
- event name
- HTTP status
- optional error code/type

The logs do not include:

- IP address
- location
- user agent
- redirect target URL
- personal contact data

## Verification checklist

1. Confirm migration `003_redirect_and_templates.sql` is applied.
2. Confirm the function secrets are set.
3. Open a valid short link and verify it returns `302`.
4. Confirm only aggregate counters increase in `redirect_links` and `properties`.
5. Confirm no analytics table or personal tracking fields are created.

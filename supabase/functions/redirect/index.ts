import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const baseHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Cache-Control": "no-store",
  "Referrer-Policy": "no-referrer",
};

function responseHeaders(
  requestId: string,
  extra: Record<string, string> = {},
): Headers {
  return new Headers({
    ...baseHeaders,
    "x-request-id": requestId,
    ...extra,
  });
}

function textResponse(body: string, status: number, requestId: string): Response {
  return new Response(body, {
    status,
    headers: responseHeaders(requestId),
  });
}

function logEvent(
  level: "info" | "warn" | "error",
  event: string,
  requestId: string,
  details: Record<string, unknown> = {},
) {
  console[level](
    JSON.stringify({
      event,
      requestId,
      ...details,
    }),
  );
}

function isRedirectTargetAllowed(target: string): boolean {
  try {
    const url = new URL(target);
    return url.protocol === "http:" || url.protocol === "https:";
  } catch (_) {
    return false;
  }
}

Deno.serve(async (req) => {
  const requestId = crypto.randomUUID();

  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: responseHeaders(requestId) });
  }

  if (req.method !== "GET" && req.method !== "HEAD") {
    logEvent("warn", "redirect_method_not_allowed", requestId, {
      status: 405,
      method: req.method,
    });
    return textResponse("Method not allowed", 405, requestId);
  }

  try {
    const url = new URL(req.url);
    const code = url.searchParams.get("c")?.trim();
    if (!code) {
      logEvent("warn", "redirect_missing_code", requestId, { status: 400 });
      return textResponse("Missing c", 400, requestId);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    if (!supabaseUrl || !serviceKey) {
      logEvent("error", "redirect_missing_env", requestId, { status: 500 });
      return textResponse("Server misconfigured", 500, requestId);
    }

    const supabase = createClient(supabaseUrl, serviceKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const { data, error } = await supabase.rpc("track_redirect_click", {
      p_short_code: code,
    });

    if (error) {
      logEvent("error", "redirect_tracking_failed", requestId, {
        status: 500,
        errorCode: error.code ?? null,
      });
      return textResponse("Internal error", 500, requestId);
    }

    if (data == null || typeof data !== "object") {
      logEvent("info", "redirect_not_found", requestId, { status: 404 });
      return textResponse("Not found", 404, requestId);
    }

    const raw = data as Record<string, unknown>;
    const target = raw["target_url"];
    if (typeof target !== "string" || !isRedirectTargetAllowed(target)) {
      logEvent("warn", "redirect_invalid_target", requestId, { status: 404 });
      return textResponse("Not found", 404, requestId);
    }

    logEvent("info", "redirect_success", requestId, { status: 302 });
    return new Response(null, {
      status: 302,
      headers: responseHeaders(requestId, { Location: target }),
    });
  } catch (error) {
    logEvent("error", "redirect_unhandled_error", requestId, {
      status: 500,
      errorType: error instanceof Error ? error.name : "unknown",
    });
    return textResponse("Internal error", 500, requestId);
  }
});

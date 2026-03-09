import { route } from "./router";
import { jsonError } from "./response";
import { ApiError } from "./errors";
import { handlePreflight, withCorsHeaders } from "./cors";

export interface Env {
  DB: D1Database;
  CICWTCH_ATTACHMENTS: R2Bucket;
  API_BEARER_TOKEN?: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method === "OPTIONS") {
      return handlePreflight(request);
    }

    let response: Response;
    try {
      response = await route(request, env);
    } catch (err) {
      if (err instanceof ApiError) {
        response = jsonError(err.message, err.type, err.status);
      } else {
        response = jsonError("Internal server error", "internal_error", 500);
      }
    }

    return withCorsHeaders(response, request);
  },
} satisfies ExportedHandler<Env>;

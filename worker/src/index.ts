import { route } from "./router";
import { jsonError } from "./response";
import { ApiError } from "./errors";

export interface Env {
  DB: D1Database;
  CICWTCH_ATTACHMENTS: R2Bucket;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    try {
      return await route(request, env);
    } catch (err) {
      if (err instanceof ApiError) {
        return jsonError(err.message, err.type, err.status);
      }
      return jsonError("Internal server error", "internal_error", 500);
    }
  },
} satisfies ExportedHandler<Env>;

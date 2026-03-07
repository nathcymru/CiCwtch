export interface Env {
  DB: D1Database;
}

const HEALTH_RESPONSE = {
  status: "ok",
  service: "cicwtch-api",
};

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    void env;

    const url = new URL(request.url);

    if (url.pathname === "/health" || url.pathname === "/api/v1/health") {
      return Response.json(HEALTH_RESPONSE);
    }

    return Response.json({ error: "Not found" }, { status: 404 });
  },
} satisfies ExportedHandler<Env>;

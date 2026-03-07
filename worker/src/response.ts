const JSON_HEADERS = { "Content-Type": "application/json" };

export function jsonOk(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: JSON_HEADERS,
  });
}

export function jsonError(
  message: string,
  type: string,
  status: number,
): Response {
  return new Response(
    JSON.stringify({ error: { message, type } }),
    { status, headers: JSON_HEADERS },
  );
}

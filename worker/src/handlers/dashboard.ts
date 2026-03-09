import type { Env } from "../index";
import { jsonOk } from "../response";

interface CountResult {
  count: number;
}

export async function getDashboard(
  _request: Request,
  env: Env,
): Promise<Response> {
  const [
    clientsTotal,
    dogsTotal,
    walksTotal,
    walksToday,
    walksUpcoming,
    walkersTotal,
    invoicesTotal,
    invoicesOutstanding,
  ] = await Promise.all([
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM clients WHERE archived_at IS NULL",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM dogs WHERE archived_at IS NULL",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL AND scheduled_date = date('now')",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM walks WHERE archived_at IS NULL AND scheduled_date > date('now')",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM walkers WHERE archived_at IS NULL",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM invoice_headers WHERE archived_at IS NULL",
    ).first<CountResult>(),
    env.DB.prepare(
      "SELECT COUNT(*) AS count FROM invoice_headers WHERE archived_at IS NULL AND status = 'issued'",
    ).first<CountResult>(),
  ]);

  return jsonOk({
    clients: { total: clientsTotal?.count ?? 0 },
    dogs: { total: dogsTotal?.count ?? 0 },
    walks: {
      total: walksTotal?.count ?? 0,
      today: walksToday?.count ?? 0,
      upcoming: walksUpcoming?.count ?? 0,
    },
    walkers: { total: walkersTotal?.count ?? 0 },
    invoices: {
      total: invoicesTotal?.count ?? 0,
      outstanding: invoicesOutstanding?.count ?? 0,
    },
  });
}

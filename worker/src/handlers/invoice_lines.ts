import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { ApiError } from "../errors";

function optionalString(
  body: Record<string, unknown>,
  key: string,
): string | null {
  return typeof body[key] === "string" ? (body[key] as string) : null;
}

interface InvoiceLineRow {
  id: string;
  invoice_header_id: string;
  walk_id: string | null;
  description: string;
  quantity: number;
  unit_price_minor: number;
  line_total_minor: number;
  sort_order: number;
  created_at: string;
  updated_at: string;
}

export async function listInvoiceLines(
  _request: Request,
  env: Env,
): Promise<Response> {
  const { results } = await env.DB.prepare(
    "SELECT * FROM invoice_lines ORDER BY invoice_header_id ASC, sort_order ASC",
  ).all<InvoiceLineRow>();
  return jsonOk(results ?? []);
}

export async function getInvoiceLine(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const line = await env.DB.prepare(
    "SELECT * FROM invoice_lines WHERE id = ?1",
  )
    .bind(params.id)
    .first<InvoiceLineRow>();

  if (!line) {
    throw ApiError.notFound();
  }

  return jsonOk(line);
}

export async function createInvoiceLine(
  request: Request,
  env: Env,
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const invoiceHeaderId = body["invoice_header_id"];
  if (typeof invoiceHeaderId !== "string" || invoiceHeaderId.trim() === "") {
    return jsonError("invoice_header_id is required", "invalid_request", 400);
  }

  const headerExists = await env.DB.prepare(
    "SELECT id FROM invoice_headers WHERE id = ?1 AND archived_at IS NULL",
  )
    .bind(invoiceHeaderId.trim())
    .first<{ id: string }>();

  if (!headerExists) {
    return jsonError("invoice header not found", "invalid_request", 400);
  }

  const description = body["description"];
  if (typeof description !== "string" || description.trim() === "") {
    return jsonError("description is required", "invalid_request", 400);
  }

  const walkIdValue = body["walk_id"];
  let walkId: string | null = null;
  if (
    walkIdValue !== undefined &&
    walkIdValue !== null &&
    walkIdValue !== ""
  ) {
    if (typeof walkIdValue !== "string") {
      return jsonError("walk_id must be a string", "invalid_request", 400);
    }
    const walkExists = await env.DB.prepare(
      "SELECT id FROM walks WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(walkIdValue)
      .first<{ id: string }>();
    if (!walkExists) {
      return jsonError("walk not found", "invalid_request", 400);
    }
    walkId = walkIdValue;
  }

  const quantityValue = body["quantity"];
  let quantity = 1;
  if (quantityValue !== undefined && quantityValue !== null) {
    if (typeof quantityValue !== "number" || quantityValue <= 0) {
      return jsonError(
        "quantity must be a positive number",
        "invalid_request",
        400,
      );
    }
    quantity = quantityValue;
  }

  const unitPriceValue = body["unit_price_minor"];
  let unitPriceMinor = 0;
  if (unitPriceValue !== undefined && unitPriceValue !== null) {
    if (
      typeof unitPriceValue !== "number" ||
      unitPriceValue < 0 ||
      !Number.isInteger(unitPriceValue)
    ) {
      return jsonError(
        "unit_price_minor must be a non-negative integer",
        "invalid_request",
        400,
      );
    }
    unitPriceMinor = unitPriceValue;
  }

  const lineTotalValue = body["line_total_minor"];
  let lineTotalMinor = 0;
  if (lineTotalValue !== undefined && lineTotalValue !== null) {
    if (
      typeof lineTotalValue !== "number" ||
      lineTotalValue < 0 ||
      !Number.isInteger(lineTotalValue)
    ) {
      return jsonError(
        "line_total_minor must be a non-negative integer",
        "invalid_request",
        400,
      );
    }
    lineTotalMinor = lineTotalValue;
  }

  const sortOrderValue = body["sort_order"];
  let sortOrder = 0;
  if (sortOrderValue !== undefined && sortOrderValue !== null) {
    if (
      typeof sortOrderValue !== "number" ||
      !Number.isInteger(sortOrderValue)
    ) {
      return jsonError(
        "sort_order must be an integer",
        "invalid_request",
        400,
      );
    }
    sortOrder = sortOrderValue;
  }

  const id = crypto.randomUUID();
  const now = new Date().toISOString();

  const line: InvoiceLineRow = {
    id,
    invoice_header_id: invoiceHeaderId.trim(),
    walk_id: walkId,
    description: description.trim(),
    quantity,
    unit_price_minor: unitPriceMinor,
    line_total_minor: lineTotalMinor,
    sort_order: sortOrder,
    created_at: now,
    updated_at: now,
  };

  await env.DB.prepare(
    `INSERT INTO invoice_lines (
      id, invoice_header_id, walk_id, description, quantity,
      unit_price_minor, line_total_minor, sort_order, created_at, updated_at
    ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10)`,
  )
    .bind(
      line.id,
      line.invoice_header_id,
      line.walk_id,
      line.description,
      line.quantity,
      line.unit_price_minor,
      line.line_total_minor,
      line.sort_order,
      line.created_at,
      line.updated_at,
    )
    .run();

  return jsonOk(line, 201);
}

export async function updateInvoiceLine(
  request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  let body: Record<string, unknown>;
  try {
    body = await request.json();
  } catch {
    return jsonError("Invalid JSON body", "invalid_request", 400);
  }

  const existing = await env.DB.prepare(
    "SELECT * FROM invoice_lines WHERE id = ?1",
  )
    .bind(params.id)
    .first<InvoiceLineRow>();

  if (!existing) {
    throw ApiError.notFound();
  }

  if (body["invoice_header_id"] !== undefined) {
    const invoiceHeaderId = body["invoice_header_id"];
    if (
      typeof invoiceHeaderId !== "string" ||
      invoiceHeaderId.trim() === ""
    ) {
      return jsonError("invoice_header_id is required", "invalid_request", 400);
    }
    const headerExists = await env.DB.prepare(
      "SELECT id FROM invoice_headers WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(invoiceHeaderId.trim())
      .first<{ id: string }>();
    if (!headerExists) {
      return jsonError("invoice header not found", "invalid_request", 400);
    }
  }

  const walkIdValue = body["walk_id"];
  if (
    walkIdValue !== undefined &&
    walkIdValue !== null &&
    walkIdValue !== ""
  ) {
    if (typeof walkIdValue !== "string") {
      return jsonError("walk_id must be a string", "invalid_request", 400);
    }
    const walkExists = await env.DB.prepare(
      "SELECT id FROM walks WHERE id = ?1 AND archived_at IS NULL",
    )
      .bind(walkIdValue)
      .first<{ id: string }>();
    if (!walkExists) {
      return jsonError("walk not found", "invalid_request", 400);
    }
  }

  if (body["quantity"] !== undefined && body["quantity"] !== null) {
    const q = body["quantity"];
    if (typeof q !== "number" || q <= 0) {
      return jsonError(
        "quantity must be a positive number",
        "invalid_request",
        400,
      );
    }
  }

  if (
    body["unit_price_minor"] !== undefined &&
    body["unit_price_minor"] !== null
  ) {
    const u = body["unit_price_minor"];
    if (typeof u !== "number" || u < 0 || !Number.isInteger(u)) {
      return jsonError(
        "unit_price_minor must be a non-negative integer",
        "invalid_request",
        400,
      );
    }
  }

  if (
    body["line_total_minor"] !== undefined &&
    body["line_total_minor"] !== null
  ) {
    const l = body["line_total_minor"];
    if (typeof l !== "number" || l < 0 || !Number.isInteger(l)) {
      return jsonError(
        "line_total_minor must be a non-negative integer",
        "invalid_request",
        400,
      );
    }
  }

  if (body["sort_order"] !== undefined && body["sort_order"] !== null) {
    const s = body["sort_order"];
    if (typeof s !== "number" || !Number.isInteger(s)) {
      return jsonError(
        "sort_order must be an integer",
        "invalid_request",
        400,
      );
    }
  }

  const now = new Date().toISOString();

  const invoiceHeaderId =
    typeof body["invoice_header_id"] === "string" && body["invoice_header_id"]
      ? (body["invoice_header_id"] as string).trim()
      : existing.invoice_header_id;

  let walkId: string | null = existing.walk_id;
  if (body["walk_id"] !== undefined) {
    walkId =
      typeof walkIdValue === "string" && walkIdValue
        ? walkIdValue
        : null;
  }

  const description =
    typeof body["description"] === "string" && body["description"]
      ? (body["description"] as string).trim()
      : existing.description;

  const quantity =
    typeof body["quantity"] === "number" && body["quantity"] > 0
      ? (body["quantity"] as number)
      : existing.quantity;

  const unitPriceMinor =
    typeof body["unit_price_minor"] === "number" &&
    body["unit_price_minor"] >= 0
      ? (body["unit_price_minor"] as number)
      : existing.unit_price_minor;

  const lineTotalMinor =
    typeof body["line_total_minor"] === "number" &&
    body["line_total_minor"] >= 0
      ? (body["line_total_minor"] as number)
      : existing.line_total_minor;

  const sortOrder =
    typeof body["sort_order"] === "number"
      ? (body["sort_order"] as number)
      : existing.sort_order;

  await env.DB.prepare(
    `UPDATE invoice_lines SET
      invoice_header_id = ?1,
      walk_id = ?2,
      description = ?3,
      quantity = ?4,
      unit_price_minor = ?5,
      line_total_minor = ?6,
      sort_order = ?7,
      updated_at = ?8
    WHERE id = ?9`,
  )
    .bind(
      invoiceHeaderId,
      walkId,
      description,
      quantity,
      unitPriceMinor,
      lineTotalMinor,
      sortOrder,
      now,
      params.id,
    )
    .run();

  const updated = await env.DB.prepare(
    "SELECT * FROM invoice_lines WHERE id = ?1",
  )
    .bind(params.id)
    .first<InvoiceLineRow>();

  if (!updated) {
    throw ApiError.notFound();
  }

  return jsonOk(updated);
}

export async function deleteInvoiceLine(
  _request: Request,
  env: Env,
  params: { id: string },
): Promise<Response> {
  const existing = await env.DB.prepare(
    "SELECT id FROM invoice_lines WHERE id = ?1",
  )
    .bind(params.id)
    .first<{ id: string }>();

  if (!existing) {
    throw ApiError.notFound();
  }

  await env.DB.prepare("DELETE FROM invoice_lines WHERE id = ?1")
    .bind(params.id)
    .run();

  return jsonOk({ success: true });
}

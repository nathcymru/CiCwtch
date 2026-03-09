/**
 * Invoice calculation service.
 *
 * Computes subtotal, tax, and total from invoice line items.
 * All monetary values are in minor currency units (e.g. pence).
 *
 * Tax is not currently modelled in the schema so defaults to 0.
 * When tax/VAT support is added, update this service rather than
 * embedding calculation logic in individual route handlers.
 */

/** Minimal line shape needed for calculation. */
export interface InvoiceLineInput {
  quantity: number;
  unit_price_minor: number;
  line_total_minor: number;
}

/** Result of an invoice total calculation. */
export interface InvoiceTotals {
  subtotal: number;
  tax: number;
  total: number;
}

/**
 * Calculate invoice totals from an array of line items.
 *
 * Subtotal is the sum of each line's `line_total_minor` value.
 * Tax is not yet modelled in the schema and defaults to 0.
 * Total equals subtotal + tax.
 */
export function calculateInvoiceTotals(
  lines: InvoiceLineInput[],
): InvoiceTotals {
  const subtotal = lines.reduce(
    (sum, line) => sum + line.line_total_minor,
    0,
  );
  const tax = 0;
  const total = subtotal + tax;
  return { subtotal, tax, total };
}

/**
 * Fetch invoice lines for a given header and calculate totals.
 *
 * Only active lines are included — the schema uses hard deletes
 * for invoice lines so all rows present belong to the invoice.
 */
export async function getInvoiceTotals(
  db: D1Database,
  invoiceHeaderId: string,
): Promise<InvoiceTotals> {
  const { results } = await db
    .prepare(
      `SELECT quantity, unit_price_minor, line_total_minor
       FROM invoice_lines
       WHERE invoice_header_id = ?1`,
    )
    .bind(invoiceHeaderId)
    .all<InvoiceLineInput>();

  return calculateInvoiceTotals(results ?? []);
}

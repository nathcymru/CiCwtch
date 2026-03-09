import { describe, it, expect } from "vitest";
import {
  calculateInvoiceTotals,
  getInvoiceTotals,
  type InvoiceLineInput,
} from "./invoiceService";

/* ------------------------------------------------------------------ */
/*  calculateInvoiceTotals (pure function)                             */
/* ------------------------------------------------------------------ */

describe("calculateInvoiceTotals", () => {
  it("returns zeroes when there are no lines", () => {
    const result = calculateInvoiceTotals([]);
    expect(result).toEqual({ subtotal: 0, tax: 0, total: 0 });
  });

  it("calculates subtotal from a single line", () => {
    const lines: InvoiceLineInput[] = [
      { quantity: 2, unit_price_minor: 1500, line_total_minor: 3000 },
    ];
    const result = calculateInvoiceTotals(lines);
    expect(result).toEqual({ subtotal: 3000, tax: 0, total: 3000 });
  });

  it("calculates subtotal from multiple lines", () => {
    const lines: InvoiceLineInput[] = [
      { quantity: 1, unit_price_minor: 2000, line_total_minor: 2000 },
      { quantity: 3, unit_price_minor: 500, line_total_minor: 1500 },
      { quantity: 1, unit_price_minor: 750, line_total_minor: 750 },
    ];
    const result = calculateInvoiceTotals(lines);
    expect(result).toEqual({ subtotal: 4250, tax: 0, total: 4250 });
  });

  it("handles lines with zero line_total_minor", () => {
    const lines: InvoiceLineInput[] = [
      { quantity: 1, unit_price_minor: 0, line_total_minor: 0 },
      { quantity: 5, unit_price_minor: 1000, line_total_minor: 5000 },
    ];
    const result = calculateInvoiceTotals(lines);
    expect(result).toEqual({ subtotal: 5000, tax: 0, total: 5000 });
  });

  it("tax defaults to zero", () => {
    const lines: InvoiceLineInput[] = [
      { quantity: 1, unit_price_minor: 10000, line_total_minor: 10000 },
    ];
    const result = calculateInvoiceTotals(lines);
    expect(result.tax).toBe(0);
    expect(result.total).toBe(result.subtotal + result.tax);
  });

  it("total equals subtotal plus tax", () => {
    const lines: InvoiceLineInput[] = [
      { quantity: 2, unit_price_minor: 1200, line_total_minor: 2400 },
      { quantity: 1, unit_price_minor: 800, line_total_minor: 800 },
    ];
    const result = calculateInvoiceTotals(lines);
    expect(result.total).toBe(result.subtotal + result.tax);
  });
});

/* ------------------------------------------------------------------ */
/*  getInvoiceTotals (DB-integrated)                                   */
/* ------------------------------------------------------------------ */

describe("getInvoiceTotals", () => {
  function mockDb(
    rows: InvoiceLineInput[],
  ): D1Database {
    return {
      prepare() {
        return {
          bind() {
            return {
              all: () => Promise.resolve({ results: rows }),
            };
          },
        };
      },
    } as unknown as D1Database;
  }

  it("returns totals for an invoice with multiple lines", async () => {
    const db = mockDb([
      { quantity: 1, unit_price_minor: 2000, line_total_minor: 2000 },
      { quantity: 2, unit_price_minor: 1500, line_total_minor: 3000 },
    ]);

    const result = await getInvoiceTotals(db, "inv-001");
    expect(result).toEqual({ subtotal: 5000, tax: 0, total: 5000 });
  });

  it("returns zeroes for an invoice with no lines", async () => {
    const db = mockDb([]);

    const result = await getInvoiceTotals(db, "inv-empty");
    expect(result).toEqual({ subtotal: 0, tax: 0, total: 0 });
  });

  it("handles null results from the database", async () => {
    const db = {
      prepare() {
        return {
          bind() {
            return {
              all: () => Promise.resolve({ results: null }),
            };
          },
        };
      },
    } as unknown as D1Database;

    const result = await getInvoiceTotals(db, "inv-null");
    expect(result).toEqual({ subtotal: 0, tax: 0, total: 0 });
  });

  it("excludes deleted lines (only lines present in DB are included)", async () => {
    // Invoice lines use hard deletes — deleted lines are not in the DB.
    // This test verifies that only the lines returned by the query
    // contribute to the total.
    const db = mockDb([
      { quantity: 1, unit_price_minor: 1000, line_total_minor: 1000 },
    ]);

    const result = await getInvoiceTotals(db, "inv-partial");
    expect(result).toEqual({ subtotal: 1000, tax: 0, total: 1000 });
  });
});

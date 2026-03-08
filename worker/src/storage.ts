import type { Env } from "./index";

/**
 * Minimal R2 helper functions for future attachment workflows.
 *
 * Full upload/download endpoints will be added in a subsequent task.
 * These helpers demonstrate the basic read/write path available via
 * the CICWTCH_ATTACHMENTS R2 bucket binding.
 */

/** Store a blob in the attachments bucket. */
export async function putAttachment(
  env: Env,
  key: string,
  data: ReadableStream | ArrayBuffer | string,
  contentType?: string,
): Promise<R2Object | null> {
  const httpMetadata: R2HTTPMetadata = {};
  if (contentType) {
    httpMetadata.contentType = contentType;
  }
  return await env.CICWTCH_ATTACHMENTS.put(key, data, { httpMetadata });
}

/** Retrieve a blob from the attachments bucket. */
export async function getAttachment(
  env: Env,
  key: string,
): Promise<R2ObjectBody | null> {
  return env.CICWTCH_ATTACHMENTS.get(key);
}

/** Delete a blob from the attachments bucket. */
export async function deleteAttachment(
  env: Env,
  key: string,
): Promise<void> {
  await env.CICWTCH_ATTACHMENTS.delete(key);
}

import type { Env } from "../index";
import { jsonOk, jsonError } from "../response";
import { putAttachment, deleteAttachment } from "../storage";

interface AttachmentRow {
  id: string;
  entity_type: string;
  entity_id: string;
  storage_provider: string;
  object_key: string;
  original_filename: string | null;
  mime_type: string | null;
  file_size_bytes: number | null;
  created_at: string;
  updated_at: string;
}

export async function createAttachment(
  request: Request,
  env: Env,
): Promise<Response> {
  let formData: FormData;
  try {
    formData = await request.formData();
  } catch {
    return jsonError(
      "Request must be multipart/form-data with a file field",
      "invalid_request",
      400,
    );
  }

  // FormData.get() returns File at runtime for binary fields,
  // but @cloudflare/workers-types types it as string | null.
  const fileEntry = formData.get("file") as unknown;
  if (
    !fileEntry ||
    typeof fileEntry === "string" ||
    !(fileEntry instanceof Blob)
  ) {
    return jsonError("file field is required", "invalid_request", 400);
  }
  const file = fileEntry as File;

  const entityType = formData.get("entity_type");
  if (typeof entityType !== "string" || entityType.trim() === "") {
    return jsonError("entity_type is required", "invalid_request", 400);
  }

  const entityId = formData.get("entity_id");
  if (typeof entityId !== "string" || entityId.trim() === "") {
    return jsonError("entity_id is required", "invalid_request", 400);
  }

  const id = crypto.randomUUID();
  const objectKey = `attachments/${id}`;
  const mimeType = file.type || null;
  const originalFilename = file.name || null;
  const fileBytes = await file.arrayBuffer();
  const fileSizeBytes = fileBytes.byteLength;
  const now = new Date().toISOString();

  await putAttachment(env, objectKey, fileBytes, mimeType ?? undefined);

  const attachment: AttachmentRow = {
    id,
    entity_type: entityType.trim(),
    entity_id: entityId.trim(),
    storage_provider: "r2",
    object_key: objectKey,
    original_filename: originalFilename,
    mime_type: mimeType,
    file_size_bytes: fileSizeBytes,
    created_at: now,
    updated_at: now,
  };

  try {
    await env.DB.prepare(
      `INSERT INTO attachments (
        id, entity_type, entity_id, storage_provider, object_key,
        original_filename, mime_type, file_size_bytes, created_at, updated_at
      ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10)`,
    )
      .bind(
        attachment.id,
        attachment.entity_type,
        attachment.entity_id,
        attachment.storage_provider,
        attachment.object_key,
        attachment.original_filename,
        attachment.mime_type,
        attachment.file_size_bytes,
        attachment.created_at,
        attachment.updated_at,
      )
      .run();
  } catch (err) {
    await deleteAttachment(env, objectKey);
    throw err;
  }

  return jsonOk(attachment, 201);
}

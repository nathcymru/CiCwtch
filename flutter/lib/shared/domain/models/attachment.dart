class Attachment {
  const Attachment({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.storageProvider,
    this.objectKey,
    this.originalFilename,
    this.mimeType,
    this.fileSizeBytes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String entityType;
  final String entityId;
  final String storageProvider;
  final String? objectKey;
  final String? originalFilename;
  final String? mimeType;
  final int? fileSizeBytes;
  final String createdAt;
  final String updatedAt;

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      storageProvider: json['storage_provider'] as String,
      objectKey: json['object_key'] as String?,
      originalFilename: json['original_filename'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSizeBytes: json['file_size_bytes'] as int?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entity_type': entityType,
      'entity_id': entityId,
      'storage_provider': storageProvider,
      'object_key': objectKey,
      'original_filename': originalFilename,
      'mime_type': mimeType,
      'file_size_bytes': fileSizeBytes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

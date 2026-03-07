export class ApiError extends Error {
  constructor(
    public readonly status: number,
    message: string,
    public readonly type: string,
  ) {
    super(message);
    this.name = "ApiError";
  }

  static notFound(): ApiError {
    return new ApiError(404, "Not found", "not_found");
  }
}

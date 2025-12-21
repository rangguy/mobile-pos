/// API endpoint constants
class ApiConstants {
  // Authentication endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String getCurrentUser = '/auth';
  static const String getUserByUuid = '/auth/{uuid}';

  // Product endpoints
  static const String products = '/products';
  static const String productsPagination = '/products/pagination';
  static const String productByUuid = '/products/{uuid}';
  static const String productByCode = '/products/code/{code}';
}

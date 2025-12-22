import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
String sanitizeImageUrl(String? url) {
  if (url == null || url!.isEmpty) {
    return '';
  }
  String cleanUrl = url!.trim();
  if (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')) {
    try {
      final uri = Uri.parse(cleanUrl);
      return uri.toString();
    } catch (e) {
      print('Error parsing URL: ${cleanUrl}, Error: ${e}');
      return '';
    }
  }
  if (cleanUrl.contains('storage') || !cleanUrl.contains('://')) {
    final projectUrl = 'https://fzbdaqrmkfsvztgooibj.supabase.co';
    String fullUrl = '';
    if (cleanUrl.startsWith('/')) {
      fullUrl = '${projectUrl}/storage/v1/object/public${cleanUrl}';
    } else {
      if (cleanUrl.startsWith('storage/')) {
        fullUrl = '${projectUrl}/${cleanUrl}';
      } else {
        fullUrl =
            '${projectUrl}/storage/v1/object/public/MainImages/${cleanUrl}';
      }
    }
    try {
      final uri = Uri.parse(fullUrl);
      return uri.toString();
    } catch (e) {
      print('Error constructing URL: ${fullUrl}, Error: ${e}');
      return '';
    }
  }
  return '';
}

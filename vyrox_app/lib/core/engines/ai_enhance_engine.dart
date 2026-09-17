import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

class AiEnhanceEngine {
  /// Uploads photo to catbox.moe
  static Future<String?> uploadImage(File file) async {
    try {
      final uri = Uri.parse('https://catbox.moe/user/api.php');
      final request = http.MultipartRequest('POST', uri)
        ..fields['reqtype'] = 'fileupload'
        ..files.add(await http.MultipartFile.fromPath('fileToUpload', file.path));

      final streamed = await request.send().timeout(const Duration(seconds: 45));
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 && response.body.trim().startsWith('http')) {
        return response.body.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Constructs URL for Pollinations AI Image Editing
  static String buildEnhanceUrl({
    required String mode,
    required String referenceUrl,
    required String userPrompt,
    int width = 1024,
    int height = 1024,
  }) {
    final prompt = _promptFor(mode, userPrompt);
    final encodedPrompt = Uri.encodeComponent(prompt);
    final encodedRef = Uri.encodeComponent(referenceUrl);
    final seed = Random().nextInt(999999);

    return 'https://image.pollinations.ai/prompt/$encodedPrompt'
        '?image=$encodedRef'
        '&model=flux'
        '&width=$width&height=$height'
        '&nologo=true&seed=$seed';
  }

  static String _promptFor(String mode, String userPrompt) {
    final extra = userPrompt.trim();
    switch (mode) {
      case 'background':
        return extra.isEmpty
            ? 'keep subject identical, place on cinematic photorealistic background, 8k portrait'
            : 'keep subject identical, change background to $extra, high quality studio photography';
      case 'faceswap':
        return 'portrait photo, masterfully blend face, photorealistic, natural skin tone, crystal clear';
      case 'outfit':
        return extra.isEmpty
            ? 'keep face identical, change clothing to elegant formal suit, high quality fashion photo'
            : 'keep face identical, change clothing to $extra, fashion photoshoot';
      case 'upscale':
        return 'super resolution 4k portrait, ultra sharp focus, crystal clear detail';
      case 'removebg':
        return 'subject cutout on clean solid white background, high contrast studio portrait';
      default:
        return extra.isEmpty ? 'photorealistic enhancement, high quality portrait' : extra;
    }
  }

  static String titleFor(String mode) {
    switch (mode) {
      case 'background': return 'Change Background';
      case 'faceswap': return 'Face Swap';
      case 'outfit': return 'Change Outfit';
      case 'upscale': return 'Upscale HD';
      case 'removebg': return 'Remove Background';
      default: return 'AI Edit';
    }
  }

  static String hintFor(String mode) {
    switch (mode) {
      case 'background': return 'e.g. "sunset beach with palm trees"';
      case 'outfit': return 'e.g. "black leather jacket and jeans"';
      case 'upscale': return 'Optional description for upscale...';
      case 'removebg': return 'Optional description...';
      default: return 'Describe your edit...';
    }
  }
}

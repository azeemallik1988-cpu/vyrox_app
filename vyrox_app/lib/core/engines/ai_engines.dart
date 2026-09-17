import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

/// Free image-to-image AI helper.
/// Uploads image to catbox.moe (free, no key), then asks Pollinations Kontext
/// to transform it based on the user's prompt.
class AiEnhanceEngine {
  /// Uploads a local file to catbox.moe and returns a public URL.
  static Future<String?> uploadImage(File file) async {
    try {
      final uri = Uri.parse('https://catbox.moe/user/api.php');
      final request = http.MultipartRequest('POST', uri)
        ..fields['reqtype'] = 'fileupload'
        ..files.add(await http.MultipartFile.fromPath('fileToUpload', file.path));

      final streamed = await request.send().timeout(const Duration(seconds: 60));
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200 && response.body.trim().startsWith('http')) {
        return response.body.trim();
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Builds a Pollinations Kontext URL for image editing.
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
        '?image=$encodedRef&model=kontext'
        '&width=$width&height=$height'
        '&nologo=true&seed=$seed';
  }

  static String _promptFor(String mode, String userPrompt) {
    final extra = userPrompt.trim();
    switch (mode) {
      case 'background':
        return extra.isEmpty
            ? 'keep the person exactly the same, replace the background with a beautiful cinematic scene, photorealistic'
            : 'keep the person exactly the same, replace the background with: $extra, photorealistic, professional lighting';
      case 'faceswap':
        return extra.isEmpty
            ? 'photorealistic portrait, subtle face enhancement, preserve original pose and lighting'
            : 'photorealistic portrait, make the person look like: $extra, preserve pose and lighting, natural look';
      case 'outfit':
        return extra.isEmpty
            ? 'keep face and pose identical, change outfit to an elegant modern style, photorealistic'
            : 'keep face and pose identical, change outfit to: $extra, photorealistic';
      case 'upscale':
        return 'upscale this image, enhance every detail, sharp 4K quality, high resolution, crystal clear, remove blur';
      case 'removebg':
        return 'remove the background completely, keep only the subject, clean sharp edges, plain white background, studio cutout';
      default:
        return extra.isEmpty ? 'enhance this image, photorealistic, high quality' : extra;
    }
  }

  /// Friendly display name for a mode.
  static String titleFor(String mode) {
    switch (mode) {
      case 'background':
        return 'Change Background';
      case 'faceswap':
        return 'Change Face';
      case 'outfit':
        return 'Change Outfit';
      case 'upscale':
        return 'Upscale HD';
      case 'removebg':
        return 'Remove Background';
      default:
        return 'AI Enhance';
    }
  }

  /// Placeholder hint for the prompt field.
  static String hintFor(String mode) {
    switch (mode) {
      case 'background':
        return 'Describe the new background (e.g. "sunset beach")';
      case 'faceswap':
        return 'Describe the new face (e.g. "older man with beard")';
      case 'outfit':
        return 'Describe the new outfit (e.g. "black business suit")';
      case 'upscale':
        return 'Optional (leave empty for auto AI upscaling)';
      case 'removebg':
        return 'Optional (leave empty for transparent-style cutout)';
      default:
        return 'Describe what you want';
    }
  }
}

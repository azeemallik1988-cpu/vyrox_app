import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/auth/auth_controller.dart';

class ImageResultScreen extends StatefulWidget {
  final String prompt;
  final String style;
  final String aspectRatio;

  const ImageResultScreen({
    super.key,
    required this.prompt,
    required this.style,
    required this.aspectRatio,
  });

  @override
  State<ImageResultScreen> createState() => _ImageResultScreenState();
}

class _ImageResultScreenState extends State<ImageResultScreen> {
  late String _imageUrl;
  bool _isLoading = true;
  bool _hasError = false;
  bool _savedToDb = false;

  @override
  void initState() {
    super.initState();
    _imageUrl = _buildPollinationsUrl();
    _saveProject();
  }

  String _buildPollinationsUrl() {
    // Get dimensions from aspect ratio
    int width = 1024;
    int height = 1024;
    if (widget.aspectRatio == '16:9') {
      width = 1280;
      height = 720;
    } else if (widget.aspectRatio == '9:16') {
      width = 720;
      height = 1280;
    }

    // Combine prompt + style for better results
    final enhancedPrompt = '${widget.prompt}, ${widget.style} style, ultra detailed, high quality, 8k';
    final encoded = Uri.encodeComponent(enhancedPrompt);
    final seed = Random().nextInt(999999);

    return 'https://image.pollinations.ai/prompt/$encoded?width=$width&height=$height&nologo=true&seed=$seed&model=flux';
  }

  Future<void> _saveProject() async {
    try {
      await AuthController.saveProject(
        title: widget.prompt.length > 40
            ? '${widget.prompt.substring(0, 40)}...'
            : widget.prompt,
        kind: 'image',
      );
      if (mounted) setState(() => _savedToDb = true);
    } catch (_) {
      // Silent fail — DB save is optional
    }
  }

  void _regenerateImage() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _imageUrl = _buildPollinationsUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Result', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _regenerateImage,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image display area
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 320),
              decoration: BoxDecoration(
                color: const Color(0xFF181228),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: _hasError
                    ? _errorWidget()
                    : _isLoading
                        ? _loadingWidget()
                        : Image.network(
                            _imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return _loadingWidget();
                            },
                            errorBuilder: (context, error, stack) {
                              return _errorWidget();
                            },
                          ),
              ),
            ),
            const SizedBox(height: 20),

            // Status badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B4FCE).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.style,
                    style: const TextStyle(color: Color(0xFFA78BFA), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.aspectRatio,
                    style: const TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (_savedToDb)
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                      SizedBox(width: 4),
                      Text('Saved', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Prompt display
            const Text('Prompt', style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              widget.prompt,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 28),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                onPressed: _regenerateImage,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome),
                    SizedBox(width: 8),
                    Text('Generate Another', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white.withOpacity(0.15)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Edit Prompt', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      height: 320,
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF7B4FCE)),
          SizedBox(height: 20),
          Text('Generating your masterpiece...', style: TextStyle(color: Colors.white60, fontSize: 14)),
          SizedBox(height: 6),
          Text('This takes 5-15 seconds', style: TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      height: 320,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          const Text('Could not load image', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Check your internet and try again', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _regenerateImage,
            child: const Text('Retry', style: TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

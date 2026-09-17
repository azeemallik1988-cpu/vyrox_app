import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/engines/key_store.dart';

class PassportPhotoScreen extends StatefulWidget {
  const PassportPhotoScreen({super.key});

  @override
  State<PassportPhotoScreen> createState() => _PassportPhotoScreenState();
}

enum PassportSize {
  india(35, 45, 'India / Schengen (35x45mm)'),
  us(51, 51, 'US Passport (51x51mm)'),
  uk(35, 45, 'UK / EU (35x45mm)'),
  china(33, 48, 'China Visa (33x48mm)');

  final double widthMm;
  final double heightMm;
  final String label;
  const PassportSize(this.widthMm, this.heightMm, this.label);
}

class _PassportPhotoScreenState extends State<PassportPhotoScreen> {
  PassportSize _size = PassportSize.india;
  int _bgIndex = 0;
  File? _originalPhoto;
  Uint8List? _cutoutBytes; // photo with background removed (transparent)
  bool _processing = false;
  bool _saving = false;
  String? _error;
  bool _keyLoaded = false;

  final ImagePicker _picker = ImagePicker();
  final GlobalKey _captureKey = GlobalKey();

  final List<Color> _bgColors = [
    Colors.white,
    const Color(0xFFD6E6F5),
    const Color(0xFFE8E8E8),
    const Color(0xFF4A90E2),
  ];
  final List<String> _bgNames = ['White', 'Light Blue', 'Grey', 'Royal Blue'];

  @override
  void initState() {
    super.initState();
    KeyStore.load().then((_) {
      if (mounted) setState(() => _keyLoaded = true);
    });
  }

  bool get _keyReady => KeyStore.segmind.isNotEmpty;

  Future<void> _enterKey() async {
    final controller = TextEditingController(text: KeyStore.segmind);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF181228),
        title: const Text('Segmind API Key', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Get a free key at segmind.com → API Keys.', style: TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'SG_...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF0F0C17),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B4FCE)),
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (result != null) {
      await KeyStore.saveSegmind(result);
      if (mounted) setState(() => _error = null);
    }
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200, maxHeight: 1600, imageQuality: 92);
      if (picked == null) return;
      setState(() {
        _originalPhoto = File(picked.path);
        _cutoutBytes = null;
        _error = null;
      });
      // Auto remove background after pick
      _removeBackground();
    } catch (_) {}
  }

  Future<void> _removeBackground() async {
    if (_originalPhoto == null) return;
    if (!_keyReady) {
      setState(() => _error = 'Tap "Set API Key" to enable background removal.');
      return;
    }

    setState(() {
      _processing = true;
      _error = null;
    });

    try {
      final b64 = base64Encode(await _originalPhoto!.readAsBytes());
      final response = await http.post(
        Uri.parse('https://api.segmind.com/v1/bg-removal'),
        headers: {'x-api-key': KeyStore.segmind, 'Content-Type': 'application/json'},
        body: jsonEncode({'image': b64, 'base64': false}),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        setState(() {
          _cutoutBytes = response.bodyBytes;
          _processing = false;
        });
      } else if (response.statusCode == 401) {
        setState(() { _error = 'Invalid key. Tap "Set API Key".'; _processing = false; });
      } else if (response.statusCode == 406 || response.statusCode == 402) {
        setState(() { _error = 'Free credits used up today. Try tomorrow.'; _processing = false; });
      } else {
        setState(() { _error = 'Background removal failed (${response.statusCode}).'; _processing = false; });
      }
    } catch (e) {
      setState(() { _error = 'Error: $e'; _processing = false; });
    }
  }

  Future<void> _saveAndShare() async {
    if (_cutoutBytes == null) {
      setState(() => _error = 'Upload a photo first (background removal needed).');
      return;
    }
    setState(() => _saving = true);
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      final boundary = _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw 'Capture failed';
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final dir = await getTemporaryDirectory();
      final filename = 'passport_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)], text: 'Passport photo · ${_size.label} · Vyrox AI');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.redAccent, content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratio = _size.widthMm / _size.heightMm;
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C17),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Passport Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KEY STATUS
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: _keyReady ? const Color(0xFF10B981).withOpacity(0.12) : Colors.orangeAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: (_keyReady ? const Color(0xFF10B981) : Colors.orangeAccent).withOpacity(0.3)),
              ),
              child: Row(children: [
                Icon(_keyReady ? Icons.check_circle : Icons.key, color: _keyReady ? const Color(0xFF10B981) : Colors.orangeAccent, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(_keyReady ? 'API key active' : 'Add free key to remove background', style: TextStyle(color: _keyReady ? const Color(0xFF10B981) : Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.w600))),
                TextButton(onPressed: _enterKey, child: Text(_keyReady ? 'Change' : 'Set API Key', style: const TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold, fontSize: 12))),
              ]),
            ),

            const Text('Photo size', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PassportSize.values.map((s) {
                final selected = _size == s;
                return GestureDetector(
                  onTap: () => setState(() => _size = s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF7B4FCE) : const Color(0xFF181228),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(s.label, style: TextStyle(color: selected ? Colors.white : Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // PREVIEW (this is captured on save)
            Center(
              child: GestureDetector(
                onTap: _pickPhoto,
                child: RepaintBoundary(
                  key: _captureKey,
                  child: AspectRatio(
                    aspectRatio: ratio,
                    child: Container(
                      width: 240,
                      color: _bgColors[_bgIndex], // background color shows through the cutout!
                      child: _processing
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF7B4FCE)))
                          : _cutoutBytes != null
                              ? Image.memory(_cutoutBytes!, fit: BoxFit.cover)
                              : _originalPhoto != null
                                  ? Image.file(_originalPhoto!, fit: BoxFit.cover)
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_outline, size: 70, color: Colors.black.withOpacity(0.25)),
                                        const SizedBox(height: 10),
                                        Text('Tap to upload', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _processing ? 'Removing background...' : 'Tap image to change photo',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Background Color', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: _bgColors.asMap().entries.map((e) {
                final selected = _bgIndex == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: GestureDetector(
                    onTap: () => setState(() => _bgIndex = e.key),
                    child: Column(children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(color: e.value, shape: BoxShape.circle, border: Border.all(color: selected ? const Color(0xFF7B4FCE) : Colors.white24, width: selected ? 3 : 1)),
                      ),
                      const SizedBox(height: 6),
                      Text(_bgNames[e.key], style: TextStyle(color: selected ? Colors.white : Colors.white54, fontSize: 11, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
                child: Row(children: [
                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600))),
                ]),
              ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4FCE),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                onPressed: _saving ? null : _saveAndShare,
                icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.download),
                label: const Text('Save & Share Passport Photo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Upload a photo → AI removes the background → pick your official color → save print-ready.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

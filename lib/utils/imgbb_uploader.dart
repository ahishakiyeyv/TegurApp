import 'dart:async';
import 'dart:io';

/// Simulated upload returning a public URL after 3 seconds.
/// Replace with real ImgBB POST later; keep the same signature.
Future<String> uploadImageToImgBBSim(File imageFile) async {
  await Future.delayed(const Duration(seconds: 3));
  // return actual URL from ImgBB response
  return 'https://i.ibb.co/album/fake/${DateTime.now().millisecondsSinceEpoch}.jpg';
}

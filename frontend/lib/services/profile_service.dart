import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';

class ProfileService {
  static final _client = Supabase.instance.client;

  static String? get currentUserId => _client.auth.currentUser?.id;
  static String? get currentUserEmail => _client.auth.currentUser?.email;

  static Future<UserProfile?> getProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return UserProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateProfile(UserProfile profile) async {
    final userId = currentUserId;
    if (userId == null) return false;
    try {
      await _client
          .from('profiles')
          .update(profile.toJson())
          .eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Pakai XFile + bytes supaya support web & mobile
  static Future<String?> uploadAvatar(XFile file) async {
    final userId = currentUserId;
    if (userId == null) return null;
    try {
      final bytes = await file.readAsBytes();
      final fileName = '$userId/avatar.jpg';
      await _client.storage.from('avatars').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
                upsert: true, contentType: 'image/jpeg'),
          );
      return _client.storage.from('avatars').getPublicUrl(fileName);
    } catch (e) {
      return null;
    }
  }
}
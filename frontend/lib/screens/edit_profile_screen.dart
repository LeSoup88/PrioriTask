import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/profile_service.dart';
import '../models/profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  late final TextEditingController _ipkController;
  late final TextEditingController _sksController;
  late final TextEditingController _jurusanController;
  late final TextEditingController _semesterController;
  late final TextEditingController _angkatanController;

  XFile? _newAvatarFile;
  Uint8List? _newAvatarBytes;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.profile.fullName ?? '');
    _nimController =
        TextEditingController(text: widget.profile.nim ?? '');
    _ipkController = TextEditingController(
        text: widget.profile.ipk.toStringAsFixed(2));
    _sksController =
        TextEditingController(text: '${widget.profile.sks}');
    _jurusanController =
        TextEditingController(text: widget.profile.jurusan);
    _semesterController =
        TextEditingController(text: '${widget.profile.semester}');
    _angkatanController =
        TextEditingController(text: '${widget.profile.angkatan}');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _ipkController.dispose();
    _sksController.dispose();
    _jurusanController.dispose();
    _semesterController.dispose();
    _angkatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.darkBackground : AppColors.background;
    final cardColor = isDark ? AppColors.darkSurface : AppColors.surface;
    final dividerColor =
        isDark ? const Color(0xFF263550) : AppColors.divider;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkNavBar : bgColor,
        foregroundColor: textPrimary,
        elevation: 0,
        title: Text('Edit Profil',
            style: TextStyle(
                fontWeight: FontWeight.w700, color: textPrimary)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary))
                  : const Text('Simpan',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar picker
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primary, width: 2.5),
                      ),
                      child: ClipOval(
                        child: _newAvatarBytes != null
                            ? Image.memory(_newAvatarBytes!,
                                fit: BoxFit.cover)
                            : widget.profile.avatarUrl != null
                                ? Image.network(
                                    widget.profile.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _avatarPlaceholder(),
                                  )
                                : _avatarPlaceholder(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('Ketuk untuk ganti foto',
                  style:
                      TextStyle(fontSize: 12, color: textSecondary)),
            ),
            const SizedBox(height: 28),

            // Informasi Pribadi
            _buildSectionTitle('Informasi Pribadi'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor),
              ),
              child: Column(
                children: [
                  _buildField(
                    label: 'Nama Lengkap',
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(color: dividerColor, height: 1),
                  _buildField(
                    label: 'NIM',
                    controller: _nimController,
                    icon: Icons.badge_outlined,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Akademik
            _buildSectionTitle('Akademik'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor),
              ),
              child: Column(
                children: [
                  _buildField(
                    label: 'Jurusan',
                    controller: _jurusanController,
                    icon: Icons.school_outlined,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                  ),
                  Divider(color: dividerColor, height: 1),
                  _buildField(
                    label: 'Semester',
                    controller: _semesterController,
                    icon: Icons.calendar_today_outlined,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  Divider(color: dividerColor, height: 1),
                  _buildField(
                    label: 'Angkatan',
                    controller: _angkatanController,
                    icon: Icons.history_edu_rounded,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  Divider(color: dividerColor, height: 1),
                  _buildField(
                    label: 'IPK',
                    controller: _ipkController,
                    icon: Icons.star_outline_rounded,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                  ),
                  Divider(color: dividerColor, height: 1),
                  _buildField(
                    label: 'SKS',
                    controller: _sksController,
                    icon: Icons.book_outlined,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child:
          const Icon(Icons.person_rounded, size: 50, color: AppColors.primary),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required Color textPrimary,
  required Color textSecondary,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Padding(                                    
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,  
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,   
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 4), // ← kecil saja
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _newAvatarFile = picked;
        _newAvatarBytes = bytes;
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      String? avatarUrl = widget.profile.avatarUrl;
      if (_newAvatarFile != null) {
        avatarUrl = await ProfileService.uploadAvatar(_newAvatarFile!);
      }

      final updatedProfile = widget.profile.copyWith(
        fullName: _nameController.text.trim(),
        nim: _nimController.text.trim(),
        semester: int.tryParse(_semesterController.text) ??
            widget.profile.semester,
        ipk: double.tryParse(_ipkController.text) ?? widget.profile.ipk,
        sks:
            int.tryParse(_sksController.text) ?? widget.profile.sks,
        jurusan: _jurusanController.text.trim(),
        angkatan: int.tryParse(_angkatanController.text) ??
            widget.profile.angkatan,
        avatarUrl: avatarUrl,
      );

      final success =
          await ProfileService.updateProfile(updatedProfile);
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Profil berhasil disimpan'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gagal menyimpan profil'),
            backgroundColor: AppColors.urgent,
            behavior: SnackBarBehavior.floating,
          ));
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final api = ApiService();
  final picker = ImagePicker();

  bool loading = true;

  String? profilePhoto;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {
    try {
      final profile = await api.getProfile();
      if (!mounted) return;

      setState(() {
        profilePhoto = profile["profile_photo"];
        emailController.text = profile["email"] ?? "";

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    setState(() {
      selectedImage = File(picked.path);
    });

    await uploadPhoto();
  }

  Future uploadPhoto() async {
    if (selectedImage == null) return;

    try {
      final url = await api.uploadProfilePhoto(selectedImage!);

      if (!mounted) return;
      setState(() {
        profilePhoto = url;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Photo updated")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload failed")));
    }
  }

  Future saveProfile() async {
    try {
      await api.updateProfile({
        "name": nameController.text,
        "phone": phoneController.text,
        "location": locationController.text,
      });
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile updated")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Update failed")));
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        TextField(
          controller: controller,
          readOnly: readOnly,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff1f2937),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 18),
      ],
    );
  }

  Widget buildAvatar() {
    ImageProvider? image;

    if (selectedImage != null) {
      image = FileImage(selectedImage!);
    } else if (profilePhoto != null) {
      image = NetworkImage(profilePhoto!);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xff9333EA), Color(0xff7E22CE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: image != null
                ? DecorationImage(image: image, fit: BoxFit.cover)
                : null,
          ),
          child: image == null
              ? const Center(
                  child: Text(
                    "U",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: pickImage,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xff9333EA),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.camera_alt,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            buildAvatar(),

            const SizedBox(height: 10),

            TextButton(
              onPressed: pickImage,
              child: const Text(
                "Change Photo",
                style: TextStyle(color: Color(0xff9333EA)),
              ),
            ),

            const SizedBox(height: 5),

            buildField("Full Name", nameController),

            buildField("Email Address", emailController, readOnly: true),

            buildField("Phone Number", phoneController),

            buildField("Location", locationController),

            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveProfile,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9333EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {

    final profile = await api.getProfile();

    setState(() {

      nameController.text = profile["name"] ?? "";
      emailController.text = profile["email"] ?? "";
      phoneController.text = profile["phone"] ?? "";
      locationController.text = profile["location"] ?? "";

      loading = false;
    });
  }

  Future saveProfile() async {

    await api.updateProfile({
      "name": nameController.text,
      "phone": phoneController.text,
      "location": locationController.text
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated"))
    );
  }

  Widget buildField(String label, TextEditingController controller){

    return Padding(
      padding: const EdgeInsets.only(bottom:16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xff1f2937),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(loading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.black
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const CircleAvatar(
              radius: 45,
              child: Text("B",style:TextStyle(fontSize:30)),
            ),

            const SizedBox(height:30),

            buildField("Full Name", nameController),
            buildField("Email Address", emailController),
            buildField("Phone Number", phoneController),
            buildField("Location", locationController),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity,50)
              ),
              child: const Text("Save Changes")
            )
          ],
        ),
      ),
    );
  }
}
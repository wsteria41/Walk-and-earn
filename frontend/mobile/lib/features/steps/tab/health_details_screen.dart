import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class HealthDetailsScreen extends StatefulWidget {
  const HealthDetailsScreen({super.key});

  @override
  State<HealthDetailsScreen> createState() => _HealthDetailsScreenState();
}

class _HealthDetailsScreenState extends State<HealthDetailsScreen> {

  final age = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final birthYear = TextEditingController();

  final api = ApiService();

  String bmi = "";
  String category = "";

  Future calculateBMI(){

    double h = double.parse(height.text)/100;
    double w = double.parse(weight.text);

    double result = w/(h*h);

    setState(() {

      bmi = result.toStringAsFixed(1);

      if(result < 18.5){
        category = "Underweight";
      }
      else if(result < 25){
        category = "Normal";
      }
      else{
        category = "Overweight";
      }

    });

    return Future.value();
  }

  Future saveHealth() async {

    await api.updateProfile({

      "age": int.parse(age.text),
      "height": int.parse(height.text),
      "weight": int.parse(weight.text),
      "birth_year": int.parse(birthYear.text)

    });
    
     ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated"))
    );

    await calculateBMI();
  }

  Widget field(String label, TextEditingController c){

    return Padding(
      padding: const EdgeInsets.only(bottom:16),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Health Details"),
        backgroundColor: Colors.black
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            field("Age", age),
            field("Height (cm)", height),
            field("Weight (kg)", weight),
            field("Birth Year", birthYear),

            const SizedBox(height:20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1f2937),
                borderRadius: BorderRadius.circular(12)
              ),

              child: Column(
                children: [
                  Text("BMI: $bmi"),
                  Text("Category: $category")
                ],
              ),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: saveHealth,
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
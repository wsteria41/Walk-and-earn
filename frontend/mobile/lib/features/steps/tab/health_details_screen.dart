import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class HealthDetailsScreen extends StatefulWidget {
  const HealthDetailsScreen({super.key});

  @override
  State<HealthDetailsScreen> createState() => _HealthDetailsScreenState();
}

class _HealthDetailsScreenState extends State<HealthDetailsScreen> {

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final birthYearController = TextEditingController();

  final api = ApiService();

  String bmi = "-";
  String category = "-";

  @override
  void initState() {
    super.initState();
    loadHealth();
  }

  /// BACKEND health data
Future loadHealth() async {

  try {

    final data = await api.getProfile();

    setState(() {

      heightController.text = (data["height"] ?? "").toString();
      weightController.text = (data["weight"] ?? "").toString();
      birthYearController.text = (data["birth_year"] ?? "").toString();

      bmi = (data["bmi"] ?? "-").toString();

      /// BMI CATEGORY frontend
      if(data["bmi"] != null){

        double val = double.parse(data["bmi"].toString());

        if(val < 18.5){
          category = "Underweight";
        }
        else if(val < 25){
          category = "Normal";
        }
        else if(val < 30){
          category = "Overweight";
        }
        else{
          category = "Obese";
        }

      }

      calculateAge(); // age update

    });

  } catch(e) {
    print("Health load error: $e");
  }

}

void calculateAge(){

  if(birthYearController.text.isEmpty) return;

  int year = int.tryParse(birthYearController.text) ?? 0;

  if(year == 0) return;

  int currentYear = DateTime.now().year;

  int age = currentYear - year;

  ageController.text = age.toString();

}

  /// BMI calculate
  void calculateBMI() {

    if(heightController.text.isEmpty || weightController.text.isEmpty) return;

    double height = double.parse(heightController.text) / 100;
    double weight = double.parse(weightController.text);

    double result = weight / (height * height);

    setState(() {

      bmi = result.toStringAsFixed(1);

      if(result < 18.5){
        category = "Underweight";
      }
      else if(result < 25){
        category = "Normal";
      }
      else if(result < 30){
        category = "Overweight";
      }
      else{
        category = "Obese";
      }

    });

  }

  /// SAVE backend
  Future saveHealth() async {

    try {

      await api.updateHealth({
        "age": int.parse(ageController.text),
        "height": int.parse(heightController.text),
        "weight": int.parse(weightController.text),
        "birth_year": int.parse(birthYearController.text)
      });

      calculateBMI();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Health details updated"))
      );

    } catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update failed"))
      );

    }

  }

  /// normal field
  Widget field(String label, TextEditingController controller,{bool readOnly=false}){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),

        const SizedBox(height:6),

        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => calculateBMI(),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff1f2937),
            contentPadding: const EdgeInsets.symmetric(horizontal:16, vertical:14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none
            )
          ),
        ),

        const SizedBox(height:18)

      ],
    );
  }

  /// Birth Year calendar
  Widget birthYearField(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "BIRTH YEAR",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),
        ),

        const SizedBox(height:6),

        TextField(
          controller: birthYearController,
          readOnly: true,
          style: const TextStyle(color: Colors.white),

          onTap: () async {

            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );

            if(picked != null){

              setState(() {
                birthYearController.text = picked.year.toString();
              });

            }

          },

          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff1f2937),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal:16, vertical:14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none
            )
          ),
        ),

        const SizedBox(height:18)

      ],
    );

  }

  /// BMI card
  Widget statsCard(){

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xff1f2937),
        borderRadius: BorderRadius.circular(20)
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "Calculated Stats",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height:20),

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "BMI",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height:6),

                  Text(
                    bmi,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "CATEGORY",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height:6),

                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  )

                ],
              )

            ],
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Health Details")
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Update your health information",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14
              ),
            ),

            const SizedBox(height:30),

            field("Age (years)", ageController),
            field("Height (cm)", heightController),
            field("Weight (kg)", weightController),

            birthYearField(),

            const SizedBox(height:10),

            statsCard(),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(

                onPressed: saveHealth,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9333EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),

                child: const Text(
                  "Save Changes",
                  style: TextStyle(fontSize:16)
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
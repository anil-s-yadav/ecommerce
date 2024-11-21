import 'package:ecommerce_app/screens/auth-ui/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/sign-up-controller.dart';
import '../../utils/app-constant.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpPage> {
  final SignUpController signUpController = Get.put(SignUpController());
  TextEditingController username = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 20,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Welcome to my app",
                  style: TextStyle(
                      color: AppConstant.appMainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              // Email Field
              buildTextField(
                  userEmail, "Email", Icons.email, TextInputType.emailAddress),
              // Username Field
              buildTextField(
                  username, "UserName", Icons.person, TextInputType.name),
              // Phone Field
              buildTextField(
                  userPhone, "Phone", Icons.phone, TextInputType.number),
              // City Field
              buildTextField(userCity, "City", Icons.location_pin,
                  TextInputType.streetAddress),
              // Password Field
              buildPasswordField(),
              SizedBox(
                height: Get.height / 20,
              ),
              // Sign Up Button
              signUpButton(),
              SizedBox(
                height: Get.height / 20,
              ),
              // Already have an account? Sign In link
              signInRedirect()
            ],
          ),
        ),
      ),
    );
  }

  // Reusable text field widget for general input fields
  Widget buildTextField(TextEditingController controller, String hintText,
      IconData icon, TextInputType inputType) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: controller,
          cursorColor: AppConstant.appSecondaryColor,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon),
            contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  // Password Field with visibility toggle
  Widget buildPasswordField() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => TextFormField(
            controller: userPassword,
            obscureText: signUpController.isPasswordVisible.value,
            cursorColor: AppConstant.appSecondaryColor,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(Icons.password),
              suffixIcon: GestureDetector(
                onTap: () {
                  signUpController.isPasswordVisible.toggle();
                },
                child: signUpController.isPasswordVisible.value
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Sign up button logic
  Widget signUpButton() {
    return Material(
      child: Container(
        width: Get.width / 2,
        height: Get.height / 18,
        decoration: BoxDecoration(
          color: AppConstant.appSecondaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextButton(
          child: Text(
            "SIGN UP",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
          onPressed: () async {
            String name = username.text.trim();
            String email = userEmail.text.trim();
            String phone = userPhone.text.trim();
            String city = userCity.text.trim();
            String password = userPassword.text.trim();

            // Check if any field is empty
            if (name.isEmpty ||
                email.isEmpty ||
                phone.isEmpty ||
                city.isEmpty ||
                password.isEmpty) {
              Get.snackbar(
                "Error",
                "Please enter all details",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppConstant.appSecondaryColor,
                colorText: AppConstant.appTextColor,
              );
            } else {
              try {
                // Call sign-up method from controller
                UserCredential? userCredential =
                    await signUpController.signUpMethod(
                  name,
                  email,
                  phone,
                  city,
                  password,
                );

                if (userCredential != null) {
                  Get.snackbar(
                    "Verification email sent.",
                    "Please check your email.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppConstant.appSecondaryColor,
                    colorText: AppConstant.appTextColor,
                  );

                  FirebaseAuth.instance.signOut();
                  Get.offAll(() => SignInScreen());
                } else {
                  Get.snackbar(
                    "Error",
                    "Signup failed, please try again.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppConstant.appSecondaryColor,
                    colorText: AppConstant.appTextColor,
                  );
                }
              } catch (e) {
                Get.snackbar(
                  "Error",
                  "Something went wrong: ${e.toString()}",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppConstant.appSecondaryColor,
                  colorText: AppConstant.appTextColor,
                );
              }
            }
          },
        ),
      ),
    );
  }

  // Sign In redirect text at the bottom
  Widget signInRedirect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(color: AppConstant.appSecondaryColor),
        ),
        GestureDetector(
          onTap: () => Get.offAll(() => SignInScreen()),
          child: Text(
            "Sign In",
            style: TextStyle(
                color: AppConstant.appSecondaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

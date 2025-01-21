import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'showproductgrid.dart';
import 'showproducttype.dart';

//Method หลักทีRun
void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBrTjEzjCIp2Wwy3x7hW8Z-bRtBIH7sscA",
            authDomain: "onlinefirebase-eb2e3.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-eb2e3-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-eb2e3",
            storageBucket: "onlinefirebase-eb2e3.firebasestorage.app",
            messagingSenderId: "1070698958371",
            appId: "1:1070698958371:web:a953bbe8c87c583b7a2b96",
            measurementId: "G-WB5CBCPBJF"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(221, 157, 232, 245)),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          // เพิ่มภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/bg.png"), // พาธของภาพที่อยู่ในโฟลเดอร์ assets
                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // จัดตำแหน่งให้อยู่ตรงกลางจอ
              children: [
                Image.asset(
                  'assets/logo2.png', // โลโก้
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // เมื่อกดปุ่มจะไปหน้าที่สอง
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            addproduct(), // ไปหน้าจอ AddProduct
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 179, 211, 128), // กำหนดสีพื้นหลัง
                  ),
                  child: Text(
                    '    บันทึกสินค้า    ',
                    style: TextStyle(
                      color:
                          Color.fromARGB(255, 255, 255, 255), // กำหนดสีของฟอนต์
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // เมื่อกดปุ่มจะไปหน้าที่สอง
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            showproductgrid(), // ไปหน้าจอ AddProduct
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 179, 211, 128), // กำหนดสีพื้นหลัง
                  ),
                  child: Text(
                    'เเสดงข้อมูลสินค้า',
                    style: TextStyle(
                      color:
                          Color.fromARGB(221, 255, 255, 255), // กำหนดสีของฟอนต์
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // เมื่อกดปุ่มจะไปหน้าที่สอง
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            showproducttype(), // ไปหน้าจอ AddProduct
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 179, 211, 128), // กำหนดสีพื้นหลัง
                  ),
                  child: Text(
                    '    ประเภทสินค้า    ',
                    style: TextStyle(
                      color:
                          Color.fromARGB(221, 255, 255, 255), // กำหนดสีของฟอนต์
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

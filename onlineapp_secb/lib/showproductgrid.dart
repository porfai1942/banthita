import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Method หลักทีRun
void main() {
  runApp(MyApp());
}

// Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 179, 211, 128)),
        useMaterial3: true,
      ),
      home: showproductgrid(),
    );
  }
}

// Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      //เติมบรรทัดที่ใช้ query ข้อมูล กรองสินค้าที่ราคา >= 500

      // ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็ น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
      // แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  //ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
    //คําสั่.ลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
            // ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
            // ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
                //ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController categorycontroller = TextEditingController();
    TextEditingController productionDatecontroller = TextEditingController();
    TextEditingController quantitycontroller = TextEditingController();
 // รายการประเภทสินค้าที่ผู้ใช้สามารถเลือก
  List<String> categories = ['ประเภท 1', 'ประเภท 2', 'ประเภท 3'];
// กำหนดค่าหมวดหมู่เริ่มต้น
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: categorycontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ประเภท'),
                ),
                TextField(
                  controller: productionDatecontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'เวลา'),
                ),
                TextField(
                  controller: quantitycontroller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'category': categorycontroller.text,
                   'productiondate': productionDatecontroller.text,
                    'quantity': int.parse(
                      quantitycontroller.text),
                };

                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // เรียกใช้ฟังก์ชันเพื่อโหลดข้อมูลใหม่เพื่อแสดงผลหลังการแก้ไข
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แสดงข้อมูลสินค้า',
          style: TextStyle(
            color: Color.fromARGB(221, 255, 255, 255),
            fontSize: 23,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 149, 227),
      ),
      body: Stack(
        children: [
          // เพิ่มภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/bg.jpg"), // พาธของภาพที่อยู่ในโฟลเดอร์ assets
                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
              ),
            ),
          ),
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(15.0), // เว้นระยะด้านบน
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // จำนวนคอลัมน์
                      crossAxisSpacing: 20, // ระยะห่างระหว่างคอลัมน์
                      mainAxisSpacing: 20, // ระยะห่างระหว่างแถว
                    ),
                    itemCount: products.length, // จำนวนรายการ
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          // รอใส่ code ว่ากดแล้วเกิดอะไรขึ้น
                        },
                        child: Card(
                          elevation: 5, // ความสูงของเงา (ช่วยเพิ่มมิติ)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // ขอบมน
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  product['name'],
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        221, 43, 77, 48), // กำหนดสีของฟอนต์
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'รายละเอียดสินค้า',
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        221, 0, 0, 0), // กำหนดสีของฟอนต์
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ' ${product['description']}',
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        221, 0, 0, 0), // กำหนดสีของฟอนต์
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'ราคา : ${product['price']} บาท',
                                  style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 48, 154, 145), // กำหนดสีของฟอนต์
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .end, // ทำให้ปุ่มอยู่ชิดขวา
                                  children: [
                                    SizedBox(
                                        width: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 80,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .red[50], // พื้นหลังสีแดงอ่อน
                                            shape:
                                                BoxShape.circle, // รูปทรงวงกลม
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              showEditProductDialog(product);
                                            },
                                            icon: Icon(Icons.edit),
                                            color: const Color.fromARGB(255,
                                                231, 158, 158), // สีของไอคอน
                                            iconSize: 20,
                                            tooltip: 'แก้ไขสินค้า',
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: SizedBox(
                                        width: 80,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors
                                                .red[50], // พื้นหลังสีแดงอ่อน
                                            shape:
                                                BoxShape.circle, // รูปทรงวงกลม
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              showDeleteConfirmationDialog(
                                                  product['key'], context);
                                            },
                                            icon: Icon(Icons.delete),
                                            color: const Color.fromARGB(255,
                                                231, 158, 158), // สีของไอคอน
                                            iconSize: 20,
                                            tooltip: 'ลบสินค้า',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

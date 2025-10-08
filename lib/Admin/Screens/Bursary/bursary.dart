import 'package:flutter/material.dart';
class Bursary extends StatelessWidget {
  const Bursary({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body:SafeArea(child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                    "Active Bursaries",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "...Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )

                  ),
                ),
                SizedBox(height: 20),

                  Card(
                    color: Color(0xFFF9FAFB),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.blue.shade100,
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.school,
                              color: Colors.blueAccent,),
                            ),
                          ),
                          title: Text('County Government Bursary',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                          ),
                          subtitle: Text("Mombasa County Government",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),),
                        ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Need-Based",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                          SizedBox(height: 2),
                          Wrap(
                            spacing: 4,
                            children: [
                              Text("Application:",
                              style: TextStyle(
                                color: Colors.grey.shade500
                              ),
                              ),
                              Text("April - March",
                                style: TextStyle(
                                    color: Colors.grey.shade500
                                ),)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: (){
                                  Navigator.pushNamed(context, "/bursarydetail");
                                },
                                    child: Text("View Details",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: ElevatedButton(onPressed: (){},
                                  child: Text("Delete",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(10),

                                  )
                                ),
                              ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context,'/bursarydetail');
                  },
                  child:Card(
                    color: Color(0xFFF9FAFB),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                color: Colors.blue.shade100,
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.school,
                                  color: Colors.blueAccent,),
                              ),
                            ),
                            title: Text('County Government Bursary',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text("Mombasa County Government",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Need-Based",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Wrap(
                            spacing: 4,
                            children: [
                              Text("Application:",
                                style: TextStyle(
                                    color: Colors.grey.shade500
                                ),
                              ),
                              Text("April - March",
                                style: TextStyle(
                                    color: Colors.grey.shade500
                                ),)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: (){},
                                  child: Text("View Details",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: ElevatedButton(onPressed: (){},
                                child: Text("Delete",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(10),

                                    )
                                ),
                              ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context,'/bursarydetail');
                  },
                  child: Card(
                    color: Color(0xFFF9FAFB),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                color: Colors.blue.shade100,
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.school,
                                  color: Colors.blueAccent,),
                              ),
                            ),
                            title: Text('County Government Bursary',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text("Mombasa County Government",
                              style: TextStyle(
                                color: Colors.grey.shade400,
                              ),),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Need-Based",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Wrap(
                            spacing: 4,
                            children: [
                              Text("Application:",
                                style: TextStyle(
                                    color: Colors.grey.shade500
                                ),
                              ),
                              Text("April - March",
                                style: TextStyle(
                                    color: Colors.grey.shade500
                                ),)
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(onPressed: (){},
                                  child: Text("View Details",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(child: ElevatedButton(onPressed: (){},
                                child: Text("Delete",
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.circular(10),

                                    )
                                ),
                              ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
          
        ),
    );
  }
}

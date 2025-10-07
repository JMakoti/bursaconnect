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
                  trailing: SizedBox(
                    width: 130,

                    child: TextFormField(
                      decoration: InputDecoration(
                          isDense: true,
                          suffixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )

                      ),
                    ),
                  )
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context,'/bursarydetail');
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1aQfvqcW7YmIYD0A6DlBNKM8NnFVHqUFMDQ&s',
                              width: 100,
                              fit: BoxFit.cover,
                              height: 100),
                              SizedBox(width: 5),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 120.0, 0),
                                    child: Text("NG-CDF Bursary",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text("Supports needy university students by covering\npart of tuition and upkeep costs to ensure\nuninterrupted learning. ",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_month,
                                        color: Colors.grey.shade500,
                                      size: 13,),
                                      Text("1 September - 30 September",
                                      style: TextStyle(
                                        fontSize:10,
                                        color: Colors.grey.shade500
                                      ),),
                                      SizedBox(width: 10),
                                      Icon(Icons.school_outlined,
                                        color: Colors.grey.shade500,
                                      size: 13,),
                                      Text("Undegraduate",
                                      style: TextStyle(
                                        fontSize: 10,
                                          color: Colors.grey.shade500
                                      ),)
                                    ],
                                  )



                                ],
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
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1aQfvqcW7YmIYD0A6DlBNKM8NnFVHqUFMDQ&s',
                                  width: 100,
                                  fit: BoxFit.cover,
                                  height: 100),
                              SizedBox(width: 5),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 120.0, 0),
                                    child: Text("NG-CDF Bursary",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text("Supports needy university students by covering\npart of tuition and upkeep costs to ensure\nuninterrupted learning. ",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_month,
                                        color: Colors.grey.shade500,
                                        size: 13,),
                                      Text("1 September - 30 September",
                                        style: TextStyle(
                                            fontSize:10,
                                            color: Colors.grey.shade500
                                        ),),
                                      SizedBox(width: 10),
                                      Icon(Icons.school_outlined,
                                        color: Colors.grey.shade500,
                                        size: 13,),
                                      Text("Undegraduate",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500
                                        ),)
                                    ],
                                  )



                                ],
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
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1aQfvqcW7YmIYD0A6DlBNKM8NnFVHqUFMDQ&s',
                                  width: 100,
                                  fit: BoxFit.cover,
                                  height: 100),
                              SizedBox(width: 5),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 120.0, 0),
                                    child: Text("NG-CDF Bursary",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text("Supports needy university students by covering\npart of tuition and upkeep costs to ensure\nuninterrupted learning. ",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade500,
                                    ),),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.calendar_month,
                                        color: Colors.grey.shade500,
                                        size: 13,),
                                      Text("1 September - 30 September",
                                        style: TextStyle(
                                            fontSize:10,
                                            color: Colors.grey.shade500
                                        ),),
                                      SizedBox(width: 10),
                                      Icon(Icons.school_outlined,
                                        color: Colors.grey.shade500,
                                        size: 13,),
                                      Text("Undegraduate",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade500
                                        ),)
                                    ],
                                  )



                                ],
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

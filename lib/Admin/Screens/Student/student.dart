import 'package:flutter/material.dart';
class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("All Applicants"),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.filter_list,
            color: Colors.blueAccent,),
              onPressed: (){},
              label: Text("Filter",
              style: TextStyle(
                color: Colors.blueAccent
              ),))
        ],
      ),
    body: SafeArea(child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "...search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Color(0xFFF9FAFB),
              child:Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   ListTile(
                     leading: Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.grey.shade200
                       ),
                       width: 30,
                       height: 30,
                       child: Icon(
                         Icons.person,
                         size: 14,
                       ),
                     ),
                     title: Text("John Maina"),
                     subtitle: Wrap(
                       spacing: 5,
                       children: [
                         Text("Status:"),
                         Container(
                           padding:
                           const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                           decoration: BoxDecoration(
                             color: Colors.orangeAccent,
                             borderRadius: BorderRadius.circular(8),
                           ),
                           child: const Text(
                             "Pending",
                             style: TextStyle(color: Colors.white, fontSize: 12),
                           ),

                         )
                       ],
                     ),
                     trailing:  Container(
                       padding:
                       const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                       decoration: BoxDecoration(
                         color: Colors.blueAccent,
                         borderRadius: BorderRadius.circular(8),
                       ),
                       child: const Text(
                         "View More",
                         style: TextStyle(color: Colors.white, fontSize: 12),
                       ),

                     ),
                   )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Color(0xFFF9FAFB),
              child:Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200
                        ),
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.person,
                          size: 14,
                        ),
                      ),
                      title: Text("John Maina"),
                      subtitle: Wrap(
                        spacing: 5,
                        children: [
                          Text("Status:"),
                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),

                          )
                        ],
                      ),
                      trailing:  Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "View More",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),

                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Color(0xFFF9FAFB),
              child:Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200
                        ),
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.person,
                          size: 14,
                        ),
                      ),
                      title: Text("John Maina"),
                      subtitle: Wrap(
                        spacing: 5,
                        children: [
                          Text("Status:"),
                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),

                          )
                        ],
                      ),
                      trailing:  GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context,"/studentdetails");
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "View More",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),

                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    )),
    );
  }
}

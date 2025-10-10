import 'package:bursaconnect/Admin/Screens/Bursary/BursaryDetails.dart';
import 'package:flutter/material.dart';
import 'package:bursaconnect/Admin/Providers/provider.dart';
import 'package:bursaconnect/Users/Models/bursary.dart';
import 'package:provider/provider.dart';
class Bursary extends StatefulWidget {
  const Bursary({super.key});

  @override
  State<Bursary> createState() => _BursaryState();
}

class _BursaryState extends State<Bursary> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<BursaryNotifier>(context,listen:false).listen_to_bursaries();
  }
  @override
  Widget build(BuildContext context) {
  final provider = Provider.of<BursaryNotifier>(context);
  final bursaries = provider.bursaries;
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Bursaries"),
      ),
        body:SafeArea(child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
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

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: bursaries.length,
                    itemBuilder:(context,index) {
                      final bursary = bursaries[index];
                      return Card(
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
                                title: Text(bursary.provider,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(bursary.provider,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(bursary.category,
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
                                  Text(bursary.applicationPeriod,
                                    style: TextStyle(
                                        color: Colors.grey.shade500
                                    ),)
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(onPressed: () {
                                      Navigator.push(
                                          context,
                                        MaterialPageRoute(builder:(context)=>BursaryDetails(bursary:bursary))
                                      );
                                    }
                                     ,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                          )
                                      ),
                                      child: Text("View Details",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadiusGeometry
                                                .circular(10),

                                          )
                                      ),
                                      child: Text("Delete",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  ),


              ],
            ),
          ),
        ),

        ),
    );
  }
}

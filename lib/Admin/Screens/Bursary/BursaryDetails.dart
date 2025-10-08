import 'package:flutter/material.dart';
class BursaryDetails extends StatefulWidget {
  const BursaryDetails({super.key});

  @override
  State<BursaryDetails> createState() => _BursaryDetailsState();
}

class _BursaryDetailsState extends State<BursaryDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("County Government Bursary",
        style: TextStyle(
          fontSize: 18,
        ),),
      ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color(0xFFF9FAFB),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                      height: 1,
                    ),
                   ListTile(
                     leading: Text("Category"),
                     trailing:Text("Government",
                     style: TextStyle(
                       fontSize: 12,
                     ),
                     ),
                   ),
                    Divider(),
                    ListTile(
                      leading: Text("Level of Study"),
                      trailing:Text("Secondary, tertiary",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Region"),
                      trailing:Text("County",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text("Funding Details",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 17,
            ),),
            Card(
              color: Color(0xFFF9FAFB),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ListTile(
                      leading: Text("Funding Type"),
                      trailing:Text("Grant",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Amount Range"),
                      trailing:Text("Ksh 5000 - 25000",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Application Deadline"),
                      trailing:Text("2025-03-31",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Contact Email"),
                      trailing:Text("education@mombasa.go.ke",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Website"),
                      trailing:Text("https://mombasa.go.ke/education",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

}


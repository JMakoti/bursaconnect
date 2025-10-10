import 'package:flutter/material.dart';
import 'package:bursaconnect/Users/Models/bursary.dart';
class BursaryDetails extends StatelessWidget {
  final Bursary? bursary;
  const BursaryDetails({super.key,this.bursary});

  @override
  Widget build(BuildContext context) {
    final bursaryArg = bursary ?? ModalRoute.of(context)?.settings.arguments as Bursary?;

    if (bursaryArg == null) {
      return const Scaffold(
        body: Center(child: Text('No bursary data found')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("${bursaryArg.provider}",
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
                      title: Text("${bursaryArg.provider}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text("Kenya",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                   ListTile(
                     leading: Text("Category"),
                     trailing:Text("${bursaryArg.category}",
                     style: TextStyle(
                       fontSize: 12,
                     ),
                     ),
                   ),
                    Divider(),
                    ListTile(
                      leading: Text("Level of Study"),
                      trailing:Text("${bursaryArg.level}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Region"),
                      trailing:Text("${bursaryArg.region}",
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
                      trailing:Text("${bursaryArg.fundingType}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Amount Range"),
                      trailing:Text("${bursaryArg.amountRange}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Application Deadline"),
                      trailing:Text("${bursaryArg.deadline}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Contact Email"),
                      trailing:Text("${bursaryArg.contactEmail}",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text("Website"),
                      trailing:Text("${bursaryArg.website}",
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


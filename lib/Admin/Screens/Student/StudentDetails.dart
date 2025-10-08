import 'package:flutter/material.dart';
class Studentdetails extends StatefulWidget {
  const Studentdetails({super.key});

  @override
  State<Studentdetails> createState() => _StudentdetailsState();
}

class _StudentdetailsState extends State<Studentdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Student Details"),
    ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTile(title: Text("Student Info"),
                children: [
                 ListTile(
                   leading: Icon(Icons.person,size: 13,),
                   title: Text("Full Name"),
                   subtitle: Text("John Maina"),
                 ),
                  ListTile(
                    leading: Icon(Icons.credit_card,size: 13),
                    title: Text("Student ID"),
                    subtitle: Text("1122334455"),
                  ),
                  ListTile(
                    leading: Icon(Icons.email_outlined,size: 13),
                    title: Text("Email"),
                    subtitle: Text("John@gmail.com"),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card_sharp,size: 13),
                    title: Text("ID Number"),
                    subtitle: Text("112288"),
                  )
                ],
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              ExpansionTile(title: Text("Education Info"),
                children: [
                  ListTile(
                    leading: Icon(Icons.school_outlined,size: 13,),
                    title: Text("Institution"),
                    subtitle: Text("Kenyatta university"),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card,size: 13),
                    title: Text("Level"),
                    subtitle: Text("University"),
                  ),
                  ListTile(
                    leading: Icon(Icons.email_outlined,size: 13),
                    title: Text("Year"),
                    subtitle: Text("Second Year"),
                  ),
                  ListTile(
                    leading: Icon(Icons.school_outlined,size: 13),
                    title: Text("Course"),
                    subtitle: Text("Bachelor of Commerce"),
                  ),
                  ListTile(
                    leading: Icon(Icons.school_outlined,size: 13),
                    title: Text("Course Duration"),
                    subtitle: Text("4 Years"),
                  ),
                  ListTile(
                    leading: Icon(Icons.laptop_chromebook_outlined,size: 13),
                    title: Text("Mode of Study"),
                    subtitle: Text("Regular"),
                  )
                ],
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              ExpansionTile(title: Text("Bursary Info"),
                children: [
                  ListTile(
                    leading: Icon(Icons.monetization_on,size: 13,),
                    title: Text("Amount Requested"),
                    subtitle: Text("15,000"),
                  ),
                  ListTile(
                    leading: Icon(Icons.monetization_on,size: 13),
                    title: Text("Amount Received"),
                    subtitle: Text("10,000"),
                  ),
                  ListTile(
                    leading: Icon(Icons.circle,size: 13,
                    color: Colors.orangeAccent,),
                    title: Text("Status"),
                    subtitle:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

                        ),
                      ],
                    ),
                  )
                ],
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              ExpansionTile(title: Text("Attachments"),
                children: [
                  ListTile(
                    leading: Icon(Icons.attachment,size: 13,),
                    title: Text("Admission Letter.pdf"),
                    subtitle: Wrap(
                      spacing: 5,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.blue),
                        Text("Fee Structure.pdf")
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.attachment,size: 13),
                    title: Text("Fee Structure.pdf"),
                    subtitle: Wrap(
                      spacing: 5,
                      children: [
                        Icon(Icons.picture_as_pdf, color: Colors.blue),
                        Text("Fee Structure.pdf")
                      ],
                    ),
                  ),

                ],
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      )
      ),

    );
  }

}

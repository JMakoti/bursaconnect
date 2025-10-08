import 'package:flutter/material.dart';
class Acceptreject extends StatefulWidget {
  const Acceptreject({super.key});

  @override
  State<Acceptreject> createState() => _AcceptrejectState();
}

class _AcceptrejectState extends State<Acceptreject> {
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
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
              ),
              SizedBox(height: 10),
              ExpansionTile(title: Text("Education Info"),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
              ),
              SizedBox(height: 10),
              ExpansionTile(title: Text("Bursary Info"),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
              ),
              SizedBox(height: 10),
              ExpansionTile(title: Text("Attachments"),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
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
              ),
            ],
          ),
        ),
      )
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(onPressed: (){
                _ShowConfirmationDialog(context, "Reject");
              },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                  ),
                  child: Text("Reject",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                    ),)
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(onPressed: (){
                _ShowConfirmationDialog(context, "Approve");
              },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: Text("Approve",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700
                  ),),
              ),
            )
          ],
        ),),
    );
  }
  void _ShowConfirmationDialog(BuildContext context, String action){
    final isApprove = action == "Approve";
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title:Text(isApprove ? "Approve Application" : "Reject Application"),
            content: Text(isApprove ? 'Are you sure you want to approve this application?' : 'Are you sure you want to reject this application?'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel"),
              ),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isApprove ? Colors.blueAccent : Colors.red
                ), child: Text(
                  isApprove ? "Approve" : "Reject"
              ),
              )
            ],
          );
        }
    );
  }
}

import 'package:flutter/material.dart';
class BursaryDetails extends StatefulWidget {
  const BursaryDetails({super.key});

  @override
  State<BursaryDetails> createState() => _BursaryDetailsState();
}

class _BursaryDetailsState extends State<BursaryDetails> {
  int _selectedIndex = 0;
  final List<String> _tabs = [
   "Description",
    "Terms & Condition",
    "Benefits",
    "Documents"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Scholarship Details"),
      ),
    body: SingleChildScrollView(
      child: Column(
        
        children: [
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
      
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )
            ),
            child: Column(
              children: [
                Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1aQfvqcW7YmIYD0A6DlBNKM8NnFVHqUFMDQ&s',
                width: 380,
                height: 200,
                fit: BoxFit.contain,)
              ],
            ),
          ),
          Container(
            height: 570,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              )
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text("Kenya",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.school_outlined,),
                  title: Text("Undergraduate",
                    style: TextStyle(
                      fontSize: 15,
                    ),),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text("1st September - 30th september",
                    style: TextStyle(
                      fontSize: 15,
                    ),),
                ),
                ListTile(
                  leading: Icon(Icons.clean_hands_rounded),
                  title: Text("Partial patnership",
                    style: TextStyle(
                      fontSize: 15,
                    ),),
                ),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                   scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context,index){
                     final isSelected = _selectedIndex == index;
                     return ChoiceChip(label: Text(
                       _tabs[index],
                       style: TextStyle(
                         fontSize: 13,
                         color: isSelected ? Colors.white : Colors.black87
                       ),
                     ),
                         selected: isSelected,
                       onSelected: (_){
                       setState(() {
                         _selectedIndex = index;
                       });
                       },
                       selectedColor: Colors.blue,
                       backgroundColor: Colors.grey.shade200,
                       labelPadding: EdgeInsets.symmetric(horizontal: 10),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                       ),
      
                     );
                    }
                    ),
                ),
               SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildTabContent(),
                ),
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
  Widget _buildTabContent(){
    switch (_selectedIndex){
      case 0:
        return Text(
    "The NG-CDF University Bursary program provides financial assistance to needy and deserving students enrolled in public and private universities across Kenya.It aims to support students from low-income families by easing the burden of tuition fees and ensuring that financial challenges do not interrupt their education.",style: TextStyle(fontSize: 14),
        );
      case 1 :
        return Text(
          "1.The applicant must be a Kenyan citizen enrolled in a recognized university.\n2.Priority is given to students from the respective constituency of application.\n3.The applicant must provide proof of admission or continuing student status.\n4.Applicants should not be receiving full scholarships from other organizations.\n5.The bursary must be used strictly for educational expenses.\n6.Incomplete or falsified applications will be automatically disqualified.",
          style: TextStyle(fontSize: 14),
        );
      case 2:
        return Text(
          "1.Partial coverage of tuition or accommodation fees.\n2.Financial relief for students facing economic hardships.\n3.Encourages equal access to higher education.\n4.Promotes retention and academic performance among university students.\n5.Builds community connection through NG-CDF educational programs.",
          style: TextStyle(fontSize: 14),
        );
      case 3 :
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.blue),
              title: Text("Scholarship Policy Handbook (PDF)"),
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.blue),
              title: Text("Referee Report Template (PDF)"),
            ),
          ],
        );
      default :
        return SizedBox();
    }
    }
}


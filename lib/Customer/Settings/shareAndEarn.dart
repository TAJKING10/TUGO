import 'package:flutter/material.dart';

class Share_Earn extends StatelessWidget {
  const Share_Earn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 35),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    icon: Image.asset(
                      "images/BackButton.png",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                const Text(
                  'Share And Earn',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'ArchivoBlack',
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0XFFF1F1F1),
            thickness: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 90.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/shareandearn.png',
                  width: 154,
                  height: 154,
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Share with friends',
                  style: TextStyle(
                    fontFamily: 'Archivoblack',
                    fontSize: 24,
                  ),
                ),
                const Text(
                  'Refer to your friend and get',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Get a cash reward of \$5',
                  style: TextStyle(
                    fontFamily: 'poppins',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 199,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Share Now',
                      style: TextStyle(
                        fontFamily: 'poppins',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

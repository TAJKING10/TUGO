import 'package:flutter/material.dart';

class Rate_Us extends StatelessWidget {
  const Rate_Us({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  'Rate Us',
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
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Enjoying the app ',
              style: TextStyle(fontSize: 18, fontFamily: 'poppins'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Give us a rate',
              style: TextStyle(fontSize: 14, fontFamily: 'poppins'),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus imperdiet eleifend purus non mattis.'
              ' Vestibulum fringilla mi vel risus congue ultrices. Pellentesque at purus vel dolor accumsan ullamcorper. '
              'Sed pellentesque, dui non maximus lacinia,'
              ' velit eros condimentum eros, et lacinia enim justo dignissim sapien. Maecenas elementum a eros eu posuere.'
              ' Vivamus sed nunc est. Donec ultrices placerat tempor. Praesent ut imperdiet risus, in venenatis mi. '
              'Etiam varius velit libero, ac porta metus vulputate at.',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 13,
                  color: Color(0XFF808083)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Suspendisse ultrices pulvinar dui, non consequat nibh luctus facilisis.'
              ' Maecenas vitae enim purus. In leo arcu, laoreet ac ligula eu, rutrum auctor massa.'
              ' Vestibulum congue ante eu velit consectetur ultrices. Cras aliquam non mauris at '
              'tincidunt. Donec ex ligula, rhoncus sed egestas vitae, finibus nec lacus. Nulla condimentum '
              'lorem at nisi mattis varius. Integer congue arcu lectus, quis porta massa sodales sed.'
              ' Ut eu lobortis mi. Proin vehicula ac lorem a vestibulum. Morbi ut tempus libero, vitae maximus risus.',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 13,
                  color: Color(0XFF808083)),
            ),
          )
        ],
      ),
    );
  }
}

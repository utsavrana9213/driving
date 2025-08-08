// import 'package:flutter/material.dart';

// class ExamOptionTile extends StatelessWidget {
//   final int index;
//   final String text;
//   final bool selected;
//   final bool isCorrect; // Add this parameter
//   final VoidCallback onTap;

//   const ExamOptionTile({
//     super.key,
//     required this.index,
//     required this.text,
//     required this.selected,
//     required this.isCorrect, // Include it here
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Determine the color based on correctness and selection
//     final Color tileColor =
//         isCorrect ? Colors.green : (selected ? Colors.red : Colors.transparent);

//     final Color borderColor =
//         isCorrect ? Colors.green : (selected ? Colors.red : Colors.white);

//     return OutlinedButton(
//       onPressed: onTap,
//       style: OutlinedButton.styleFrom(
//         side: BorderSide(color: borderColor),
//         padding: const EdgeInsets.all(14),
//         backgroundColor: tileColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 30,
//             height: 30,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               color: Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${index + 1}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );

    
//   }
// }


import 'package:flutter/material.dart';

class ExamOptionTile extends StatelessWidget {
  final int index;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  // Optional new parameters
  final bool isCorrect;
  final bool isWrong;
  final bool disableTap;

  const ExamOptionTile({
    Key? key,
    required this.index,
    required this.text,
    required this.selected,
    required this.onTap,
    this.isCorrect = false,
    this.isWrong = false,
    this.disableTap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tileColor = Colors.transparent;
    Color borderColor = Colors.white;

    if (isCorrect) {
      tileColor = Colors.green;
      borderColor = Colors.green;
    } else if (isWrong) {
      tileColor = Colors.red;
      borderColor = Colors.red;
    } else if (selected) {
      tileColor = Colors.white.withOpacity(0.1);
      borderColor = Colors.red;
    }

    return OutlinedButton(
      onPressed: disableTap ? null : onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        backgroundColor: tileColor,
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

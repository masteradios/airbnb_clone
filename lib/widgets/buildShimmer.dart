import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const double defaultPadding = 16.0;

class BuildShimmer extends StatelessWidget {
  const BuildShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: ShimmerWidget(),
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!);
  }
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.deepPurple,
      ),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                color: Colors.grey,
              ),
              Container(
                height: 200,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.grey, // Shimmer color
                ),
                width: double.infinity,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: SizedBox(
                    width: double.infinity,
                    height: 300,
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

// class ShimmerWidget extends StatelessWidget {
//   const ShimmerWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Skeleton(height: 120, width: 120),
//         const SizedBox(width: defaultPadding),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Skeleton(width: 80),
//               const SizedBox(height: defaultPadding / 2),
//               const Skeleton(),
//               const SizedBox(height: defaultPadding / 2),
//               const Skeleton(),
//               const SizedBox(height: defaultPadding / 2),
//               Row(
//                 children: const [
//                   Expanded(
//                     child: Skeleton(),
//                   ),
//                   SizedBox(width: defaultPadding),
//                   Expanded(
//                     child: Skeleton(),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
//
// class Skeleton extends StatelessWidget {
//   final double? height;
//   final double? width;
//   const Skeleton({super.key, this.width, this.height});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(16),
//       ),
//     );
//   }
// }

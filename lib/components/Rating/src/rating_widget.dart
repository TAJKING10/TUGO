import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Partner/dashboard(partner).dart';
import '../../../Partner/navigationbarPartnerSide.dart';
import 'RatingController.dart';
import 'rating_cubit.dart';
import 'widgets/criterion_button_widget.dart';
import 'widgets/default_button.dart';
import 'widgets/stars_widget.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

// Get the current user's email
String? uid11 = _auth.currentUser?.uid;
class RatingWidget extends StatefulWidget {
  final RatingController controller;
  final String uid1;
  final RatingModel ratingModel; // Add this line
  final String CUSTOMERINITIALuid;

  const RatingWidget({Key? key, required this.controller, required this.uid1, required this.ratingModel, required this.CUSTOMERINITIALuid}) : super(key: key);

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  final animationDuration = const Duration(milliseconds: 800);
  final animationCurve = Curves.ease;

  int selectedRate = 0;
  late RatingController controller = widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      controller.listenStateChanges(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get ratingSurvey {
    final options = [
      '',
      controller.ratingModel.ratingConfig.ratingSurvey1,
      controller.ratingModel.ratingConfig.ratingSurvey2,
      controller.ratingModel.ratingConfig.ratingSurvey3,
      controller.ratingModel.ratingConfig.ratingSurvey4,
      controller.ratingModel.ratingConfig.ratingSurvey5,
    ];
    return options.length > selectedRate
        ? options[selectedRate]
        : options.first;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RatingCubit, RatingState>(
      bloc: controller.ratingCubit,
      buildWhen: (previous, current) =>
      current is LoadingState || previous is LoadingState,
      builder: (context, state) {
        final isLoading = state is LoadingState;
        return IgnorePointer(
          ignoring: isLoading,
          child: AnimatedPadding(
            duration: animationDuration,
            curve: animationCurve,
            padding:
            EdgeInsets.symmetric(horizontal: selectedRate == 0 ? 50 : 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                if (controller.ratingModel.title != null) ...{
                  Text(
                    controller.ratingModel.title!,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                },
                const SizedBox(height: 10),
                if (controller.ratingModel.subtitle != null) ...{
                  Text(controller.ratingModel.subtitle!),
                },
                const SizedBox(height: 20),
                AnimatedContainer(
                  duration: animationDuration,
                  curve: animationCurve,
                  width: selectedRate == 0
                      ? MediaQuery.of(context).size.width * 0.8
                      : MediaQuery.of(context).size.width * 0.4,
                  child: FittedBox(
                    child: StarsWidget(
                      selectedColor: Colors.amber,
                      selectedLenght: selectedRate,
                      unselectedColor: Colors.grey,
                      length: 5,
                      onChanged: (count) {
                        setState(() => selectedRate = count);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedAlign(
                  duration: animationDuration,
                  curve: animationCurve,
                  alignment: Alignment.topCenter,
                  heightFactor: selectedRate == 0 ? 0 : 1,
                  child: AnimatedOpacity(
                    duration: animationDuration,
                    curve: animationCurve,
                    opacity: selectedRate == 0 ? 0 : 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 14),
                        Text(
                          ratingSurvey,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.9,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.from(
                              controller.ratingModel.ratingConfig.items.map(
                                    (criterion) => CriterionButton(
                                  text: criterion.name,
                                  onSelectChange: (selected) => controller
                                      .ratingCubit
                                      .selectedCriterionsUpdate(
                                      criterion, selected),
                                ),
                              )),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Stack(
                  children: [
                    AnimatedOpacity(
                      duration: animationDuration,
                      curve: animationCurve,
                      opacity: selectedRate == 0 ? 0 : 1,
                      child: Center(
                        child: DefaultButton.text(
                          "Confirm",
                          textColor: Colors.white,
                          color: Theme.of(context).colorScheme.secondary,
                          outlineColor: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            // Save the rating
                            // Save the rating
                            controller.ratingCubit.saveRate(selectedRate);

// Get the selected criterion based on the selected rate
                            RatingCriterionModel selectedCriterion;
                            switch (selectedRate) {
                              case 1:
                                selectedCriterion = controller.ratingModel.ratingConfig.items[0];
                                break;
                              case 2:
                                selectedCriterion = controller.ratingModel.ratingConfig.items[1];
                                break;
                              case 3:
                                selectedCriterion = controller.ratingModel.ratingConfig.items[2];
                                break;
                              case 4:
                                selectedCriterion = controller.ratingModel.ratingConfig.items[3];
                                break;
                              default:
                                selectedCriterion = controller.ratingModel.ratingConfig.items[0];
                                break;
                            }

// Update the partner status and save the selected criterion in Firestore
                            FirebaseFirestore.instance
                                .collection('INITIALBOOKING')
                                .doc(widget.uid1)
                                .update({
                              'partnerStatus': 'COMPLETED',
                              'selectedrating': selectedRate,
                              'selectedCriterionId': selectedCriterion.id,
                              'selectedCriterionName': selectedCriterion.name,
                              // 'CUSTOMERRRRRRRRRRRRRRUIDDDDDDDDDDDDD': uid11,

                            }).then((_) {
                              print('Document updated successfully');
                              final FirebaseAuth _auth = FirebaseAuth.instance;

                              // Get the current user's email
                              String? uid11 = _auth.currentUser?.uid;
                              // Fetch customer document
                              FirebaseFirestore.instance.collection('TUGOCUSTOMERS').doc(widget.CUSTOMERINITIALuid).get().then((customerDoc) {
                                if (customerDoc.exists) {
                                  int currentTotalRating = customerDoc.data()?['totalRating'] ?? 0;
                                  int currentNumRatings = customerDoc.data()?['numRatings'] ?? 0;

                                  // Calculate new total rating and number of ratings
                                  int newTotalRating = currentTotalRating + selectedRate;
                                  int newNumRatings = currentNumRatings + 1;

                                  // Update customer document
                                  FirebaseFirestore.instance.collection('TUGOCUSTOMERS').doc(widget.CUSTOMERINITIALuid).update({
                                    'totalRating': newTotalRating,
                                    'numRatings': newNumRatings,
                                  }).then((_) {
                                    print('Customer rating updated successfully');

                                    // Calculate average rating
                                    double averageRating = newTotalRating / newNumRatings;

                                    // Update average rating in Firestore
                                    FirebaseFirestore.instance.collection('TUGOCUSTOMERS').doc(widget.CUSTOMERINITIALuid).update({
                                      'averageRating': averageRating,
                                    }).then((_) {
                                      print('Average rating updated successfully');
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Navigation_Bar_Partner_Side(),
                                        ),
                                      );
                                      // You can add any additional logic here
                                    }).catchError((error) {
                                      print('Error updating average rating: $error');
                                    });
                                  }).catchError((error) {
                                    print('Error updating customer rating: $error');
                                  });
                                } else {
                                  print('Customer document not found');
                                }
                              }).catchError((error) {
                                print('Error fetching customer document: $error');
                              });
                            }).catchError((error) {
                              print('Error updating document: $error');
                            });

                          },

                          isLoading: isLoading,
                        ),
                      ),
                    ),

                    IgnorePointer(
                      ignoring: selectedRate != 0,
                      child: AnimatedOpacity(
                        duration: animationDuration,
                        curve: animationCurve,
                        opacity: selectedRate == 0 ? 1 : 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DefaultButton(
                            outline: false,
                            flat: true,
                            color: Colors.transparent,
                            textColor: const Color(0xFF2F333A),
                            onPressed: () {
                              // Call the function to ignore classification
                              controller.ratingCubit.ignoreForEver();

                              // Update the partner status in Firestore
                              FirebaseFirestore.instance
                                  .collection('INITIALBOOKING')
                                  .doc(widget.uid1)
                                  .update({'partnerStatus': 'COMPLETED'})
                                  .then((_) {
                                print('Document updated successfully');
                                // You can add any additional logic here
                              }).catchError((error) {
                                print('Error updating document: $error');
                              });
                            },
                            isLoading: isLoading,
                            child: const Text(
                              "I'd rather not classify",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }
}

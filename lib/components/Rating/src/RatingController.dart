import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/rating_criterion_model.dart';
import 'models/rating_model.dart';
import 'rating_cubit.dart';

export 'models/rating_criterion_model.dart';
//Exports
export 'models/rating_model.dart';

abstract class RatingController {
  final RatingModel ratingModel;
  RatingController(this.ratingModel);

  Future<void> ignoreForEverCallback();
  Future<void> saveRatingCallback(
      int rate, List<RatingCriterionModel> selectedCriterions);

  late final RatingCubit ratingCubit =
      RatingCubit(ignoreForEverCallback, saveRatingCallback);

  _RatingListenHelper? _ratingListenHelper;
  void listenStateChanges(BuildContext context) {
    _ratingListenHelper = _RatingListenHelper(context, ratingCubit);
  }

  @mustCallSuper
  void dispose() {
    _ratingListenHelper?.dispose();
    ratingCubit.close();
  }
}

class PrintRatingController extends RatingController {
  PrintRatingController(RatingModel ratingModel) : super(ratingModel);

  @override
  Future<void> ignoreForEverCallback() async {
    print('Rating ignored forever!');
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  Future<void> saveRatingCallback(
      int rate, List<RatingCriterionModel> selectedCriterions) async {
    print('Rating saved!\nRate: $rate\nsSelectedItems: $selectedCriterions');
    await Future.delayed(const Duration(seconds: 3));
  }
}

class _RatingListenHelper {
  final BuildContext context;
  _RatingListenHelper(this.context, RatingCubit ratingCubit) {
    // _streamSubscriptions.add(ratingCubit.stream.listen(_loadingStateListener));
    _streamSubscriptions.add(ratingCubit.stream
        .listen(_closeDialogStateListener, onError: _onErrorListener));
    // ratingCubit.stream.handleError(_onErrorListener);
  }

  final _streamSubscriptions = <StreamSubscription>[];

  // void _loadingStateListener(RatingState state) {
  //   if (state is LoadingState) {
  //     LoaderWidget.showLoader(context, title: state.message);
  //   } else {
  //     LoaderWidget.hideLoader(context);
  //   }
  // }

  void _closeDialogStateListener(RatingState state) {
    if (state is CloseDialogState) {
      Navigator.of(context).pop(state.isIgnored);
    }
  }

  void _onErrorListener(Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint("[Person Store Rating Error] - $error");
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(SnackBar(content: Text('Error ocurred: $error')));
    }
  }

  void dispose() {
    for (var subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}

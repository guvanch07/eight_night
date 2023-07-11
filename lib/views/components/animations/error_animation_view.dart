import 'package:eight_night/views/components/animations/lottie_animation_view.dart';
import 'package:eight_night/views/components/animations/models/lottie_animation.dart';

class ErrorAnimationView extends LottieAnimationView {
  const ErrorAnimationView({super.key})
      : super(
          animation: LottieAnimation.error,
          reverse: true,
        );
}

import 'package:flutter/widgets.dart';
import 'package:logos_maru/logos/logos_widget.dart';

class CallbackWidget extends StatelessWidget {

  final VoidCallback? onPressed;

  const CallbackWidget({
    required VoidCallback? this.onPressed,
  });

  @override
  Widget build( BuildContext context ) {
    return GestureDetector(
      onTap: onPressed,
      child: LogosTxt(
        comment: 'callbackTest',
        logosID: 17
      ),
    );
  }
}

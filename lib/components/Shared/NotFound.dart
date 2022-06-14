import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Image.asset("assets/empty_box.png"),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nothing found", style: Theme.of(context).textTheme.headline6),
            Text(
              "The box is empty",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ],
    );
  }
}

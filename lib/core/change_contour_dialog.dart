import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:inspector_tps/core/api/maximo_session.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/redux/app_state.dart';
import 'package:inspector_tps/core/sl.dart';
import 'package:inspector_tps/core/txt.dart';
import 'package:inspector_tps/core/utils/core_utils.dart';
import 'package:inspector_tps/data/local_storages/shared_prefs.dart';

void changeContourDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => StoreConnector<AppState, bool>(
        converter: (store) => store.state.isDev,
        builder: (context, isDev) {
          return AlertDialog(
            title: Text(Txt.changeContourDialogTitle),
            content: ChangeContourDialogContent(isDev: isDev),
            actions: [
              TextButton(
                onPressed: () {
                  saveDev(!isDev);
                  context.store.dispatch(IsDevAction(!isDev));
                  sl<MaximoSession>().config();
                },
                child: Text(
                  isDev ? Txt.setProd : Txt.setDev,
                ),
              ),
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: Text(Txt.ok)),
            ],
          );
        }),
  );
}

class ChangeContourDialogContent extends StatefulWidget {
  const ChangeContourDialogContent({super.key, required this.isDev});

  final bool isDev;

  @override
  State<ChangeContourDialogContent> createState() =>
      _ChangeContourDialogContentState();
}

class _ChangeContourDialogContentState
    extends State<ChangeContourDialogContent> {
  final TextEditingController controller =
      TextEditingController(text: readHost());


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(changeContourDialogDescription(widget.isDev)),
        if (widget.isDev) ...[
          TextField(
            controller: controller,
          ),
          TextButton(
              onPressed: () {
                saveHost(controller.text.trim());
                setState(() {});
                sl<MaximoSession>().config();
              },
              child: Text(
                Txt.changeAddress,
                style: const TextStyle(color: Colors.red),
              )),
        ],
      ],
    );
  }
}

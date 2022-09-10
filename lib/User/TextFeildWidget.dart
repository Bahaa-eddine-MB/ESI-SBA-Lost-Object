import 'package:flutter/material.dart';

class TextFeildWidget extends StatefulWidget {
  final int maxLines;
  final bool phone;
  final String label;
  final String text;
  final bool hint;
  final ValueChanged<String> onChanged;
  const TextFeildWidget(
      {Key? key,
      required this.label,
      required this.text,
      required this.onChanged,
      this.maxLines = 1,
      required this.phone,
      required this.hint})
      : super(key: key);

  @override
  State<TextFeildWidget> createState() => _TextFeildWidgetState();
}

class _TextFeildWidgetState extends State<TextFeildWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return 
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: widget.hint == true
                  ? "Add something about you"
                  : widget.phone == true
                      ? "Add a phone number"
                      : "",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: widget.phone ? TextInputType.phone : null,
            controller: controller,
            maxLines: widget.maxLines,
          )
        ],
     
    );
  }
}

import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:todoapp/uploadPic.dart';

Future showDialogs({required BuildContext context}) async {
  final HtmlEditorController _htmlController = HtmlEditorController();
  String? downloadUrl;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              content: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 29),
                      Container(
                        height: 350,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: HtmlEditor(
                          controller: _htmlController,
                          htmlEditorOptions: const HtmlEditorOptions(
                            hint: 'Add Description...',
                            autoAdjustHeight: false,
                            shouldEnsureVisible: true,
                          ),
                          htmlToolbarOptions: const HtmlToolbarOptions(
                            toolbarPosition: ToolbarPosition.aboveEditor,
                            toolbarItemHeight: 25,
                            gridViewHorizontalSpacing: 6,
                            gridViewVerticalSpacing: 6,
                            renderBorder: true,
                            renderSeparatorWidget: false,

                            //by default
                            defaultToolbarButtons: [
                              FontButtons(
                                  bold: true,
                                  italic: true,
                                  underline: true,
                                  superscript: true,
                                  subscript: true,
                                  strikethrough: true,
                                  clearAll: false),
                              ListButtons(
                                  ol: true, ul: true, listStyles: false),
                              ColorButtons(
                                  highlightColor: true, foregroundColor: false),
                              InsertButtons(
                                  link: true,
                                  picture: true,
                                  audio: false,
                                  hr: false,
                                  otherFile: false,
                                  table: false,
                                  video: false),
                            ],
                            toolbarType: ToolbarType.nativeGrid,
                            dropdownIconSize: 18.0,
                            //by default
                          ),
                          plugins: [
                            SummernoteAtMention(
                              getSuggestionsMobile: (String value) {
                                var mentions = <String>[
                                  'test1',
                                  'test2',
                                  'test3'
                                ];
                                return mentions
                                    .where((element) => element.contains(value))
                                    .toList();
                              },
                              mentionsWeb: ['test1', 'test2', 'test3'],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Add Image"),
                            Container(
                                height: 29,
                                width: 34,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.9)),
                                child: const Icon(
                                  Icons.attach_file,
                                  color: Colors.lightBlue,
                                  size: 19.0,
                                )),
                          ],
                        ),
                        onTap: () async {
                          downloadUrl = await uploadData(context);
                        },
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 200,
                        height: 58,
                        child: ElevatedButton(
                          child: const Text(
                            '+SUBMIT',
                          ),
                          onPressed: () async {
                            String desc = await _htmlController.getText();
                            Navigator.pop(context,
                                {"desc": desc, 'url': downloadUrl ?? ""});
                          },
                        ),
                      ),
                    ]),
              ));
        });
      });
}

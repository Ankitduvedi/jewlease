import 'dart:html'; // For DivElement
import 'dart:js' as js; // For invoking JavaScript
import 'dart:ui' as ui; // For platformViewRegistry (Web only)

import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';

class ExcelSheet extends StatefulWidget {
  @override
  _ExcelSheetState createState() => _ExcelSheetState();
}

class _ExcelSheetState extends State<ExcelSheet> {
  // 2D list to store cell values
  @override
  void initState() {
    // TODO: implement initState
    if (kIsWeb) {
      // Register the custom HTML element (only for Flutter Web)
      ui.platformViewRegistry.registerViewFactory(
        'handsontable-container',
        (int viewId) => DivElement()..id = 'spreadsheet',
      );
    }
    js.context.callMethod('initializeHandsontable');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    js.context.callMethod('dismissSpreadsheet');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: 'handsontable-container');
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPdfPath;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      // Cargar el archivo desde assets
      final bytes = await rootBundle.load('assets/pdfs/terminos_condiciones.pdf');
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/terminos_condiciones.pdf');

      // Guardar el archivo en almacenamiento local
      await file.writeAsBytes(bytes.buffer.asUint8List());

      // Actualizar la ruta del archivo cargado
      setState(() {
        localPdfPath = file.path;
        errorMessage = null; // Reiniciar mensaje de error
      });
    } catch (e) {
      // Manejo de errores
      setState(() {
        localPdfPath = null;
        errorMessage = 'Error al cargar el PDF: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        backgroundColor: Colors.green,
      ),
      body: errorMessage != null
          ? _buildErrorWidget()
          : (localPdfPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: localPdfPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          setState(() {
            errorMessage = 'Error al renderizar el PDF: $error';
          });
        },
        onRender: (pages) {
          print('Total de páginas: $pages');
        },
      )),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadPdf,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}
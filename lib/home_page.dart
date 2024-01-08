import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> rams = [2, 3, 4, 6, 8, 12, 16];

  double? ram = 8;
  double screen = 5.5;
  double capacity = 5500;
  bool? isInstagramChecked = false;
  // bool? isTwitterChecked = false;
  // bool? isYoutubeChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Karbon Ayak İzi Hesapla',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _ramInput(context),
                const SizedBox(height: 10),
                _screenSize(),
                const SizedBox(height: 10),
                _batteryCapacity(),
                const SizedBox(height: 10),
                const Text(
                  'Hesaplanacak Uygulamalar:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // CheckboxListTile(
                //   title: const Text('Instagram'),
                //   secondary: const Icon(FontAwesomeIcons.instagram),
                //   value: isInstagramChecked,
                //   onChanged: (value) => {
                //     setState(() {
                //       isInstagramChecked = value;
                //     })
                //   },
                // ),
                // CheckboxListTile(
                //   title: const Text('Twitter'),
                //   secondary: const Icon(FontAwesomeIcons.twitter),
                //   value: isTwitterChecked,
                //   onChanged: (value) => {
                //     setState(() {
                //       isTwitterChecked = value;
                //     })
                //   },
                // ),
                // CheckboxListTile(
                //   title: const Text('Youtube'),
                //   secondary: const Icon(FontAwesomeIcons.youtube),
                //   value: isYoutubeChecked,
                //   onChanged: (value) => {
                //     setState(() {
                //       isYoutubeChecked = value;
                //     })
                //   },
                // ),
              ],
            ),
            ElevatedButton(
              onPressed: () => {sendDataToServer()},
              child: const Text('Hesapla'),
            )
          ],
        ),
      ),
    );
  }

  void sendDataToServer() async {
    Map<String, dynamic> data = {
      'ram': ram,
      'screen': screen,
      'capacity': capacity,
      // 'isInstagramChecked': isInstagramChecked,
      // 'isTwitterChecked': isTwitterChecked,
      // 'isYoutubeChecked': isYoutubeChecked,
    };

    String jsonData = jsonEncode(data);

    try {
      var url = Uri.parse("http://10.0.2.2:5000/predict");

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Data sent successfully!');
      } else {
        print('Failed to send data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }
  }

  Widget _batteryCapacity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pil Kapasitesi (mAh): ${capacity.toDouble()}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Slider(
          divisions: 122,
          min: 800,
          max: 13000,
          value: capacity,
          onChanged: (value) => {
            setState(() {
              print(value);
              capacity = value;
            })
          },
        ),
      ],
    );
  }

  Widget _screenSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ekran Boyutu: $screen',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Slider(
          divisions: 20,
          min: 5,
          max: 7,
          value: screen,
          onChanged: (value) => {
            setState(() {
              print(value);
              screen = value;
            })
          },
        ),
      ],
    );
  }

  Widget _ramInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('RAM:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(
          child: DropdownButtonFormField<double>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(width: 1, color: Colors.black)),
            ),
            onChanged: (selectedValue) => {
              if (selectedValue is double)
                {
                  setState(() {
                    ram = selectedValue;
                  })
                }
            },
            value: ram,
            items: rams
                .map(
                  (item) => DropdownMenuItem<double>(
                    value: item,
                    child: Text("$item GB"),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

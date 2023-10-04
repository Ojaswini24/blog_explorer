import 'package:flutter/material.dart';

class BlogContent extends StatelessWidget {
  final String title;
  final String imageUrl;

  BlogContent({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF885566),
        title: Text('Blog Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey, // Set the background color to black
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                width: 200, // Set the desired width for the image
                height: 200, // Set the desired height for the image
              ),
              SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set text color to white
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

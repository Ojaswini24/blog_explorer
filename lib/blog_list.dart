import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'blog_content.dart';
import 'blog.dart';

class BlogLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF885566),
        title: Text('Blog Explorer'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BlogSearchDelegate(), // Custom search delegate
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: BlogList(),
      ),
    );
  }
}

class BlogList extends StatefulWidget {
  @override
  _BlogListState createState() => _BlogListState();
}

List<Blog> filteredBlogs = []; // Initialize filteredBlogs

class _BlogListState extends State<BlogList> {
  List<Blog> blogs = [];

  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  void fetchBlogs() async {
    const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
    const String adminSecret =
        '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData.containsKey('blogs') &&
            responseData['blogs'] is List) {
          final List<dynamic> blogData = responseData['blogs'];

          final List<Blog> fetchedBlogs = blogData.map((data) {
            return Blog(
              title: data['title'],
              imageUrl: data['image_url'],
            );
          }).toList();

          setState(() {
            blogs = fetchedBlogs;
            filteredBlogs = blogs; // Initialize filteredBlogs
            isLoading = false;
          });
        } else {
          print('Unexpected response format: $responseData');
        }
      } else {
        setState(() {
          errorMessage = 'Failed to fetch blogs. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  void filterBlogs(String query) {
    // Filter the blogs based on the search query
    final filtered = blogs.where((blog) {
      final titleLower = blog.title.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredBlogs = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: filteredBlogs.length, // Use filteredBlogs
        itemBuilder: (context, index) {
          final blog = filteredBlogs[index]; // Use filteredBlogs
          return Card(
            elevation: 5.0,
            margin: EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(
                blog.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Image.network(
                blog.imageUrl,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogContent(
                      title: blog.title,
                      imageUrl: blog.imageUrl,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}

class BlogSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar (e.g., clear text)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show search results based on the query
    final filteredResults = filteredBlogs.where((blog) {
      // Use filteredBlogs
      final titleLower = blog.title.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) {
        final blog = filteredResults[index];
        return ListTile(
          title: Text(blog.title),
          onTap: () {
            // Navigate to the blog detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogContent(
                  title: blog.title,
                  imageUrl: blog.imageUrl,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while typing
    final suggestionList = query.isEmpty
        ? []
        : filteredBlogs.where((blog) {
            // Use filteredBlogs
            final titleLower = blog.title.toLowerCase();
            final queryLower = query.toLowerCase();
            return titleLower.contains(queryLower);
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final blog = suggestionList[index];
        return ListTile(
          title: Text(blog.title),
          onTap: () {
            // Populate the search bar with the selected suggestion
            query = blog.title;
          },
        );
      },
    );
  }
}

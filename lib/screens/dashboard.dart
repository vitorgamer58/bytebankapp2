import 'package:bytebank2/screens/contacts_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image.network('https://imgr.search.brave.com/unILmJy79E7kr0bWh3tOZPIjvhVv0TypOiGLM_FuVBo/fit/480/324/no/1/aHR0cHM6Ly9jZG4u/c2hvcGlmeS5jb20v/cy9maWxlcy8xLzA3/NDIvOTgzMS9wcm9k/dWN0cy9BbmNhcF9m/bGFnX2RpZ2l0YWxf/bGFyZ2UucG5nP3Y9/MTQ5MjY1NzI1Ng')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/bytebank_logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactsList()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 120,
                    width: 130,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.people,
                          color: Colors.white,
                          size: 24,
                        ),
                        Text(
                          'Contatos',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:easyred/Firebase/FirebaseUtils.dart';
import 'package:easyred/Utils/PostContent.dart';
import 'package:easyred/Utils/widgetButtons.dart';
import 'package:easyred/Pages/Home/drawerHome.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int op = 0;
  Future<void> _userDataFuture = Future.value();

  @override
  void initState() {
    super.initState();

    /// inicializan los datos
    _userDataFuture = Provider.of<FirebaseUtils>(context, listen: false)
        .initUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerHome(),
      body: FutureBuilder<void>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se cargan los datos
            return Center(
                child: Image.asset(
              'assets/images/loading.gif',
              height: 50,
              width: 50,
            ));
          } else if (snapshot.hasError) {
            // Manejar cualquier error que ocurra durante la carga de datos
            return Center(child: Text('Error al cargar los datos'));
          } else {
            // Los datos están listos, construye la interfaz de usuario
            return _buildProfileUI();
          }
        },
      ),
    );
  }

  Widget _buildProfileUI() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 24.0),
                child: Center(child: _buildAvatarWidget()),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  '@${Provider.of<FirebaseUtils>(context, listen: false).initUsername}',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 20),
                ),
              ),
              Container_Buttons(),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          op = 1;
                        });
                      },
                      child: Text(
                        'Posts',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: HexColor('A138C1'),
                        ),
                      ),
                    ),
                    /*
                    TextButton(
                      onPressed: () {
                        setState(() {
                          op = 2;
                        });
                      },
                      child: Text(
                        'Videos',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: HexColor('A138C1'),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          op = 3;
                        });
                      },
                      child: Text(
                        'About',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: HexColor('A138C1'),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
              op == 1 ? PostContent() : op == 2 ? Container(child: Text('contenedor videos'),) : Container(child: Text('contenedor about'),),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildAvatarWidget() {
    String? userAvatarUrl =
        Provider.of<FirebaseUtils>(context, listen: false).initUserAvatar;
    if (userAvatarUrl == null || userAvatarUrl.isEmpty) {
      return CircleAvatar(
        radius: 70,
        backgroundImage: AssetImage('assets/images/default.jpg'),
      );
    } else {
      return CircleAvatar(
        radius: 70,
        backgroundImage: NetworkImage(userAvatarUrl),
      );
    }
  }
}

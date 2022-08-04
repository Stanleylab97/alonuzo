import 'package:alonuzo/Launcher/login_success/login_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthentificationPreestataire extends StatefulWidget {
  const AuthentificationPreestataire({Key? key}) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<AuthentificationPreestataire>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 1),
              child: Container(
                margin: EdgeInsets.only(top: 2),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * .01),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: TabBar(
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.white,
                              labelStyle: TextStyle(fontSize: 20.0),
                              indicatorColor: Colors.white,
                              indicatorWeight: 2,
                              indicator: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    blurRadius: 25,
                                    offset: Offset(
                                        0, 20), // changes position of shadow
                                  ),
                                ],
                              ),
                              controller: tabController,
                              tabs: [
                                Tab(
                                  text: 'Particulier',
                                ),
                                Tab(
                                  text: 'Entreprise',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Inscription",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.josefinSans(
                                        textStyle: TextStyle(),
                                        fontSize: 60,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Et si on exposait vos services au monde ?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.squarePeg(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: size.height * .05,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Nom",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.person),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Prénoms",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon:
                                          Icon(Icons.verified_user_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Téléphone",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.phone_android),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "E-mail",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Quartier",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.place),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Mot de passe",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.password_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Confirmez le mot de passe",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.password_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginSuccessScreen()));
                                    },
                                    child: Text(
                                      "S'inscrire",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(52, 57, 76, 1),
                                      shape: StadiumBorder(),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Déjà inscrit ?"),
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Se conneter",
                                            style:
                                                TextStyle(color: Colors.orange),
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            )),
                          ),
                          SingleChildScrollView(
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Inscription",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.josefinSans(
                                        textStyle: TextStyle(),
                                        fontSize: 60,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "Et si on exposait vos services au monde ?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.squarePeg(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: size.height * .05,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Raison sociale",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.business_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "E-mail",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Téléphone",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.phone),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Régistre de commerce",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.email_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Mot de passe",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.password_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    decoration: InputDecoration(
                                      hintText: "Confirmez le mot de passe",
                                      fillColor: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.1),
                                      filled: true,
                                      prefixIcon: Icon(Icons.password_outlined),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18),
                                          borderSide: BorderSide.none),
                                    ),
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: size.height * .05,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      "S'inscrire",
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromRGBO(52, 57, 76, 1),
                                      shape: StadiumBorder(),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Déjà inscrit ?"),
                                      TextButton(
                                          onPressed: () {},
                                          child: Text("Se conneter",
                                              style: TextStyle(
                                                  color: Colors.orange)))
                                    ],
                                  )
                                ],
                              ),
                            )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          
      ),
    );
  }
}

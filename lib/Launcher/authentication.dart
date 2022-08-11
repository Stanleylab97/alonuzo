import 'dart:convert';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:alonuzo/Launcher/login_success/login_success_screen.dart';
import 'package:alonuzo/services/networkHandler.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/secteur_activite.dart';

class AuthentificationPreestataire extends StatefulWidget {
  const AuthentificationPreestataire({Key? key}) : super(key: key);

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<AuthentificationPreestataire>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  NetworkHandler networkHandler = NetworkHandler();
  bool isLoading = false;
  Logger log = Logger();
  String token = "";
  late String errorText;

  late List<Secteur> autoCompleteData = [];

  isConnected() async {
    return await DataConnectionChecker().connectionStatus;
    // actively listen for status update
  }

  getArticles() async {
    DataConnectionStatus status = await isConnected();
    List<Secteur> list = [];
    if (status == DataConnectionStatus.connected) {
      var response = await networkHandler.unsecureget("/metier/liste");

      if (response.statusCode == 200) {
        Map<String, dynamic> output = json.decode(response.body);
        var y = output['metiers']
            .map((metier) => Secteur.fromJson(metier))
            .toList();
         log.v(y);
        for (Secteur i in y) {
          list.add(i);
        }
        setState(() {
          autoCompleteData = list;
          isLoading = false;
        });
      } else {
        setState(() {
          if (response.statusCode == 401) {
            errorText = 'Token invalide. Veuillez vous reconnecter';
            log.e('Erreur ${response.statusCode}: $errorText');
            isLoading = false;

            Flushbar(
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              message: errorText,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              duration: Duration(seconds: 3),
            )..show(context);

            autoCompleteData = [];
          }

          if (response.statusCode == 500) {
            errorText = 'Erreur de connexion au serveur';
            log.e('Erreur ${response.statusCode}: $errorText');
            isLoading = false;
            Flushbar(
              margin: EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
              message: errorText,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              duration: Duration(seconds: 3),
            )..show(context);
            autoCompleteData = [];
          }
        });
      }
    } else {
      setState(() {
        autoCompleteData = [];
      });
      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        message: 'Veuillez vérifier votre connexion internet',
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue[300],
        ),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future fetchAutoCompleteData() async {
    setState(() {
      isLoading = true;
    });

    getArticles();

    setState(() {
      isLoading = false;
    });
  }

  bool vis = true;
  bool validate = false;
  bool circular = false;
  //Particulier controllers
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _village_quartier1 = TextEditingController();
  TextEditingController _sexe = TextEditingController();
  TextEditingController _telephone_mobile = TextEditingController();
  TextEditingController _email1 = TextEditingController();
  TextEditingController _nip = TextEditingController();
  TextEditingController _secteur = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password1confirm = TextEditingController();

  //Entreprise controllers
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController _raison_sociale = TextEditingController();
  TextEditingController _adresse = TextEditingController();
  TextEditingController _email2 = TextEditingController();
  TextEditingController _telephone_fixe = TextEditingController();
  TextEditingController _numero_rccm = TextEditingController();
  TextEditingController _site_internet = TextEditingController();
  TextEditingController _village_quartier2 = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _password2confirm = TextEditingController();

  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    fetchAutoCompleteData();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  registerParticulier() async {
    if (_formKey.currentState!.validate()) {
      // final prefs = await SharedPreferences.getInstance();
      // final storage = new FlutterSecureStorage();

      setState(() {
        circular = true;
      });
      Map<String, dynamic> data = {
        "village_quartiers_id": 1,
        "nom": _nom.text.trim(),
        "prenom": _prenom.text,
        "sexe": _sexe,
        "telephone_mobile": _telephone_mobile.text.trim(),
        "email": _email1.text.trim(),
        // "numero_identification_personnelle": _nip.text,
        "type_prestataire": "Particulier",
        "numero_piece": "25554454",
        "nature_piece": "IFU",
        "secteur_activite": [1, 2],
        // "password": _password1.text.trim(),

        //"statut_prestataire":"ON"
      };
      DataConnectionStatus status = await isConnected();
      if (status == DataConnectionStatus.connected) {
        var response =
            await networkHandler.unsecurepost("/createprestataire", data);

        if (response.statusCode == 200) {
          Map<String, dynamic> output = json.decode(response.body);

          // await storage.write(key: "token" , value:  output["token"]);
          /*  await prefs.setString('username', output["userName"]);
          await prefs.setString('nom', output["nom"]);
          await prefs.setString('prenom', output["prenoms"]); */

          setState(() {
            validate = true;
            circular = false;
          });

          Navigator.pushNamedAndRemoveUntil(
              context, LoginSuccessScreen.routeName, (route) => false);
        } else {
          setState(() {
            validate = false;
            if (response.statusCode == 401) {
              circular = false;
              errorText = 'Identifiant ou mot de passe incorrects';
              //log.e('Erreur ${response.statusCode}: $errorText');

              Flushbar(
                margin: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                message: errorText,
                icon: Icon(
                  Icons.info_outline,
                  size: 28.0,
                  color: Colors.blue[300],
                ),
                duration: Duration(seconds: 3),
              )..show(context);
            }

            if (response.statusCode == 500) {
              circular = false;
              errorText = 'Erreur système détectée';
              CherryToast.error(
                      title: Text("Erreur réseau"),
                      displayTitle: false,
                      description: Text(errorText),
                      animationType: AnimationType.fromRight,
                      animationDuration: Duration(milliseconds: 1000),
                      autoDismiss: true)
                  .show(context);
            }
          });

          _password2.clear();
        }
      } else {
        setState(() {
          circular = false;
        });
        CherryToast.error(
                title: Text("Erreur réseau"),
                displayTitle: false,
                description: Text("Vérifiez votre connexion internet!"),
                animationType: AnimationType.fromRight,
                animationDuration: Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
      }
    }
  }

  showError(String errormessage) {
    return Flushbar(
      message: errormessage,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue[300],
    )..show(context);
  }

  registerEntreprise() async {
    if (_formKey2.currentState!.validate()) {
      /*  final prefs = await SharedPreferences.getInstance();
      final storage = new FlutterSecureStorage(); */

      setState(() {
        circular = true;
      });
      Map<String, String> data = {
        "raison_sociale": _raison_sociale.text.trim(),
        "adresse": _adresse.text.trim(),
        "telephone_fixe": _telephone_fixe.text.trim(),
        "site_internet": _site_internet.text.trim(),
        "numero_rccm": _numero_rccm.text.trim(),
        // "password": _password2.text.trim()
      };
      DataConnectionStatus status = await isConnected();
      if (status == DataConnectionStatus.connected) {
        var response =
            await networkHandler.authenticateUser("/authenticate", data);

        if (response.statusCode == 200) {
          Map<String, dynamic> output = json.decode(response.body);

          /*   log.v(output["token"]);
          await prefs.setString('token', output["token"]);
          log.v(prefs.getString("token")); */

          // await storage.write(key: "token" , value:  output["token"]);
          /*    await prefs.setString('username', output["userName"]);
          await prefs.setString('nom', output["nom"]);
          await prefs.setString('prenom', output["prenoms"]);
 */
          setState(() {
            validate = true;
            circular = false;
          });

          Navigator.pushNamedAndRemoveUntil(
              context, LoginSuccessScreen.routeName, (route) => false);
        } else {
          setState(() {
            validate = false;
            if (response.statusCode == 401) {
              circular = false;
              errorText = 'Identifiant ou mot de passe incorrects';
              //log.e('Erreur ${response.statusCode}: $errorText');

              Flushbar(
                margin: EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
                message: errorText,
                icon: Icon(
                  Icons.info_outline,
                  size: 28.0,
                  color: Colors.blue[300],
                ),
                duration: Duration(seconds: 3),
              )..show(context);
            }

            if (response.statusCode == 500) {
              circular = false;
              errorText = 'Erreur système détectée';
              CherryToast.error(
                      title: Text("Erreur réseau"),
                      displayTitle: false,
                      description: Text(errorText),
                      animationType: AnimationType.fromRight,
                      animationDuration: Duration(milliseconds: 1000),
                      autoDismiss: true)
                  .show(context);
            }
          });

          _password1.clear();
        }
      } else {
        setState(() {
          circular = false;
        });
        CherryToast.error(
                title: Text("Erreur réseau"),
                displayTitle: false,
                description: Text("Vérifiez votre connexion internet!"),
                animationType: AnimationType.fromRight,
                animationDuration: Duration(milliseconds: 1000),
                autoDismiss: true)
            .show(context);
      }
    }
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
                                offset:
                                    Offset(0, 20), // changes position of shadow
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
                          child: Form(
                            key: _formKey,
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
                                TextFormField(
                                  controller: _nom,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Entrez votre nom';

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorText: validate ? null : "",
                                    labelText: 'Nom',
                                    prefixIcon: Icon(Icons.person),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    fillColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none),
                                  ),
                                  //onSaved: (input) => _email = input
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _nom,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Saisir le prénom';

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorText: validate ? null : "",
                                    labelText: 'Prénoms',
                                    prefixIcon: Icon(Icons.verified_user),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    fillColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none),
                                  ),
                                  //onSaved: (input) => _email = input
                                ),
                                Autocomplete<Secteur>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return List.empty();
                                    } else {
                                      return autoCompleteData.where((article) =>
                                          article.libelle
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase()));
                                    }
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return Material(
                                      elevation: 4,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);

                                          return ListTile(
                                            title: SubstringHighlight(
                                              text: option.libelle,
                                              term: _secteur.text,
                                              textStyleHighlight: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                              setState(() {
                                                //_secteur.text = option.libelle;
                                              });
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: options.length,
                                      ),
                                    );
                                  },
                                  onSelected: (selectedString) =>
                                      print(selectedString.libelle),
                                  displayStringForOption: (Secteur d) =>
                                      '${d.libelle} ${d.code} ${d.libelle}',
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    this._secteur = controller;

                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        labelText: 'Secteur d\'activité',
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: BorderSide.none),
                                        hintText: "Recherche de métier",
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _telephone_mobile,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Saisissez le téléphone';

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorText: validate
                                        ? null
                                        : "",
                                    labelText: 'Téléphone',
                                    prefixIcon: Icon(Icons.phone_android),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    fillColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none),
                                  ),
                                  //onSaved: (input) => _email = input
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _email1,
                                  validator: (input) {
                                    if (input!.isEmpty)
                                      return 'Entrez votre mail';

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorText:
                                        validate ? null : "",
                                    labelText: 'E-mail',
                                    prefixIcon: Icon(Icons.mail),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    fillColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none),
                                  ),
                                  //onSaved: (input) => _email = input
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Département",
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
                                Autocomplete<Secteur>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return List.empty();
                                    } else {
                                      return autoCompleteData.where((article) =>
                                          article.libelle
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase()));
                                    }
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return Material(
                                      elevation: 4,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);

                                          return ListTile(
                                            title: SubstringHighlight(
                                              text: option.libelle,
                                              term: _secteur.text,
                                              textStyleHighlight: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                              setState(() {
                                                //_secteur.text = option.libelle;
                                              });
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: options.length,
                                      ),
                                    );
                                  },
                                  onSelected: (selectedString) =>
                                      print(selectedString.libelle),
                                  displayStringForOption: (Secteur d) =>
                                      '${d.libelle} ${d.code} ${d.libelle}',
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    this._secteur = controller;

                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        labelText: 'Commune',
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: BorderSide.none),
                                        hintText: "Recherche de commune",
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Autocomplete<Secteur>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return List.empty();
                                    } else {
                                      return autoCompleteData.where((article) =>
                                          article.libelle
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase()));
                                    }
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return Material(
                                      elevation: 4,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);

                                          return ListTile(
                                            title: SubstringHighlight(
                                              text: option.libelle,
                                              term: _secteur.text,
                                              textStyleHighlight: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                              setState(() {
                                                //_secteur.text = option.libelle;
                                              });
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: options.length,
                                      ),
                                    );
                                  },
                                  onSelected: (selectedString) =>
                                      print(selectedString.libelle),
                                  displayStringForOption: (Secteur d) =>
                                      '${d.libelle} ${d.code} ${d.libelle}',
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    this._secteur = controller;

                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        labelText: 'Arrondissement',
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: BorderSide.none),
                                        hintText: "Recherche d\'arrondissement",
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Autocomplete<Secteur>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return List.empty();
                                    } else {
                                      return autoCompleteData.where((article) =>
                                          article.libelle
                                              .toLowerCase()
                                              .contains(textEditingValue.text
                                                  .toLowerCase()));
                                    }
                                  },
                                  optionsViewBuilder:
                                      (context, onSelected, options) {
                                    return Material(
                                      elevation: 4,
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);

                                          return ListTile(
                                            title: SubstringHighlight(
                                              text: option.libelle,
                                              term: _secteur.text,
                                              textStyleHighlight: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                              setState(() {
                                                //_secteur.text = option.libelle;
                                              });
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: options.length,
                                      ),
                                    );
                                  },
                                  onSelected: (selectedString) =>
                                      print(selectedString.libelle),
                                  displayStringForOption: (Secteur d) =>
                                      '${d.libelle} ${d.code} ${d.libelle}',
                                  fieldViewBuilder: (context, controller,
                                      focusNode, onEditingComplete) {
                                    this._secteur = controller;

                                    return TextFormField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      onEditingComplete: onEditingComplete,
                                      decoration: InputDecoration(
                                        labelText: 'Quartier',
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        filled: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: BorderSide.none),
                                        hintText: "Recherche de quartier",
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                /*  TextField(
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
                                ),*/
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
                                    fontSize: 25, fontWeight: FontWeight.w600),
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
                              /*  TextField(
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
                              ), */
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
                                          style:
                                              TextStyle(color: Colors.orange)))
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

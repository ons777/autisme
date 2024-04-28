import 'package:flutter/material.dart';

class RessourcesPage extends StatelessWidget {
  const RessourcesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ressources pour les parents'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conseils pour gérer les enfants autistes
            Text(
              'Dix conseils pour communiquer avec un enfant autiste.',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1. Favorisez des jeux en lien avec les intérêts de l’enfant',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '2. Mettez-vous à la hauteur de l’enfant, afin de favoriser une communication face à face et faciliter l’échange',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '3. Mettez l’accent sur les mots importants',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '4. Utilisez des supports visuels (gestes, photos, images)',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '5. Ajustez votre niveau de langage à celui de l’enfant, en utilisant des énoncés juste un peu plus longs que ceux qu’il produit',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '6. Répétez souvent les mêmes mots, dans différents contextes, afin de favoriser l’apprentissage du vocabulaire',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '7. Parlez beaucoup de ce que qu’on fait, ou de ce que l’enfant fait, afin de donner des modèles de petits énoncés adéquats',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '8. Exagérez les expressions et les exclamations pour susciter une réaction chez l’enfant',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '9. Stimulez la communication dans des contextes naturels de la vie quotidienne (ex : lors des repas, du bain, des jeux)',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '10. Gardez en tête que la communication se stimule dans le plaisir.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),

            SizedBox(height: 20.0),

            // Adresses et numéros de professionnels
            _buildSectionTitle('Adresses et numéros de professionnels :'),
            SizedBox(height: 10.0),
            _buildInfo(
              'Psychologues spécialisés :',
              'Dr. Olfa Moussa\nAdresse : 3  rue khadouja themri, Tunis, \nTél : 27 548 330',
            ),
            _buildInfo(
              'Centre des enfants autiste :',
              'Adresse :  R46W+4FX, Rue des Orangers\nTél : 96 379 080',
            ),
            SizedBox(height: 20.0),

            // Liens vers une playlist de musique
            _buildSectionTitle('Playlist de musique apaisante :'),
            SizedBox(height: 10.0),
            _buildLink(
              'Écoutez notre playlist de musique relaxante sur Spotify',
              'https://open.spotify.com/playlist/6AYjWnOD9wJUuOaXij1KxP',
            ),
            SizedBox(height: 20.0),

            // Liens vers des jeux pour les enfants autistes
            _buildSectionTitle('Jeux pour les enfants autistes :'),
            SizedBox(height: 10.0),
            _buildLink(
              'Jouez à des jeux interactifs sur Autisme-Education',
              'https://www.autisme-education.com/',
            ),
            _buildLink(
              'Découvrez des jeux éducatifs sur Autism Speaks',
              'https://www.autismspeaks.org/activities',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          description,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildInfo(String title, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          details,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildLink(String title, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 5.0),
        InkWell(
          onTap: () {
            // Ouvrir le lien lorsque l'utilisateur appuie dessus
            // (vous pouvez remplacer cette fonction par l'ouverture du lien dans le navigateur ou dans votre application)
          },
          child: Text(
            url,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}

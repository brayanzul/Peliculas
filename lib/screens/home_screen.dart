import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Peliculas de Cines'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon( Icons.search_outlined ),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
      
            // Tarjetaa Principales
            CardSwiper( movies: moviesProvider.onDisPlayMovies ),
      
            // Slider de Peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies, // populares
              title: 'Populares', // opcional
              onNextPage: () => moviesProvider.getPopularMovies()
            ),
      
          ],
        ),
      )
    );
  }
}
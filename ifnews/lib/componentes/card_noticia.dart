import 'package:flutter/material.dart';
import 'package:ifnews/estado.dart';

class CardNoticia extends StatelessWidget {
  final dynamic noticia;

  const CardNoticia({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        estadoApp.mostrarDetalhes(noticia["_id"]);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da notícia
            if (noticia["noticia"]["blobs"] != null &&
                noticia["noticia"]["blobs"].isNotEmpty)
              Image.asset(
                'lib/recursos/imagens/${noticia["noticia"]["blobs"][0]["file"]}',
                fit: BoxFit.cover,
              )
            else
              Image.asset(
                'lib/recursos/imagens/default_image.jpeg',
                fit: BoxFit.cover,
              ),
            // Título da notícia
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                noticia["noticia"]["titulo"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            // Autor da notícia
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 18),
                  const SizedBox(width: 5.0),
                  Text(
                    noticia["noticia"]["autor"],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Expanded(
              // Adiciona o Expanded para dar mais espaço ao conteúdo
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 18),
                        const SizedBox(width: 5.0),
                        Text(
                          noticia["likes"].toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';
import 'package:productosapp/screens/loading_screen.dart';
import 'package:productosapp/services/product_service.dart';
import 'package:productosapp/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    final produstsService = Provider.of<ProductService>(context);
    if (produstsService.isLoading) return LoadingScreen(); // blequea pantalla

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: produstsService.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          child: ProductCard(product: produstsService.products[index],),
          onTap: () {
            produstsService.selectedProduct = produstsService.products[index].copy();
            Navigator.pushNamed(context, 'product').then((value) => setState((){}));
          }
        )
      ),
      floatingActionButton:  FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          produstsService.selectedProduct = new Product(
            available: true,
            name: '',
            price: 0
          );
          Navigator.pushNamed(context, 'product').then((value) => setState((){}));
        },
      ),
    );
  }
}
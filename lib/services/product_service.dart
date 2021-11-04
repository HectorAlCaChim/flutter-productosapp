
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:productosapp/models/models.dart';

class  ProductService extends ChangeNotifier {
  final String _baseUrl = 'flutter-courses-cf94a-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  Product selectedProduct;
  File newPicture;
  bool isSaving = true;
  bool isLoading = true; // bandera para saver la carga de la request

  ProductService() {
    this.loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode( resp.body );

    productsMap.forEach((key, value) {
      final temProduct = Product.fromMap(value);
      temProduct.id = key;
      this.products.add(temProduct);
    });

    this.isLoading = false;
    notifyListeners();
    return this.products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      // se agrega un nuevo producto
      this.createProduct(product);
    } else {
      this.updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }
  Future createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());

    // Agregar a la lista
    final decodeData = json.decode(resp.body);
    product.id = decodeData['name'];
    this.products.add(product);

    print(products.toString());

    return product.id;
  }
  Future updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());

    // Actualizar la lista de productos
    final index = this.products.indexWhere((element) => element.id == product.id);
    this.products[index] = product;

    print(products.toString());

    return product.id;
  }
  void updateSeletedProductImage(String path) {

    this.selectedProduct.picture = path;
    this.newPicture = File.fromUri(Uri(path: path));

    notifyListeners();

  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:productosapp/providers/product_form_provider.dart';
import 'package:productosapp/services/product_service.dart';
import 'package:productosapp/widgets/products_image.dart';
import 'package:productosapp/ui/input_decorations.dart';
import 'package:provider/provider.dart';
class ProductsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvder(productService.selectedProduct),
      child: _ProductsScreenBody(productService: productService)
    );
    //return _ProductsScreenBody(productService: productService);
  }
}

class _ProductsScreenBody extends StatelessWidget {
  const _ProductsScreenBody({
    Key key,
    @required this.productService,
  }) : super(key: key);

  final ProductService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvder>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(url: productService.selectedProduct.picture,),
                Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 40, color: Colors.white,), 
                    onPressed: () => Navigator.of(context).pop(), // salir de la pagina actual
                  )
                ),
                Positioned(
                  top: 60,
                  right: 20,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white,), 
                    onPressed: () async {
                      // camara o galeria
                      final picker = new ImagePicker();
                      final PickedFile pickedFile = await picker.getImage(
                        source: ImageSource.camera,
                        imageQuality: 100
                      );
                      if (pickedFile == null) {
                        print('Imgen no seleccionada');
                      }
                      print('Tenemos una imagen');
                      productService.updateSeletedProductImage(pickedFile.path);
                    }, 
                  )
                )
              ],
            ),
            _ProductForm(),
            SizedBox(height: 100,)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () async {
          // guardar producto
          if (!productForm.isValiForm()) return;
          await productService.saveOrCreateProduct(productForm.product);
        },
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvder>(context);
    final product = productForm.product;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 200,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10,),

              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.length<1) 
                    return 'El nombre es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre'
                ),
              ),
              SizedBox(height: 30,),

              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value) == null) {
                    product.price = 0;
                  } else  {
                    product.price = double.parse(value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio'
                ),
              ),

              SizedBox(height: 30,),

              SwitchListTile.adaptive(
                title: Text('Disponible'),
                activeColor: Colors.indigo,
                value: product.available, 
                onChanged: productForm.updateAvailable
              ),

              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )
    ],
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25))
  );
}
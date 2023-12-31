import 'package:bukatokoid/models/slider_model.dart';
import 'package:bukatokoid/screens/all_product_screen.dart';
import 'package:bukatokoid/services/product_service.dart';
import 'package:bukatokoid/utils/constants.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:bukatokoid/services/slider_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:bukatokoid/core/widgets.dart';
import 'package:bukatokoid/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> products;
  List<SliderModel> sliders = [];
  int activeIndex = 0;
  @override
  void initState() {
    sliders = getSliders();
    products = ProductService().fetchTopProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: sliders.length,
              itemBuilder: (context, index, realIndex) {
                String? img = sliders[index].image;
                String? name = sliders[index].name;
                return BuildCarousel(imageUrl: img!, name: name!);
              },
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: sliders.length,
              effect: const ExpandingDotsEffect(
                  activeDotColor: primaryColor,
                  dotColor: Colors.grey,
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 10),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed('/allProducts');
                    },
                    child: const Text(
                      "More",
                      style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: products,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String? img = snapshot.data![index].image;
                        String? title = snapshot.data![index].title;
                        String? price = snapshot.data![index].price.toString();
                        return ProductCard(
                            imageUrl: img, title: title, price: price);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

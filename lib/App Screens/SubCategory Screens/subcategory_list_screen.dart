import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:avtoskola_varketilshi/Models/subcategory_model.dart';
import 'package:avtoskola_varketilshi/Utils%20&%20Services/subcategory_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subcategory_practice_screen.dart';

class SubCategoryListScreen extends StatelessWidget {
  const SubCategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe argument extraction with comprehensive error handling
    String category;
    
    try {
      final dynamic args = Get.arguments;
      
      // Debug logging
      print('🔍 SubCategoryListScreen received: $args (type: ${args.runtimeType})');
      
      if (args == null) {
        category = 'B, B1';
        print('⚠️ No arguments, using default: $category');
      } else if (args is String) {
        category = args;
        print('✅ String argument: $category');
      } else if (args is Map) {
        // Handle any type of Map
        final Map<dynamic, dynamic> mapArgs = args;
        if (mapArgs.containsKey('category')) {
          category = mapArgs['category']?.toString() ?? 'B, B1';
          print('📋 Map with category key: $category');
        } else if (mapArgs.isNotEmpty) {
          category = mapArgs.values.first?.toString() ?? 'B, B1';
          print('🗂️ Map first value: $category');
        } else {
          category = 'B, B1';
          print('📭 Empty map, using default: $category');
        }
      } else {
        category = args.toString();
        print('🔄 Other type converted: $category');
      }
    } catch (e) {
      // Fallback in case of any error
      category = 'B, B1';
      print('❌ Error processing arguments: $e, using default: $category');
    }
    
    final List<SubCategoryModel> subCategories = SubCategoryService.getSubCategories(category);
    final languageController = Get.find<LanguageController>();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.red),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/slogo.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Sub-categories List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  final subCategory = subCategories[index];
                  return _buildSubCategoryListItem(
                    context,
                    subCategory,
                    index + 1,
                    languageController.isEnglish,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubCategoryListItem(
    BuildContext context,
    SubCategoryModel subCategory,
    int number,
    bool isEnglish,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => SubCategoryPracticeScreen(),
            arguments: {
              'subCategory': subCategory,
              'category': subCategory.category,
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade700,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEnglish ? subCategory.nameEn : subCategory.nameKa,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEnglish ? subCategory.descriptionEn : subCategory.descriptionKa,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:avtoskola_varketilshi/Controllers/Exams%20Controllers/enhanced_exam_controller.dart';
import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:avtoskola_varketilshi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnhancedExamScreen extends StatelessWidget {
  const EnhancedExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EnhancedExamController());
    final languageController = Get.find<LanguageController>();
    
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before leaving exam
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.exam),
            content: const Text('Are you sure you want to exit the exam?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.loading,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }
            
            final question = controller.currentQuestion;
            if (question == null) {
              return const Center(
                child: Text(
                  'No questions available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            
            return Column(
              children: [
                // Top bar with timer and stats (fixed at top)
                _buildTopBar(controller, context),
                
                // Progress bar
                _buildProgressBar(controller),
                
                // Scrollable content area
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                      // Question display
                      _buildQuestionSection(question, controller, languageController, context),
                      
                      // Options
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            for (int i = 0; i < question.options.length; i++)
                              _buildOptionTile(controller, question, i, context, languageController),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      
                      // Bottom navigation
                      _buildBottomNavigation(controller, context),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
  
  Widget _buildTopBar(EnhancedExamController controller, BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              // Back arrow
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer, color: Colors.red, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      controller.formattedTime,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Correct Answers Counter (1/32 format)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.correctAnswersCount.value}/${controller.examQuestions.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Incorrect Answers Counter (1/32 format)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cancel, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.wrongAnswersCount.value}/${controller.maxIncorrectAnswers.value + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Question ID
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.tag, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '#${controller.currentQuestion?.id ?? 0}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Logo at the right side
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 28,
                  width: 28,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.drive_eta,
                        color: Colors.white,
                        size: 18,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  
  Widget _buildProgressBar(EnhancedExamController controller) {
    return Container(
      height: 4,
      child: LinearProgressIndicator(
        value: controller.progressPercentage,
        backgroundColor: Colors.grey.shade800,
        valueColor: AlwaysStoppedAnimation<Color>(
          controller.wrongAnswersCount.value > controller.maxIncorrectAnswers.value 
            ? Colors.red 
            : Colors.green,
        ),
      ),
    );
  }
  
  Widget _buildQuestionSection(question, EnhancedExamController controller, LanguageController languageController, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number
          Text(
            'Question ${controller.currentIndex.value + 1} of ${controller.examQuestions.length}',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          
          // Question image if available
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: InteractiveViewer(
                  panEnabled: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 3.0,
                  child: _buildQuestionImage(question.imageUrl!),
                ),
              ),
            ),
          if (question.imageUrl != null) const SizedBox(height: 12),
          
          // Question text
          Obx(() => Text(
            question.getLocalizedQuestion(languageController.currentLanguageCode),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildQuestionImage(String imageUrl) {
    // Debug: Print the image URL being loaded
    print('🖼️ Loading image: $imageUrl');
    
    // List of possible image paths to try
    List<String> imagePaths = [
      imageUrl, // Original path from JSON
      imageUrl.replaceAll('assets/', ''), // Remove 'assets/' prefix if present
      'assets/$imageUrl', // Add 'assets/' prefix if missing
      imageUrl.replaceAll('assets/Qimages/', 'assets/images/'), // Try images folder
      'assets/images/1.png', // Default fallback image
    ];
    
    // Remove duplicates
    imagePaths = imagePaths.toSet().toList();
    
    // Debug: Print all paths being tried
    print('🔍 Trying paths: $imagePaths');
    
    return _tryLoadImage(imagePaths, 0, imageUrl);
  }
  
  Widget _tryLoadImage(List<String> paths, int index, String originalUrl) {
    if (index >= paths.length) {
      // All paths failed, show detailed fallback UI
      return GestureDetector(
        onTap: () {
          // Show debug information
          print('❌ All image paths failed for: $originalUrl');
          print('📁 Tried paths: $paths');
        },
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade400, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image,
                  color: Colors.red.shade400,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Image Not Found',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expected: ${originalUrl}',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Tap for Debug Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    print('🔄 Trying path ${index + 1}/${paths.length}: ${paths[index]}');
    
    return Image.asset(
      paths[index],
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        print('❌ Failed to load: ${paths[index]}');
        print('Error: $error');
        // Try next path
        return _tryLoadImage(paths, index + 1, originalUrl);
      },
    );
  }
  
  Widget _buildOptionTile(
    EnhancedExamController controller,
    question,
    int index,
    BuildContext context,
    LanguageController languageController,
  ) {
    final isSelected = controller.isSelected(controller.currentIndex.value, index);
    final isCorrect = controller.isCorrectAnswer(controller.currentIndex.value, index);
    final isWrong = controller.isWrongAnswer(controller.currentIndex.value, index);
    
    Color? backgroundColor;
    Color? borderColor;
    Color? textColor;
    IconData? icon;
    
    if (controller.showingAnswer.value) {
      if (isCorrect) {
        backgroundColor = Colors.green.withOpacity(0.2);
        borderColor = Colors.green;
        textColor = Colors.green;
        icon = Icons.check_circle;
      } else if (isWrong) {
        backgroundColor = Colors.red.withOpacity(0.2);
        borderColor = Colors.red;
        textColor = Colors.red;
        icon = Icons.cancel;
      } else if (!isSelected && controller.isCorrectAnswer(controller.currentIndex.value, index)) {
        // Show correct answer even if not selected
        backgroundColor = Colors.green.withOpacity(0.1);
        borderColor = Colors.green.withOpacity(0.5);
        textColor = Colors.green.withOpacity(0.8);
      }
    } else if (isSelected) {
      backgroundColor = Colors.blue.withOpacity(0.2);
      borderColor = Colors.blue;
      textColor = Colors.blue;
    }
    
    return GestureDetector(
      onTap: controller.showingAnswer.value 
        ? null 
        : () => controller.selectOption(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade700,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Option letter
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: (borderColor ?? Colors.grey.shade700).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(65 + index), // A, B, C, D
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Option text
            Expanded(
              child: Obx(() => Text(
                question.getLocalizedOptions(languageController.currentLanguageCode)[index],
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 14,
                ),
              )),
            ),
            
            // Result icon
            if (icon != null)
              Icon(icon, color: borderColor, size: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomNavigation(EnhancedExamController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: controller.currentIndex.value > 0 && !controller.showingAnswer.value
                ? () => controller.previousQuestion()
                : null,
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.previous),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Skip button
          if (controller.canSkipQuestion)
            Expanded(
              child: ElevatedButton(
                onPressed: !controller.showingAnswer.value
                  ? () => controller.skipQuestion()
                  : null,
                child: const Text('Skip'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          
          const SizedBox(width: 8),
          
          // Next button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: !controller.showingAnswer.value &&
                      controller.currentIndex.value < controller.examQuestions.length - 1
                ? () => controller.moveToNextQuestion()
                : null,
              icon: const Icon(Icons.arrow_forward),
              label: Text(AppLocalizations.of(context)!.next),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

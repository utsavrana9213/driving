import 'package:avtoskola_varketilshi/Controllers/SubCategory%20Controllers/practice_controller.dart';
import 'package:avtoskola_varketilshi/Controllers/language_controller.dart';
import 'package:avtoskola_varketilshi/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryPracticeScreen extends StatelessWidget {
  const SubCategoryPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PracticeController());
    final languageController = Get.find<LanguageController>();
    
    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before leaving practice
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Practice?'),
            content: const Text('Your progress will be lost. Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(AppLocalizations.of(context)!.no),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(AppLocalizations.of(context)!.yes),
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
                // Top bar with counters
                _buildTopBar(controller, context, languageController.isEnglish),
                
                // Progress bar
                _buildProgressBar(controller),
                
                // Question display
                _buildQuestionSection(question, controller, languageController, context),
                
                // Options
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (int i = 0; i < question.options.length; i++)
                          _buildOptionTile(controller, question, i, context, languageController),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                
                // Bottom navigation
                _buildBottomNavigation(controller, context),
              ],
            );
          }),
        ),
      ),
    );
  }
  
  Widget _buildTopBar(PracticeController controller, BuildContext context, bool isEnglish) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            children: [
              // Back button
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.red),
              ),
              
              // Sub-category name
              Expanded(
                child: Column(
                  children: [
                    Text(
                      isEnglish ? controller.subCategory.nameEn : controller.subCategory.nameKa,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Practice Mode',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Reload JSON button (for developers)
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.grey.shade900,
                      title: const Text('Reload Questions?', style: TextStyle(color: Colors.white)),
                      content: const Text(
                        'This will reload questions from JSON files.\nUse this after modifying image paths in JSON files.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.forceReloadQuestions();
                            Navigator.of(context).pop();
                            Get.snackbar(
                              'Questions Reloaded',
                              'JSON files have been reloaded with latest changes',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: const Duration(seconds: 2),
                            );
                          },
                          child: const Text('Reload', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.sync, color: Colors.blue),
                tooltip: 'Reload JSON files',
              ),
              
              // Reset button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset Practice?'),
                      content: const Text('This will clear all your answers and start over.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(AppLocalizations.of(context)!.no),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.resetPractice();
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.yes),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.refresh, color: Colors.orange),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Score counters
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Correct counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.correctAnswersCount}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Wrong counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.wrongAnswersCount}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Score percentage
              if (controller.totalAnswered.value > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.scorePercentage.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar(PracticeController controller) {
    return Container(
      height: 4,
      child: LinearProgressIndicator(
        value: controller.progressPercentage,
        backgroundColor: Colors.grey.shade800,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
  
  Widget _buildQuestionSection(question, PracticeController controller, LanguageController languageController, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${controller.currentIndex.value + 1} of ${controller.questions.length}',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
              if (controller.isCurrentQuestionAnswered)
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Question image if available
          if (question.imageUrl != null && question.imageUrl!.isNotEmpty)
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
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
                  child: _buildPracticeQuestionImage(question.imageUrl!, question.id, context),
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
  
  Widget _buildOptionTile(
    PracticeController controller,
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
    } else if (isSelected && !controller.showingAnswer.value) {
      backgroundColor = Colors.blue.withOpacity(0.2);
      borderColor = Colors.blue;
      textColor = Colors.blue;
    }
    
    return GestureDetector(
      onTap: controller.showingAnswer.value || controller.isCurrentQuestionAnswered
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
  
  Widget _buildBottomNavigation(PracticeController controller, BuildContext context) {
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
          
          // Question selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '${controller.currentIndex.value + 1}/${controller.questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Next button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: !controller.showingAnswer.value &&
                      controller.currentIndex.value < controller.questions.length - 1
                ? () => controller.nextQuestion()
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

  Widget _buildPracticeQuestionImage(String imageUrl, int questionId, BuildContext context) {
    // Clean image loading - use exact path from controller
    return Image.asset(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Show a helpful placeholder when image is missing
        return Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade400, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                color: Colors.orange.shade400,
                size: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Missing Image Q$questionId',
                style: TextStyle(
                  color: Colors.orange.shade400,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expected: $imageUrl',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

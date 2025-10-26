#!/usr/bin/env python3
"""
Script to verify that D and T-S category questions have unique image paths
"""

import json
import os

def verify_category(category_dir, category_name, expected_folder):
    """Verify a specific category"""
    
    base_path = "/Users/utsavrana/Downloads/untitled folder 2/Driving-License-Guide-App/assets/questions"
    category_path = os.path.join(base_path, category_dir)
    
    print(f"\n🔍 Verifying {category_name} Category ({category_dir}):")
    print("=" * 50)
    
    if not os.path.exists(category_path):
        print(f"❌ Path not found: {category_path}")
        return
    
    total_questions = 0
    unique_images = set()
    sample_questions = []
    
    # Process all JSON files in the category
    for filename in os.listdir(category_path):
        if filename.endswith('.json'):
            file_path = os.path.join(category_path, filename)
            
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    questions = json.load(f)
                
                for question in questions:
                    q_id = question.get('id')
                    image_url = question.get('imageUrl', 'NO IMAGE')
                    
                    total_questions += 1
                    unique_images.add(image_url)
                    
                    # Collect first 5 questions as samples
                    if len(sample_questions) < 5:
                        sample_questions.append((q_id, image_url))
                        
            except Exception as e:
                print(f"❌ Error reading {filename}: {e}")
    
    # Show sample questions
    print("📝 Sample Questions:")
    for q_id, image_url in sample_questions:
        print(f"  Q{q_id}: {image_url}")
    
    print(f"\n📊 Statistics:")
    print(f"  Total questions: {total_questions}")
    print(f"  Unique images: {len(unique_images)}")
    print(f"  All unique: {'YES ✅' if len(unique_images) == total_questions else 'NO ❌'}")
    
    # Check if images follow expected pattern
    expected_pattern_count = 0
    for image_url in unique_images:
        if f"assets/Qimages/{expected_folder}/" in image_url and image_url.endswith('.jpg'):
            expected_pattern_count += 1
    
    print(f"  Expected pattern: {expected_pattern_count}/{len(unique_images)} images")
    print(f"  Pattern: assets/Qimages/{expected_folder}/q[ID].jpg")

def main():
    """Main verification function"""
    
    print("🎯 Verifying D and T-S Categories Only")
    print("=" * 60)
    
    # Verify D category
    verify_category("d", "D", "D")
    
    # Verify T-S category  
    verify_category("t-s", "T-S", "TS")
    
    print(f"\n✅ Verification Complete!")
    print(f"\nNext steps:")
    print(f"1. Run the app")
    print(f"2. Go to practice screen for D or T-S categories")
    print(f"3. Tap the blue reload button (🔄)")
    print(f"4. Each question should show unique images!")

if __name__ == "__main__":
    main()

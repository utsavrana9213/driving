#!/usr/bin/env python3
"""
Script to automatically set unique images for each question in JSON files.
This will replace all "assets/images/image.png" with unique paths like "assets/Qimages/B/q752.jpg"
"""

import json
import os

def fix_json_images(file_path, category_folder):
    """Fix image URLs in a JSON file to be unique per question"""
    
    print(f"Processing: {file_path}")
    
    # Read the JSON file
    with open(file_path, 'r', encoding='utf-8') as f:
        questions = json.load(f)
    
    # Update each question with unique image
    modified = False
    for question in questions:
        question_id = question.get('id')
        current_image = question.get('imageUrl', '')
        
        # If it's using the generic "assets/images/image.png", replace with unique path
        if current_image == "assets/images/image.png" or current_image == "":
            new_image = f"assets/Qimages/{category_folder}/q{question_id}.jpg"
            question['imageUrl'] = new_image
            print(f"  Q{question_id}: {current_image} -> {new_image}")
            modified = True
        else:
            print(f"  Q{question_id}: keeping custom image: {current_image}")
    
    # Write back the file if modified
    if modified:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(questions, f, indent=2, ensure_ascii=False)
        print(f"✅ Updated {file_path}")
    else:
        print(f"ℹ️  No changes needed for {file_path}")
    
    return modified

def main():
    """Main function to process all JSON files"""
    
    base_path = "/Users/utsavrana/Downloads/untitled folder 2/Driving-License-Guide-App/assets/questions"
    
    # Define category mappings
    categories = {
        "b-b1": "B",
        "c": "C", 
        "d": "D",
        "t-s": "TS"
    }
    
    total_modified = 0
    
    for category_dir, category_folder in categories.items():
        category_path = os.path.join(base_path, category_dir)
        
        if os.path.exists(category_path):
            print(f"\n📁 Processing category: {category_dir} -> {category_folder}")
            
            # Process all JSON files in the category
            for filename in os.listdir(category_path):
                if filename.endswith('.json'):
                    file_path = os.path.join(category_path, filename)
                    if fix_json_images(file_path, category_folder):
                        total_modified += 1
        else:
            print(f"⚠️  Category path not found: {category_path}")
    
    print(f"\n🎉 Done! Modified {total_modified} files.")
    print("\nNext steps:")
    print("1. Run the app")
    print("2. Go to practice screen")
    print("3. Tap the blue reload button (🔄)")
    print("4. Each question should now have a unique image path!")

if __name__ == "__main__":
    main()

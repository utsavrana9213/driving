#!/usr/bin/env python3
"""
Script to verify that each question has a unique image path
"""

import json
import os

def verify_warning_signs():
    """Check the warning signs JSON file"""
    
    file_path = "/Users/utsavrana/Downloads/untitled folder 2/Driving-License-Guide-App/assets/questions/b-b1/bb1_warning_signs.json"
    
    print("🔍 Verifying Warning Signs Images:")
    print("=" * 50)
    
    with open(file_path, 'r', encoding='utf-8') as f:
        questions = json.load(f)
    
    for i, question in enumerate(questions[:10]):  # Show first 10 questions
        q_id = question.get('id')
        image_url = question.get('imageUrl', 'NO IMAGE')
        print(f"Q{q_id}: {image_url}")
    
    print(f"\n✅ Total questions: {len(questions)}")
    
    # Check for duplicates
    image_urls = [q.get('imageUrl', '') for q in questions]
    unique_images = set(image_urls)
    
    print(f"📊 Unique images: {len(unique_images)}")
    print(f"🎯 All unique: {'YES' if len(unique_images) == len(questions) else 'NO'}")
    
    if len(unique_images) != len(questions):
        # Find duplicates
        from collections import Counter
        counts = Counter(image_urls)
        duplicates = {url: count for url, count in counts.items() if count > 1}
        print(f"🔄 Duplicates found: {duplicates}")

if __name__ == "__main__":
    verify_warning_signs()

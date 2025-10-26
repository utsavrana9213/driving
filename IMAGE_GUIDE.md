# 📸 How to Add Unique Images for Each Question

## Quick Setup Guide

### Method 1: Add Images via JSON (Recommended)
Edit the JSON file for your questions and specify unique images:

```json
{
  "id": 752,
  "imageUrl": "assets/images/traffic_sign_752.png",
  ...
},
{
  "id": 753,
  "imageUrl": "assets/images/road_marking_753.jpg",
  ...
},
{
  "id": 754,
  "imageUrl": "assets/images/intersection_754.png",
  ...
}
```

### Method 2: Use Question ID-based Images
Place images with the question ID as the filename:

**For B, B1 Category:**
- `assets/Qimages/B/q752.png`
- `assets/Qimages/B/q753.png`
- `assets/Qimages/B/q754.png`

**For C Category:**
- `assets/Qimages/C/q752.png`
- `assets/Qimages/C/q753.png`

**For D Category:**
- `assets/Qimages/D/q752.png`
- `assets/Qimages/D/q753.png`

**For T, S Category:**
- `assets/Qimages/TS/q752.png`
- `assets/Qimages/TS/q753.png`

## 🎯 How It Works Now

1. **Custom Images First**: If you specify an `imageUrl` in the JSON, it will ALWAYS be used
2. **Auto-Generated Fallback**: If no `imageUrl` is specified, it generates: `assets/Qimages/[category]/q[id].png`
3. **No More Same Images**: Each question gets a unique image based on its ID

## 📝 Examples

### Example 1: Custom Image for Specific Question
```json
{
  "id": 752,
  "imageUrl": "assets/images/my_custom_image.png",
  "question": "..."
}
```

### Example 2: Leave Empty for Auto-Generated
```json
{
  "id": 753,
  "imageUrl": "",  // Will use: assets/Qimages/B/q753.png
  "question": "..."
}
```

### Example 3: Mix Custom and Auto-Generated
```json
[
  {
    "id": 752,
    "imageUrl": "assets/images/custom_752.png",  // Custom
    ...
  },
  {
    "id": 753,
    "imageUrl": "",  // Auto: assets/Qimages/B/q753.png
    ...
  },
  {
    "id": 754,
    "imageUrl": "assets/images/special_sign.jpg",  // Custom
    ...
  }
]
```

## 🔄 How to Apply Changes

1. **Edit JSON file** with your image paths
2. **Add image files** to the specified locations
3. **In the app**: Tap the blue sync button (🔄) to reload
4. **Or restart** the app for a fresh load

## 📂 Folder Structure
```
assets/
├── images/           # Your custom images
│   ├── traffic_sign_752.png
│   ├── road_marking_753.jpg
│   └── intersection_754.png
├── Qimages/
│   ├── B/           # B, B1 category images
│   │   ├── q752.png
│   │   ├── q753.png
│   │   └── q754.png
│   ├── C/           # C category images
│   ├── D/           # D category images
│   └── TS/          # T, S category images
```

## ✅ Benefits

- **Unique images** for every question
- **Easy to manage** - just edit JSON
- **Flexible** - use any image path
- **No code changes** needed
- **Works immediately** with reload button

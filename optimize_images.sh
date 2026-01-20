#!/bin/bash

# Backup images folder within public
if [ ! -d "public/images_backup" ]; then
    echo "Creating backup in public/images_backup..."
    cp -r public/images public/images_backup
else
    echo "Backup already exists in public/images_backup, skipping backup creation."
fi

# Optimize JPEGs larger than 300KB (lowered threshold)
echo "Optimizing JPEGs..."
find public/images -type f \( -name "*.jpg" -o -name "*.jpeg" \) -size +300k -print0 | while IFS= read -r -d '' file; do
    current_size=$(ls -lh "$file" | awk '{print $5}')
    echo "Optimizing $file ($current_size)..."
    # Resize to max width 800px and set quality to 60%
    sips -Z 800 -s formatOptions 60 "$file" --out "$file" > /dev/null
done

# Optimize PNGs larger than 300KB
echo "Optimizing PNGs..."
find public/images -type f -name "*.png" -size +300k -print0 | while IFS= read -r -d '' file; do
    current_size=$(ls -lh "$file" | awk '{print $5}')
    echo "Optimizing $file ($current_size)..."
    # Resize to max width 800px
    sips -Z 800 "$file" --out "$file" > /dev/null
done

echo "Optimization complete."

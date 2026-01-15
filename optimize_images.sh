#!/bin/bash

# Backup images folder
if [ ! -d "images_backup" ]; then
    echo "Creating backup..."
    cp -r images images_backup
else
    echo "Backup already exists, skipping backup creation."
fi

# Optimize JPEGs larger than 500KB
echo "Optimizing JPEGs..."
find images -type f \( -name "*.jpg" -o -name "*.jpeg" \) -size +500k | while read file; do
    current_size=$(ls -lh "$file" | awk '{print $5}')
    echo "Optimizing $file ($current_size)..."
    # Resize to max width 1600px and set quality to 70%
    sips -Z 1600 -s formatOptions 70 "$file" --out "$file" > /dev/null
done

# Optimize PNGs larger than 500KB (Resize only, sips png compression is limited)
echo "Optimizing PNGs..."
find images -type f -name "*.png" -size +500k | while read file; do
    current_size=$(ls -lh "$file" | awk '{print $5}')
    echo "Optimizing $file ($current_size)..."
    sips -Z 1600 "$file" --out "$file" > /dev/null
done

echo "Optimization complete."

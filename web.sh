
#!/bin/bash

export flutter_path=$(which flutter)
export flutter_web_sdk_folder=${flutter_path%flutter}cache/flutter_web_sdk

if [ ! -d $flutter_web_sdk_folder ]; then
  echo Flutter web sdk folder not found!
  read -n1 -p "Press any key to exit..."
  exit
fi

echo Find flutter web sdk folder:
echo $flutter_web_sdk_folder
echo
read -n1 -p "Press any key to continue..."

echo "Start performing the replacement..."
find $flutter_web_sdk_folder/kernel -name dart_sdk.js | xargs sed -i 's?//unpkg.com/?//cdn.jsdelivr.net/npm/?g'
echo "Complete replacement!"
read -n1 -p "Press any key to exit..."

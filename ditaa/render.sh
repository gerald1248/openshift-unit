rm *.png
for file in `find . -type f | grep -v "\(png\|sh\)$"`; do
  ditaa ${file}
done

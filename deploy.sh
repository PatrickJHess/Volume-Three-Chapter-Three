
# to deploy run ./deploy.sh
#!/bin/bash
echo "Cleaning old build..."
myst clean --all
echo "Baking with BASE_URL..."
BASE_URL="/Volume-Three-Chapter-Three/" myst build --html
echo "Shipping to GitHub Pages..."
ghp-import -n -p -f _build/html
echo "Done! Check your site in 60 seconds."

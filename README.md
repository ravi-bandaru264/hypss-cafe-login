# Hypss-Cafe Login Demo

## Demo credentials
- Username: `admin`
- Password: `cafe123`

This is a front-end demo login. Credentials are checked in browser JavaScript only; do **not** use this approach for a real production authentication system. Production login should use a server/backend, secure password hashing, HTTPS, and session/token management.

## Run locally
1. Extract the ZIP folder.
2. Open `index.html` in a browser, or use VS Code and the Live Server extension.
3. Enter the demo credentials above.
4. Successful login opens the demo cafe dashboard; Logout returns to the login screen.

## Deploy with Netlify (easy)
1. Open https://app.netlify.com/ and sign up/login.
2. In Netlify, choose **Add new site → Deploy manually**.
3. Drag the extracted project folder (the folder containing `index.html`, `style.css`, `script.js`, and `assets`) into the deployment area.
4. Wait for deployment. Netlify will provide a public website URL.
5. Open the URL and test the login.

## Deploy with GitHub Pages
1. Create a GitHub repository and upload all project files/folders.
2. Open repository **Settings → Pages**.
3. Under Build and deployment, select **Deploy from a branch**.
4. Choose `main` and `/ (root)`, then Save.
5. Wait for GitHub Pages to publish and open the generated URL.

## Deploy with Vercel
1. Sign in to https://vercel.com/.
2. Import your GitHub repository.
3. For this static project, leave framework preset as **Other** and build command empty.
4. Set output directory to `.` (root), then deploy.

All three options can host this static demo. For production cafe management and real accounts, connect a secure backend/database before using real credentials.

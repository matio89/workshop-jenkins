# Create image based off of our express back end base image
FROM gmc-express-back-base:latest

# Get all the code needed to run the app
COPY . /usr/src/app

# Expose the port the app runs in
EXPOSE 3000

# Serve the app
CMD ["npm", "start"]

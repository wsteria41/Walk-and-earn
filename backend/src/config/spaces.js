const { S3Client } = require("@aws-sdk/client-s3");

const spacesClient = new S3Client({
  endpoint: "https://sgp1.digitaloceanspaces.com",
  region: "sgp1",
  credentials: {
    accessKeyId: process.env.DO_SPACE_KEY,
    secretAccessKey: process.env.DO_SPACE_SECRET
  }
});

module.exports = spacesClient;
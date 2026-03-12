const AWS = require("aws-sdk");

const spacesEndpoint = new AWS.Endpoint("sgp1.digitaloceanspaces.com");

const s3 = new AWS.S3({
  endpoint: spacesEndpoint,
  accessKeyId: process.env.DO_SPACE_KEY,
  secretAccessKey: process.env.DO_SPACE_SECRET
});

module.exports = s3;
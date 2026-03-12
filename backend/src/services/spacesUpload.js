const { Upload } = require("@aws-sdk/lib-storage");
const spacesClient = require("../config/spaces");

async function uploadFile(file) {

  const upload = new Upload({
    client: spacesClient,
    params: {
      Bucket: "wearn-profile-images",
      Key: `profiles/${Date.now()}-${file.originalname}`,
      Body: file.buffer,
      ACL: "public-read"
    }
  });

  const result = await upload.done();

  return result.Location;
}

module.exports = { uploadFile };
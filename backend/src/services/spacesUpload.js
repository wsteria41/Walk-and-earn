const { Upload } = require("@aws-sdk/lib-storage");
const spacesClient = require("../config/spaces");

async function uploadFile(file, userId) {

  const upload = new Upload({
    client: spacesClient,
    params: {
      Bucket: "wearn-profile-images",
      Key: `profiles/${userId}/profile.png`,
      Body: file.buffer,
      ACL: "public-read",
      ContentType: file.mimetype
    }
  });

  const result = await upload.done();

  return result.Location;
}

module.exports = { uploadFile };
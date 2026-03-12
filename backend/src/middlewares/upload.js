const multer = require("multer");
const multerS3 = require("multer-s3");
const s3 = require("../config/spaces");

const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: "wearn-profile-images",
    acl: "public-read",
    key: function (req, file, cb) {
      cb(null, Date.now().toString() + "-" + file.originalname);
    }
  })
});

module.exports = upload;